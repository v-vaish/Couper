//
//  CLuckyDrawViewController.m
//  Couper
//
//  Created by Vinay on 23/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "CLuckyDrawViewController.h"
#import "CDCircleOverlayView.h"
#import "CUserDetails.h"
#import "CWebHandler.h"
#import "Utils.h"
#import "CSharedContent.h"
#import "UserCouponStatistics.h"
#import "CTags.h"
#import "AppDelegate.h"
#import "CShared.h"
#import "StaticMessages.h"
#import "UIView+Animation.h"
#import "CGoldInformationVC.h"
#import "CMoreChanceVC.h"
#import "CPrizeDetailsVC.h"



#define COUPON_TYPE_NEGATIVE    1
#define COUPON_TYPE_POSITIVE    2
#define COUPON_TYPE_COUPON      3
#define COUPON_TYPE_GRAND_PRIZE 4
#define COUPON_TYPE_BOMB        6
#define COUPON_TYPE_STEAL_GOLD  7
#define COUPON_TYPE_GOLD        8
#define COUPON_TYPE_STEAL_POWER 9


static NSArray *recipientsArray = nil;

@implementation CLuckyDrawViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.prizeListTV.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView setContentSize:CGSizeMake(320, 445)];
    [_totalGoldInWordLbl.layer setCornerRadius:5.0];
    _totalGoldInWordLbl.clipsToBounds = YES;
    [Utils makeCircleImage:circleImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLuckyDrawInfo:) name:@"pushNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self addTopBar];
    
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(luckDrawCouponAPI) withObject:nil afterDelay:0.1];
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar setRightButtonImage:[UIImage imageNamed:@"casout_btn.png"]];
    [_customTopBar createTopBar:@"home" currentVC:self leftBtn:NO rightBtn:YES];
}

-(void)rightBtnListner
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CashoutManager"] animated:YES];
}



-(void)refreshLuckyDrawInfo:(NSNotification*)notification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
    [self performSelector:@selector(luckDrawCouponAPI) withObject:nil];
        
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
        
            });
         */
    });
}

#pragma mark Lucky Draw Coupon API Methods

-(void)luckDrawCouponAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
       // NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue])
        {
            NSArray *luckyDrawListArray = _responseDict[@"data"][@"lucky_draw_list"];
            luckyDrawDict = luckyDrawListArray[0];
            [CShared setLuckDrawId:luckyDrawDict[@"draw_id"]];
            
            // save server response in data models
            UserCouponStatistics *statistics = [[UserCouponStatistics alloc] initWithDictionary:luckyDrawDict];
            nextCouponDecider = [[NextCouponDecider alloc] initWithUserCouponStatistics:statistics];
            
            [self updateUIValue];
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
    [_requestUrl appendFormat:@"m=get_lucky_draw_list"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}

-(void)updateUIValue
{
    [self.luckyDrawNoLbl setText:[NSString stringWithFormat:@"Lucky Draw %@",luckyDrawDict[@"draw_id"]]];
    luckyDrawCouponArray = luckyDrawDict[@"coupons"];
    self.noOfSlot = luckyDrawCouponArray.count;
    self.chanceLeftLbl.text = [NSString stringWithFormat:@"%@/5",luckyDrawDict[@"total_spins_left"]];
    
    int totalGold = [luckyDrawDict[@"gold"] intValue];
    [self changeGoldInWord:totalGold];
    
    [_scrollView bringSubviewToFront:_totalGoldLbl];
    self.powerLevelLbl.text = [NSString stringWithFormat:@"%@ / 1000",luckyDrawDict[@"user_power_level"]];
    
    float powerValue = [luckyDrawDict[@"user_power_level"] floatValue]/1000;
    [self.powerProgressBar setProgress:powerValue animated:YES];
    
    self.shareable =[luckyDrawDict[@"shareable"] integerValue];
    
    [self.view bringSubviewToFront:self.prizeListView];
    
    NSTimeInterval timeLeft= [Utils differenceTwoDate:luckyDrawDict[@"server_time"] endDate:luckyDrawDict[@"end_date_time"]];
    //int numberOfDays = timeLeft / 86400;
    //if(numberOfDays > 0)
      //timeLeft = timeLeft - 86400;
    //else
    //    timeLeft = timeLeft;
    
    // Start timer
    [self setCountDownTime:timeLeft];
    [self performSelector:@selector(startOrResumeStopwatch) withObject:nil afterDelay:0.1];
    
    if(timeLeft >0){
        
        [self performSelector:@selector(startOrResumeStopwatch) withObject:nil afterDelay:0.1];
    }
    else{
        
        if (![CShared getGrandPriceStatus]) {
            [CShared setGrandPriceStatus:TRUE];
            UIAlertView *warningAlert2 = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:SM_GRAND_PRICE_WINNING delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert2 show];
        }
    }

    // Add wheel after download all images
    [Utils hideIndicatorView:self.view];
    [self addWheel];
    
    //Enable Circle Touch
    if([luckyDrawDict[@"total_spins_left"] intValue] <= 0){
        [self WheelTouchDisable];
        [Utils alert:@"You have ran out of spins ): Get more spins?"];
        
    }
    else
    {
        [self WheelTouchEnable];
    }
}

-(void)changeGoldInWord:(int)totalGold
{
    NSString *goldStr;
    if(totalGold >= 1000)
    {   totalGold = totalGold/1000;
        goldStr = [NSString stringWithFormat:@"%d",totalGold];
        _totalGoldInWordLbl.text = [NSString stringWithFormat:@"Thousand"];
    }
    else if(totalGold < 1000 && (totalGold >= 100))
    {
        goldStr = [NSString stringWithFormat:@"%d",totalGold/100];
        _totalGoldInWordLbl.text = [NSString stringWithFormat:@"Hundred"];
    }
    else
    {
        goldStr = [NSString stringWithFormat:@"%d",totalGold];
        _totalGoldInWordLbl.text = [NSString stringWithFormat:@"Zero"];
    }
    
    _totalGoldLbl.text = goldStr;
}

-(void)WheelTouchEnable
{
    [circle setUserInteractionEnabled:YES];
}

-(void)WheelTouchDisable
{
    [circle setUserInteractionEnabled:NO];
}


#pragma mark Update Coupon History API Methods

-(void)updateCouponHistory
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getHistoryParameters:aWiningCoupon] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue])
        {
            victimUser = nil;
            if([aWiningCoupon.couponType intValue] == 4 && [_responseDict[@"message"] length] > 0)
                [Utils alert:_responseDict[@"message"]];
            
            [self performSelector:@selector(checkWinningSpinCount) withObject:nil afterDelay:4];
            
            
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}

-(NSString *)getHistoryParameters:(ACoupon *)_aCoupon
{
    NSString *victimUserId = victimUser[@"id"];
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=add_luckydraw_spin_history_v2"];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",luckyDrawDict[@"draw_id"]];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&coupon_id=%@",_aCoupon.couponId];
    [_requestUrl appendFormat:@"&coupon_type=%@",_aCoupon.couponType];
    [_requestUrl appendFormat:@"&power=%@",_aCoupon.power];
    [_requestUrl appendFormat:@"&victim_user_id=%@",(victimUserId.length == 0)?@"0":victimUserId];
    
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}

-(void)checkWinningSpinCount
{
    int userUsedSpin = [luckyDrawDict[@"spin_used_today"] intValue] + 1;
    
    if(userUsedSpin == 10 || userUsedSpin == 25 || userUsedSpin == 45 || userUsedSpin == 60 || userUsedSpin == 85 || userUsedSpin == 120 || userUsedSpin == 150)
        [self openWinningSpinopup:userUsedSpin];
    else
    {
        [Utils showIndicatorView:self.view];
        [self performSelectorInBackground:@selector(luckDrawCouponAPI) withObject:nil];
    }
}

-(void)openWinningSpinopup:(int)spin
{
    CSpinWinningVC *winningVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SpinWinning"];
    winningVC.delegate = self;
    [winningVC setUserSpin:[NSString stringWithFormat:@"%d",spin]];
    
    [self addChildViewController:winningVC];
    [winningVC didMoveToParentViewController:self];
    [self.view addSubview:winningVC.view];
}

#pragma mark Spin Winning Delegate 

-(void)winningPopupClosed:(UIViewController *)currentVC
{
    [currentVC.view removeFromSuperview];
    
    [Utils showIndicatorView:self.view];
    [self performSelectorInBackground:@selector(luckDrawCouponAPI) withObject:nil];
}

#pragma mark Add Share API Methods

-(void)addShareAPI:(NSString *)_platform
{
    
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getShareParameters:_platform] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue])
        {
            [self performSelectorInBackground:@selector(luckDrawCouponAPI) withObject:nil];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getShareParameters:(NSString *)_platform
{
    NSString *_shareList = @"";
    NSString *_shareCount;
    
    if([_platform isEqualToString:PLATFORM_FB])
    {
        _shareList = @"";
        _shareCount = @"1";
    }
    else
    {
        //NSLog(@"recipientsArray = %@",recipientsArray);
        
        for(NSString *number in recipientsArray)
            _shareList = [_shareList stringByAppendingString:[NSString stringWithFormat:@"%@,",number]];
        
        _shareList = [_shareList substringToIndex:[_shareList length]-1];
        _shareCount = [NSString stringWithFormat:@"%d",(int)recipientsArray.count];
    }
    
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=add_share_luckydraw"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",luckyDrawDict[@"draw_id"]];
    [_requestUrl appendFormat:@"&no_of_shares=%@",_shareCount];
    [_requestUrl appendFormat:@"&platform=%@",_platform];
    [_requestUrl appendFormat:@"&share_list=%@",_shareList];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}



#pragma mark Action Methods

-(IBAction)spinBtnAction:(id)sender
{
    CSpinDetailsVC *spinDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SpinInfo"];
    spinDetailsVC.delegate = self;
    [spinDetailsVC setTotalSpin:[NSString stringWithFormat:@"%@",luckyDrawDict[@"total_spins_left"]]];
    [self addChildViewController:spinDetailsVC];
    [spinDetailsVC didMoveToParentViewController:self];
    [self.view addSubview:spinDetailsVC.view];
}


-(IBAction)goldBtnAction:(id)sender
{
    CGoldInformationVC *goldVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GoldInfo"];
    [self addChildViewController:goldVC];
    [goldVC didMoveToParentViewController:self];
    [self.view addSubview:goldVC.view];

    
}

-(IBAction)moreSpinBtnAction:(id)sender
{
    CMoreChanceVC *moreChanceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreSpin"];
    [self addChildViewController:moreChanceVC];
    [moreChanceVC didMoveToParentViewController:self];
    [self.view addSubview:moreChanceVC.view];
}

-(void)enableOWButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[_appWallBtn setEnabled:YES];
        [[Supersonic sharedInstance] showOW];
    });
}


-(IBAction)viewPrizesBtnAction:(id)sender
{
    CPrizeDetailsVC *prizeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrizeInfo"];
    [prizeVC setCouponArray:nextCouponDecider];
    [self addChildViewController:prizeVC];
    [prizeVC didMoveToParentViewController:self];
    [self.view addSubview:prizeVC.view];
}

-(IBAction)followBtnAction:(id)sender
{
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(followsMerchantAPI) withObject:nil afterDelay:0.1];
}


-(IBAction)closePrizesBtnAction:(id)sender
{
    [self animationFadeOut:self.prizeListView];
}

-(void)animationFadeIn:(UIView *)_animatedView
{
    _animatedView.alpha = 0.0f;
    _animatedView.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    _animatedView.transform = CGAffineTransformMakeScale(1,1);
    _animatedView.alpha = 1.0f;
    [UIView commitAnimations];
}


-(void)animationFadeOut:(UIView *)_animatedView
{
    _animatedView.alpha = 1.0f;
    _animatedView.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    _animatedView.transform = CGAffineTransformMakeScale(0.1,0.1);
    _animatedView.alpha = 0.0f;
    [UIView commitAnimations];

    [self performSelector:@selector(doneFadeOut:) withObject:_animatedView afterDelay:1];
}


-(void)doneFadeOut:(UIView *)_animationView
{
    [self.prizeListView setHidden:YES];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Follow Merchant API Methods

-(void)followsMerchantAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getFollowParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        [Utils hideIndicatorView:self.view];
        if([_responseDict[@"message"] length] > 0)
            [Utils alert:_responseDict[@"message"]];
        
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getFollowParameters
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=update_member_follow_merchant"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&merchant_id=%@",luckyDrawDict[@"merchant_id"]];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}


#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if([aWiningCoupon.couponType intValue] == 7 || [aWiningCoupon.couponType intValue] == 9 || [aWiningCoupon.couponType intValue] == 6)
        return SB_userArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    //if([aWiningCoupon.couponType intValue] == 7 || [aWiningCoupon.couponType intValue] == 9 || [aWiningCoupon.couponType intValue] == 6)
    //{
        NSDictionary *tempDict = SB_userArray[indexPath.row];
        [self createCellForSB:cell row:indexPath singlCouponData:tempDict];
    //}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if([aWiningCoupon.couponType intValue] == 7 || [aWiningCoupon.couponType intValue] == 9 || [aWiningCoupon.couponType intValue] == 6)
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([aWiningCoupon.couponType intValue] == 7 || [aWiningCoupon.couponType intValue] == 9 || [aWiningCoupon.couponType intValue] == 6)
    {
        NSString *couponTypeStr = ([aWiningCoupon.couponType intValue] == 6)?@"Bomb":@"Steal";
        NSDictionary *tempDict = SB_userArray[indexPath.row];
        
        victimUser = tempDict;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you sure you want to %@ %@ user",couponTypeStr,tempDict[@"name"]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self performSelectorInBackground:@selector(updateCouponHistory) withObject:nil];
        [self animationStealBomb];
        
        [winingView removeFromSuperview];
        aWiningCoupon.couponType = @"";
        [self.prizeListView setHidden:YES];
    }
}


-(void)animationStealBomb
{
    UIView *_stealBombView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _stealBombView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_stealBombView];
    
    UIImageView *blackBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    blackBgView.backgroundColor = [UIColor blackColor];
    blackBgView.alpha = 0.5;
    [_stealBombView addSubview:blackBgView];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH -20 , SCREEN_HEIGHT - 200)];
    //bgView.backgroundColor = Color_Dark_Green;
    
    UIColor *bombColor = [UIColor colorWithRed:105/255.0 green:152/255.0 blue:246/255.0 alpha:1];
    UIColor *stealPowerColor = [UIColor colorWithRed:252/255.0 green:90/255.0 blue:100/255.0 alpha:1];
    UIColor *stealGoldColor = [UIColor colorWithRed:31/255.0 green:46/255.0 blue:86/255.0 alpha:1];
    
    if([aWiningCoupon.couponType intValue] == 9)
        [bgView setBackgroundColor:stealPowerColor];
    else if([aWiningCoupon.couponType intValue] == 7)
        [bgView setBackgroundColor:stealGoldColor];
    else if([aWiningCoupon.couponType intValue] == 6)
        [bgView setBackgroundColor:bombColor];
    
    [_stealBombView addSubview:bgView];
    
    float y_axis = 160;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(_stealBombView.frame.size.width/2 - 50, y_axis - 70, 100, 30)];
    titleLbl.font = [UIFont systemFontOfSize:24];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [_stealBombView addSubview:titleLbl];
    
    UILabel *vsLbl = [[UILabel alloc] initWithFrame:CGRectMake(_stealBombView.frame.size.width/2 - 50, y_axis + 20, 100, 30)];
    [vsLbl setText:@"VS"];
    vsLbl.font = [UIFont systemFontOfSize:35];
    vsLbl.textAlignment = NSTextAlignmentCenter;
    vsLbl.textColor = [UIColor whiteColor];
    [_stealBombView addSubview:vsLbl];
    
    float imageWidth = 80;
    float imageHeight = 80;
   
    CSharedContent *sharedContent = [CSharedContent instance];
    
    UIImageView *userIV = [[UIImageView alloc] initWithFrame:CGRectMake(30, y_axis, imageWidth,imageHeight)];
    userIV.backgroundColor = [UIColor blackColor];
    [Utils makeCircleImage:userIV];
    [userIV sd_setImageWithURL:[NSURL URLWithString:sharedContent.userDetails.image] placeholderImage:[UIImage imageNamed:@"user-default.png"]];
    [_stealBombView addSubview:userIV];

    UIImageView *opponentIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, y_axis, imageWidth,imageHeight)];
    opponentIV.backgroundColor = [UIColor blackColor];
    [Utils makeCircleImage:opponentIV];
    [opponentIV sd_setImageWithURL:victimUser[@"profile_img"] placeholderImage:[UIImage imageNamed:@"user-default.png"]];
    [_stealBombView addSubview:opponentIV];

    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    
    UIProgressView *firstPB = [[UIProgressView alloc] initWithFrame:CGRectMake(20, y_axis + 110, 100, 4)];
    firstPB.progressTintColor = [UIColor redColor];//[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1];
    firstPB.trackTintColor = [UIColor colorWithRed:205/255.0 green:190/255.0 blue:112/255.0 alpha:1];
    firstPB.transform = transform;
    [firstPB setProgress:0.5];
    [_stealBombView addSubview:firstPB];

    UIProgressView *secondPB = [[UIProgressView alloc] initWithFrame:CGRectMake(_stealBombView.frame.size.width-120, y_axis + 110, 100, 4)];
    secondPB.progressTintColor = [UIColor redColor];//[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1];
    secondPB.trackTintColor = [UIColor colorWithRed:205/255.0 green:190/255.0 blue:112/255.0 alpha:1];
    secondPB.transform = transform;
    [secondPB setProgress:0.5];
    [_stealBombView addSubview:secondPB];

    
    
    UIImage *_img;
    BOOL isBomb;
    
    if([aWiningCoupon.couponType intValue] == 6)
    {   _img = [UIImage imageNamed:@"kaboom.png"];
        [titleLbl setText:@"Bombing"];
        isBomb = TRUE;
        [Utils playSound:@"bomb" type:@"wav"];
    }
    //else if([aWiningCoupon.couponType intValue] == 7)
      //  _img = [UIImage imageNamed:@"cha_ching.png"];
    else
    {
        _img = [UIImage imageNamed:@"cha_ching.png"];
        [titleLbl setText:@"Stealing"];
        isBomb = FALSE;
        
        [self performSelector:@selector(playChaChingSound) withObject:nil afterDelay:1];
    }
    
    float emojiWidth = 100;
    float emojiHeight = 100;
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 40, (SCREEN_HEIGHT/2 - emojiHeight/2) - 80, emojiWidth , emojiHeight);
    [bgBtn setBackgroundImage:_img forState:UIControlStateNormal];
    [_stealBombView addSubview:bgBtn];
    bgBtn.alpha = 0.0;
    bgBtn.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:2.0f animations:^{
        
        bgBtn.transform = CGAffineTransformMakeScale(1,1);
        bgBtn.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [bgBtn removeFromSuperview];
        [secondPB setProgress:0.0 animated:YES];
        
        if(!isBomb)
        {
            [UIView animateWithDuration:2.0f animations:^{
                [firstPB setProgress:1.0 animated:YES];
                
                UILabel *myPowerLbl = [[UILabel alloc] initWithFrame:CGRectMake( 20, y_axis + 120, 100, 30)];
                [myPowerLbl setText:@"+"];
                myPowerLbl.font = [UIFont systemFontOfSize:35];
                myPowerLbl.textAlignment = NSTextAlignmentCenter;
                myPowerLbl.textColor = [UIColor whiteColor];
                [_stealBombView addSubview:myPowerLbl];
                
            } completion:nil];
        }
        [self performSelector:@selector(taskCompleted:) withObject:_stealBombView afterDelay:2];
    }];
}

-(void)taskCompleted:(UIView *)_sbView
{
    [_sbView removeFromSuperview];
}

-(void)playChaChingSound
{
    [Utils playSound:@"cha_ching" type:@"wav"];
}

-(void)createCellForSB:(UITableViewCell *)_cell row:(NSIndexPath *)_indexPath singlCouponData:(NSDictionary *)_tempDict
{
    [_cell.contentView setBackgroundColor:[UIColor whiteColor]];
    _cell.backgroundColor = _cell.contentView.backgroundColor;
    
    
    NSString *_imageUrl = @"";
    
    if([[_tempDict allKeys] containsObject:@"profile_img"])
        _imageUrl = _tempDict[@"profile_img"];
    else{
        _imageUrl = _tempDict[@"picture"][@"data"][@"url"];
    }
    
    UIImageView *_userImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    _userImage.backgroundColor = [UIColor clearColor];
    [_userImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    [_cell addSubview:_userImage];
    
    UILabel *_CouponName = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, SCREEN_WIDTH - 150, 30)];
    _CouponName.text = _tempDict[@"name"];
    _CouponName.backgroundColor = [UIColor clearColor];
    _CouponName.textColor = [UIColor darkGrayColor];
    [_cell addSubview:_CouponName];
}


-(IBAction)newSendSMS:(id)sender{
    /*
    if ([luckyDrawDict[@"has_shared"] intValue]==0){
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Share to Unlock" message:@"Please share the joy to unlock. Click the \"share to unlock\" button in the center of the wheel" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        
    }else{
     */
    
    [self sendSMS];
        
    //}
}

-(IBAction)newShare:(id)sender{
    
    FBGraphViewController *fbLogin = [FBGraphViewController instance];
    fbLogin.delegate = self;
    [fbLogin setPostData:luckyDrawDict];
    [fbLogin fbPost];
}



#pragma mark ActionSheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self sendSMS];
    }
    else if(buttonIndex == 1)
    {
        FBGraphViewController *fbLogin = [FBGraphViewController instance];
        fbLogin.delegate = self;
        [fbLogin setPostData:luckyDrawDict];
        [fbLogin fbPost];
    }
}

- (void)sendSMS
{
    /*
    if(![Utils isSIMCardExist])
    {
        [Utils alert:@"Sorry SIM Card must be required to use this feature."];
        return;
    }
    */
    
    if ([Utils isContactAccessGranted])
    {
        NSArray *arrContact = [Utils getAllContacts];
        CContactPicker *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactPicker"];
        obj.contactDelegate = self; 
        obj.arrContact = [arrContact mutableCopy];

        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        [Utils alert:@"Permission is not Granted."];
    }
}

#pragma Selected Contact Delegate

-(void)contactSelected:(NSArray *)recipents
{
    recipientsArray = recipents;
    NSString *message = SM_INVITE_FRIEND_SMS;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //[messageController setRecipients:recipents];
    [messageController setBody:message];
    messageController.recipients = recipents;
    
    UIImage *myImage = [UIImage imageNamed:@"couperLogo.jpg"];
    
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments])
    {
        NSData* attachment = UIImageJPEGRepresentation(myImage, 1.0);
        [messageController addAttachmentData:attachment typeIdentifier:@"public.data" filename:@"couperLogo.jpg"];
    }
    
    //Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark Message Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            
            [self performSelectorInBackground:@selector(addShareAPI:) withObject:PLATFORM_SMS];
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCountDownTime:(NSTimeInterval)_countDownTime
{
    if(_countDownTime > 0)
    {
        if(!mzTimer)
        mzTimer = [[MZTimerLabel alloc] initWithLabel:_lblTimer andTimerType:MZTimerLabelTypeTimer];
        mzTimer.timeFormat = @"DD:HH:mm:ss";
        mzTimer.resetTimerAfterFinish = YES;
        mzTimer.delegate = self;
        
        [mzTimer setCountDownTime:_countDownTime];
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
        [_btnStartPause setTitle:@"Pause" forState:UIControlStateNormal];
    //}
}


- (IBAction)resetStopWatch:(id)sender {
    [mzTimer reset];
    
    if(![mzTimer counting]){
        [_btnStartPause setTitle:@"Start" forState:UIControlStateNormal];
    }
}


-(void)addWheel
{
    float circleWidth = SCREEN_WIDTH - (45*2);
    float circleViewWidth = circleWidth + 25;
    
    float circle_x = (circleViewWidth/2) - (circleWidth/2);
    float circleView_x = (SCREEN_WIDTH/2) - (circleViewWidth/2);
    float circleViewIndicator_x = (circleViewWidth/2) - (indicatorImageView.frame.size.width/2);
    CGFloat ringCenterWidth = circleWidth/3;
    
    float circleViewShareBtn_x = (circleViewWidth/2) - (ringCenterWidth/2);
    float circleViewShareBtn_y = (circleViewWidth/2) - (ringCenterWidth/2);
    float circle_y = (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)?110:130;
    
    self.circleView.frame = CGRectMake(circleView_x, circle_y, circleViewWidth, circleViewWidth);
    
    indicatorImageView.frame = CGRectMake(circleViewIndicator_x, 0, indicatorImageView.frame.size.width, indicatorImageView.frame.size.height);
    
    self.shareBtn.frame = CGRectMake(circleViewShareBtn_x, circleViewShareBtn_y, ringCenterWidth,ringCenterWidth);
    CGRect _circleFrame = CGRectMake(circle_x, 12, circleWidth, circleWidth);

    if(!circle)
    {
        circle = [[CDCircle alloc] initWithFrame:_circleFrame numberOfSegments:self.noOfSlot ringWidth:ringCenterWidth];
        circle.dataSource = self;
        circle.delegate = self;
        
        [Utils playSound:@"sound_welcome" type:@"wav"];
    }
    
    if(!overlay)
        overlay = [[CDCircleOverlayView alloc] initWithCircle:circle];
    
    circle.numberOfChance = [luckyDrawDict[@"total_spins_left"] intValue];

    //To modify all thumbs, simply iterate through them and change their properties.
    UIColor *tileBGColor = [UIColor whiteColor];
    UIColor *_grey = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    for (CDCircleThumb *thumb in circle.thumbs) {
        
        [thumb.iconView setHighlitedIconColor:[UIColor lightGrayColor]];
        thumb.separatorColor = [UIColor clearColor];
        
        if(tileBGColor == [UIColor whiteColor])
            tileBGColor = _grey;
        else
            tileBGColor = [UIColor whiteColor];
        
        thumb.separatorStyle = CDCircleThumbsSeparatorBasic;
        thumb.gradientFill = NO;
        thumb.arcColor = tileBGColor;
    }
    
    [self.circleView addSubview:circle];
    //Overlay cannot be subview of a circle because then it would turn around with the circle
    [self.circleView addSubview:overlay];
    
    [self.circleView bringSubviewToFront:indicatorImageView];
    [self.circleView bringSubviewToFront:self.shareBtn];
    
    [self.circleView setHidden:NO];
}

#pragma mark - Circle delegate & data source

-(void) circle:(CDCircle *)circle didMoveToSegment:(NSInteger)segment thumb:(CDCircleThumb *)thumb {
    
    aWiningCoupon = nextCouponDecider.statistics.coupons[segment];
    
    if([aWiningCoupon.couponType intValue] != COUPON_TYPE_GOLD)
    {
        NSTimeInterval timeLeft= [Utils differenceTwoDate:luckyDrawDict[@"server_time"] endDate:luckyDrawDict[@"end_date_time"]];;
        int numberOfDays = timeLeft / 86400;
        
        if(numberOfDays  < 1){
            [Utils alert:SM_GRAND_PRICE_WINNING];
            [self WheelTouchEnable];
            return;
        }
    }
    
    [self performSelector:@selector(animateSelectedCoupon:) withObject:aWiningCoupon afterDelay:0.5];
    
    if([aWiningCoupon.couponType intValue] != 7 && [aWiningCoupon.couponType intValue] != 9 && [aWiningCoupon.couponType intValue] != 6)
        [self performSelectorInBackground:@selector(updateCouponHistory) withObject:nil];
    
    [Utils playSound:@"sound_stop" type:@"wav"];
}



-(UIImage *) circle:(CDCircle *)circle iconForThumbAtRow:(NSInteger)row {
    
    ACoupon *_acoupon = nextCouponDecider.statistics.coupons[row];

    if([_acoupon.noAvailable intValue] == 0)
        return [UIImage imageNamed:@"sold_out"];
    else
        return _acoupon.couponImage;
}

-(NSInteger)getNextCouponId
{
    return [nextCouponDecider getNextCouponSequence];
}

-(void)getStartTouch
{
    [Utils playSound:@"sound_spin" type:@"wav"];
    [self WheelTouchDisable];
}


-(void)animateSelectedCoupon:(ACoupon *)_aCoupon
{
    winingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [winingView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:winingView];
    
    UIImageView *_bgView = [[UIImageView alloc] initWithFrame:winingView.frame];
    UIColor *color = [UIColor whiteColor]; // for example
    _bgView.backgroundColor = [color colorWithAlphaComponent:0.8];
    [winingView addSubview:_bgView];
    
    float viewWidth = 310;
    float viewHeight = 380;
    
    UIImageView *_alertView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - (viewWidth/2), 20, viewWidth, viewHeight)];

    [_alertView.layer setCornerRadius:5.0];
    _alertView.clipsToBounds = YES;
    //[Utils makeCircleImage:_alertView];
    //[self setPopupBGColor:_alertView];
    
    float couponWidth = 150;
    float couponHeight = 150;
    
    UIImageView *selectedCouponImage = [[UIImageView alloc] initWithFrame:CGRectMake(_alertView.frame.size.width/2 - (couponWidth/2), 30, couponWidth, couponHeight)];
    [selectedCouponImage setImage:_aCoupon.couponImage];
    [_alertView addSubview:selectedCouponImage];
    [_alertView setUserInteractionEnabled:YES];
    [winingView addSubview:_alertView];
    
    float couponImageEnd = selectedCouponImage.frame.size.height + selectedCouponImage.frame.origin.y;
    
    UILabel *_couponNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, couponImageEnd, _alertView.frame.size.width - 20, 30)];
    _couponNameLbl.text = _aCoupon.couponName;
    _couponNameLbl.textAlignment = NSTextAlignmentCenter;
    _couponNameLbl.textColor = [UIColor blackColor];
    [_alertView addSubview:_couponNameLbl];
    
    UILabel *_couponDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,_couponNameLbl.frame.origin.y + 15, _alertView.frame.size.width - 20, 60)];
    _couponDescLbl.textColor = [UIColor blackColor];
    _couponDescLbl.numberOfLines = 0;
    _couponDescLbl.font = [UIFont systemFontOfSize:12];
    _couponDescLbl.textAlignment = NSTextAlignmentCenter;
    _couponDescLbl.text = _aCoupon.couponDescription;
    [_alertView addSubview:_couponDescLbl];
    
    float buttonWidth = 200;
    float buttonHeight = 25;
    
    UIColor *buttonColor = [UIColor darkGrayColor];
    
    if([aWiningCoupon.couponType intValue] == 7 || [aWiningCoupon.couponType intValue] == 9 || [aWiningCoupon.couponType intValue] == 6)
    {
        UIButton *topPlayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topPlayerBtn.frame = CGRectMake(_alertView.frame.size.width/2 - (buttonWidth/2), _alertView.frame.size.height - 105, buttonWidth, buttonHeight);
        topPlayerBtn.backgroundColor = buttonColor;
        [topPlayerBtn setTitle:@"Random Players" forState:UIControlStateNormal];
        topPlayerBtn.tag = 1;
        [topPlayerBtn.layer setCornerRadius:5];
        [topPlayerBtn setExclusiveTouch:YES];
        topPlayerBtn.clipsToBounds = YES;
        [topPlayerBtn addTarget:self  action:@selector(SBCategoryListner:) forControlEvents:UIControlEventTouchUpInside];
        topPlayerBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_alertView addSubview:topPlayerBtn];
        
        UIButton *fbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fbBtn.frame = CGRectMake(_alertView.frame.size.width/2 - (buttonWidth/2), _alertView.frame.size.height - 70, buttonWidth, buttonHeight);
        fbBtn.backgroundColor = buttonColor;
        [fbBtn setTitle:@"Facebook Friends" forState:UIControlStateNormal];
        [fbBtn.layer setCornerRadius:5];
        [fbBtn setExclusiveTouch:YES];
        fbBtn.clipsToBounds = YES;
        fbBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        fbBtn.tag = 2;
        [fbBtn addTarget:self  action:@selector(SBCategoryListner:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:fbBtn];
        
        UIButton *revengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        revengeBtn.frame = CGRectMake(_alertView.frame.size.width/2 - (buttonWidth/2), _alertView.frame.size.height - 35, buttonWidth, buttonHeight);
        revengeBtn.backgroundColor = buttonColor;
        [revengeBtn.layer setCornerRadius:5];
        revengeBtn.clipsToBounds = YES;
        [revengeBtn setExclusiveTouch:YES];
        [revengeBtn setTitle:@"Revenge" forState:UIControlStateNormal];
        revengeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        revengeBtn.tag = 3;
        [revengeBtn addTarget:self  action:@selector(SBCategoryListner:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:revengeBtn];
   
        //Call Top player and revenage API
        [self performSelector:@selector(topPlayerAPI) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIButton *bragFB = [UIButton buttonWithType:UIButtonTypeCustom];
        bragFB.frame = CGRectMake(_alertView.frame.size.width/2 - (buttonWidth/2), _alertView.frame.size.height - 65, buttonWidth, buttonHeight);
        bragFB.backgroundColor = buttonColor;
        [bragFB.layer setCornerRadius:5];
        [bragFB setExclusiveTouch:YES];
        bragFB.clipsToBounds = YES;
        [bragFB setTitle:@"share the joy with your friends" forState:UIControlStateNormal];
        [bragFB addTarget:self  action:@selector(bragFBListner:) forControlEvents:UIControlEventTouchUpInside];
        bragFB.titleLabel.font = [UIFont systemFontOfSize:11];
        [_alertView addSubview:bragFB];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(_alertView.frame.size.width/2 - (buttonWidth/2), _alertView.frame.size.height - 30, buttonWidth, buttonHeight);
        okBtn.backgroundColor = buttonColor;
        [okBtn.layer setCornerRadius:5];
        [okBtn setExclusiveTouch:YES];
        okBtn.clipsToBounds = YES;
        [okBtn setTitle:@"I don't want to share" forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [okBtn addTarget:self  action:@selector(okBtnListner:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:okBtn];

    }

    // Add Advertisement banner
    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, winingView.frame.size.height-150, 320, 50) currentController:winingView];
    
    if([_aCoupon.couponType intValue] == COUPON_TYPE_BOMB)
        [Utils playSound:@"sound_negative" type:@"wav"];
    else if([_aCoupon.couponType intValue] == COUPON_TYPE_POSITIVE)
        [Utils playSound:@"sound_positive" type:@"wav"];
    else if([_aCoupon.couponType intValue] == COUPON_TYPE_GOLD)
        [Utils playSound:@"sound_notification" type:@"wav"];
    else
        [Utils playSound:@"sound_notification" type:@"wav"];
    
    [self animationFadeIn:winingView];
    
    //[self performSelector:@selector(animationDone:) withObject:_animationView afterDelay:5];
}


-(void)setPopupBGColor:(UIImageView *)popupView
{
    UIColor *bgColor;
    
    switch ([aWiningCoupon.couponType intValue]) {
        case COUPON_TYPE_POSITIVE:
            //bgColor = [UIColor colorWithRed:198/255.0 green:34/255.0 blue:16/255.0 alpha:1];
            bgColor = [UIColor colorWithRed:253/255.0 green:129/255.0 blue:76/255.0 alpha:1];
            break;
        
        case COUPON_TYPE_BOMB:
            //bgColor = [UIColor colorWithRed:97/255.0 green:0/255.0 blue:35/255.0 alpha:1];
            bgColor = [UIColor colorWithRed:105/255.0 green:152/255.0 blue:246/255.0 alpha:1];
            break;

        case COUPON_TYPE_GOLD:
            bgColor = [UIColor colorWithRed:250/255.0 green:239/255.0 blue:12/255.0 alpha:1];
            break;
            
        case COUPON_TYPE_STEAL_GOLD:
            bgColor = [UIColor colorWithRed:250/255.0 green:239/255.0 blue:12/255.0 alpha:1];
                    //[UIColor colorWithRed:31/255.0 green:46/255.0 blue:86/255.0 alpha:1];
            
            break;
            
        case COUPON_TYPE_STEAL_POWER:
            //bgColor = [UIColor colorWithRed:198/255.0 green:34/255.0 blue:16/255.0 alpha:1];
            bgColor = [UIColor colorWithRed:252/255.0 green:90/255.0 blue:100/255.0 alpha:1];
            break;
            
        case COUPON_TYPE_GRAND_PRIZE:
            bgColor = [UIColor colorWithRed:158/255.0 green:143/255.0 blue:252/255.0 alpha:1];
            break;
        default:
            bgColor = Color_Light_Green;
            break;
    }
    
    [popupView setBackgroundColor:bgColor];
}

-(void)SBCategoryListner:(UIButton *)_senderBtn
{
    if (_senderBtn.tag == 1)
    {
        SB_userArray = topPlayerDict[@"top"];
        
        if(SB_userArray.count > 0)
        {
            [self.prizeListTV reloadData];
            [self.view bringSubviewToFront:self.prizeListView];
            [self.prizeListView setHidden:NO];
            [self animationFadeIn:self.prizeListView];
        }
        else
        {
            [Utils alert:@"Server is not responding, please wait for a moment and click again"];
            [self animationFadeOut:self.prizeListView];
            [self performSelector:@selector(topPlayerAPI) withObject:nil afterDelay:0.1];
        }
        
    }
    else if (_senderBtn.tag == 2)
    {
        FBGraphViewController *fbLogin = [FBGraphViewController instance];
        fbLogin.delegate = self;
        [fbLogin fbFindFriends];
        
    }
    else if (_senderBtn.tag == 3)
    {
        SB_userArray = topPlayerDict[@"revengers"];
        
        if(SB_userArray.count > 0)
        {
            [self.prizeListTV reloadData];
            [self.view bringSubviewToFront:self.prizeListView];
            [self.prizeListView setHidden:NO];
            [self animationFadeIn:self.prizeListView];
        }
        else
        {
            [Utils alert:@"No buddy have bomb or steal you"];
            [self animationFadeOut:self.prizeListView];
        }
        
    }
}

#pragma mark Get Top Player API Methods

-(void)topPlayerAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getTopPlayerParameter] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue])
        {
            topPlayerDict = _responseDict[@"data"];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getTopPlayerParameter
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=get_top_players"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}


#pragma mark Facebook Delegates

-(void)fbInstalledAppUsersList:(NSArray *)_friendsList
{
    if(_friendsList.count == 0)
    {
        [Utils alert:@"Invite your Facebook friends to join the fun here at Couper now!"];
    }
    else
    {
        SB_userArray = _friendsList;
        
        [self.prizeListTV reloadData];
        [self.view bringSubviewToFront:self.prizeListView];
        [self.prizeListView setHidden:NO];
        [self animationFadeIn:self.prizeListView];
    }
}


-(void)fbPostCompletion:(NSString *)_postId
{
    [self performSelectorInBackground:@selector(addShareAPI:) withObject:[NSString stringWithFormat:@"1"]];//narmeet min share to unlock 1 spin
}



-(void)animationDone:(UIView *)_animationView
{
    [_animationView removeFromSuperview];
}

-(void)bragFBListner:(id)sender
{
    FBGraphViewController *fbLogin = [FBGraphViewController instance];
    fbLogin.delegate = self;
    [fbLogin setPostData:luckyDrawDict];
    [fbLogin fbPost];

    if([luckyDrawDict[@"total_spins_left"] intValue] > 0)
        [self WheelTouchEnable];
    
    UIButton *sendreBtn = (UIButton *)sender;
    [[sendreBtn.superview superview] removeFromSuperview];
}

-(void)okBtnListner:(id)sender
{
    if([luckyDrawDict[@"total_spins_left"] intValue] > 0)
        [self WheelTouchEnable];
    
    UIButton *sendreBtn = (UIButton *)sender;
    [[sendreBtn.superview superview] removeFromSuperview];
}

#pragma mark Banner custom Delegates

-(void)bannerTouchBegin
{
    [self performSelectorInBackground:@selector(addShareAPI:) withObject:PLATFORM_FB];
}

#pragma mark SpinDetails Delegate

-(void)closeSpinPopup:(UIViewController *)currentVC
{
    [currentVC.view removeFromSuperview];
    
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(luckDrawCouponAPI) withObject:nil afterDelay:0.1];
}


@end
