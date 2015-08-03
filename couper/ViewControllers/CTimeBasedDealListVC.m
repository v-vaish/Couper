//
//  CTimeBasedDealListVC.m
//  Couper
//
//  Created by vinay on 05/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CTimeBasedDealListVC.h"
#import "CCustomTopBar.h"
#import "CSharedContent.h"
#import "CWebHandler.h"
#import "CTags.h"
#import "Utils.h"
#import "FBGraphViewController.h"





@implementation CTimeBasedDealListVC

int selectedIndex=0;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.couponArray = [NSMutableArray new];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@"timebaseddeal" currentVC:self leftBtn:YES rightBtn:NO];
}

#pragma mark - Share Action

- (void)shareBtn:(UIButton *)sender{
    
    int cellIndex = (int)sender.tag - 100;
    selectedIndex = cellIndex;
    NSDictionary *cellDict = [self.couponArray objectAtIndex:cellIndex];
    
    FBGraphViewController *_fbGraphVC = [FBGraphViewController instance];
    _fbGraphVC.delegate = self;
    NSDictionary *dic = @{@"picture" :cellDict[@"coupon_image"],@"description" :cellDict[@"description"],@"name" :cellDict[@"name"]};
    
    [_fbGraphVC setPostData:dic];
    [_fbGraphVC fbPost];

}


@end
