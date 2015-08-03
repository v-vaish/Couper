//
//  CTabBarController.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CTabBarController.h"
#include "CTags.h"

@interface CTabBarController ()

@end

@implementation CTabBarController

@synthesize plusController;
@synthesize centerButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSelectedIndex:1];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    if(IS_IPHONE_6)
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_bar~iPhone6.png"]];
    else
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_bar.png"]];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"bottom_Circle.png"] highlightImage:[UIImage imageNamed:@"bottom_Circle.png"] target:self action:@selector(buttonPressed:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 82;
    tabFrame.origin.y = self.view.frame.size.height - 82;
    self.tabBar.frame = tabFrame;
    
    UIView *_leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2 - 40, 35)];
    _leftView.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:_leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 40, 0, SCREEN_WIDTH/2 - 40, 35)];
    rightView.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:rightView];
}
*/

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 52;
    tabFrame.origin.y = self.view.frame.size.height - 52;
    self.tabBar.frame = tabFrame;
}



// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
}

- (void)buttonPressed:(id)sender
{
    [self setSelectedIndex:1];
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

- (void)doHighlight:(UIButton*)b {
    [b setHighlighted:YES];
}

- (void)doNotHighlight:(UIButton*)b {
    [b setHighlighted:NO];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBarController.selectedIndex != 1){
        [self performSelector:@selector(doNotHighlight:) withObject:centerButton afterDelay:0];
    }
}

- (BOOL)tabBarHidden {
    return self.centerButton.hidden && self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    self.centerButton.hidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
