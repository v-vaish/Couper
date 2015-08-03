//
//  UserWebServices.h
//  Couper
//
//  Created by Vinay on 3/28/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWebHandler.h"
#import "CUserDetails.h"

@interface UserWebServices : CWebHandler


-(void)getLoggedInUserDetails:(NSMutableDictionary *)params
                      success:(void (^)(CUserDetails *userDetail))success
                      failure:(void (^)(NSError *error))failure;


@end
