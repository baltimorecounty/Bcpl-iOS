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
    [self.detailViewLoadingIndicator startAnimating];
    self.detailViewLoadingIndicator.hidden = NO;
    self.webView.hidden = YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.detailViewLoadingIndicator stopAnimating];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if ([_wvTitle isEqualToString:@"Ask Us"]) {
            NSString* js =
            @"var meta = document.createElement('meta'); "
            "meta.setAttribute( 'name', 'viewport' ); "
            "meta.setAttribute( 'content', 'width = device-width; initial-scale = 1.5; maximum-scale=1.5; user-scalable-0' ); "
            "document.getElementsByTagName('head')[0].appendChild(meta)";
            
            
        }

    }
        if (![_wvTitle isEqualToString:@"Ask Us"] || ![_wvTitle isEqualToString:@"Mobile Tools"]) {
            NSString*js =
            @"var meta = document.createElement('meta'); "
            "meta.setAttribute( 'name', 'viewport' ); "
            "meta.setAttribute( 'content', 'width = device-width; initial-scale = 1.25; maximum-scale=1.25; user-scalable-0' ); "
            "document.getElementsByTagName('head')[0].appendChild(meta)";
            
            [self.webView stringByEvaluatingJavaScriptFromString: js];
            
            
        }
    
    self.webView.hidden = NO;
    
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
