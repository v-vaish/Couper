//
//  CTabBarController.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTabBarController : UITabBarController

@property(nonatomic, weak) IBOutlet UIViewController *plusController;
@property(nonatomic, weak) IBOutlet UIButton *centerButton;

@property(nonatomic, assign) BOOL tabBarHidden;

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;


@end
