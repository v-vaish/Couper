//
//  UIView+Animation.m
//  Couper
//
//  Created by vinay on 24/06/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "UIView+Animation.h"
#import "CTags.h"

@implementation UIView_Animation

@synthesize popupView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *_bgView = [[UIImageView alloc] initWithFrame:self.frame];
        _bgView.backgroundColor = [UIColor blackColor];
        [_bgView setAlpha:0.5];
        [self addSubview:_bgView];
        
        [self setPopupDefaultUI:frame];
        
        
    }
    return self;
}

-(void)setPopupDefaultUI:(CGRect)frame
{
    popupView = [[UIView alloc] initWithFrame:frame];
    popupView.backgroundColor = Color_Light_Green;
    
    [self addSubview:popupView];
    
    [self setCenterFadeInAnimation];
}

-(void)addTopBar:(NSString *)title rightCross:(BOOL)status
{
    UILabel *_couponNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0  , popupView.frame.size.width , 40)];
    _couponNameLbl.text = title;
    _couponNameLbl.textAlignment = NSTextAlignmentCenter;
    _couponNameLbl.textColor = [UIColor whiteColor];
    _couponNameLbl.backgroundColor = Color_Dark_Green;
    [popupView addSubview:_couponNameLbl];
    
    if(status)
    {
        UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        crossBtn.frame = CGRectMake(popupView.frame.size.width -50, 2, 40, 40);
        [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [crossBtn addTarget:self  action:@selector(crossBtnListner:) forControlEvents:UIControlEventTouchUpInside];
        crossBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [popupView addSubview:crossBtn];
    }
}


-(void)crossBtnListner:(id)sender
{
    [self removeFromSuperview];
}


-(void)removeFromSuperview
{
    [self setCenterFadeoutAnimation];
}

-(void)setCenterFadeInAnimation
{
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.transform = CGAffineTransformMakeScale(1,1);
    self.alpha = 1.0f;
    [UIView commitAnimations];
    
}

-(void)setCenterFadeoutAnimation
{
    self.alpha = 1.0f;
    self.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.transform = CGAffineTransformMakeScale(0.1,0.1);
    self.alpha = 0.0f;
    [UIView commitAnimations];
}

@end
