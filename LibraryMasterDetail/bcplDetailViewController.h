//
//  bcplDetailViewController.h
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface bcplDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, MBProgressHUDDelegate> {
    NSTimer *timer;
    UIWebView *webView;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) id menuItem;

@property (strong, nonatomic) id wvTitle;
@property (strong, nonatomic) id wvUrl;



@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *detailViewLoadingIndicator;

@end
