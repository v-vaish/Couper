//
//  UserCouponStatistics.h
//  Couper
//
//  Created by Vinay on 4/9/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACoupon.h"
#import "CouponType.h"


@interface UserCouponStatistics : NSObject


@property(nonatomic, strong) NSMutableArray *coupons;
@property(nonatomic, strong) NSMutableArray *couponTypes;
@property(nonatomic) NSInteger totalChances;



-(id) initWithDictionary:(NSDictionary *)dict;



@end
