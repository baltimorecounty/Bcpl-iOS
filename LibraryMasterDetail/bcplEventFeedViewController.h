//
//  bcplEventFeedViewController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/25/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bcplEventFeedViewController : UIViewController <UISplitViewControllerDelegate, NSXMLParserDelegate>
@property (strong, nonatomic) id eventItem;

@property (strong, nonatomic) IBOutlet UITableView *eventFeedTableView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *eventFeedLoadingIndicator;

@end
