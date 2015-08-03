//
//  CTermAndConditionsViewController.m
//  Couper
//
//  Created by Appy on 16/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CTermAndConditionsViewController.h"
#import "CCustomTopBar.h"

@interface CTermAndConditionsViewController ()

@end

@implementation CTermAndConditionsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTopBar];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@"T&C" currentVC:self leftBtn:YES rightBtn:NO];
}

#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
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
