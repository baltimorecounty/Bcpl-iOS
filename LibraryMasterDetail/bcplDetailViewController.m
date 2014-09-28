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

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.wvUrl) {
        //Set the title of the page to the menu Item selected
        self.navigationItem.title = self.wvTitle;
        
        //This puts the dynamically created webview below the navbar
        self.edgesForExtendedLayout = UIRectEdgeNone;

        webView = [[UIWebView alloc] init];
        webView.delegate = self;
        
        webView.contentMode = UIViewContentModeScaleToFill;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        NSString *fullURL = [self.wvUrl description];
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
        [webView loadRequest:requestObj];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.detailViewLoadingIndicator startAnimating];
    self.detailViewLoadingIndicator.hidden = NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.detailViewLoadingIndicator stopAnimating];
    [self.view addSubview:webView];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //Fixes view for portrait and landscape
    //Needs to be applied after teh subview is added ot teh screen
    [webView setFrame:frame];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.navigationItem.hidesBackButton = YES;
        }
    
    // Update the view.
    [self configureView];
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
