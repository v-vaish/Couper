//
//  CProfileViewController.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CProfileViewController.h"
#import "Utils.h"
#import "CCustomTopBar.h"
#import "CSharedContent.h"
#import "CWebHandler.h"



@interface CProfileViewController ()

@end

@implementation CProfileViewController

#pragma mark View LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTopBar];
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    [_customTopBar createTopBar:@"profile" currentVC:self leftBtn:NO rightBtn:NO];
}


#pragma mark Methods

-(void)initialization
{
    // self.followersCount = 0;
    
    //[self getFollowsAPI];
    
    [Utils makeCircleImage:profile_image];
    
    CSharedContent *sharedContent = [CSharedContent instance];
    [profile_image sd_setImageWithURL:[NSURL URLWithString:sharedContent.userDetails.image] placeholderImage:[UIImage imageNamed:@"profilepic"]];
    [profile_userName setText:sharedContent.userDetails.name];
    
}




#pragma mark Follow List API Methods

-(void)getFollowsAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        [Utils hideIndicatorView:self.view];
        
        if([_responseDict[@"result"] intValue])
        {
            NSArray *_followArr = _responseDict[@"data"];
        
            if (_followArr.count > 0) {
                NSString *followersCountStr = [NSString stringWithFormat:@"FOLLOWS (%d)", (int)_followArr.count];
                [self.followersBtn setTitle:followersCountStr forState:UIControlStateNormal];
            }
        }
        //else
            //[Utils alert:_responseDict[@"message"]];
        
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
    [_requestUrl appendFormat:@"m=get_member_follow_list"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}






#pragma mark Action Methods

-(IBAction)viewProfileBtnAction:(id)sender
{
    
}

-(IBAction)followsBtnAction:(id)sender
{
    
}

-(IBAction)walletBtnAction:(id)sender
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Wallet"] animated:YES];
}

-(IBAction)settingsBtnAction:(id)sender
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Settings"] animated:YES];

}

-(IBAction)badgesBtnAction:(id)sender
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Badges"] animated:YES];
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
