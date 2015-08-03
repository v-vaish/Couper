//
//  Utils.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@interface Utils : NSObject


+ (void)showIndicatorView:(UIView *)_view;
+ (void)hideIndicatorView:(UIView *)_view;
+ (void)alert:(NSString *)_msg;
+(BOOL)isCameraAvailable;
+(void)openCamera:(id)_selfRef;
+(void)getPhotoFromGallary:(id)_selfRef;
+ (void)makeCircleImage:(UIImageView *)_imageView;
+ (void)makeCircleButton:(UIButton *)_button;

+(void)setImageAsColor:(UIImage *)_image view:(UIView *)_currentView;
+(CGSize)getVideoResolution:(NSString *)_videoPath;
+(UIImage *)thumbNail:(NSURL *)_localFileUrl;
+ (UIImage *)convertViewInImage:(UIView *)view;

+(NSTimeInterval)differenceTwoDate:(NSString *)startDate endDate:(NSString *)endDate;
+ (NSString *)getTimeRepresentationForDate:(NSString *)date;
+(void)playSound:(NSString *)_fileName type:(NSString *)_type;


+ (NSArray *)getAllContacts;
+ (BOOL) isContactAccessGranted;
+(BOOL)isSIMCardExist;
+ (BOOL)validateEmail:(NSString *)emailStr;
+(BOOL)checkMobileNumberValidationByAPI:(NSString *)numberStr;

@end
