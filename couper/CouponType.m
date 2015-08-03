//
//  CouponType.m
//  Couper
//
//  Created by Vinay on 4/9/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CouponType.h"

@implementation CouponType


-(id) initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    
    if(self)
    {
        self.typeName = @"";
        self.percentage = [[dict valueForKey:@"percentage" defaultValue:@"0"] floatValue];
    }
    
    return self;
}


-(void)setMaximumChances:(float)maximumChances
{
    /*===Converting percentage to actual number===*/
    
    _maximumChances = maximumChances;
    
    /*===This is the actual number of chances a user can really have===*/
    self.actualChances = (maximumChances * _percentage) / 100.0;
}

@end
