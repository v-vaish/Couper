//
//  XNativeOWDelegate.m
//  couper
//
//  Created by vinay on 15/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import "XNativeOWDelegate.h"
#import "CMoreChanceVC.h"
#import "AppDelegate.h"

@interface XNativeOWDelegate ()

@property (atomic,strong) CMoreChanceVC *moreChanceVC;

@end


@implementation XNativeOWDelegate


- (id) initWithView:(CMoreChanceVC*) view{
    [self setMoreChanceVC:view];
    return self;
}


// Called if the SDK initializes successfully
- (void)nativeXSDKDidCreateSession {
    NSLog(@"Wahoo! Now I'm ready to show an ad.");
    [self.moreChanceVC fetchNativeAdForSession];
    
}

// Called if the SDK fails to initialize.
- (void)nativeXSDKDidFailToCreateSession:(NSError *)error {
    NSLog(@"Oh no! Something isn't set up correctly - re-read the documentation or ask customer support for some help - https://selfservice.nativex.com/Help");
}

- (void) nativeXSDKDidRedeemWithRewardInfo:(NativeXRewardInfo *)rewardInfo {
    // Add code to handle the reward info and credit your user here.
    int totalRewardAmount = 0;
    for (NativeXReward *reward in rewardInfo.rewards) {
        NSLog(@"Reward: rewardName:%@ rewardId:%@ amount:%@", reward.rewardName, reward.rewardId, reward.amount);
        // grab the amount and add it to total
        totalRewardAmount += [reward.amount intValue];
    }
    
    if(totalRewardAmount > 0)
        [self.moreChanceVC getVideoCredit:[NSString stringWithFormat:@"%d",totalRewardAmount]];
}


-(void)nativeXSDKDidRedeemWithError:(NSError *)error
{
    NSLog(@"Native X Error = %@",[error description]);
}

- (void)nativeXAdView:(NativeXAdView *)adView didLoadWithPlacement:(NSString *)placement
{
    
    NSLog(@"didLoadWithPlacement Called");
    [[self moreChanceVC] enableMoreOWButton];
    //Called when an ad has been loaded/cached and is ready to be shown
}

-(void)nativeXAdViewDidDismiss:(NativeXAdView *)adView
{
    NSLog(@"nativeXAdViewDidDismiss Called");
    [THIS.tabBarController.tabBar setHidden:NO];
    [self.moreChanceVC disableMoreOWButton];
    
    if(!THIS.isRedirectFromApp)
        [self.moreChanceVC closeNativeXPopup];
    else
        [self.moreChanceVC checkReemedValue];
    
    
}

- (void)nativeXAdViewWillDisplay:(NativeXAdView *)adView
{
    [THIS.tabBarController.tabBar setHidden:YES];
}


- (void)nativeXAdViewWillRedirectUser:(NativeXAdView *)adView;
{
    THIS.isRedirectFromApp = TRUE;
    
     NSLog(@"nativeXAdViewWillRedirectUser Called");
}




@end
