//
//  CAdBannerHandler.m
//  Couper
//
//  Created by vinay on 19/05/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CAdBannerHandler.h"
#import "CShared.h"

@implementation CAdBannerHandler
@synthesize delegate;


static CAdBannerHandler *bannerHandler = nil;

+(CAdBannerHandler *)instance
{
    if(bannerHandler == nil)
        bannerHandler = [[CAdBannerHandler alloc] init];
    
    return bannerHandler;
}

-(void)addBanner:(CGRect)_frame currentController:(UIView *)_currView
{
    _currentView  = _currView;
    
    
    _bannerView = [[GADBannerView alloc] initWithFrame:_frame];
    [_currentView addSubview:_bannerView];
    
    
    // Replace this ad unit ID with your own ad unit ID.
    _bannerView.adUnitID = @"ca-app-pub-6778033182322148/4304848519";
    _bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[[NSString stringWithFormat:@"%@",[CShared deviceId]]  // Eric's iPod Touch
                            ];
    
    
    [_bannerView loadRequest:request];
}



#pragma mark Banner Delegates

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  _currentView.frame.size.height -
                                  bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
}


- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {

    //NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}


@end
