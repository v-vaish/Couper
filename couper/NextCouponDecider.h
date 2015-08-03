//
//  NextCouponDecider.h
//  Couper
//
//  Created by Vinay on 4/9/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCouponStatistics.h"

#define NOT_AVAILABLE   -1

@interface NextCouponDecider : NSObject


@property(nonatomic, strong) UserCouponStatistics *statistics;

-(id)initWithUserCouponStatistics:(UserCouponStatistics *)stats;
-(NSInteger)getNextCouponSequence;

@end
