//
//  CSpinDetailsVC.h
//  Couper
//
//  Created by vinay on 06/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZTimerLabel/MZTimerLabel.h>


@protocol SpinDetailsProtocol

-(void)closeSpinPopup:(UIViewController *)currentVC;

@end

@interface CSpinDetailsVC : UIViewController <MZTimerLabelDelegate>
{
    MZTimerLabel *mzTimer;
    NSString *totalSpinStr;
}
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UILabel *totalSpinLbl;
@property (nonatomic,weak) IBOutlet UILabel *countDownTimerLbl;

@property (nonatomic,strong) id delegate;
-(void)setTotalSpin:(NSString *)totalSpin;

@end
