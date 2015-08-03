//
//  CItemSummeryVC.m
//  Couper
//
//  Created by vinay on 05/06/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CItemSummeryVC.h"
#import "CTags.h"

@implementation CItemSummeryVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self addTableViewHeader];
    [self addTableViewFooter];
    
    [self.itemTableView reloadData];
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
    [_customTopBar createTopBar:@"luckydraw" currentVC:self leftBtn:YES rightBtn:NO];
}



#pragma mark TopBarDelegate

-(void)leftBtnListner
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addTableViewHeader
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.itemTableView.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UIButton *addItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addItemBtn.frame = CGRectMake(10, 10, self.itemTableView.frame.size.width-20, 30);
    [addItemBtn setTitle:@"Add Item" forState:UIControlStateNormal];
    addItemBtn.backgroundColor = Color_Dark_Green;
    [addItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addItemBtn addTarget:self action:@selector(addItemBtnListner:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addItemBtn];
    
    _itemTableView.tableHeaderView  = bgView;
}

-(void)addTableViewFooter
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.itemTableView.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UIButton *checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkOutBtn.frame = CGRectMake(10, 10, self.itemTableView.frame.size.width-20, 30);
    [checkOutBtn setTitle:@"Check Out" forState:UIControlStateNormal];
    checkOutBtn.backgroundColor = Color_Dark_Green;
    [checkOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[addItemBtn addTarget:self action:@selector(checkOutBtnListner:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:checkOutBtn];
    
    _itemTableView.tableFooterView = bgView;
}


-(void)addItemBtnListner:(id)sender
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AddItem"] animated:YES];
}


#pragma mark Tableview Delegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;//[itemArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    //NSDictionary *tempDict = itemArray[indexPath.row];
    
    UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
    [brandName setText:@"Brand Name:"];
    brandName.textColor = [UIColor blackColor];
    brandName.backgroundColor = [UIColor clearColor];
    brandName.font = [UIFont systemFontOfSize:12];
    [cell addSubview:brandName];

    UILabel *brandValue = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 80, 20)];
    [brandValue setText:@"ALDO"];//tempDict[@"brand_name"]];
    brandValue.textColor = [UIColor darkGrayColor];
    brandValue.backgroundColor = [UIColor clearColor];
    brandValue.font = [UIFont systemFontOfSize:13];
    [cell addSubview:brandValue];

    UIImageView *brandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 270, 200)];
    brandImageView.backgroundColor = [UIColor clearColor];
    brandImageView.image = [UIImage imageNamed:@"item.png"];//tempDict[@"brand_image"];
    [cell addSubview:brandImageView];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
