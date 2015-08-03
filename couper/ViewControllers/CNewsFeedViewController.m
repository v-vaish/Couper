//
//  CNewsFeedViewController.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CNewsFeedViewController.h"
#import "CCustomTopBar.h"
#import "CWebHandler.h"
#import "CSharedContent.h"
#import "CShared.h"
#import "Utils.h"
#import "CTags.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface CNewsFeedViewController ()

@end

@implementation CNewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utils showIndicatorView:self.view];
    [self performSelector:@selector(newsFeedAPI) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addTopBar
{
    CCustomTopBar *_customTopBar = [CCustomTopBar instance];
    [_customTopBar createTopBar:@"newsfeed" currentVC:self leftBtn:NO rightBtn:NO];
}

#pragma mark Get Feed News API Methods

-(void)newsFeedAPI
{
    CWebHandler *_webHandler = [CWebHandler instance];
    [_webHandler invokeAPIUsingGet:[self getParameter] success:^(id result) {
        
        NSDictionary *_responseDict = (NSDictionary *)result;
        //NSLog(@"Response = %@", _responseDict);
        
        [Utils hideIndicatorView:self.view];
        
        if([_responseDict[@"result"] intValue])
        {
            newsArray = [_responseDict[@"data"] objectAtIndex:0][@"activity_list"];
            
            if(newsArray.count)
                [self.newsTableView reloadData];
            else
                [Utils alert:@"Sorry! No feeds available for now."];
        }
    } failure:^(NSError *error) {
        
        [Utils hideIndicatorView:self.view];
        //NSLog(@"loginError = %@",[error description]);
    }];
}


-(NSString *)getParameter
{
    CSharedContent *sharedContent = [CSharedContent instance];
    
    NSMutableString *_requestUrl = [[NSMutableString alloc] init];
    [_requestUrl appendFormat:@"%@",BASE_URL];
    [_requestUrl appendFormat:@"m=get_activity"];
    [_requestUrl appendFormat:@"&member_id=%@",sharedContent.userDetails.userId];
    [_requestUrl appendFormat:@"&luckydraw_id=%@",[CShared getLuckDrawId]];
    
    NSString *_urlStr = (NSString *)_requestUrl;
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Reuest Url = %@",_urlStr);
    return _urlStr;
}


#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *tempDict = newsArray[indexPath.row];

    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50,50)];
    [Utils makeCircleImage:userImage];
    [userImage setBackgroundColor:[UIColor clearColor]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:tempDict[@"profile_img"]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    [cell addSubview:userImage];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(65, 3, SCREEN_WIDTH - 110, 50)];
    msg.text = tempDict[@"message"];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor darkGrayColor];
    msg.font = [UIFont systemFontOfSize:12];
    msg.numberOfLines = 0;
    [cell addSubview:msg];
    
    UIImageView *emojiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 30,35)];
    [emojiImageView setBackgroundColor:[UIColor clearColor]];
    emojiImageView.image  = [UIImage imageNamed:@"plain_emoji.png"];
    [cell addSubview:emojiImageView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
