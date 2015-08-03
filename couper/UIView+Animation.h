//
//  UIView+Animation.h
//  Couper
//
//  Created by vinay on 24/06/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView_Animation : UIView

@property (nonatomic,strong) UIView *popupView;

-(void)addTopBar:(NSString *)title rightCross:(BOOL)status;

@end
