//
//  FBGraphViewController.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@protocol FBLoginDelegate

@optional

- (void)fbLoginCompletion:(NSDictionary *)_response;
- (void)fbPostCompletion:(NSString *)_postId;
- (void)fbInstalledAppUsersList:(NSArray *)_friendsList;


@end

@interface FBGraphViewController : UIViewController<FBSDKAppInviteDialogDelegate,FBSDKSharingDelegate>
{
    NSDictionary *postDataDict;
}
@property (nonatomic, strong) id delegate;

+(FBGraphViewController *)instance;
-(void)fbUserInformation;
-(void)fbInviteFriends;
-(void)fbPost;
-(void)fbFindFriends;
-(void)setPostData:(NSDictionary *)_postDict;
-(void)fbLikes;

@end
