//
//  CWebHandler.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <AFNetworking.h>
#import "CWebHandler.h"
#import "Utils.h"
#import "StaticMessages.h"


@implementation CWebHandler

static CWebHandler *_CWebHandler = nil;

+(CWebHandler *)instance
{
    if(_CWebHandler == nil)
        _CWebHandler = [[CWebHandler alloc] init];
    
    return _CWebHandler;
}


-(void)connected:(void (^)(BOOL result))_result {

    __block BOOL reachable;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                //NSLog(@"No Internet Connection");
                reachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //NSLog(@"WIFI");
                
                reachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //NSLog(@"3G");
                reachable = YES;
                break;
            default:
                //NSLog(@"Unkown network status");
                reachable = NO;
                break;
        }
        
        _result(reachable);
        
    }];
}

-(void)invokeAPI:(NSString *)_method url:(NSString *)_url parameters:(NSMutableDictionary *)_parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    /*
    [self connected:^(BOOL result) {
        
        if(result)
        {*/
            if([_method isEqualToString:@"GET"])
            {
                NSMutableString *_requestUrl = [[NSMutableString alloc] initWithString:_url];
                int _count = (int)[[_parameters allKeys] count];
                for (int i=0; i< _count; i++) {
                    
                    NSString *_key = [_parameters allKeys][i];
                    [_requestUrl appendFormat:@"%@=%@",_key,[_parameters valueForKey:_key]];
                    
                    if(i != _count-1)
                    {
                        [_requestUrl appendString:@"&"];
                    }
                }
                [self invokeAPIUsingGet:_requestUrl success:success failure:failure];
            }
            else
            {
                [self invokeAPIUsingPost:_parameters postUrl:_url success:success failure:failure];
            }
    /*
        }
        else
        {
            [Utils alert:SM_Error_InternetConnection];
            return;
        }
    }]; */
}


//GET Request

-(void)invokeAPIUsingGet:(NSString *)_requestUrl success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:_requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"JSON: %@", responseObject);
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"ErrorCode: %zd Error: %@", error.code,error.description);
        failure(error);
    }];
}


//POST URL-Form-Encoded Request

-(void)invokeAPIUsingPost:(NSMutableDictionary *)_parameterDict postUrl:(NSString *)_url success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:_url parameters:_parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"ErrorCode: %zd Error: %@", error.code,error.description);
        failure(error);
    }];
}


//POST Multi-Part Request

-(void)invokeAPIUsingPostWithMultiPart:(NSMutableDictionary *)_parameterDict postUrl:(NSString *)_url  success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    [manager POST:_url parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"ErrorCode: %zd Error: %@", error.code,error.description);
        failure(error);
    }];
}


@end
