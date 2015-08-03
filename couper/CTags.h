//
//  CTags.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#ifndef Couper_CTags_h
#define Couper_CTags_h


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define Color_Couper_Blue  [UIColor colorWithRed:79/255.0 green:141/255.0 blue:204/255.0 alpha:1]
#define Color_Green_Theam  [UIColor colorWithRed:132/255.0 green:222/255.0 blue:213/255.0 alpha:1]
#define Color_Dark_Green   [UIColor colorWithRed:48/255.0 green:171/255.0 blue:172/255.0 alpha:1]
#define Color_Light_Green  [UIColor colorWithRed:222/255.0 green:236/255.0 blue:186/255.0 alpha:1]

#define TOP_BAR_HEIGHT 38
#define Tab_BAR_HEIGHT 49

#define ACCOUNT_TYPE    @"1"


#define PLATFORM_FB     @"1"
#define PLATFORM_SMS    @"2"
#define PLATFORM_Ad    @"3"


#define DEVICE_PLATFORM    @"iOS"

#endif
