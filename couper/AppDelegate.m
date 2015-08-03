//
//  AppDelegate.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AWSSNS/AWSSNS.h>
#import "Constants.h"
#import "CShared.h"
#import "CMoreChanceVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize tabBarController;

@synthesize isGrandPrizeExist;
@synthesize isAppInBackground;
@synthesize isRedirectFromApp;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    //[Fabric with:@[CrashlyticsKit]];

    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Sets up Mobile Push Notification
    UIMutableUserNotificationAction *readAction = [UIMutableUserNotificationAction new];
    readAction.identifier = @"READ_IDENTIFIER";
    readAction.title = @"Read";
    readAction.activationMode = UIUserNotificationActivationModeForeground;
    readAction.destructive = NO;
    readAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *deleteAction = [UIMutableUserNotificationAction new];
    deleteAction.identifier = @"DELETE_IDENTIFIER";
    deleteAction.title = @"Delete";
    deleteAction.activationMode = UIUserNotificationActivationModeForeground;
    deleteAction.destructive = YES;
    deleteAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *ignoreAction = [UIMutableUserNotificationAction new];
    ignoreAction.identifier = @"IGNORE_IDENTIFIER";
    ignoreAction.title = @"Ignore";
    ignoreAction.activationMode = UIUserNotificationActivationModeForeground;
    ignoreAction.destructive = NO;
    ignoreAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *messageCategory = [UIMutableUserNotificationCategory new];
    messageCategory.identifier = @"MESSAGE_CATEGORY";
    [messageCategory setActions:@[readAction, deleteAction] forContext:UIUserNotificationActionContextMinimal];
    [messageCategory setActions:@[readAction, deleteAction, ignoreAction] forContext:UIUserNotificationActionContextDefault];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:[NSSet setWithArray:@[messageCategory]]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //Register for Amazon Push notification services
    AWSStaticCredentialsProvider *credentialsProvider = [AWSStaticCredentialsProvider credentialsWithAccessKey:@"AKIAJPIQTRBMNIBTCLWQ" secretKey:@"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"];
    
    // Sets up the AWS Mobile SDK for iOS
    //AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:CognitoRegionType
    //                                                                                              identityPoolId:CognitoIdentityPoolId];
    
    AWSServiceConfiguration *defaultServiceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:DefaultServiceRegionType
                                                                                       credentialsProvider:credentialsProvider];

    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = defaultServiceConfiguration;
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

//Create static object to access easily appdelete members and methods
static AppDelegate *temp = nil;
+(AppDelegate*)sharedInstanceGlobalObject
{
    if(!temp)
    {
        temp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return temp;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    isAppInBackground = TRUE;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    NSString *deviceTokenString = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"deviceTokenString: %@", deviceTokenString);
    
    [CShared setDeviceToken:deviceTokenString];
    [self.window.rootViewController.childViewControllers.firstObject performSelectorOnMainThread:@selector(displayDeviceInfo) withObject:nil waitUntilDone:nil];
    
    AWSSNS *sns = [AWSSNS defaultSNS];
    AWSSNSCreatePlatformEndpointInput *request = [AWSSNSCreatePlatformEndpointInput new];
    request.token = deviceTokenString;
    request.platformApplicationArn = SNSPlatformApplicationArn;
    [[sns createPlatformEndpoint:request] continueWithBlock:^id(BFTask *task) {
        if (task.error != nil) {
            //NSLog(@"Error: %@",task.error);
        } else {
            AWSSNSCreateEndpointResponse *createEndPointResponse = task.result;
            //NSLog(@"endpointArn: %@",createEndPointResponse);
            [[NSUserDefaults standardUserDefaults] setObject:createEndPointResponse.endpointArn forKey:@"endpointArn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.window.rootViewController.childViewControllers.firstObject performSelectorOnMainThread:@selector(displayDeviceInfo) withObject:nil waitUntilDone:NO];
            
        }
        
        return nil;
    }];
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"Failed to register with error: %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //NSLog(@"userInfo: %@",userInfo);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    AWSMobileAnalytics *mobileAnalytics = [AWSMobileAnalytics mobileAnalyticsForAppId:MobileAnalyticsAppId];
    id<AWSMobileAnalyticsEventClient> eventClient = mobileAnalytics.eventClient;
    id<AWSMobileAnalyticsEvent> pushNotificationEvent = [eventClient createEventWithEventType:@"PushNotificationEvent"];
    
    NSString *action = @"Undefined";
    if ([identifier isEqualToString:@"READ_IDENTIFIER"]) {
        action = @"read";
        //NSLog(@"User selected 'Read'");
    } else if ([identifier isEqualToString:@"DELETE_IDENTIFIER"]) {
        action = @"Deleted";
        //NSLog(@"User selected `Delete`");
    } else {
        action = @"Undefined";
    }
    
    [pushNotificationEvent addAttribute:action forKey:@"Action"];
    [eventClient recordEvent:pushNotificationEvent];
    
    [self.window.rootViewController.childViewControllers.firstObject performSelectorOnMainThread:@selector(displayUserAction:)
                                                                                      withObject:action
                                                                                   waitUntilDone:NO];
    
    completionHandler();
}


@end
