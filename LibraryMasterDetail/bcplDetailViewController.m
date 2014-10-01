//
//  bcplDetailViewController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplDetailViewController.h"


@interface bcplDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation bcplDetailViewController


@synthesize webView, detailViewLoadingIndicator;

#pragma mark - Managing the detail item

- (void)setMenuItem:(id)menuItem
{
    _menuItem = menuItem;
    
    _wvUrl = [_menuItem objectForKey:@"url"];
    _wvTitle = [_menuItem objectForKey:@"title"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //[self.detailViewLoadingIndicator startAnimating];
    //self.detailViewLoadingIndicator.hidden = NO;
    self.webView.hidden = YES;
    
    //HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
    MBProgressHUD *myHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self.navigationController.view addSubview:HUD];
    
    //HUD.delegate = self;
    myHUD.labelText = @"Loading";
    
    //[HUD show:YES];
    
    //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled) {
        //show error alert, etc.
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if ([_wvTitle isEqualToString:@"Ask Us"]) {
            NSString* js =
            @"var meta = document.createElement('meta'); "
            "meta.setAttribute( 'name', 'viewport' ); "
            "meta.setAttribute( 'content', 'width = device-width; initial-scale = 1.5; maximum-scale=1.5; user-scalable-0' ); "
            "document.getElementsByTagName('head')[0].appendChild(meta)";
            
            [self.webView stringByEvaluatingJavaScriptFromString: js];
            
        }

    }
        if (![_wvTitle isEqualToString:@"Ask Us"]) {
            NSString*js =
            @"var meta = document.createElement('meta'); "
            "meta.setAttribute( 'name', 'viewport' ); "
            "meta.setAttribute( 'content', 'width = device-width; initial-scale = 1.25; maximum-scale=1.25; user-scalable-0' ); "
            "document.getElementsByTagName('head')[0].appendChild(meta)";
            
            [self.webView stringByEvaluatingJavaScriptFromString: js];
            
            
        }
    
    self.webView.hidden = NO;
    
    //[HUD hide:YES];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.navigationItem.hidesBackButton = YES;
        }
    
    self.navigationItem.title = self.wvTitle;
    
    NSString *fullURL = [self.wvUrl description];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    self.webView.delegate = self;
    
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
