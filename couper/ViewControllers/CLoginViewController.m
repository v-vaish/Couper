
//
//  CLoginViewController.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CLoginViewController.h"
#import "AppDelegate.h"
#import "CCustomTopBar.h"
#import "CShared.h"
#import "Utils.h"
#import "CTags.h"
#import "CWebHandler.h"
#import "CUserDetails.h"
#import "CSharedContent.h"

#define FADE_DUREATION 2.0

@interface CLoginViewController ()

@end

@implementation CLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:facebookBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Methods Action

-(IBAction)fbLoginBtnAction
{
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(facebookLogin) withObject:nil afterDelay:0.1];
}

-(void)facebookLogin
{
    FBGraphViewController *_fbGraphVC = [FBGraphViewController instance];
    _fbGraphVC.delegate = self;
    [_fbGraphVC fbUserInformation];
}

#pragma mark Facebook Delegate

-(void)fbLoginCompletion:(NSDictionary *)_response
{
    //NSLog(@"response %@",_response);
    fbResponse = _response;
    
    if (_response==nil)
        [Utils hideIndicatorView:self.view];
    else
    [self performSelector:@selector(loginAPI) withObject:nil];
}

#pragma mark Login API Methods

-(void)loginAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    
    NSString *_requestUrl = [NSString stringWithFormat:@"%@",[self getLoginParameters]];
    _requestUrl = [_requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_webHandler invokeAPIUsingGet:_requestUrl success:^(id result) {
        [Utils hideIndicatorView:self.view];
       
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue] == 1)
        {
            CSharedContent *_sharedContent = [CSharedContent instance];
            [_sharedContent saveUserDetails:_responseDict[@"data"]];
        }
        
        THIS.tabBarController = (UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
        [THIS.window addSubview:THIS.tabBarController.view];
        
    } failure:^(NSError *error) {
        [Utils hideIndicatorView:self.view];

    }];
}


-(NSMutableString *)getLoginParameters
{
    NSString *_profileImgUrl = [[fbResponse[@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    if([_profileImgUrl length] == 0)
        _profileImgUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",fbResponse[@"id"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:fbResponse[@"id"] forKey:@"fb_id"];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=member_login"];
    [_requestUrl appendFormat:@"&sm_id=%@",fbResponse[@"id"]];
    [_requestUrl appendFormat:@"&first_name=%@",fbResponse[@"first_name"]];
    [_requestUrl appendFormat:@"&last_name=%@",fbResponse[@"last_name"]];
    [_requestUrl appendFormat:@"&full_name=%@",fbResponse[@"name"]];
    [_requestUrl appendFormat:@"&gender=%@",fbResponse[@"gender"]];
    [_requestUrl appendFormat:@"&email=%@",fbResponse[@"email"]];
    [_requestUrl appendFormat:@"&profile_img=%@",_profileImgUrl];
    [_requestUrl appendFormat:@"&account_type=%@",ACCOUNT_TYPE];
    [_requestUrl appendFormat:@"&device_token=%@",[CShared getDeviceToken]];
    [_requestUrl appendFormat:@"&device=%@",DEVICE_PLATFORM];
    
    //NSLog(@"Request Url = %@",_requestUrl);
    return _requestUrl;
}


#pragma mark Registration API Methods

-(void)registration
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPI:@"GET" url:[self getRegistrationUrl] parameters:[self getRagistrationParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", result);
        [CShared saveUserInfo:_responseDict];
        
        THIS.tabBarController = (UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
        [THIS.window addSubview:THIS.tabBarController.view];
        
        
    } failure:^(NSError *error) {
        //NSLog(@"loginError = %@",error);
    }];
}

-(NSString *)getRegistrationUrl
{
    NSString *_url = [NSString stringWithFormat:@"%@%@",BASE_URL,@""];
    return _url;
}

-(NSMutableDictionary *)getRagistrationParameters
{
    NSMutableDictionary *_tempDict =  [NSMutableDictionary new];
    
    return _tempDict;
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
