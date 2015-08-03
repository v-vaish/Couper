//
//  DemoRVDelegate.m
//  sdk6demo
//
//  Copyright (c) 2015 Supersonic. All rights reserved.
//

#import "DemoRVDelegate.h"
#import "CMoreChanceVC.h"
#import "AppDelegate.h"

@interface DemoRVDelegate ()
@property (atomic,strong) CMoreChanceVC *moreChanceVC;
@end

@implementation DemoRVDelegate

@synthesize moreChanceVC;

- (id) initWithView:(CMoreChanceVC*) view{
    [self setMoreChanceVC:view];
    return self;
}

//Fired when callback was successfully made
- (void)supersonicRVInitSuccess{
    //NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVInitSuccess");
}

- (void)supersonicRVInitFailedWithError:(NSError *)error{
    //NSLog(@"DEMO APP|%s|%s|%@", "DemoRVDelegate", "supersonicRVInitFailedWithError", [error description]);
}

- (void)supersonicRVAdAvailabilityChanged:(BOOL)hasAvailableAds{
    //NSLog(@"DEMO APP|%s|%s|%@", "DemoRVDelegate", "supersonicRVAdAvailabilityChanged", hasAvailableAds ? @"Yes" : @"No");
    if (hasAvailableAds == TRUE){
        [[self moreChanceVC] enableRVButton];
    }
    else {
        [[self moreChanceVC] disableRVButton];
    }
}

- (void)supersonicRVAdOpened{
    //NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdOpened");
    [THIS.tabBarController.tabBar setHidden:YES];
}

- (void)supersonicRVAdStarted{
    //NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdStarted");
}

- (void)supersonicRVAdEnded{
    //NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdEnded");
}

- (void)supersonicRVAdClosed{
    //NSLog(@"DEMO APP|%s|%s", "DemoRVDelegate", "supersonicRVAdClosed");
    [THIS.tabBarController.tabBar setHidden:NO];
}

- (void)supersonicRVAdRewarded:(NSInteger)amount{
    //NSLog(@"DEMO APP|%s|%s|amount = %ld", "DemoRVDelegate", "supersonicRVAdRewarded", (long)amount);
    
    [self.moreChanceVC getVideoCredit:[NSString stringWithFormat:@"%ld",amount]];
}

- (void)supersonicRVAdFailedWithError:(NSError *)error{
    //NSLog(@"DEMO APP|%s|%s|%@", "DemoRVDelegate", "supersonicRVAdFailedWithError", [error description]);
}

@end
