//
//  CMoreChanceVC.m
//  Couper
//
//  Created by vinay on 05/05/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "CMoreChanceVC.h"
#import "CTags.h"
#import "CWebHandler.h"
#import "Utils.h"
#import "CSharedContent.h"
#import "CShared.h"
#import "FBGraphViewController.h"
#import "CAdBannerHandler.h"
#import "AppDelegate.h"





#define APP_KEY @"3c3c4909"
#define UNIQUE_USERID @"demoUserId"

#define XNATIVE_APP_KEY @"29432"

@implementation CMoreChanceVC

@synthesize demoOWDelegate;
@synthesize demoRVDelegate;
@synthesize nativeOWDelegate;

-(void)viewDidLoad
{
    [super viewDidLoad];

    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, SCREEN_HEIGHT-180, 320, 50) currentController:self.view];
    
    [self.videoBtn setEnabled:NO];
    [self.appWallBtn setEnabled:NO];
    [self.moreAppWallBtn setEnabled:NO];
    
    [self.videoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.appWallBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.moreAppWallBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //[self.mainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 340)];
    [self setCenterFadeInAnimation];
    
    [SUSupersonicAdsConfiguration getConfiguration].useClientSideCallbacks = [NSNumber numberWithInt:1];
    [SUSupersonicAdsConfiguration getConfiguration].language = @"EN";
    
    //Initialize an instance of the 'Offerwall' callbacks delegate
    [self setDemoOWDelegate: [[DemoOWDelegate alloc] initWithView:self]];
    [[Supersonic sharedInstance] setOWDelegate:[self demoOWDelegate]];
    [[Supersonic sharedInstance] initOWWithAppKey:APP_KEY withUserId:UNIQUE_USERID];
    
    
    //Video Advertisement
    //Initialize an instance of the 'Rewarded Video' callbacks delegate
    [self setDemoRVDelegate: [[DemoRVDelegate alloc] initWithView:self]];
    [[Supersonic sharedInstance] setRVDelegate:[self demoRVDelegate]];
    [[Supersonic sharedInstance] initRVWithAppKey:APP_KEY withUserId:UNIQUE_USERID];

    // XNative OfferWall
    self.nativeOWDelegate = [[XNativeOWDelegate alloc] initWithView:self];
    
    [[NativeXSDK sharedInstance] setDelegate:self.nativeOWDelegate];
    //[[NativeXSDK sharedInstance] createSessionWithAppId:XNATIVE_APP_KEY];
    
    NSString *sesstionId = [[NativeXSDK sharedInstance] getSessionId];
    
    if(sesstionId)
    {
        [self performSelector:@selector(refreshSession:) withObject:sesstionId afterDelay:0.3];
    }
    else
        [[NativeXSDK sharedInstance] createSessionWithAppId:XNATIVE_APP_KEY];
    
}



-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@"spinview" currentVC:self leftBtn:YES rightBtn:NO];
}

#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)animationDone
{
    [self.view removeFromSuperview];
}


-(IBAction)crossBtnAction:(id)sender
{
    [self setCenterFadeoutAnimation];
}

-(IBAction)videoBtnAction:(UIButton *)sender
{
    [[Supersonic sharedInstance] showRVWithViewController:self];
}

-(IBAction)appWallBtnAction:(UIButton *)sender
{
    [[Supersonic sharedInstance] showOWWithViewController:self];
}


-(IBAction)moreAllWallBtnAction:(UIButton *)sender
{
    //[[NativeXSDK sharedInstance] actionTakenWithActionID:XNATIVE_APP_KEY];
    
        [[NativeXSDK sharedInstance] showReadyAdStatelessWithPlacement:kAdPlacementGameLaunch delegate:self.nativeOWDelegate rootViewController:self];
}


-(void)refreshSession:(NSString *)sesstionId
{
    [[NativeXSDK sharedInstance] createSessionWithAppId:XNATIVE_APP_KEY andPublisherUserId:sesstionId];
    [self performSelector:@selector(fetchNativeAdForSession) withObject:nil afterDelay:0.3];
    
}


-(void)checkReemedValue
{
    [[NativeXSDK sharedInstance] redeemRewards];
    THIS.isRedirectFromApp = FALSE;
    [self fetchNativeAdForSession];
}

-(void)closeNativeXPopup
{
    [[NativeXSDK sharedInstance] redeemRewards];
    [self fetchNativeAdForSession];
}

-(void)fetchNativeAdForSession
{
    [[NativeXSDK sharedInstance] fetchAdStatelessWithPlacement:kAdPlacementGameLaunch withAppId:XNATIVE_APP_KEY delegate:self.nativeOWDelegate];

}

-(void)enableButtonWithSession
{
    [_moreAppWallBtn setEnabled:YES];
    [self.moreAppWallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}


- (void) enableMoreOWButton {
    dispatch_async(dispatch_get_main_queue(), ^{

        [self enableButtonWithSession];
    });
}

- (void) disableMoreOWButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_moreAppWallBtn setEnabled:NO];
        [self.moreAppWallBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    });
}



- (void) enableOWButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_appWallBtn setEnabled:YES];
        [self.appWallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    });
}

- (void) enableRVButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_videoBtn setEnabled:YES];
        [self.videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
}

- (void) disableRVButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_videoBtn setEnabled:NO];
        [self.videoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    });
}

-(void)getOfferWallCredits:(NSDictionary *)creditDict
{
    [[Supersonic sharedInstance] getOWCredits];
}


-(void)getVideoCredit:(NSString *)_amount
{
    [self performSelectorInBackground:@selector(addShareAPI:) withObject:_amount];
}



#pragma mark Add Share API Methods

-(void)addShareAPI:(NSString *)_totalSpin
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getShareParameters:_totalSpin] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue])
        {
            [Utils alert:[NSString stringWithFormat:@"You will receive %@ spin(s) shortly.",_totalSpin]];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}

-(NSString *)getShareParameters:(NSString *)_totalSpin
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=add_share_luckydraw"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",[CShared getLuckDrawId]];
    [_requestUrl appendFormat:@"&no_of_shares=%@",_totalSpin];
    [_requestUrl appendFormat:@"&platform=%@",PLATFORM_Ad];
    [_requestUrl appendFormat:@"&share_list=%@",@""];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}



@end
