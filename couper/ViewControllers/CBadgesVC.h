//
//  CBadgesVC.h
//  Couper
//
//  Created by vinay on 06/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCustomTopBar.h"

@interface CBadgesVC : UIViewController <CCustomTopBarDelegate>
{

    IBOutlet UIProgressView *progressBarExperience;
    IBOutlet UIProgressView *progressBarStarbucks;
    IBOutlet UIProgressView *progressBarCoffee;
    
    float progressValueExperience;
    float progressValueStarbucks;
    float progressValueCoffee;
    
}

@end
