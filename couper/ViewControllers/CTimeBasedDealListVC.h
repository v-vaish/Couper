//
//  CTimeBasedDealListVC.h
//  Couper
//
//  Created by vinay on 05/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTimeBasedDealListVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *couponTableView;
@property (nonatomic,strong) NSMutableArray *couponArray;

@end
