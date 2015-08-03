//
//  NSDictionary+NullValueReplace.m
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "NSDictionary+NullValueReplace.h"

@implementation NSDictionary (NullValueReplace)

- (id)valueForKey:(id)key defaultValue:(NSString *)value
{
    id string = [self valueForKey:key];
    
    if([string isEqual:[NSNull null]] || string == nil) {
        return value;
    }
    
    return string;
}


-(BOOL)isValidDictionary
{
    BOOL status = FALSE;
    
    if(self && ![(id)self isEqual:[NSNull null]] && [(id)self isKindOfClass:[NSDictionary class]]) {
        status = TRUE;
    }
    
    return status;
}


@end

