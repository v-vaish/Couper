//
//  CSharedContent.m
//  Couper
//
//  Created by vinay on 11/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CSharedContent.h"

@implementation CSharedContent


CSharedContent *sharedContent = nil;

+(id)instance
{
    if(sharedContent == nil)
        sharedContent = [[CSharedContent alloc] init];
    
    return sharedContent;
}

-(void)saveUserDetails:(NSDictionary *)_tempDict
{
    CUserDetails *_details = [[CUserDetails alloc] initWithDictionary:_tempDict];
    self.userDetails  = _details;
}


@end
