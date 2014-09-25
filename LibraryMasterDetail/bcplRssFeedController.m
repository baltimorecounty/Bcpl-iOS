//
//  bcplRssFeedController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/23/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplRssFeedController.h"
#import "bcplRssDetailViewController.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@interface bcplRssFeedController () {
    NSMutableArray *_objects; //TODO Remove this
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSString *element;
}

@end

@implementation bcplRssFeedController

- (void)setRssItem:(id)rssItem
{
    _rssItem = rssItem;
    
    //_wvUrl = [rssItem objectForKey:@"url"];
    //_wvTitle = [rssItem objectForKey:@"title"];
    
    // Update the view.
    [self configureView];
}

- (void)configureView
{
    //self.detailViewController = (bcplDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.title = [_rssItem objectForKey:@"title"];
    
    feeds = [[NSMutableArray alloc] init];
    
    NSString *urlStr = [_rssItem objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    NSString *title = [_rssItem objectForKey:@"title"];
    BOOL showImage = [[_rssItem objectForKey:@"showImage"] boolValue];
    NSString *htmlTitle = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    NSString *htmlDesc = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil && [title rangeOfString:@"Events"].location != NSNotFound) {
        NSString *dateTimeText = [self getDateTime:htmlDesc];
        NSString *dateText = [self getDate:dateTimeText];
        NSString *timeText = [self getTime:dateTimeText];
        NSString *startTime = [self getStartTime:timeText];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:simpleTableIdentifier];
        
        cell.textLabel.text = startTime;

        cell.detailTextLabel.text = [self parseHtml:htmlTitle];

    }
    else if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        if (showImage) {
            NSData *myImage = [self getImageUrl:[[feeds objectAtIndex:indexPath.row] objectForKey: @"description"]];
            [[cell imageView] setImage:[UIImage imageWithData:myImage]];
            
            cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
            
            cell.detailTextLabel.text = [self parseHtml:htmlDesc];

        }
        
    }
    
    //Set that little arrow to let the you know that each cell is selectable
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowOfCell = [indexPath row];
    NSString *title = [self parseHtml:[[feeds objectAtIndex:indexPath.row] objectForKey: @"title"]];
    
    NSString *htmlContent = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    NSDictionary *rssDetails = @{@"title": title, @"content": htmlContent};
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"segueRssDetail" sender:rssDetails];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueRssDetail"]) {
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
    [self.rssFeedTableView reloadData];
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

//Retrieves the first image from a string formatted as html
-(NSData *)getImageUrl:(NSString *)htmlString {
    NSError * __autoreleasing *error;
    
    HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:htmlString error:error];
    
    HTMLNode *bodyNode = [htmlParser body];
    
    NSArray *imgNodes = [bodyNode findChildTags:@"img"];
    
    for (HTMLNode *imgNode in imgNodes) {
        
        NSString *url = [imgNode getAttributeNamed:@"src"];
        
        return [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    
    return nil;
}




@end
