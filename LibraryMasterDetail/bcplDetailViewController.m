

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
NSTimer *timer;


@synthesize webView, detailViewLoadingIndicator;

#pragma mark - Managing the detail item

- (void)setMenuItem:(id)menuItem
{
    _menuItem = menuItem;
    
    _wvUrl = [_menuItem objectForKey:@"url"];
    _wvTitle = [_menuItem objectForKey:@"title"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // webView connected
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
    //self.webView.hidden = YES;
    
    MBProgressHUD *myHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    myHUD.labelText = @"Loading";

}

- (void)cancelWeb
{
    NSLog(@"Web Error: %@", @"what is happening");
    //Show the webview
    self.webView.hidden = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     NSLog(@"Web Error: %@", error);
    
    if ([error code] != NSURLErrorCancelled) {
        //show error alert, etc.
        
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self showWebView:[self getWEbViewScale]];
}

-(NSString *)getWEbViewScale {
    NSString* initialScale = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if ([_wvTitle isEqualToString:@"Ask Us"]) {
            initialScale = @"1.5";
            
        }
        
    }
    if (![_wvTitle isEqualToString:@"Ask Us"]) {
        initialScale = @"1.25";
    }
    
    return initialScale;
}

-(void)showWebView: (NSString *)initalScale {
    //Setup the view port for the webview
    //This helps us make pages easier to read
    NSString *js = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
     @"var meta = document.createElement('meta'); ",
     @"meta.setAttribute( 'name', 'viewport' ); ",
     @"meta.setAttribute( 'content', 'width = device-width; initial-scale = ",
     initalScale,
     @"; maximum-scale=",
     initalScale,
     @"1.25; user-scalable-0' ); document.getElementsByTagName('head')[0].appendChild(meta)"];
    
    //Execute the viewport script
    [self.webView stringByEvaluatingJavaScriptFromString: js];
    
    //Show the webview
    self.webView.hidden = NO;
    
    //Hide the loading inidcator
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
    
    self.webView.suppressesIncrementalRendering = YES;
    
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
