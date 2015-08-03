//
//  UserCouponStatistics.m
//  Couper
//
//  Created by Vinay on 4/9/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "UserCouponStatistics.h"

@implementation UserCouponStatistics


#define EMPTY_COUPON 14



-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if(self)
    {
        self.coupons = [NSMutableArray new];
        self.couponTypes = [NSMutableArray new];

        /*==Creating Coupon objects from coupon dictionaries===*/
        NSArray *couponsArray = dict[@"coupons"];
        for(NSDictionary *couponDict in couponsArray) {
            ACoupon *coupon = [[ACoupon alloc] initWithDictionary:couponDict];
            if(coupon) {
                [self.coupons addObject:coupon];
            }
        }
        
        /*===Sorting the coupons according to the sequence, so that it can be displayed in order in UI===*/
       // [self sortCoupons];
        
        /*==Creating Coupon Type objects from coupon type dictionaries===*/
       /*
        NSArray *couponTypeArray = dict[@"couponTypes"];
        
        for(NSDictionary *couponTypeDict in couponTypeArray) {
            CouponType *couponType = [[CouponType alloc] initWithDictionary:couponTypeDict];
            if(couponType) {
                [self.coupons addObject:couponType];
            }
        }
        */

        /*===Total chances a user can have, will come through API===*/
        //self.totalChances = [[dict valueForKey:@"totalChances" defaultValue:@"0"] integerValue];

    }
    
    return self;
}


/*===Overriding setter because if need to update the totalChances in the middle, it will automatically update the percentage===*/
-(void)setTotalChances:(NSInteger)totalChances
{
    _totalChances = totalChances;
    
    for(CouponType *couponType in self.couponTypes) {
        couponType.maximumChances = totalChances;
    }
    
}


-(void)sortCoupons
{
#warning If server is using rank instead of sequence, replace the use of sequence with rank everywhere
   
    /*
    [self.coupons sortUsingComparator:
     ^NSComparisonResult(ACoupon *coupon1, ACoupon *coupon2) {
         
         if (coupon1.sequence > coupon2.sequence) {
             return NSOrderedDescending;
         }
         else if (coupon1.sequence < coupon2.sequence) {
             return NSOrderedAscending;
         }
         else {
             return NSOrderedSame;
         }
     }];
     */
}



@end
