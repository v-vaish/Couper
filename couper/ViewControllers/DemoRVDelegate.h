//
//  DemoRVDelegate.h
//  sdk6demo
//
//  Copyright (c) 2015 Supersonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Supersonic/Supersonic.h>

@class CMoreChanceVC;

//An implementation of the 'Rewarded Video' callbacks delegate.
//An instance of this class is given to 'Supersonic' SDK upon initialization.
//Have a look at method 'viewDidLoad' of the DemoViewController class
@interface DemoRVDelegate : NSObject <SupersonicRVDelegate>

- (id) initWithView:(CMoreChanceVC*) view;

@end
