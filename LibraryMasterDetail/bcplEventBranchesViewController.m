//
//  bcplEventBranchesViewController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/24/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplEventBranchesViewController.h"
#import "bcplRssFeedController.h"

@interface bcplEventBranchesViewController () {
    NSMutableArray *_branches;
}
@end

@implementation bcplEventBranchesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Select a Branch";
    
    //Full list of branches
    _branches = [[NSMutableArray alloc] initWithObjects:@"Arbutus", @"Catonsville", @"Cockeysville", @"Essex", @"Hereford", @"Lansdowne", @"Loch Raven", @"Mobile Library Services", @"North Point", @"Owings Mills", @"Parkville-Carney", @"Perry Hall", @"Pikesville",@"Randallstown",@"Reisterstown", @"Rosedale", @"Sollers Point", @"Towson", @"White Marsh", @"Woodlawn", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_branches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDate *object = _branches[indexPath.row];
    
    cell.textLabel.text = [object description];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the row of the cell so we can identify which menu item was selected
    NSInteger rowOfCell = [indexPath row];
    
    //Get the title of the row selected
    NSString *menuTitle = _branches[rowOfCell];
    NSString *url = [self getBranchRssFeed:menuTitle];
    
    
    NSMutableDictionary *rssItem = [NSMutableDictionary dictionaryWithDictionary:@{@"title": [NSString stringWithFormat:@"%@%@", menuTitle, @" Branch Events"], @"url": url, @"showImage": @false}];
    
    [self performSegueWithIdentifier:@"segueEventFeed" sender:rssItem];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueEventFeed"]) {
        bcplRssFeedController *rssVc = [segue destinationViewController];
        
        [rssVc setRssItem:sender];
    }
}

//Gets the appropriate url based on the menu title being passed in
-(NSString *)getBranchRssFeed:(NSString *)branchName {
    if ([branchName isEqualToString:@"Arbutus"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=1&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Catonsville"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=2&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Cockeysville"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=3&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Essex"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=4&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Hereford"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=5&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Lansdowne"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=6&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Loch Raven"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=7&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Mobile Library Services"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=8&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In-House+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"North Point"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=9&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Owings Mills"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=10&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Parkville-Carney"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=11&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Perry Hall"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=12&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Pikesville"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=13&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Randallstown"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=14&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Reisterstown"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=15&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Rosedale"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=16&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Sollers Point"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=20&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Towson"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=17&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"White Marsh"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=18&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else if ([branchName isEqualToString:@"Woodlawn"]) {
        return @"http://md.evanced.info/bcpl/lib/eventsxml.asp?ag=&et=&lib=19&nd=30&feedtitle=Baltimore+County+Public+Library%3CBR%3ESchedule+of+Events%3Cbr%3E%28In%2DHouse+Registration+Mode%29&dm=rss2&LangType=0";
    }
    else {
        return nil;
    }
}

@end
