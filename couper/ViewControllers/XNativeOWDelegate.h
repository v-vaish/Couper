//
//  XNativeOWDelegate.h
//  couper
//
//  Created by vinay on 15/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NativeXSDK.h>

@class CMoreChanceVC;

@interface XNativeOWDelegate : NSObject <NativeXSDKDelegate, NativeXAdViewDelegate>
{
    
}
-(id) initWithView:(CMoreChanceVC*) view;




@end
