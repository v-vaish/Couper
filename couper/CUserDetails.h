//
//  CUserDetails.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "JSonObj.h"

@interface CUserDetails : JSonObj

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *image;

@end
