//
//  bcpliTunesController.m
//  LibraryMasterDetail
//
//  Created by Marty on 10/6/14.
//  Copyright (c) 2014 ___martypowell___. All rights reserved.
//

#import "bcpliTunesController.h"

@interface bcpliTunesController ()

@end

@implementation bcpliTunesController

- (void)setMenuItem:(id)menuItem
{
    _menuItem = menuItem;
    
    _wvUrl = [_menuItem objectForKey:@"url"];
    _wvTitle = [_menuItem objectForKey:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_wvUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
