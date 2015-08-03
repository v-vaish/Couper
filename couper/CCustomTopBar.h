//
//  CCustomTopBar.h
//  Couper
//
//  Created by Vinay on 20/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol CCustomTopBarDelegate

@optional
-(void)leftBtnListner;
-(void)rightBtnListner;

@end

@interface CCustomTopBar : NSObject
{
    UIView              *topBarView;
    UIViewController    *currentVC;
    UIImage             *rightButtonImage;
}

@property (nonatomic,strong) id delegate;

+(CCustomTopBar *)instance;
-(void)createTopBar:(NSString *)_title currentVC:(UIViewController *)_currentVC leftBtn:(BOOL)_leftBtnBool rightBtn:(BOOL)_rightBtnBool;

-(void)setRightButtonImage:(UIImage *)_buttonImage;

@end
