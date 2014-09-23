////
////  bcplMasterViewController.m
////  LibraryMasterDetail
////
////  Created by Marty on 9/22/14.
////  Copyright (c) 2014 ___martypowell___. All rights reserved.
////
//
//#import "bcplMasterViewController.h"
//
//#import "bcplDetailViewController.h"
//#import "HTMLParser.h"
//#import "HTMLNode.h"
//
//@interface bcplMasterViewController () {
//    NSMutableArray *_objects; //TODO Remove this
//    NSXMLParser *parser;
//    NSMutableArray *feeds;
//    NSMutableDictionary *item;
//    NSMutableString *title;
//    NSMutableString *link;
//    NSMutableString *description;
//    NSString *element;
//}
//@end
//
//@implementation bcplMasterViewController
//
//@synthesize allEntries = _allEntries;
//
//- (void)awakeFromNib
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
//        self.preferredContentSize = CGSizeMake(320.0, 600.0);
//    }
//    [super awakeFromNib];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.detailViewController = (bcplDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
//    
//    self.title = @"BCPL";
//    
//    feeds = [[NSMutableArray alloc] init];
//    
//    NSURL *url = [NSURL URLWithString:@"http://www.bcpl.info/blog/feed"];
//    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    
//    [parser setDelegate:self];
//    [parser setShouldResolveExternalEntities:NO];
//    [parser parse];
//    
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table View
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [feeds count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    
//    
//    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
//    
//    cell.detailTextLabel.text = [self parseHtml:[[feeds objectAtIndex:indexPath.row] objectForKey: @"description"]];
//    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}
//
///*
// // Override to support rearranging the table view.
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
// {
// }
// */
//
///*
// // Override to support conditional rearranging of the table view.
// - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
// {
// // Return NO if you do not want the item to be re-orderable.
// return YES;
// }
// */
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        NSDate *object = _objects[indexPath.row];
//        self.detailViewController.detailItem = object;
//    }
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = _objects[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
//    
//    element = elementName;
//    
//    if ([element isEqualToString:@"item"]) {
//        
//        item    = [[NSMutableDictionary alloc] init];
//        title   = [[NSMutableString alloc] init];
//        link    = [[NSMutableString alloc] init];
//        description = [[NSMutableString alloc] init];
//        
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    
//    if ([element isEqualToString:@"title"]) {
//        [title appendString:string];
//    } else if ([element isEqualToString:@"link"]) {
//        [link appendString:string];
//    } else if ([element isEqualToString:@"description"]) {
//        [description appendString:string];
//    }
//}
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    
//    if ([elementName isEqualToString:@"item"]) {
//        
//        [item setObject:title forKey:@"title"];
//        [item setObject:link forKey:@"link"];
//        [item setObject:description forKey:@"description"];
//        
//        [feeds addObject:[item copy]];
//        
//    }
//    
//}
//- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    
//    
//    [self.tableView reloadData];
//    
//}
//
//
//-(NSString *)parseHtml:(NSString *)htmlString {
//    NSError * __autoreleasing *error;
//    
//    HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:htmlString error:error];
//    
//    HTMLNode *bodyNode = [htmlParser body];
//    
//    return [bodyNode allContents];
//}
//
//@end
