//
//  CMoreChanceVC.h
//  Couper
//
//  Created by vinay on 05/05/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Supersonic/Supersonic.h>
#import <Supersonic/SupersonicConfiguration.h>
#import <Supersonic/SUSupersonicAdsConfiguration.h>

#import "FBGraphViewController.h"
#import "DemoOWDelegate.h"
#import "DemoRVDelegate.h"
#import "CCustomTopBar.h"
#import "XNativeOWDelegate.h"


@interface CMoreChanceVC : UIViewController <CCustomTopBarDelegate,FBLoginDelegate>

@property(nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, weak) IBOutlet UIView *adView;

@property(nonatomic, weak) IBOutlet UIButton *videoBtn;
@property(nonatomic, weak) IBOutlet UIButton *appWallBtn;
@property(nonatomic, weak) IBOutlet UIButton *moreAppWallBtn;

//An instance of a delegate that provides 'Offerwall' callbacks
@property (atomic,strong) DemoOWDelegate *demoOWDelegate;
@property (atomic,strong) DemoRVDelegate *demoRVDelegate;
@property (atomic,strong) XNativeOWDelegate *nativeOWDelegate;

-(void)enableOWButton;
-(void)enableRVButton;
-(void)disableRVButton;
-(void)enableMoreOWButton;
-(void)disableMoreOWButton;

-(void)getOfferWallCredits:(NSDictionary *)creditDict;
-(void)getVideoCredit:(NSString *)_amount;
-(void)fetchNativeAdForSession;
-(void)checkReemedValue;
-(void)closeNativeXPopup;
@end
