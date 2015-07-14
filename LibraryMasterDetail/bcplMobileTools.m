//
//  bcplMobileTools.m
//  LibraryMasterDetail
//
//  Created by Marty on 10/6/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplMobileTools.h"
#import "bcpliTunesController.h"

@interface bcplMobileTools ()

@end

@implementation bcplMobileTools
NSMutableDictionary *mobileTools;
NSArray *menuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mobileTools = [[NSMutableDictionary alloc] init];
    
    [mobileTools setObject:@{@"desc": @"Read 3M e-books.", @"link": @"http://itunes.apple.com/us/app/3m-cloud-library/id466446054?mt=8"} forKey:@"3M Cloud Library"];
    [mobileTools setObject:@{@"desc": @"Chat online with a live tutor (2 p.m. until midnight).", @"link": @"https://itunes.apple.com/us/app/brainfuse/id575242780?mt=8"} forKey:@"Brainfuse"];
    [mobileTools setObject:@{@"desc": @"Use research databases.", @"link": @"https://itunes.apple.com/us/app/accessmylibrary/id342518632?mt=8"} forKey:@"GaleCengage"];
    [mobileTools setObject:@{@"desc": @"Download language lessons.", @"link": @"https://itunes.apple.com/us/app/mango-languages-library-edition/id443516516?mt=8&ls=1"} forKey:@"Mango Languages Library Edition"];
    [mobileTools setObject:@{@"desc": @"Read or listen to OverDrive audio and e-books.", @"link": @"https://itunes.apple.com/us/app/overdrive-media-console/id366869252?mt=8"} forKey:@"OverDrive"];
    [mobileTools setObject:@{@"desc": @"Search business and residential listings.", @"link": @"https://itunes.apple.com/us/app/referenceusa-for-ipad/id532313135?mt=8"} forKey:@"RefUSA"];
    [mobileTools setObject:@{@"desc": @"Download popular magazines.", @"link": @"https://itunes.apple.com/us/app/zinio-5-000+-digital-magazines/id364297166?mt=8"} forKey:@"Zinio"];
    
     menuItems= [[mobileTools allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        //If we don't have any records to show
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *title = [menuItems objectAtIndex:indexPath.row];
    NSString *desc = [[mobileTools objectForKey:title] objectForKey:@"desc"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = desc;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [menuItems objectAtIndex:indexPath.row];
    //Get the url that is associated with teh webview, if there is one
    NSString *url = [[mobileTools objectForKey:title] objectForKey:@"link"];
    
    //Object for sending to the detail view controller
    NSMutableDictionary *menuItem = [NSMutableDictionary dictionaryWithDictionary:@{@"title": title, @"url": url}];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    //[self performSegueWithIdentifier:@"segueMobileToolsDetail" sender:menuItem];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"segueMobileToolsDetail"]) {
//        bcpliTunesController *rssVc = [segue destinationViewController];
//        
//        [rssVc setMenuItem:sender];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
