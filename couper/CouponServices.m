//
//  CouponServices.m
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CouponServices.h"

@implementation CouponServices


-(void)getCoupons:(NSMutableDictionary *)params
          success:(void (^)(UserCouponStatistics *statistics))success
          failure:(void (^)(NSError *error))failure
{
    
    [super invokeAPIUsingGet:@"coupon api url" success:^(id result) {
        
        UserCouponStatistics *statistics = [[UserCouponStatistics alloc] initWithDictionary:result];
        success(statistics);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}



@end
