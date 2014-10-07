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
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableArray *feedDates;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *pubDate;
    NSMutableString *description;
    NSString *element;
    NSMutableDictionary *rssDateGrouping;
    NSString *screenTitle;
    BOOL noResults;
}

@end

@implementation bcplRssFeedController

- (void)setRssItem:(id)rssItem
{
    _rssItem = rssItem;

}

- (void)configureView
{
    self.title = screenTitle;
    
    feeds = [[NSMutableArray alloc] init];
    
    dispatch_async( dispatch_get_global_queue(0, 0), ^{
        
        NSString *urlStr = [_rssItem objectForKey:@"url"];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        
        // call the result handler block on the main queue (i.e. main thread)
        dispatch_async( dispatch_get_main_queue(), ^{
            // running synchronously on the main thread now -- call the handler
            [parser parse];
            
            if ([feeds count] == 0) {
                noResults = YES;
                [feeds addObject:@{@"title":@"There are currently no items in this feed.", @"description": @"No Results"}];
            }

            [_rssFeedTableView reloadData];
            
            [HUD hide:YES];
            
            self.rssFeedTableView.hidden = NO;
            
            
            
        });
    });
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    screenTitle = [_rssItem objectForKey:@"title"];
    
    self.rssFeedTableView.hidden = YES;
    
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [feeds count];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    //Determine if we want to show the first image included in the feed
    BOOL showImage = [[_rssItem objectForKey:@"showImage"] boolValue];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        //If we don't have any records to show
        if (noResults) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        
    }

    NSString *myTitle = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    NSString *htmlDesc = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    if ([screenTitle rangeOfString:@"News"].location != NSNotFound) {
//        NSString *pubDate = [[feeds objectAtIndex:indexPath.row] objectForKey: @"pubDate"];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        //Thu, 25 Sep 2014 18:04:13 +0100
//        [dateFormatter setDateFormat:@""];
//        NSDate *inputDate = [dateFormatter dateFromString:pubDate];
//        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
//        NSString *outputDate = [outputDateFormatter stringFromDate:inputDate];
//        
//        
//        
//        cell.detailTextLabel.text = outputDate;
    }
    else {
        cell.detailTextLabel.text = [self parseHtml:htmlDesc];
    }

    if(noResults) {
        //Wrap text to display the entire no events message
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        
        //Don't allow user to select the row
        cell.userInteractionEnabled = NO;
        
        //Remove table row lines from the view
        [_rssFeedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    else {
        //Set that little arrow to let the you know that each cell is selectable
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //Check to see if the device is using wifi
        BOOL hasWiFi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
        
        //showImage - parameter we pass in
        //!noResults - Don't show image if there are no results
        //hasWiFi - Only show images if we are on a wifi network connection for performance
        if (showImage && !noResults && hasWiFi) {
            NSData *myImage = [self getImageUrl:[[feeds objectAtIndex:indexPath.row] objectForKey: @"description"]];
            [[cell imageView] setImage:[UIImage imageWithData:myImage]];
        }
    }
    
    cell.textLabel.text = [self parseHtml:myTitle];
    //cell.textLabel.text = myTitle;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self parseHtml:[[feeds objectAtIndex:indexPath.row] objectForKey: @"title"]];
    
    NSString *htmlContent = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    NSDictionary *rssDetails = @{@"title": title, @"content": htmlContent};
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
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
        pubDate = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:str];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:str];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:str];
    } else if ([element isEqualToString:@"pubDate"]) {
        [description appendString:str];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //Make sure the title is of substantial length, we were getting some empty feeds that caused problems, so hopefully this is a safeguard
    if ([elementName isEqualToString:@"item"] && [title length] > 10) {
        
            [item setObject:title forKey:@"title"];
            [item setObject:link forKey:@"link"];
            [item setObject:description forKey:@"description"];
            [item setObject:pubDate forKey:@"pubDate"];
    
        
        [feeds addObject:[item copy]];
        
    }
    
}

//Once we get the data for the RSS Feed Reload our table view so that it's populated with that data.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.rssFeedTableView reloadData];
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
