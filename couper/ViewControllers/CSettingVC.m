//
//  CSettingVC.m
//  Couper
//
//  Created by vinay on 16/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CSettingVC.h"
#import "CWebHandler.h"
#import "CSharedContent.h"
#import "Utils.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@implementation CSettingVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTopBar];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@"settings" currentVC:self leftBtn:YES rightBtn:NO];
}

#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Logotu API Methods

-(void)logoutAPI
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        [Utils hideIndicatorView:self.view];
        
        if([_responseDict[@"result"] intValue])
        {
            THIS.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
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
    [_requestUrl appendFormat:@"m=member_logout"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}


-(IBAction)logoutBtnPressed:(id)sender
{
    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure, Do you want to logout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [_alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [Utils showIndicatorView:self.view];
        [self performSelector:@selector(logoutAPI) withObject:nil afterDelay:0.1];
    }
}


@end
