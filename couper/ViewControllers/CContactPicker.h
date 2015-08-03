//
//  CContactPicker.h
//  Couper
//
//  Created by Appy on 18/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CContactPickerDelegate

@optional
-(void)contactSelected:(NSArray *)selectedContactArray;
@end

@interface CContactPicker : UIViewController <UISearchBarDelegate>
{
    NSMutableArray *filterContactArray;
    BOOL isSearching;
    int searchIndex;
}
@property(nonatomic, strong) NSMutableArray *arrContact;

@property (nonatomic,strong) id contactDelegate;

@end


