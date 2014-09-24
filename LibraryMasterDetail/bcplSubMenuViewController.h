//
//  bcplSubMenuViewController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class bcplRssFeedController;

@interface bcplSubMenuViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *whatToReadMenu;

@property (strong, nonatomic) bcplRssFeedController *rssFeedViewController;

@end
