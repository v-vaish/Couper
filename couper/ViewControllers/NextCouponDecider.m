//
//  NextCouponDecider.m
//  Couper
//
//  Created by Vinay on 4/9/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "NextCouponDecider.h"

@implementation NextCouponDecider


-(id)initWithUserCouponStatistics:(UserCouponStatistics *)stats
{
    self = [super init];
    
    if(self)
    {
        self.statistics = stats;
        [self commonInit];
    }
    
    return self;
}


-(id)init
{
    self = [super init];
    
    if(self) {
        [self commonInit];
    }
    
    return self;
}


-(void)commonInit
{
    if(!self.statistics) {
        [NSException raise:@"Unexpected Initialization of NextCouponDecider" format:@"Use initWithUserCouponStatistics and make sure UserCouponStatistics object is not null."];
    }
    else {
        
    }
}


-(NSInteger)getNextCouponSequence
{
    int lowerBound = 1;
    int upperBound = (int)self.statistics.coupons.count;
    int value = lowerBound + arc4random() % (upperBound - lowerBound);
    
    return value;
}


@end
