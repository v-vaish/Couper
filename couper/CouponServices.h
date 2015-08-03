//
//  CouponServices.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CWebHandler.h"
#import "ACoupon.h"
#import "CQueryResults.h"
#import "UserCouponStatistics.h"

@interface CouponServices : CWebHandler


-(void)getCoupons:(NSMutableDictionary *)params
          success:(void (^)(UserCouponStatistics *statistics))success
          failure:(void (^)(NSError *error))failure;

@end
