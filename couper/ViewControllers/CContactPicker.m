//
//  CContactPicker.m
//  Couper
//
//  Created by Appy on 18/04/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//


#import "CContactPicker.h"
#import "CCustomTopBar.h"
#import "CWebHandler.h"
#import "CSharedContent.h"
#import "CShared.h"
#import "Utils.h"


@interface CContactPicker ()
{
    NSMutableDictionary *dictSelectedElement;
}

@property(nonatomic,weak) IBOutlet  UITableView *tblContact;
@property(nonatomic,weak) IBOutlet  UISearchBar *searchBarContact;

@end


@implementation CContactPicker


@synthesize contactDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    filterContactArray = [[NSMutableArray alloc] init];
    dictSelectedElement = [[NSMutableDictionary alloc] init];
    
    [self performSelector:@selector(getShareListAPI) withObject:nil afterDelay:0.1];
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
    [_customTopBar createTopBar:@"contact" currentVC:self leftBtn:YES rightBtn:NO];
}

#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Get Share Contact List API Methods

-(void)getShareListAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getShareParameters] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        if([_responseDict[@"result"] intValue])
        {
            NSString *_existNumberStr = _responseDict[@"data"][0][@"list"];
            _existNumberStr = [_existNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSArray *_existNumberArray;
            if(_existNumberStr.length > 0)
            {
                _existNumberArray = [_existNumberStr componentsSeparatedByString:@","];
                [self filterContactList:_existNumberArray];
            }
            else
                [self.tblContact reloadData];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getShareParameters
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=get_share_list"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",[CShared getLuckDrawId]];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}

-(void)filterContactList:(NSArray *)_existContactArr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (phone IN %@)", _existContactArr];
    _arrContact = [[_arrContact filteredArrayUsingPredicate:predicate] mutableCopy];
    
    
    [self.tblContact reloadData];
}


#pragma mark Tableview Delegates


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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    if (isSearching) {
        
        NSDictionary *_tempDict = [filterContactArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [_tempDict objectForKey:@"UserName"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button setFrame:CGRectMake(270.0, 7.0, 30.0, 30.0)];
        
        BOOL isSelected = [[dictSelectedElement objectForKey:_tempDict[@"index"]] boolValue];
        if(isSelected)
            [button setImage:[UIImage imageNamed:@"check_box_active"] forState:UIControlStateNormal];
        else
            [button setImage:[UIImage imageNamed:@"check_box_empty"] forState:UIControlStateNormal];
        
        [button setUserInteractionEnabled:NO];
        //[button addTarget:self action:@selector(buttonCheckUncheckClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];

    }
    else {
        
        cell.textLabel.text = [[self.arrContact objectAtIndex:indexPath.row] objectForKey:@"UserName"];;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button setFrame:CGRectMake(270.0, 7.0, 30.0, 30.0)];
        
        BOOL isSelected = [[dictSelectedElement objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]] boolValue];
        if(isSelected)
            [button setImage:[UIImage imageNamed:@"check_box_active"] forState:UIControlStateNormal];
        else
            [button setImage:[UIImage imageNamed:@"check_box_empty"] forState:UIControlStateNormal];
        
        [button setUserInteractionEnabled:NO];
        //[button addTarget:self action:@selector(buttonCheckUncheckClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyStr;
    NSMutableDictionary *tempDict;
    
    if (isSearching)
    {
        keyStr = [[filterContactArray objectAtIndex:indexPath.row] objectForKey:@"index"];
        tempDict = filterContactArray[indexPath.row];
    }
    else
    {
        keyStr = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        tempDict = self.arrContact[indexPath.row];
    }
    
    BOOL  isSelected = [[dictSelectedElement objectForKey:keyStr] boolValue];
    if(!isSelected)
    {
        NSString *numberStr = [tempDict objectForKey:@"phone"];
        
        //numberStr = [numberStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if([Utils checkMobileNumberValidationByAPI:numberStr])
        {
            [dictSelectedElement setValue:[NSNumber numberWithBool:YES] forKey:keyStr];
        }
        else
        {
            [Utils alert:[NSString stringWithFormat:@"Sorry %@ this mobile number is not valid for Singapore",numberStr]];
            return;

        }
        /*
        // Put number validation according to Singapore mobile number
        if(numberStr.length > 10 || numberStr.length < 8)
        {
            [Utils alert:[NSString stringWithFormat:@"Sorry %@ the mobile number is invalid.",numberStr]];
            return;
        }
        
        if (numberStr.length == 10 && [[numberStr substringToIndex:2] intValue] == 65)
        {
            //NSLog(@"Valid Number");
            [dictSelectedElement setValue:[NSNumber numberWithBool:YES] forKey:keyStr];
            [tableView reloadData];
            return;
        }
        else if(numberStr.length == 10 && [[numberStr substringToIndex:2] intValue] != 65)
        {
            [Utils alert:[NSString stringWithFormat:@"Sorry %@ the mobile number is invalid.",numberStr]];
            return;
        }
        
        if (numberStr.length == 8 && ([[numberStr substringToIndex:1] intValue] == 8 || [[numberStr substringToIndex:1] intValue] == 9))
        {
            //NSLog(@"Valid Number");
            [dictSelectedElement setValue:[NSNumber numberWithBool:YES] forKey:keyStr];
            [tableView reloadData];
            return;
        }
        else
        {
            [Utils alert:[NSString stringWithFormat:@"Sorry %@ the mobile number is invalid.",numberStr]];
            return;
        }
         */
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
    NSString *keyStr;
    if (isSearching)
        keyStr = [[filterContactArray objectAtIndex:indexPath.row] objectForKey:@"index"];
    else
        keyStr = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    
    //NSString *keyStr = [NSString stringWithFormat:@"%d",(int)indexPath.row];
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
    if ([arr count] < 1) {
        [Utils alert:@"Please select at least one contacts"];
        return;
    }
    
    NSMutableArray *contactArr = [[NSMutableArray alloc] init];
    
    for (NSString *key in arr) {
        
        NSString *numberStr = [[self.arrContact objectAtIndex:[key intValue]] objectForKey:@"phone"];
        
        [contactArr addObject:numberStr];
    }
    
    
    if([contactDelegate respondsToSelector:@selector(contactSelected:)])
        [contactDelegate contactSelected:contactArr];
    
    [dictSelectedElement removeAllObjects];

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //isSearching = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
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
    
    [searchBar resignFirstResponder];
    [self searchTableList];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchTableList {
    NSString *searchString = self.searchBarContact.text;
    /*
    for (NSDictionary *tempDict in self.arrContact) {
        NSString *tempStr = tempDict[@"UserName"];
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [filterContactArray addObject:tempDict];
        }
    }
    */
    for (int i=0; i<self.arrContact.count;i++) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:self.arrContact[i]];
        
        NSString *tempStr = tempDict[@"UserName"];
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [tempDict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
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
