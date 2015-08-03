//
//  NSDictionary+NullValueReplace.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullValueReplace)

- (id)valueForKey:(id)key defaultValue:(NSString *)value;
- (BOOL)isValidDictionary;

@end
