//
//  UserWebServices.m
//  Couper
//
//  Created by Vinay on 3/28/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "UserWebServices.h"

@implementation UserWebServices



-(void)getLoggedInUserDetails:(NSMutableDictionary *)params
                      success:(void (^)(CUserDetails *userDetail))success
                      failure:(void (^)(NSError *error))failure
{
    
    [super invokeAPIUsingGet:@"login api url" success:^(id result) {
        
        CUserDetails *user = [[CUserDetails alloc] initWithDictionary:(NSDictionary *)result];
        success(user);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
