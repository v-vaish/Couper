//
//  CCashoutManagerVC.m
//  Couper
//
//  Created by vinay on 24/06/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CCashoutManagerVC.h"
#import "CSharedContent.h"
#import "CAdBannerHandler.h"
#import "CWebHandler.h"
#import "CShared.h"
#import "Utils.h"
#import "CTags.h"

#define PAYPAL_VIEW 1
#define BANK_VIEW   2

@implementation CCashoutManagerVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addAdImpression];
    
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(getUserGoldAPI) withObject:nil afterDelay:0.1];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTopBar];
}


-(void)addAdImpression
{
    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, SCREEN_HEIGHT-150, 320, 50) currentController:self.view];
}



-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@"Cashout" currentVC:self leftBtn:YES rightBtn:NO];
}


-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Get User Gold API Methods

-(void)getUserGoldAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getParameter] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        [Utils hideIndicatorView:self.view];
        
        if([_responseDict[@"result"] intValue])
        {
            NSDictionary *goldDict = _responseDict[@"data"];
            
            NSString *totalUserGold = goldDict[@"gold"];
            NSString *currentGoldRate = goldDict[@"current_gold_rate"];
            
            
            if([totalUserGold intValue] > 0)
            {
                _totalGoldLbl.text = totalUserGold;
                float balance = [totalUserGold floatValue]/[currentGoldRate floatValue];
                _balanceLbl.text = [NSString stringWithFormat:@"%.2f",balance];
            }
            else
            {
                _totalGoldLbl.text = @"0";
                _balanceLbl.text = @"0";
            }
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getParameter
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=get_gold"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",[CShared getLuckDrawId]];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}

-(IBAction)payPalBtnAction
{
    //UIView_Animation *paypalPopup = [[UIView_Animation alloc] init];
    //[paypalPopup setCenterAnimation];

    [self addView:PAYPAL_VIEW];
    
}

-(IBAction)bankBtnAction
{
    [self addView:BANK_VIEW];
}


-(void)addView:(int)_tag
{
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    
    UIImageView *blackBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    blackBgView.backgroundColor = [UIColor blackColor];
    blackBgView.alpha = 0.5;
    [mainView addSubview:blackBgView];
    
    float bgViewHeight = (_tag == PAYPAL_VIEW)?200:350;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2 - bgViewHeight/2 - 50, SCREEN_WIDTH -20 , bgViewHeight)];
    bgView.backgroundColor = Color_Dark_Green;
    [mainView addSubview:bgView];
    
    float y_axis = 20;
    float gap = 20;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2 - 150/2, y_axis, 150, 30)];
    titleLbl.font = [UIFont systemFontOfSize:22];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [bgView addSubview:titleLbl];

    y_axis = y_axis + titleLbl.frame.size.height + gap;
    
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2 - 250/2, y_axis, 250, 30)];
    emailTF.placeholder = @"Email";
    emailTF.borderStyle = UITextBorderStyleRoundedRect;
    emailTF.delegate = self;
    [bgView addSubview:emailTF];
    
    y_axis = y_axis + emailTF.frame.size.height + gap;
    
    if(_tag == PAYPAL_VIEW)
    {
        titleLbl.text = @"PayPal Details";
    }
    else
    {
        titleLbl.text = @"Bank Details";
        
        userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2 - 250/2, y_axis, 250, 30)];
        userNameTF.placeholder = @"Full Name";
        userNameTF.borderStyle = UITextBorderStyleRoundedRect;
        userNameTF.delegate = self;
        [bgView addSubview:userNameTF];
        
        y_axis = y_axis + gap + userNameTF.frame.size.height;

        bankNameTF = [[UITextField alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2 - 250/2, y_axis, 250, 30)];
        bankNameTF.placeholder = @"Bank Name";
        bankNameTF.borderStyle = UITextBorderStyleRoundedRect;
        bankNameTF.delegate = self;
        [bgView addSubview:bankNameTF];

        y_axis = y_axis + gap + bankNameTF.frame.size.height;
        
        bankAccountTF = [[UITextField alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2 - 250/2, y_axis, 250, 30)];
        bankAccountTF.placeholder = @"Bank Account";
        bankAccountTF.borderStyle = UITextBorderStyleRoundedRect;
        bankAccountTF.delegate = self;
        [bgView addSubview:bankAccountTF];
        
        y_axis = y_axis + gap + bankAccountTF.frame.size.height;
        
    }
    
    float buttonWidth = 120;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(20, y_axis, buttonWidth, 30);
    submitBtn.backgroundColor = [UIColor grayColor];
    [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    submitBtn.tag = _tag;
    [submitBtn addTarget:self  action:@selector(submitBtnListner:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(bgView.frame.size.width - (buttonWidth + 20), y_axis, buttonWidth, 30);
    cancelBtn.backgroundColor = [UIColor grayColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self  action:@selector(cancelBtnListner:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
}

-(void)submitBtnListner:(UIButton *)senderBtn
{
    if([_balanceLbl.text intValue] < 1)
    {
        [Utils alert:@"Sorry! You need a minimum of $1 to withdraw!"];
        return;
    }
    selectedPaymentType = (int)senderBtn.tag;
    [Utils hideIndicatorView:self.view];

        if([Utils validateEmail:emailTF.text])
        {
            [Utils showIndicatorView:self.view];
            [self performSelector:@selector(paymentAPI:) withObject:senderBtn afterDelay:0.1];
        }
        else
            [Utils alert:@"Invalid Email Address"];
    
}

#pragma mark Call Payment API Methods

-(void)paymentAPI:(UIButton *)senderBtn
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getTopPlayerParameter:selectedPaymentType] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        [Utils hideIndicatorView:self.view];
        
        if([_responseDict[@"result"] intValue])
        {
            _balanceLbl.text = @"0";
            _totalGoldLbl.text = @"0";
            
            [senderBtn.superview.superview removeFromSuperview];
            [Utils alert:@"Great job! We will transfer you within two working days!"];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


//52.74.115.111/couperv3_dev/web.php?m=add_payment&total_price=3&gold=45&type=Paypal&paypal_id=749e0odm3090i&email=jimmy@couperhq.com&luckydraw_id=7&member_id=845&bank_name=&account_name=&account_number


-(NSString *)getTopPlayerParameter:(int)paymentType
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=add_payment"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&total_price=%@",(_balanceLbl.text == nil)?@"":_balanceLbl.text];
    [_requestUrl appendFormat:@"&gold=%@",(_totalGoldLbl.text == nil)?@"":_totalGoldLbl.text];
    [_requestUrl appendFormat:@"&email=%@",emailTF.text];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",[CShared getLuckDrawId]];
    
    if(paymentType == PAYPAL_VIEW)
    {
        [_requestUrl appendFormat:@"&type=%@",@"paypal"];
        [_requestUrl appendFormat:@"&paypal_id=%@",emailTF.text];
        [_requestUrl appendFormat:@"&bank_name=%@",@""];
        [_requestUrl appendFormat:@"&account_name=%@",@""];
        [_requestUrl appendFormat:@"&account_number=%@",@""];
    }
    else
    {
        [_requestUrl appendFormat:@"&type=%@",@"bank"];
        [_requestUrl appendFormat:@"&paypal_id=%@",@""];
        [_requestUrl appendFormat:@"&bank_name=%@",bankNameTF.text];
        [_requestUrl appendFormat:@"&account_name=%@",userNameTF.text];
        [_requestUrl appendFormat:@"&account_number=%@",bankAccountTF.text];
    }
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}


-(void)cancelBtnListner:(UIButton *)senderBtn
{
    [senderBtn.superview.superview removeFromSuperview];
}




#pragma mark TextFiled Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}





@end
