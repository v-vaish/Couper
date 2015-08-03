//
//  ACoupon.m
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "ACoupon.h"
#import "ImageDownloader.h"

#define FOLDER_COUPON_IMAGES @"Coupons"

@implementation ACoupon


-(id) initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    
    if(self)
    {
        self.couponId = dict[@"coupon_id"];
        //self.couponType = [[CouponType alloc] initWithDictionary:dict[@"type"]];
        self.couponType = dict[@"couponType"];
        self.couponName = dict[@"name"];
        self.couponImageURL = dict[@"coupon_image"];
        //self.sequence = [dict[@"no_available"] intValue];
        self.probability = [dict[@"probability"] floatValue];
        self.couponDescription = dict[@"description"];
        self.noAvailable = dict[@"no_available"];
        self.useQR = dict[@"use_qr"];
        self.power = dict[@"power"];
    }
    
    return self;
}

-(void)setCouponImageURL:(NSString *)couponImageURL
{
    _couponImageURL = couponImageURL;
    
    if([couponImageURL isValidString]) {
        //#warning Write image downloading code here.....
       // self.couponImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:couponImageURL]]];
        
        ImageDownloader *_imageDownloader = [ImageDownloader instance];
        [_imageDownloader createFolderForImages:FOLDER_COUPON_IMAGES];
        [_imageDownloader downloadAndStoreImages:couponImageURL folderName:FOLDER_COUPON_IMAGES];
        
        self.couponImage = [_imageDownloader getImageFromFolder:couponImageURL folderName:FOLDER_COUPON_IMAGES];
        
    }
    else {
        //#warning You can set a default image here.....
        self.couponImage = [UIImage imageNamed:@"coupon1"];
    }
}



-(NSMutableDictionary*) toJson
{
    NSMutableDictionary *json = [super toJson];
    
    return json;
}


@end
