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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    BOOL showImage = [[_rssItem objectForKey:@"showImage"] boolValue];
    
    if (showImage) {
        NSData *myImage = [self getImageUrl:[[feeds objectAtIndex:indexPath.row] objectForKey: @"description"]];
        [[cell imageView] setImage:[UIImage imageWithData:myImage]];
    }

    cell.textLabel.text = [self parseHtml:[[feeds objectAtIndex:indexPath.row] objectForKey: @"title"]];
    
    cell.detailTextLabel.text = [self parseHtml:[[feeds objectAtIndex:indexPath.row] objectForKey: @"description"]];
    
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
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
    [self.rssFeedTableView reloadData];
    
}


-(NSString *)parseHtml:(NSString *)htmlString {
    NSError * __autoreleasing *error;
    
    HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:htmlString error:error];
    
    HTMLNode *bodyNode = [htmlParser body];
    
    return [bodyNode allContents];
}

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
