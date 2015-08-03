//
//  JSonObj.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+JEN.h"
#import "NSDictionary+NullValueReplace.h"


@interface JSonObj : NSObject

- (id)initWithDictionary : (NSDictionary *) dict;

-(NSMutableDictionary*) toJson;


@end
