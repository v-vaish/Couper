//
//  CAdBannerHandler.h
//  Couper
//
//  Created by vinay on 19/05/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface CAdBannerHandler : UIViewController <GADBannerViewDelegate>

@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) GADBannerView *bannerView;
@property (nonatomic,strong) UIView *currentView;

+(CAdBannerHandler *)instance;
-(void)addBanner:(CGRect)_frame currentController:(UIView *)currentView;


@end
