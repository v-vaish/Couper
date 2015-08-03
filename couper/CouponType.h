//
//  CouponType.h
//  Couper
//
//  Created by Vinay on 4/9/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "JSonObj.h"

#define COUPON_TYPE_SORRY       @"coupon_type_sorry"
#define COUPON_TYPE_EMPTY       @"coupon_type_empty"
#define COUPON_TYPE_REWARD      @"coupon_type_reward"

@interface CouponType : JSonObj


@property(nonatomic, strong) NSString *typeName;
@property(nonatomic) float percentage;
@property(nonatomic) float maximumChances;
@property(nonatomic) NSInteger actualChances;

@end
