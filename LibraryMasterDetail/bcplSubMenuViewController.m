//
//  bcplSubMenuViewController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplSubMenuViewController.h"
#import "bcplRssFeedController.h"

@implementation bcplSubMenuViewController {
    NSDictionary *menuItems;
    NSArray *sectionTitles;
    NSMutableArray *_objects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //xself.rssFeedViewController = (bcplRssFeedController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"What To Read";
    
    menuItems = @{@"Customers": @[@"New Books", @"New DVDs", @"New CDs", @"New Large Print"], @"Between the Covers": @[@"All Articles", @"Adult Fiction", @"Adult Non Fiction", @"Teen Books", @"Children's Books", @"Picture Books"]};
    
    sectionTitles = [[menuItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _objects = [[NSMutableArray alloc] initWithObjects:@"All Articles", @"Adult Fiction", @"Adult Non Fiction", @"Teen Books", @"Children's Books", @"Picture Books", @"Ask Us", @"News", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [sectionTitles objectAtIndex:section];
    NSArray *sectionMenuItems = [menuItems objectForKey:sectionTitle];
    return [sectionMenuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SubMenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell...
    NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionMenuItems = [menuItems objectForKey:sectionTitle];
    NSString *item = [sectionMenuItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionMenuItems = [menuItems objectForKey:sectionTitle];
        NSString *item = [sectionMenuItems objectAtIndex:indexPath.row];
        NSString *url = [self getRssViewUrl:item];
        
        NSDictionary *rssItem = @{@"title": item, @"url": url, @"showImage": @YES};
    
        [self performSegueWithIdentifier:@"segueRssFeed" sender:rssItem];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueRssFeed"]) {
        bcplRssFeedController *rssVc = [segue destinationViewController];
        
        [rssVc setRssItem:sender];
    }
}

//Gets the appropriate url based on the menu title being passed in
-(NSString *)getRssViewUrl:(NSString *)menuTitle {
    
    menuTitle = [menuTitle lowercaseString];
    
    if ([menuTitle isEqualToString:@"all articles"]) {
        return @"http://www.bcpl.info/blog/feed";
    }
    else if ([menuTitle isEqualToString:@"adult fiction"]) {
        return @"http://www.bcpl.info/taxonomy/term/203/0/feed";
    }
    else if ([menuTitle isEqualToString:@"adult non fiction"]) {
        return @"http://www.bcpl.info/taxonomy/term/200/0/feed";
    }
    else if ([menuTitle isEqualToString:@"teen books"]) {
        return @"http://www.bcpl.info/taxonomy/term/188/0/feed";
    }
    else if ([menuTitle isEqualToString:@"children's books"]) {
        return @"http://http/www.bcpl.info/taxonomy/term/191/0/feed";
    }
    else if ([menuTitle isEqualToString:@"picture books"]) {
        return @"http://www.bcpl.info/taxonomy/term/270/0/feed";
    }
    else if ([menuTitle isEqualToString:@"new books"]) {
        return @"http://catalog.bcpl.lib.md.us/polaris/rss/NewTitles.aspx?type=1";
    }
    else if ([menuTitle isEqualToString:@"new dvds"]) {
        return @"http://catalog.bcpl.lib.md.us/polaris/rss/NewTitles.aspx?type=2";
    }
    else if ([menuTitle isEqualToString:@"new cds"]) {
        return @"http://catalog.bcpl.lib.md.us/polaris/rss/NewTitles.aspx?type=3";
    }
    else if ([menuTitle isEqualToString:@"new large print"]) {
        return @"http://catalog.bcpl.lib.md.us/polaris/rss/NewTitles.aspx?type=4";
    }
    else {
        return nil;
    }
}
@end
