//
//  bcplMasterViewController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bcplSubMenuViewController.h"

@class bcplDetailViewController;

@interface bcplMasterViewController : UITableViewController


@property (strong, nonatomic) bcplDetailViewController *detailViewController;
@property (strong, nonatomic) bcplSubMenuViewController *subMenuViewController;



@end
