//
//  DemoOWDelegate.m
//  sdk6demo
//
//  Copyright (c) 2015 Supersonic. All rights reserved.
//

#import "DemoOWDelegate.h"
#import "CMoreChanceVC.h"
#import "AppDelegate.h"

@interface DemoOWDelegate ()
    @property (atomic,strong) CMoreChanceVC *moreChanceVC;
@end

@implementation DemoOWDelegate

@synthesize moreChanceVC;

- (id) initWithView:(CMoreChanceVC*) view{
    [self setMoreChanceVC:view];
    return self;
}

- (void)supersonicOWInitSuccess {
    //NSLog(@"DEMO APP|%s|%s", "DemoOWDelegate", "supersonicOWInitSuccess");
    [[self moreChanceVC] enableOWButton];
}

- (void)supersonicOWShowSuccess {
    //NSLog(@"DEMO APP|%s|%s", "DemoOWDelegate", "supersonicOWShowSuccess");
    [THIS.tabBarController.tabBar setHidden:YES];
}

- (void)supersonicOWInitFailedWithError:(NSError *)error {
    //NSLog(@"DEMO APP|%s|%s|%@", "DemoOWDelegate", "supersonicOWInitFailedWithError", [error description]);
}

- (void)supersonicOWShowFailedWithError:(NSError *)error {
    //NSLog(@"DEMO APP|%s|%s|%@", "DemoOWDelegate", "supersonicOWShowFailedWithError", [error description]);
}

- (void)supersonicOWAdClosed {
    //NSLog(@"DEMO APP|%s|%s", "DemoOWDelegate", "supersonicOWAdClosed");
    [THIS.tabBarController.tabBar setHidden:NO];
}

- (BOOL)supersonicOWDidReceiveCredit:(NSDictionary *)creditInfo {
    //NSLog(@"DEMO APP|%s|%s", "DemoOWDelegate", "supersonicDidReceiveCredit");
    return YES;
}

- (void)supersonicOWFailGettingCreditWithError:(NSError *)error{
    //NSLog(@"DEMO APP|%s|%s|%@", "DemoOWDelegate", "supersonicOWFailGettingCreditWithError", [error description]);
}

@end
