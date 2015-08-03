//
//  CSharedContent.h
//  Couper
//
//  Created by vinay on 11/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUserDetails.h"

@interface CSharedContent : NSObject


@property (nonatomic,strong) CUserDetails *userDetails;

+(id)instance;
-(void)saveUserDetails:(NSDictionary *)_tempDict;

@end
