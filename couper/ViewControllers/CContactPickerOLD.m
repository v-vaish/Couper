//
//  CContactPicker.m
//  Couper
//
//  Created by Appy on 18/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CContactPicker.h"
#import "CCustomTopBar.h"
#import "Utils.h"

@interface CContactPicker ()
{
    NSMutableDictionary *dictSelectedElement;
}

@property(nonatomic,weak) IBOutlet  UITableView *tblContact;
@property(nonatomic,weak) IBOutlet  UISearchBar *searchBarContact;

@end

@implementation CContactPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    filterContactArray = [[NSMutableArray alloc] init];
    dictSelectedElement = [[NSMutableDictionary alloc] init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addTopBar];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    _customTopBar.delegate = self;
    [_customTopBar createTopBar:@" Contact" currentVC:self leftBtn:YES rightBtn:NO];
}

#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) {
        return [filterContactArray count];
    }
    else {
        return [self.arrContact count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    if (isSearching) {
        cell.textLabel.text = [[filterContactArray objectAtIndex:indexPath.row] objectForKey:@"UserName"];
    }
    else {
        cell.textLabel.text = [[self.arrContact objectAtIndex:indexPath.row] objectForKey:@"UserName"];;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button setFrame:CGRectMake(270.0, 7.0, 30.0, 30.0)];
    
    BOOL isSelected = [[dictSelectedElement objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]] boolValue];
    if(isSelected)
        [button setImage:[UIImage imageNamed:@"check_box_active"] forState:UIControlStateNormal];
    else
        [button setImage:[UIImage imageNamed:@"check_box_empty"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonCheckUncheckClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyStr = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    BOOL  isSelected = [[dictSelectedElement objectForKey:keyStr] boolValue];
    if(!isSelected)
    {
        [dictSelectedElement setValue:[NSNumber numberWithBool:YES] forKey:keyStr];
        
    }
    else
    {
        [dictSelectedElement removeObjectForKey:keyStr];
        
    }
    
    [tableView reloadData];

}
#pragma mark-Button Action

-(void)buttonCheckUncheckClicked:(id)sender
{
    //Getting the indexPath of cell of clicked button
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tblContact];
    
    NSIndexPath *indexPath = [self.tblContact indexPathForRowAtPoint:touchPoint];
    // No need to use tag sender will keep the reference of clicked button
    UIButton *button = (UIButton *)sender;
    //Checking the condition button is checked or unchecked.
    //accordingly replace the array object and change the button image
    NSString *keyStr = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    BOOL  isSelected = [[dictSelectedElement objectForKey:keyStr] boolValue];
    if(!isSelected)
    {
        [button setImage:[UIImage imageNamed:@"check_box_active"] forState:UIControlStateNormal];
        [dictSelectedElement setValue:[NSNumber numberWithBool:YES] forKey:keyStr];
        
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"check_box_empty"]
                forState:UIControlStateNormal];
        [dictSelectedElement removeObjectForKey:keyStr];
        
    }
    
}


-(IBAction)sendBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray *arr = [dictSelectedElement allKeys];
    if ([arr count] < 3) {
        [Utils alert:@"Please select at least three contacts"];
        return;
    }
    
    
    NSMutableArray *contactArr = [[NSMutableArray alloc] init];
    
    for (NSString *key in arr) {
        [contactArr addObject:[[self.arrContact objectAtIndex:[key intValue]] objectForKey:@"phone"]];
    }
    
    if([self.contactDelegate respondsToSelector:@selector(contactSelected:)])
        [self.contactDelegate contactSelected:contactArr];
    
    
}

#pragma mark Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [filterContactArray removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        isSearching = NO;
    }
     [self.tblContact reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchTableList];
}


- (void)searchTableList {
    NSString *searchString = self.searchBarContact.text;
    
    for (NSDictionary *tempDict in self.arrContact) {
        NSString *tempStr = tempDict[@"UserName"];
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [filterContactArray addObject:tempDict];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
