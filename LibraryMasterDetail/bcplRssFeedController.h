//
//  bcplRssFeedController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/23/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface bcplRssFeedController : UIViewController <UISplitViewControllerDelegate, NSXMLParserDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (retain) NSMutableArray *allEntries;

@property (strong, nonatomic) id rssItem;

@property (strong, nonatomic) IBOutlet UITableView *rssFeedTableView;

@end
