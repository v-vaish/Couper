//
//  CustomPickerView.m
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import "CustomPickerView.h"

@implementation CustomPickerView
@synthesize arrRecords,delegate;


-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrRecords = arrValues;
    }
    return self;

}
-(void)showPicker{
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    self.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *_bg = [[UIImageView alloc] initWithFrame:self.frame];
    [_bg setBackgroundColor:[UIColor blackColor]];
    _bg.alpha = 0.5;
    
    
    copyListOfItems = [[NSMutableArray alloc] init];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height- 212, self.frame.size.width, 0.0)];
    
    //[picketView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height- 212 - 44, self.frame.size.width, 44)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:243/255.0 blue:208/255.0 alpha:1.0];
    
    picketToolbar.barStyle = UIBarStyleBlackOpaque;
    [picketToolbar sizeToFit];

    
    txtSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, 240, 31)];
    txtSearch.tag = 1;
    txtSearch.barStyle = UIBarStyleBlackTranslucent;
    txtSearch.backgroundColor = [UIColor clearColor];
    txtSearch.delegate = self;
    txtSearch.userInteractionEnabled = TRUE;
    
    for (UIView *subview in txtSearch.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    } 
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneClick)];
    [picketToolbar addSubview:txtSearch];
    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible,btnDone, nil];
    [picketToolbar setItems:arrBarButtoniTems];
    [self addSubview:_bg];
    [self addSubview:pickerView];
    [self addSubview:picketToolbar];
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
 
    searching = NO;
	letUserSelectRow = NO;
////    if (pickerView) {
////        [pickerView removeFromSuperview];
////    }
//    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
//    pickerView.showsSelectionIndicator = YES;
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
    
		searching = YES;
		letUserSelectRow = YES;
    
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;

	}
	
	[pickerView reloadAllComponents];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self btnDoneClick];
}

- (void) searchTableView {
	
	NSString *searchText = txtSearch.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];

	
	for (NSString *sTemp in self.arrRecords)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0){
			[copyListOfItems addObject:sTemp];
        }
	}
    [pickerView reloadAllComponents];

    searchArray = nil;
}

-(void)keyboardWillShowNotification:(id)sender{
    
    pickerView.frame = CGRectMake(0.0, self.frame.size.height- 212 -212 , self.frame.size.width, 0.0);
    picketToolbar.frame = CGRectMake(0, self.frame.size.height- 212 - 44 -212, self.frame.size.width, 44);}

-(void)keyboardWillHideNotification:(id)sender{
    
    pickerView.frame = CGRectMake(0.0, self.frame.size.height- 212, self.frame.size.width, 0.0);
    picketToolbar.frame = CGRectMake(0, self.frame.size.height- 212 - 44, self.frame.size.width, 44);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)btnDoneClick{
    
    NSString *strSelectedValue;
    
    if (searching ) {
        
        if (copyListOfItems.count > 0) {
            
            strSelectedValue = [copyListOfItems objectAtIndex:[pickerView selectedRowInComponent:0]];
            int selectedIndex = (int)[self.arrRecords indexOfObject:strSelectedValue];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
                [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
            }
            
        }else{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
                [self.delegate selectedRow:-1 withString:@"NOT FOUND"];
            }
        }
        
    }else{
        
        strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
        int selectedIndex = (int)[self.arrRecords indexOfObject:strSelectedValue];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
            [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self removeFromSuperview];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (searching) {
        return copyListOfItems.count;
    }else{
        return self.arrRecords.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (searching) {
        return [copyListOfItems objectAtIndex:row];
    }else{
        return [self.arrRecords objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
           
}

@end
