//
//  CUserDetails.m
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CUserDetails.h"

@implementation CUserDetails


-(id) initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    
    if(self)
    {
        self.userId = dict[@"member_id"];
        self.name = dict[@"full_name"];
        self.image = dict[@"profile_img"];
    }
    
    return self;
}



-(NSMutableDictionary*) toJson
{
    NSMutableDictionary *json = [super toJson];
    
    return json;
}



@end
