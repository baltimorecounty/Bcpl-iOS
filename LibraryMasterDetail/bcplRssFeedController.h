//
//  bcplRssFeedController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/23/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bcplRssFeedController : UIViewController <UISplitViewControllerDelegate, NSXMLParserDelegate>

@property (retain) NSMutableArray *allEntries;

@property (strong, nonatomic) id rssItem;

@property (strong, nonatomic) IBOutlet UITableView *rssFeedTableView;

@end
