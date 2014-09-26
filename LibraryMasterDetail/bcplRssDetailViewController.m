//
//  bcplRssDetailViewController.m
//  LibraryMasterDetail
//
//  Created by Marty on 9/23/14.
//  Co  pyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcplRssDetailViewController.h"

@interface bcplRssDetailViewController ()
@end

@implementation bcplRssDetailViewController

- (void)setRssDetail:(id)rssDetail {
    _rssDetail = rssDetail;
    
}


- (void)configureView
{
    //self.detailViewController = (bcplDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Set the title of the page to the menu Item selected
    self.navigationItem.title = [_rssDetail objectForKey:@"title"];
    NSString *content = [_rssDetail objectForKey:@"content"];
    
    [_rssDetailView loadHTMLString:content baseURL:nil];
    
    //[_rssDetailLoadingIndicator stopAnimating];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
