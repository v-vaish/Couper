//
//  CSpinWinningVC.m
//  couper
//
//  Created by vinay on 17/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import "CSpinWinningVC.h"
#import "CAdBannerHandler.h"
#import "CShared.h"
#import "CTags.h"

@interface CSpinWinningVC ()

@end

@implementation CSpinWinningVC

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:_scrollView];
    
    spinArray = [CShared getSpinList];
    goldArray = [CShared getGoldList];

    [self addAdImpression];
    [self displayMsgByUsedSpin];
}

-(void)addAdImpression
{
    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, SCREEN_HEIGHT-180, 320, 50) currentController:self.view];
}

-(void)displayMsgByUsedSpin
{
    NSInteger goldIndex = [spinArray indexOfObject:userUsedSpin];
    NSString *winningGold = goldArray[goldIndex];
    
    _winningMsgLbl.text = [NSString stringWithFormat:@"You receive %@ Gold for completing %@ spins today! Spin more, Win more!",winningGold,userUsedSpin];
}


-(void)setUserSpin:(NSString *)usedSpin 
{
    userUsedSpin = usedSpin;
}

-(IBAction)crossBtnAction:(id)sender
{
    if([delegate respondsToSelector:@selector(winningPopupClosed:)])
        [delegate winningPopupClosed:self];
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
