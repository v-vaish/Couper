//
//  Copyright (c) 2015 Supersonic. All rights reserved.
//

#ifndef SUPERSONIC_RV_DELEGATE_H
#define SUPERSONIC_RV_DELEGATE_H

#import <Foundation/Foundation.h>

@protocol SupersonicRVDelegate <NSObject>

@required

- (void)supersonicRVInitSuccess;
- (void)supersonicRVInitFailedWithError:(NSError *)error;
- (void)supersonicRVAdAvailabilityChanged:(BOOL)hasAvailableAds;
- (void)supersonicRVAdOpened;
- (void)supersonicRVAdStarted;
- (void)supersonicRVAdEnded;
- (void)supersonicRVAdClosed;
- (void)supersonicRVAdRewarded:(NSInteger)amount;
- (void)supersonicRVAdFailedWithError:(NSError *)error;

@end

#endif