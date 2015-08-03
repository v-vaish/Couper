//
//  CShared.h
//  Couper
//
//  Created by Vinay on 19/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomPickerView.h"

@interface CShared : NSObject <CustomPickerViewDelegate>


+(void)saveUserInfo:(NSDictionary *)_tempDict;
+(void)deleteUserInfo;

+(void)setFirstName:(NSString *)_firstName;
+(NSString *)getFirstName;
+(void)setLastName:(NSString *)_lastName;
+(NSString *)getLastName;
+(void)setFullName:(NSString *)_firstName;
+(NSString *)getFullName;
+(void)setEmail:(NSString *)_email;
+(NSString *)getEmail;
+(void)setGender:(NSString *)_gender;
+(NSString *)getGender;
+(void)setUserImageUrl:(NSString *)_userImageUrl;
+(NSString *)getUserImageUrl;

+(void)setDeviceToken:(NSString *)_token;
+(NSString *)getDeviceToken;

+(void)setLuckDrawId:(NSString *)_drawId;
+(NSString *)getLuckDrawId;

+(void)setGrandPriceStatus:(BOOL)_status;
+(BOOL)getGrandPriceStatus;

+(NSString *)deviceId;
+(NSArray *)getSpinList;
+(NSArray *)getGoldList;

@end
