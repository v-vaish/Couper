//
//  CSpinWinningVC.h
//  couper
//
//  Created by vinay on 17/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpinWinningDelegate

-(void)winningPopupClosed:(UIViewController *)currentVC;

@end


@interface CSpinWinningVC : UIViewController
{
    NSString *userUsedSpin;
    
    NSArray *spinArray;
    NSArray *goldArray;
}

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UILabel *winningMsgLbl;

@property (nonatomic,strong) id delegate;

-(void)setUserSpin:(NSString *)usedSpin;

@end
