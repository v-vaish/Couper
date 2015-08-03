//
//  CProfileViewController.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CProfileViewController : UIViewController
{
    IBOutlet UIImageView    *profile_image;
    IBOutlet UILabel        *profile_userName;
    
}
@property (nonatomic) int followersCount;

@property (weak, nonatomic) IBOutlet UIButton *followersBtn;
@end
