//
//  CLuckyDrawViewController.h
//  Couper
//
//  Created by Vinay on 23/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZTimerLabel.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
#import "FBGraphViewController.h"
#import "CCustomTopBar.h"
#import "CDCircle.h"
#import "NextCouponDecider.h"
#import "CContactPicker.h"
#import "CAdBannerHandler.h"
#import "CSpinDetailsVC.h"
#import "CSpinWinningVC.h"


@interface CLuckyDrawViewController : UIViewController <MZTimerLabelDelegate,CCustomTopBarDelegate,CDCircleDelegate, CDCircleDataSource,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,CContactPickerDelegate,ADBannerViewDelegate,FBLoginDelegate,SpinDetailsProtocol,SpinWinningDelegate>
{
    MZTimerLabel *mzTimer;
    IBOutlet UIImageView *indicatorImageView;
    IBOutlet UIImageView *circleImageView;

    
    NSMutableArray *imageArray;
    NSArray *luckyDrawCouponArray;
    NSDictionary *luckyDrawDict;
    NSDictionary *topPlayerDict;
    
    NextCouponDecider *nextCouponDecider;
    CDCircle *circle;
    CDCircleOverlayView *overlay;
    
    ACoupon *aWiningCoupon;
    NSArray *SB_userArray;
    NSOperationQueue *operationQueue;
    UIView *winingView;
    
    NSDictionary *victimUser;
}

/*Controls and Methods for Timer*/
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *powerLevelLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *powerProgressBar;

@property (weak, nonatomic) IBOutlet UIButton *btnStartPause;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendsBtn;


@property (weak, nonatomic) IBOutlet UILabel *luckyDrawNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *chanceLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalGoldLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalGoldInWordLbl;
@property (weak, nonatomic) IBOutlet UIView *prizeListView;


@property (weak, nonatomic) IBOutlet UITableView *prizeListTV;

@property (nonatomic) NSInteger noOfSlot;
@property (nonatomic) NSInteger shareable;

@property (nonatomic,strong) ADBannerView *bannerView;

@property(nonatomic, weak) IBOutlet UIView *adView;


@end
