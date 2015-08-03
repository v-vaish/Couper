//
//  CSpinDetailsVC.m
//  Couper
//
//  Created by vinay on 06/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import "CSpinDetailsVC.h"
#import "CMoreChanceVC.h"
#import "CAdBannerHandler.h"
#import "CTags.h"

@implementation CSpinDetailsVC

@synthesize delegate;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view bringSubviewToFront:_scrollView];
    [self setCenterFadeInAnimation];
    
    [self updateInformationOnUI];
    [self addAdImpression];
    [self setCountDownTime:[self calculateNextSpinTime]];
    [self performSelector:@selector(startOrResumeStopwatch) withObject:nil afterDelay:0.1];
}

-(void)addAdImpression
{
    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, SCREEN_HEIGHT-180, 320, 50) currentController:self.view];
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
    [UIView beginAnimations:@"fadeOutNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.view.transform = CGAffineTransformMakeScale(0.1,0.1);
    self.view.alpha = 0.0f;
    [UIView commitAnimations];
    
    [self performSelector:@selector(animationDone) withObject:nil afterDelay:1];
}


-(IBAction)crossBtnAction:(id)sender
{
    [self setCenterFadeoutAnimation];
}

-(IBAction)moreSpinBtnAction:(id)sender
{
    CMoreChanceVC *moreChanceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreSpin"];
    [self addChildViewController:moreChanceVC];
    [moreChanceVC didMoveToParentViewController:self];
    [self.view addSubview:moreChanceVC.view];
}


-(void)animationDone
{
    if([delegate respondsToSelector:@selector(closeSpinPopup:)])
        [delegate closeSpinPopup:self];
    
    //[self.view removeFromSuperview];
}

-(void)setTotalSpin:(NSString *)totalSpin
{
    totalSpinStr = totalSpin;
}

-(void)updateInformationOnUI
{
    _totalSpinLbl.text = [NSString stringWithFormat:@"%@/5",totalSpinStr];
}


-(int )calculateNextSpinTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    
    NSDate *date = [NSDate date];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    int currentMinute = [dateStr intValue];
    int leftTime = 30 - ((currentMinute > 30)?currentMinute-30:currentMinute);
    
    //NSLog(@"time left = %d",leftTime);

    return leftTime * 60; // change in second
}


-(void)setCountDownTime:(NSTimeInterval)_countDownTime
{
    if(_countDownTime > 0)
    {
        if(!mzTimer)
            mzTimer = [[MZTimerLabel alloc] initWithLabel:_countDownTimerLbl andTimerType:MZTimerLabelTypeTimer];
        mzTimer.timeFormat = @"mm:ss";
        mzTimer.resetTimerAfterFinish = YES;
        mzTimer.delegate = self;
        
        [mzTimer setCountDownTime:_countDownTime];
    }
    else
    {
        _totalSpinLbl.text = [NSString stringWithFormat:@"%d/5",[totalSpinStr intValue]+1];
        
        [self setCountDownTime:[self calculateNextSpinTime]];
        [self performSelector:@selector(startOrResumeStopwatch) withObject:nil afterDelay:0.1];
    }
}


#pragma mark CountDownTimer Methods

//- (IBAction)startOrResumeStopwatch:(id)sender {
- (void)startOrResumeStopwatch {
    
    /* if([mzTimer counting]){
     [mzTimer pause];
     [_btnStartPause setTitle:@"Resume" forState:UIControlStateNormal];
     }else{*/
    [mzTimer start];
    
    //}
}

- (IBAction)resetStopWatch:(id)sender {
    [mzTimer reset];
    
    if(![mzTimer counting]){
       // [_btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
    }
}



@end
