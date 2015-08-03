//
//  CShared.m
//  Couper
//
//  Created by Vinay on 19/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CShared.h"
#import "AppDelegate.h"

@implementation CShared


+(void)saveUserInfo:(NSDictionary *)_tempDict
{
    [CShared setMemberId:_tempDict[@"member_id"]];
    [CShared setFullName:_tempDict[@"full_name"]];
    [CShared setLastName:_tempDict[@"profile_img"]];
    [CShared setEmail:_tempDict[@"member_id"]];
    
}

+(void)deleteUserInfo
{
    [CShared setFirstName:@""];
    [CShared setLastName:@""];
    [CShared setEmail:@""];
    [CShared setGender:@""];
    [CShared setUserImageUrl:@""];
}



+(void)setMemberId:(NSString *)_firstName
{
    [[NSUserDefaults standardUserDefaults] setValue:_firstName forKey:@"member_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getMemberId
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"member_id"];
}


+(void)setFirstName:(NSString *)_firstName
{
    [[NSUserDefaults standardUserDefaults] setValue:_firstName forKey:@"firstName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getFirstName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"firstName"];
}

+(void)setLastName:(NSString *)_lastName
{
    [[NSUserDefaults standardUserDefaults] setValue:_lastName forKey:@"lastName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getLastName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"lastName"];
}

+(void)setFullName:(NSString *)_firstName
{
    [[NSUserDefaults standardUserDefaults] setValue:_firstName forKey:@"fullName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getFullName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"fullName"];
}


+(void)setEmail:(NSString *)_email
{
    [[NSUserDefaults standardUserDefaults] setValue:_email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getEmail
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
}

+(void)setGender:(NSString *)_gender
{
    [[NSUserDefaults standardUserDefaults] setValue:_gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getGender
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"gender"];
}

+(void)setUserImageUrl:(NSString *)_userImageUrl
{
    [[NSUserDefaults standardUserDefaults] setValue:_userImageUrl forKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getUserImageUrl
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"image"];
}

+(void)setDeviceToken:(NSString *)_token
{
    [[NSUserDefaults standardUserDefaults] setValue:_token forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getDeviceToken
{
    NSString *deviceTokenString;
    
    deviceTokenString = [[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"];
    
    if(deviceTokenString.length == 0)
        deviceTokenString = @"";
    
    return deviceTokenString;
    
}

+(void)setLuckDrawId:(NSString *)_drawId
{
    [[NSUserDefaults standardUserDefaults] setValue:_drawId forKey:@"draw_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getLuckDrawId
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"draw_id"];
}

+(void)setGrandPriceStatus:(BOOL)_status
{
    THIS.isGrandPrizeExist = _status;
}


+(BOOL)getGrandPriceStatus
{
    return THIS.isGrandPrizeExist;
}

+(NSString *)deviceId
{
    NSUUID *device_id = [[UIDevice currentDevice] identifierForVendor];
    return [NSString stringWithFormat:@"%@",device_id];
}

-(void)openPicker:(NSMutableArray *)_tempArray currentVC:(UIViewController *)_currentVC
{
    CustomPickerView *_pickerClass = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withNSArray:_tempArray];
    
    _pickerClass.delegate = _currentVC;
    [_currentVC.view addSubview:_pickerClass];
    [_pickerClass showPicker];
    
}


+(NSArray *)getSpinList
{
    return [[NSArray alloc] initWithObjects:@"10",@"25",@"45",@"60",@"85",@"120",@"150", nil];
}

+(NSArray *)getGoldList
{
    return [[NSArray alloc] initWithObjects:@"300",@"400",@"700",@"2000",@"5000",@"8000",@"13000", nil];
}

#pragma mark Picker Delegate

-(void)selectedRow:(int)row withString:(NSString *)text{
    
    //NSLog(@"%d",row);
    //lblIndex.text = [NSString stringWithFormat:@"%d",row];
    //lblText.text = text;
    
}

@end
