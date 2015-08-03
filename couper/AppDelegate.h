//
//  AppDelegate.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THIS [AppDelegate sharedInstanceGlobalObject]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UITabBarController *tabBarController;
@property (nonatomic,assign) BOOL isGrandPrizeExist;
@property (nonatomic,assign) BOOL isAppInBackground;
@property (nonatomic,assign) BOOL isRedirectFromApp;

+(AppDelegate*)sharedInstanceGlobalObject;


@end

