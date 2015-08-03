//
//  CContactPicker.h
//  Couper
//
//  Created by Appy on 18/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CContactPickerDelegate <NSObject>

@optional
-(void)contactSelected:(NSArray *)selectedContactArray;
@end

@interface CContactPicker : UIViewController <UISearchBarDelegate>
{
    NSMutableArray *filterContactArray;
    BOOL isSearching;
}
@property(nonatomic, strong) NSArray *arrContact;

@property (nonatomic,weak) id<CContactPickerDelegate> contactDelegate;

@end
