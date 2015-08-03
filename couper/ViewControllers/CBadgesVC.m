//
//  CBadgesVC.m
//  Couper
//
//  Created by vinay on 06/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CBadgesVC.h"


#define MAXIMUM_VALUE 2000


@implementation CBadgesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTopBar];
    
    
    
    [self setResponse];
    
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@"profile" currentVC:self leftBtn:YES rightBtn:NO];
}


-(void)initialization
{
    UIImage *_trackImage = [UIImage imageNamed:@""];
    UIImage *_processImage = [UIImage imageNamed:@""];
    
    [progressBarExperience setTrackImage:_trackImage];
    [progressBarExperience setProgressImage:_processImage];

    [progressBarStarbucks setTrackImage:_trackImage];
    [progressBarStarbucks setProgressImage:_processImage];

    [progressBarCoffee setTrackImage:_trackImage];
    [progressBarCoffee setProgressImage:_processImage];
    
}
-(void)setResponse
{
    NSMutableDictionary *_tempDict = [[NSMutableDictionary alloc] init];
    [_tempDict setObject:@"1255" forKey:@"experience_bar_value"];
    [_tempDict setObject:@"1355" forKey:@"starbucks_bar_value"];
    [_tempDict setObject:@"1155" forKey:@"coffee_bar_value"];
    
    [self increaseProgressvalue:[_tempDict[@"experience_bar_value"] floatValue]/MAXIMUM_VALUE progressBar:progressBarExperience];
    [self increaseProgressvalue:[_tempDict[@"starbucks_bar_value"] floatValue]/MAXIMUM_VALUE progressBar:progressBarStarbucks];
    [self increaseProgressvalue:[_tempDict[@"coffee_bar_value"] floatValue]/MAXIMUM_VALUE progressBar:progressBarCoffee];

}


#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)increaseProgressvalue:(float)_value progressBar:(UIProgressView *)_progressBar
{
    _progressBar.progress = _value;
}




@end
