//
//  bcplAppDelegate.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/22/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplAppDelegate.h"
#import "bcplMasterViewController.h"
#import "bcplDetailViewController.h"

@implementation bcplAppDelegate

UISplitViewController *splitViewController;
UINavigationController *navigationController;
NSString * storyboardName;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //iPad
        splitViewController = (UISplitViewController *)self.window.rootViewController;
        navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        storyboardName = @"Main_iPad";
    }
    else {
        //iPhone
        navigationController = (UINavigationController *)self.window.rootViewController;
        storyboardName = @"Main_iPhone";
    }
    
    
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        //Determine if the network is available
        BOOL isReachable = ![AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"];
        
        //Network is not reachable, let the user know
        if (!isReachable) {
            //Create an alert to notify the user there is no network connection
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                            message:@"You must connect to the Internet to use this application."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            //Show the alert
            [alert show];
            
            //Load a view that shows there is no internet connection
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            _vc = [storyboard instantiateViewControllerWithIdentifier:@"bcplNoData"];
            [navigationController pushViewController:_vc animated:NO];
        }
        
        
    }];
    
    // Start monitoring the internet connection
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void) initialize {
    // TODO: put in whatever custom user agent you want here:
    NSString* userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.168 Safari/535.19";
    
    NSDictionary* initDefaults = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  userAgent, @"UserAgent",
                                  nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:initDefaults];
}

@end
