//
//  CCashoutManagerVC.h
//  Couper
//
//  Created by vinay on 24/06/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"
#import "CCustomTopBar.h"

@interface CCashoutManagerVC : UIViewController <CCustomTopBarDelegate,UITextFieldDelegate>
{
    NSString *totalGold;
    int selectedPaymentType;
    
    UITextField *emailTF;
    UITextField *bankAccountTF;
    UITextField *bankNameTF;
    UITextField *userNameTF;

}

@property (nonatomic,weak) IBOutlet UITextField *totalGoldTF;
@property (nonatomic,weak) IBOutlet UITextField *totalDollarTF;



@property (nonatomic,weak) IBOutlet UILabel *totalGoldLbl;
@property (nonatomic,weak) IBOutlet UILabel *balanceLbl;

@end
