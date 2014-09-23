//
//  bcplMasterViewController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplMasterViewController.h"

#import "bcplDetailViewController.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@interface bcplMasterViewController (){
    NSMutableArray *_objects;
    NSMutableArray *_webViewObjects;
}

@end

@implementation bcplMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (bcplDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.title = @"BCPL";
    
    //Full list of main menu items
    _objects = [[NSMutableArray alloc] initWithObjects:@"Catalog", @"My Account", @"Branches and Hours", @"Events", @"What to Read", @"Mobile Tools", @"Ask Us", @"News", nil];
    
    //List of menu objects that should go directly to a web view
    _webViewObjects = [[NSMutableArray alloc] initWithObjects:@"Catalog", @"My Account", @"Branches and Hours", @"Mobile Tools", @"Ask Us", nil];
    
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
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *test = @"maryt's test";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        
    }
    else {
        //Get the row of the cell so we can identify which menu item was selected
        NSInteger rowOfCell = [indexPath row];
        
        //Get the title of the row selected
        NSString *menuTitle = _objects[rowOfCell];
        
        if ([_webViewObjects containsObject:menuTitle]) {
            //Get the url that is associated with teh webview, if there is one
            NSString *url = [self getWebViewUrl:menuTitle];
            
            //Object for sending to the detail view controller
            NSMutableDictionary *menuItem = [NSMutableDictionary dictionaryWithDictionary:@{@"title": menuTitle, @"url": url}];
            
            [self performSegueWithIdentifier:@"showDetail" sender:menuItem];
        }
        else {
            [self performSegueWithIdentifier:@"segueSubMenu" sender:test];
        }
    }
    
}

//Gets the appropriate url based on the menu title being passed in
-(NSString *)getWebViewUrl:(NSString *)menuTitle {
    if ([menuTitle isEqualToString:@"Catalog"]) {
        return @"https://catalog.bcpl.lib.md.us/Mobile/Search";
    }
    else if ([menuTitle isEqualToString:@"My Account"]) {
        return @"https://catalog.bcpl.lib.md.us/Mobile/MyAccount/Logon";
    }
    else if ([menuTitle isEqualToString:@"Branches and Hours"]) {
        return @"https://catalog.bcpl.lib.md.us/Mobile/Hours?organizationID=1";
    }
    else if ([menuTitle isEqualToString:@"Mobile Tools"]) {
        return @"https://catalog.bcpl.lib.md.us/mobile/Custom/Pages/Bcpl-databases-mobile.aspx";
    }
    else if ([menuTitle isEqualToString:@"Ask Us"]) {
        return @"http://bcpl.libanswers.com/mobile.php";
    }
    else {
        return nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        bcplDetailViewController *dvc = [segue destinationViewController];
        
        [dvc setMenuItem:sender];
    }
    
    if ([[segue identifier] isEqualToString:@"sequeSubMenu"]) {
        bcplSubMenuViewController *smv = [segue destinationViewController];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        
//
//        if ([menuItem isEqualToString:@"Catalog"]) {
//            object = @"https://catalog.bcpl.lib.md.us/Mobile/Search";
//        }
//        else if([menuItem isEqualToString:@"My Account"]) {
//            object = @"https://catalog.bcpl.lib.md.us/Mobile/MyAccount/Logon";
//        }
//        else if([menuItem isEqualToString:@"Branches and Hours"]) {
//            object = @"https://catalog.bcpl.lib.md.us/Mobile/Hours?organizationID=1";
//        }
//        else if([menuItem isEqualToString:@"Mobile Tools"]) {
//            object = @"https://catalog.bcpl.lib.md.us/mobile/Custom/Pages/Bcpl-databases-mobile.aspx";
//        }
//        else if([menuItem isEqualToString:@"Ask Us"]) {
//            object = @"http://bcpl.libanswers.com/mobile.php";
//        }
//        else {
//           object = _objects[indexPath.row];
//            
//            //Manually trigger seque we want to perform
//            
//        }
//        
//        [[segue destinationViewController] setDetailItem:object];
//    }
//    else {
//        
//    }
//}



@end
