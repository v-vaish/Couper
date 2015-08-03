//
//  CNewsFeedViewController.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNewsFeedViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *newsArray;
}
@property (nonatomic,strong) IBOutlet UITableView *newsTableView;

@end
