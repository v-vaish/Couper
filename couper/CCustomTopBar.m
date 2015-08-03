//
//  CCustomTopBar.m
//  Couper
//
//  Created by Vinay on 20/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CCustomTopBar.h"
#import "CTags.h"



@implementation CCustomTopBar

@synthesize delegate;




static CCustomTopBar *_CustomTopBar =nil;

+(CCustomTopBar *)instance
{
    if(_CustomTopBar == nil)
        _CustomTopBar = [[CCustomTopBar alloc] init];
    
    return _CustomTopBar;
}

-(void)createTopBar:(NSString *)_title currentVC:(UIViewController *)_currentVC leftBtn:(BOOL)_leftBtnBool rightBtn:(BOOL)_rightBtnBool
{
    _title = [NSString stringWithFormat:@"%@",_title];
    currentVC = _currentVC;
    
    topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_BAR_HEIGHT)];
    [topBarView setBackgroundColor:Color_Green_Theam];
    
    if(_title.length)
    {
        float _titleWidth = 200;
        float _labelHeight = 20;
        UILabel *_topBarTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (_titleWidth/2), (topBarView.frame.size.height/2) - (_labelHeight/2), _titleWidth, _labelHeight)];
        _topBarTitle.backgroundColor = [UIColor clearColor];
        //[_topBarTitle setAttributedText:[self setTitleAttributes:_title]];
        _topBarTitle.text = _title;
        _topBarTitle.textColor = [UIColor whiteColor];
        [_topBarTitle setTextAlignment:NSTextAlignmentCenter];
        _topBarTitle.font = [UIFont systemFontOfSize:20];
        [topBarView addSubview:_topBarTitle];
    }
    
    if(_leftBtnBool)
    {
        UIImage *_leftBtnImage = [UIImage imageNamed:@"back_btn.png"];
        
        float _btnWidth = (_leftBtnImage.size.width < topBarView.frame.size.height)?topBarView.frame.size.height:_leftBtnImage.size.width;
        float _btnHeight = topBarView.frame.size.height;
        
        UIButton *_leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(5, 5, _btnWidth, _btnHeight);
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn setImage:_leftBtnImage forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnListner:) forControlEvents:UIControlEventTouchUpInside];
        [topBarView addSubview:_leftBtn];
    }
    
    if(_rightBtnBool)
    {
        UIImage *_rightBtnImage;
        
        if(rightButtonImage)
            _rightBtnImage = rightButtonImage;
        else
            return;
        
        float _btnWidth = (_rightBtnImage.size.width <topBarView.frame.size.height)?topBarView.frame.size.height:_rightBtnImage.size.width;
        float _btnHeight = topBarView.frame.size.height;
        
        UIButton *_rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - _btnWidth, 3, _btnWidth, _btnHeight);
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn addTarget:self action:@selector(rightBtnListner:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setImage:_rightBtnImage forState:UIControlStateNormal];
        [topBarView addSubview:_rightBtn];
    }
    
    [currentVC.view addSubview:topBarView];
}

-(void)leftBtnListner:(UIButton *)sender
{
    if([delegate respondsToSelector:@selector(leftBtnListner)])
        [delegate leftBtnListner];
}

-(void)rightBtnListner:(UIButton *)sender
{
    if([delegate respondsToSelector:@selector(rightBtnListner)])
        [delegate rightBtnListner];
}

-(NSMutableAttributedString *)setTitleAttributes:(NSString *)input
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:input];
    [attrString beginEditing];
    [attrString addAttribute:NSForegroundColorAttributeName value:Color_Couper_Blue range:NSMakeRange(0, 6)];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:16]
                   range:NSMakeRange(0, 6)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(6, input.length-6)];
    
    [attrString endEditing];
    
    return attrString;
}


-(void)setRightButtonImage:(UIImage *)_buttonImage
{
    rightButtonImage = _buttonImage;
}



@end
