//
//  CGoldInformationVC.m
//  Couper
//
//  Created by vinay on 26/06/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import "CGoldInformationVC.h"
#import "CWebHandler.h"
#import "CSharedContent.h"
#import "CShared.h"
#import "Utils.h"
#import "CTags.h"
#import "CAdBannerHandler.h"

@implementation CGoldInformationVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view bringSubviewToFront:_scrollView];
    [_scrollView setContentSize:CGSizeMake(280, 550)];
    [self setCenterFadeInAnimation];
    [self createIncreaseGoldList];
    
    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, SCREEN_HEIGHT-180, 320, 50) currentController:self.view];

    
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(getGoldAPI) withObject:nil afterDelay:0.1];
}


-(void)createIncreaseGoldList
{
    increaseSpinListArr = [CShared getSpinList];
    increaseGoldListArr = [CShared getGoldList];
    
}

-(void)setCenterFadeInAnimation
{
    self.view.alpha = 0.0f;
    self.view.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.view.transform = CGAffineTransformMakeScale(1,1);
    self.view.alpha = 1.0f;
    [UIView commitAnimations];
}


-(void)setCenterFadeoutAnimation
{
    self.view.alpha = 1.0f;
    self.view.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.view.transform = CGAffineTransformMakeScale(0.1,0.1);
    self.view.alpha = 0.0f;
    [UIView commitAnimations];
}


-(IBAction)crossBtnAction:(id)sender
{
    [self setCenterFadeoutAnimation];
}

-(void)animationDone
{
    [self.view removeFromSuperview];
}


#pragma mark Get Gold API Methods

-(void)getGoldAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        [Utils hideIndicatorView:self.view];
        
        if([_responseDict[@"result"] intValue])
        {
            
            [self updateUIInformation:_responseDict[@"data"]];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getParameters
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=get_gold"];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",[CShared getLuckDrawId]];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}



-(void)updateUIInformation:(NSDictionary *)_tempDict
{
    
    _topBarLbl.text = [NSString stringWithFormat:@"1$ = %@",_tempDict[@"current_gold_rate"]];
    
    NSString *currentGoldPrice = _tempDict[@"current_gold_rate"];
    NSString *userEarnGold = _tempDict[@"gold"];
    
    int leftGold = [currentGoldPrice intValue] - ([userEarnGold intValue]%[currentGoldPrice intValue]);
    float earnDollar = [userEarnGold floatValue]/[currentGoldPrice floatValue];
    
    _goldEarnedTF.text = [NSString stringWithFormat:@"%@",userEarnGold];
    _dollerEarnedTF.text = [NSString stringWithFormat:@"%.2f",earnDollar];
    
    if(earnDollar >= 1)
    {
        //_goldLeftIV.image = [UIImage imageNamed:@"greatJob_icon.png"];
        _leftToCashoutLbl.text = [NSString stringWithFormat:@"You can now cashout!"];
    }
    else
    {
        //_goldLeftIV.image = [UIImage imageNamed:@"soon_icon.png"];
        _leftToCashoutLbl.text = [NSString stringWithFormat:@"%d more gold to cashout",leftGold];
    }
    
    
    
    
    BOOL status = FALSE;
    for (int i=0; i<increaseSpinListArr.count; i++) {
        
        if([_tempDict[@"spin_used"] intValue] > 150)
        {
            _nextObjectiveLbl.text = [NSString stringWithFormat:@"Mission Accomplish!"];
            
        }
        else if([increaseSpinListArr[i] intValue] > [_tempDict[@"spin_used"] intValue] && !status)
        {
            int leftSpin = [increaseSpinListArr[i] intValue] - [_tempDict[@"spin_used"] intValue];
            _nextObjectiveLbl.text = [NSString stringWithFormat:@"%d more spin to earn %@ gold",leftSpin,increaseGoldListArr[i]];
            
            status = TRUE;
            
        }
        
        float y_axis = 300;
        UILabel *rewardLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y_axis + (i*30 +15), 260, 30)];
        rewardLbl.text = [NSString stringWithFormat:@"Spin %@ times to earn %@ gold",increaseSpinListArr[i],increaseGoldListArr[i]];
        rewardLbl.font = [UIFont systemFontOfSize:13];
        rewardLbl.textColor = [UIColor darkGrayColor];
        [_scrollView addSubview:rewardLbl];
        
        UIImageView *showStatus = [[UIImageView alloc] initWithFrame:CGRectMake(240, y_axis + (i*30 +15), 25, 25)];
        
        if(status)
            showStatus.backgroundColor = [UIColor lightGrayColor];
        else
            showStatus.image = [UIImage imageNamed:@"check_red.png"];
        
        [_scrollView addSubview:showStatus];

    }
    
    
}

@end
