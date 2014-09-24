//
//  bcplEventBranchesViewController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/24/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class bcplRssFeedController;


@interface bcplEventBranchesViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *eventBranchesTableView;

@property (strong, nonatomic) bcplRssFeedController *rssFeedViewController;

@end
