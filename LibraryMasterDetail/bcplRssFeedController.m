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
    screenTitle = [_rssItem objectForKey:@"title"];
    
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
    NSString *myTitle = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    NSString *htmlDesc = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    BOOL showImage = [[_rssItem objectForKey:@"showImage"] boolValue];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
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
    
    if (showImage) {
        NSData *myImage = [self getImageUrl:[[feeds objectAtIndex:indexPath.row] objectForKey: @"description"]];
        [[cell imageView] setImage:[UIImage imageWithData:myImage]];

    }
    cell.textLabel.text = [self parseHtml:myTitle];
    
    //Set that little arrow to let the you know that each cell is selectable
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [description appendString:string];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    if ([elementName isEqualToString:@"item"]) {
        
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
