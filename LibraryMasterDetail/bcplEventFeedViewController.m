//
//  bcplEventFeedViewController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/25/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplEventFeedViewController.h"
#import "bcplRssDetailViewController.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@interface bcplEventFeedViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableArray *feedDates;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSString *element;
    NSMutableDictionary *rssDateGrouping;
    NSString *screenTitle;
    BOOL noResults;
}

@end

@implementation bcplEventFeedViewController


- (void)setRssItem:(id)eventItem
{
    _eventItem = eventItem;
}

- (void)configureView
{
    
    feeds = [[NSMutableArray alloc] init];
    dispatch_async( dispatch_get_global_queue(0, 0), ^{
    NSString *urlStr = [_eventItem objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
        dispatch_async( dispatch_get_main_queue(), ^{
            [parser parse];
            
            if ([feedDates count] == 0) {
                noResults = YES;
                [feedDates addObject:@""];
                [rssDateGrouping addEntriesFromDictionary:@{@"": @[@{@"title":@"There are no events scheduled for this location.", @"description": @""}]}];
            }
            
            [_eventFeedTableView reloadData];
            
            [HUD hide:YES];
            
            self.eventFeedTableView.hidden = NO;
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenTitle = [_eventItem objectForKey:@"title"];
    // Do any additional setup after loading the view.
    self.title = screenTitle;
    
    self.eventFeedTableView.hidden = YES;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD show:YES];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = [feedDates count];
    
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([feedDates count] > 0) {
        return [feedDates objectAtIndex:section];
    }
    //If there no records we don't want to display a header, but we still want to display a record
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [feedDates objectAtIndex:section];
    NSArray *sectionMenuItems = [rssDateGrouping objectForKey:sectionTitle];
    
    return [sectionMenuItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:0.0 green:87.0/255.0 blue:167.0/255.0 alpha:1.0];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Prepare the cell for manipulation
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *sectionTitle = [feedDates objectAtIndex:indexPath.section];
    NSArray *sectionMenuItems = [rssDateGrouping objectForKey:sectionTitle];
    
    NSDictionary *item = [sectionMenuItems objectAtIndex:indexPath.row];
    
    NSString *myTitle = [item objectForKey:@"title"];
    NSString *htmlDesc = [item objectForKey:@"description"];
    
    if(!noResults) {
        NSString *dateTimeText = [self getDateTime:htmlDesc];
        NSString *timeText = [self getTime:dateTimeText];
        NSString *startTime = [self getStartTime:timeText];
        
        //Set the initial label to teh start time of the event
        cell.textLabel.text = startTime;
        
        //Set that little arrow to let the you know that each cell is selectable
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        //Wrap text to display the entire no events message
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.numberOfLines = 0;
        
        //Don't allow user to select the row
        cell.userInteractionEnabled = NO;
        
        //Remove table row lines from the view
        [self.eventFeedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    //Set the main text for the cell
    cell.detailTextLabel.text = [self parseHtml:myTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *htmlContent = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    NSString *sectionTitle = [feedDates objectAtIndex:indexPath.section];
    NSArray *sectionMenuItems = [rssDateGrouping objectForKey:sectionTitle];
    NSDictionary *item = [sectionMenuItems objectAtIndex:indexPath.row];
    
    NSDictionary *eventDetails = @{@"title": [item objectForKey:@"title"], @"content": [item objectForKey:@"description"]};
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    }
    
    [self performSegueWithIdentifier:@"segueEventDetail" sender:eventDetails];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueEventDetail"]) {
        bcplRssDetailViewController *rssVc = [segue destinationViewController];
        
        [rssVc setRssDetail:sender];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:description forKey:@"description"];
        
        
        [feeds addObject:[item copy]];
        
    }
    
}

//Once we get the data for the RSS Feed Reload our table view so that it's populated with that data.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
        rssDateGrouping = [[NSMutableDictionary alloc] init];
        feedDates = [[NSMutableArray alloc] init];
        //Get each unique date
        for (NSDictionary *item in feeds) {
            NSString *itemDate = [self getDate:[self getDateTime:[self parseHtml:item[@"description"]]]];
            
            if (![feedDates containsObject:itemDate]) {
                [feedDates addObject:itemDate];
            }
        }
        
        //Create an array for each date so we can store the values
        for(NSString *date in feedDates) {
            
            rssDateGrouping[date] = [[NSMutableArray alloc]init];
        }
        
        //Store the items in the appropriate date array
        for (NSDictionary *item in feeds) {
            NSString *itemDate = [self getDate:[self getDateTime:[self parseHtml:item[@"description"]]]];
            
            [rssDateGrouping[itemDate] addObject:item];
        }
    
    
    
    
    
    [self.eventFeedTableView reloadData];
}

//Retreive a date time string from the html being passed in
//The html string is expected to be in the following format
//<b>When:</b> Tuesday, September 30, 2014 - 9:30 AM - 10:30 AM<br><b>Where:</b> Arbutus Branch at * Arbutus Meeting Room<br><br>Connect with your baby through stories, rhymes, bounces and songs, followed by a play time. <i>Registration required.</i><br />
-(NSString *)getDateTime:(NSString *)htmlString {
    NSArray *parts = [htmlString componentsSeparatedByString:@"<br>"];
    
    for(NSString *part in parts) {
        if ([part rangeOfString:@"When:"].location != NSNotFound) {
            //Replace the br tag, the bold label and trim the string
            return [[[part stringByReplacingOccurrencesOfString:@"<b>When:</b>" withString:@""] stringByReplacingOccurrencesOfString:@"<br>" withString:@""] stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        }
    }
    
    return nil;
}

//Extracts Date String from a datetime string that should be in the following format
//Friday, September 26, 2014 - 1:00 PM - 3:00 PM
-(NSString *)getDate:(NSString *)dateString {
    //Return date in the following format
    //Day Name, MonthName DayNumber, Year
    NSError * __autoreleasing *error;
    NSString *pattern = @"\\w*,\\s\\w*\\s\\d{1,2},\\s\\d{4}";
    
    NSRegularExpression *dateRegExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:error];
    
    NSArray *dates = [dateRegExp matchesInString:dateString options:0 range:NSMakeRange(0, [dateString length])];
    
    for ( NSTextCheckingResult* match in dates )
    {
        NSString* matchText = [dateString substringWithRange:[match range]];
        return matchText;
    }
    return nil;
}

//Extracts Time String from a datetime string that should be in the following format
//Friday, September 26, 2014 - 1:00 PM - 3:00 PM
-(NSString *)getTime:(NSString *)dateString {
    NSError * __autoreleasing *error;
    NSString *pattern = @"\\d{1,2}:\\d{2}\\s(A|P)M\\s-\\s\\d{1,2}:\\d{2}\\s(A|P)M";
    
    NSRegularExpression *dateRegExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:error];
    
    
    NSArray *times = [dateRegExp matchesInString:dateString options:0 range:NSMakeRange(0, [dateString length])];
    
    for ( NSTextCheckingResult* match in times )
    {
        NSString* matchText = [dateString substringWithRange:[match range]];
        return matchText;
    }
    return nil;
    
}

//Extracts Time String from a datetime string that should be in the following format
//Friday, September 26, 2014 - 1:00 PM - 3:00 PM
-(NSString *)getStartTime:(NSString *)timeString {
    NSError * __autoreleasing *error;
    NSString *pattern = @"\\d{1,2}:\\d{2}\\s(A|P)M";
    
    NSRegularExpression *dateRegExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:error];
    
    
    NSArray *times = [dateRegExp matchesInString:timeString options:0 range:NSMakeRange(0, [timeString length])];
    
    for ( NSTextCheckingResult* match in times )
    {
        NSString* matchText = [timeString substringWithRange:[match range]];
        return matchText;
    }
    return nil;
    
}

//Removes any html tags from a string formatted as html
-(NSString *)parseHtml:(NSString *)htmlString {
    NSError * __autoreleasing *error;
    
    HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:htmlString error:error];
    
    HTMLNode *bodyNode = [htmlParser body];
    
    return [bodyNode allContents];
}



@end
