//
//  CPrizeDetailsVC.m
//  Couper
//
//  Created by vinay on 08/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import "CPrizeDetailsVC.h"
#import "CAdBannerHandler.h"
#import "CTags.h"

@implementation CPrizeDetailsVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CAdBannerHandler *_bannerHandler = [CAdBannerHandler instance];
    [_bannerHandler addBanner:CGRectMake(0, SCREEN_HEIGHT-180, 320, 50) currentController:self.view];
 
    
    [self.view bringSubviewToFront:_scrollView];
    [_prizeTableView reloadData];
    [self setCenterFadeInAnimation];
}

-(void)setCenterFadeInAnimation
{
    self.view.alpha = 0.0f;
    self.view.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.view.transform = CGAffineTransformMakeScale(1,1);
    self.view.alpha = 1.0f;
    [UIView commitAnimations];
}


-(void)setCenterFadeoutAnimation
{
    self.view.alpha = 1.0f;
    self.view.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.view.transform = CGAffineTransformMakeScale(0.1,0.1);
    self.view.alpha = 0.0f;
    [UIView commitAnimations];
}


-(IBAction)crossBtnAction:(id)sender
{
    [self setCenterFadeoutAnimation];
}

-(void)animationDone
{
    [self.view removeFromSuperview];
}


-(void)setCouponArray:(NextCouponDecider *)_couponArray
{
    nextCouponDecider = _couponArray;
}

#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nextCouponDecider.statistics.coupons count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    ACoupon  *aCouponDict = nextCouponDecider.statistics.coupons[indexPath.row];
    [self createCell:cell row:indexPath singlCouponData:aCouponDict];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark Create TableView Cell

-(void)createCell:(UITableViewCell *)_cell row:(NSIndexPath *)_indexPath singlCouponData:(ACoupon *)aCouponDict
{
    UIImageView *_couponImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70,70)];
    [_couponImage setBackgroundColor:[UIColor clearColor]];
    [_couponImage setImage:aCouponDict.couponImage];
    [_cell addSubview:_couponImage];
    
    UILabel *_CouponName = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, SCREEN_WIDTH - 100, 30)];
    _CouponName.text = aCouponDict.couponName;
    _CouponName.backgroundColor = [UIColor clearColor];
    _CouponName.textColor = [UIColor darkGrayColor];
    [_cell addSubview:_CouponName];
    
    UILabel *_CouponDesc = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, SCREEN_WIDTH - 150, 60)];
    _CouponDesc.text = aCouponDict.couponDescription;
    _CouponDesc.numberOfLines = 3;
    _CouponDesc.backgroundColor = [UIColor clearColor];
    _CouponDesc.textColor = [UIColor lightGrayColor];
    _CouponDesc.font = [UIFont systemFontOfSize:11];
    _CouponDesc.contentMode = UIViewContentModeScaleAspectFit;
    [_cell addSubview:_CouponDesc];
}



@end
