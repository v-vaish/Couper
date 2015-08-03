//
//  CGoldInformationVC.h
//  Couper
//
//  Created by vinay on 26/06/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"


@interface CGoldInformationVC : UIViewController
{
    NSArray *increaseGoldListArr;
    NSArray *increaseSpinListArr;
}

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UILabel *topBarLbl;
@property (nonatomic,weak) IBOutlet UILabel *leftToCashoutLbl;
@property (nonatomic,weak) IBOutlet UILabel *nextObjectiveLbl;
@property (nonatomic,weak) IBOutlet UITextField *goldEarnedTF;
@property (nonatomic,weak) IBOutlet UITextField *dollerEarnedTF;

@property (nonatomic,weak) IBOutlet UIImageView *goldLeftIV;




@end
