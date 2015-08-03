//
//  CWebHandler.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BASE_URL  @"http://54.254.102.185/cp/web.php?" /*test url*/

#define BASE_URL  @"http://52.74.115.111/couperv3_dev/web.php?"




@protocol WebHandlerDelegate

@end


@interface CWebHandler : NSObject


+(CWebHandler *)instance;

-(void)invokeAPI:(NSString *)_method url:(NSString *)_url parameters:(NSMutableDictionary *)_parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

-(void)invokeAPIUsingGet:(NSString *)_requestUrl success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

-(void)invokeAPIUsingPost:(NSMutableDictionary *)_parameterDict postUrl:(NSString *)_url success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

-(void)invokeAPIUsingPostWithMultiPart:(NSMutableDictionary *)_parameterDict postUrl:(NSString *)_url  success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;




@end
