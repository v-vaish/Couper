//
//  ACoupon.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "JSonObj.h"
#import <UIKit/UIKit.h>
#import "CouponType.h"

@interface ACoupon : JSonObj


@property(nonatomic, strong) NSString *couponId;
//@property(nonatomic, strong) CouponType *couponType;
@property(nonatomic, strong) NSString *couponType;
@property(nonatomic, strong) NSString *couponName;
@property(nonatomic, strong) UIImage *couponImage;
@property(nonatomic, strong) NSString *couponImageURL;
@property(nonatomic, strong) NSString *couponDescription;
@property(nonatomic ) float probability;
@property(nonatomic, strong) NSString *noAvailable;
@property(nonatomic, strong) NSString *useQR;
@property(nonatomic, strong) NSString *power;

#warning If server is using rank instead of sequence, replace the use of sequence with rank everywhere
/*===sequence must be unique for all coupon type including empty and eorry, e.g if there are 2 sorry type coupons,
 there sequence must be unique===*/
//@property(nonatomic) NSInteger sequence;

/*==This was defined in document, not sure if this can be used as sequence*/
@property(nonatomic) NSInteger rank;


-(void)setCouponImageURL:(NSString *)couponImageURL;

@end
