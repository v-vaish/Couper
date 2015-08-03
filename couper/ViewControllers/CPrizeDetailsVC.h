//
//  CPrizeDetailsVC.h
//  Couper
//
//  Created by vinay on 08/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NextCouponDecider.h"
#import "ACoupon.h"

@interface CPrizeDetailsVC : UIViewController
{
    NextCouponDecider *nextCouponDecider;
}

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UITableView *prizeTableView;

-(void)setCouponArray:(NextCouponDecider *)_couponArray;

@end
