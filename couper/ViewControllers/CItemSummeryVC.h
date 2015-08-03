//
//  CItemSummeryVC.h
//  Couper
//
//  Created by vinay on 05/06/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCustomTopBar.h"

@interface CItemSummeryVC : UIViewController <UITableViewDataSource,UITableViewDelegate,CCustomTopBarDelegate>
{

    NSMutableArray *itemArray;
}


@property (nonatomic,strong) IBOutlet UITableView *itemTableView;

@end
