//
//  FBGraphViewController.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FBGraphViewController.h"

enum facebookMode
{
    kFacebookLogin,
    kFacebookFriendList,
    kFacebookFindFriends,
    kFacebookPost,
    kFacebookLikes
};

@interface FBGraphViewController ()

@end

@implementation FBGraphViewController

@synthesize delegate;



static FBGraphViewController *fbGraph = nil;

+(FBGraphViewController *)instance
{
    if(fbGraph == nil)
        fbGraph = [[FBGraphViewController alloc] init];
    
    return fbGraph;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPostData:(NSDictionary *)_postDict
{
    postDataDict = _postDict;
}


-(void)fbUserInformation
{
    [self FBLoginRequest:kFacebookLogin];
}

-(void)fbInviteFriends
{
    [self FBLoginRequest:kFacebookFriendList];
}

-(void)fbFindFriends
{
    [self FBLoginRequest:kFacebookFindFriends];
}

-(void)fbPost
{
    [self FBLoginRequest:kFacebookPost];
}

-(void)fbLikes
{
    [self FBLoginRequest:kFacebookLikes];
}

-(void)FBLoginRequest:(enum facebookMode)_facebookMode
{
    // FBSample logic
    // Check to see whether we have already opened a session.
    if ([FBSDKAccessToken currentAccessToken]) {
        // login is integrated with the send button -- so if open, we send
        if(_facebookMode == kFacebookLogin)
            [self fbGraphRequest];
        else if (_facebookMode == kFacebookFriendList)
            [self sendAppRequestToFriends];
        else if (_facebookMode == kFacebookPost)
            [self fbGraphPostRequest];
        else if(_facebookMode == kFacebookFindFriends)
            [self FBfetchFriendsInfo];
        else if (_facebookMode == kFacebookLikes)
            [self getLikes:[[NSUserDefaults standardUserDefaults] valueForKey:@"fb_id"]];
    } else {
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"facebook"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        NSArray *_permissions = @[@"user_friends",@"email",@"public_profile"];//@"publish_actions",manage_friendlists"];
        
        [login logInWithReadPermissions:_permissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
                if([delegate self])
                    [delegate fbLoginCompletion:nil];
            } else if (result.isCancelled) {
                // Handle cancellations
            } else {
                
                [self fbGraphRequest];
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
//                if ([result.grantedPermissions containsObject:@"email"]) {
//                    // Do work
//                }
                
            
            }
        }];
        
        
//        [login logInWithReadPermissions:_permissions
//                                           allowLoginUI:YES
//                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                          
//                                          // if login fails for any reason, we alert
//                                          if (error) {
//                                              
//                                              if([delegate self])
//                                                  [delegate fbLoginCompletion:nil];
//                                              /*
//                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                               message:error.localizedDescription
//                                               delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil];
//                                               [alert show];*/
//                                              // if otherwise we check to see if the session is open, an alternative to
//                                              // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
//                                              // property of the session object; the macros are useful, however, for more
//                                              // detailed state checking for FBSession objects
//                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
//                                              
//                                              if(!error && status == FBSessionStateOpen)
//                                              {
//                                                  if(_facebookMode == kFacebookLogin)
//                                                      [self fbGraphRequest];
//                                                  else if (_facebookMode == kFacebookFriendList)
//                                                      [self sendAppRequestToFriends];
//                                                  else if (_facebookMode == kFacebookPost)
//                                                      [self fbGraphPostRequest];
//                                                  else if (_facebookMode == kFacebookFindFriends)
//                                                      [self FBfetchFriendsInfo];
//                                              }
//                                          }
//                                      }];
    }
}


-(void)fbGraphRequest
{
    //[NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,first_name,last_name,username,email,picture",@"fields",nil]
    
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             
             
             NSDictionary *userData = (NSDictionary *)result;
             //NSLog(@"%@",userData);
             
             
             //FBGraphObject *response = (FBGraphObject*)result;
             //NSLog(@"Response: %@",response[@"link"]);
             
             [self fbResponse:userData];
         }
     }];
    
//    [FBRequestConnection startWithGraphPath:@"me"
//                                 parameters:nil
//                                 HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
//     {
//         NSDictionary *userData = (NSDictionary *)result;
//         //NSLog(@"%@",userData);
//         
//         
//         //FBGraphObject *response = (FBGraphObject*)result;
//         //NSLog(@"Response: %@",response[@"link"]);
//         
//         [self fbResponse:userData];
//     }];
}

/*
 -(void)fbPostUsingGraphAPI
 {
 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
 [params setObject:@"FunYou" forKey:@"name"];
 [params setObject:@"Allow your users to share stories on Facebook from your app using the iOS SDK." forKey:@"description"];
 [params setObject:@"https://developers.facebook.com/docs/ios/share/" forKey:@"link"];
 [params setObject:@"Build great social apps and get more installs." forKey:@"caption"];
 [params setObject:[Util resizeImage:[UIImage imageNamed:@"user_default.jpg"] scaledToSize:CGSizeMake(100, 100)] forKey:@"picture"];
 //[params setObject:@"FRIEND_ID" forKey:@"to"];
 
 
 [FBRequestConnection startWithGraphPath:@"me/feed"
 parameters:params
 HTTPMethod:@"POST"
 completionHandler:^(FBRequestConnection *connection,
 id result,
 NSError *error)
 {
 NSDictionary *userData = (NSDictionary *)result;
 //NSLog(@"Result:: %@",[userData description]);
 if (error)
 {
 //showing an alert for failure
 [Util alert:@"Facebook" message:error.description];
 }
 else
 {
 //showing an alert for success
 [Util alert:@"Facebook" message:@"Shared the photo successfully"];
 }
 }];
 }
 */

-(void)fbGraphPostRequest
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //---- Code For time Base deal section
    
//    [params setObject:[NSString stringWithFormat:@"%@",postDataDict[@"name"]] forKey:@"name"];
//    [params setObject:postDataDict[@"picture"] forKey:@"picture"];
//    [params setObject:postDataDict[@"description"] forKey:@"description"];
//    [params setObject:@"https://developers.facebook.com/docs/ios/share/" forKey:@"link"]
    
    
    //----- Code for Lucky Base deal section
    
//    [params setObject:[NSString stringWithFormat:@"Couper"] forKey:@"name"];
//    [params setObject:@"http://res.cloudinary.com/demo/image/upload/sample.jpg" forKey:@"picture"];
//    [params setObject:@"Couper allows you to earn rewards from your phone through its daily deals and spinning wheel" forKey:@"description"];
//    //[params setObject:@"http://www.couperhq.com/" forKey:@"link"];
//    [params setObject:@"Build great social apps and get more installs." forKey:@"caption"];
    
    
    //----- Code done to handle both untill API Reponse get fixed in Lucky Based deal
    
    
    
    [params setObject:[NSString stringWithFormat:@"%@",postDataDict[@"name"]] forKey:@"name"];
    
    if (postDataDict[@"picture"] != nil) {
        [params setObject:postDataDict[@"picture"] forKey:@"picture"];
    }
    else{
       [params setObject:@"http://bit.ly/1IvnS39" forKey:@"picture"];
    }
    [params setObject:@"Fight me on Couper to win the weekly Grand Prize!" forKey:@"caption"];
    [params setObject:@"http://apple.co/1Pgxl0j" forKey:@"link"];
    [params setObject:postDataDict[@"description"] forKey:@"description"];
    
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/redirectToContent?id=988867195"];
    
    if (postDataDict[@"picture"] != nil) {
        content.imageURL =[NSURL URLWithString:postDataDict[@"picture"]];
    }
    else{
        content.imageURL =[NSURL URLWithString:@"http://apple.co/1Pgxl0j"];
       // [params setObject:@"http://bit.ly/1IvnS39" forKey:@"picture"];
    }
    
    content.contentDescription = postDataDict[@"description"];
    content.contentTitle=@"Fight me on Couper to win the weekly Grand Prize!";
    [FBSDKShareDialog showFromViewController:self
                                  withContent:content
                                     delegate:self];
    

}

- (void)fbResponse:(NSDictionary *)_responseData
{
    /*
     NSOperationQueue *queue = [NSOperationQueue new];
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
     selector:@selector(setUserImage:)
     object:_responseData[@"picture"][@"data"][@"url"]];
     
     [operation setCompletionBlock:^{
     
     if([delegate self])
     [delegate fbLoginCompletion:_responseData];
     }];
     [queue addOperation:operation];
     */
    
    //[Shared setUserImage:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",_responseData[@"id"]]];
    
    if([delegate self])
        [delegate fbLoginCompletion:_responseData];
}

/*
 -(void)setUserImage:(NSString *)_url
 {
 [Shared setUserImage:[Util downloadImage:_url]];
 }
 */

-(void)getLikes:(NSString *)_facebookId
{
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/likes"
                                               parameters:nil
                                               HTTPMethod:@"GET"]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 // ...
                 
                 NSDictionary *userData = (NSDictionary *)result;
                 //NSLog(@"response === %@",userData);

             }];
}


-(void)sendAppRequestToFriends
{
//    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
//    
//    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
//                                                  message:@"FunYou app message"
//                                                    title:@"FounYou App Title!"
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          // Case A: Error launching the dialog or sending request.
//                                                          //NSLog(@"Error sending request.");
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // Case B: User clicked the "x" icon
//                                                              //NSLog(@"User canceled request.");
//                                                          } else {
//                                                              //NSLog(@"Request Sent.");
//                                                          }
//                                                      }
//                                                  }];
//    
}


- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
        //if (results != nil && [results count]>0){
        NSString *_query = @"none";
        
        //NSLog(@"query = %@",_query);
        if([delegate self])
            [delegate fbPostCompletion:_query];
    
}


- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
   
    
}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    
}


-(void)FBfetchFriendsInfo {
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/friends"
                                  parameters:@{@"fields":@"id,name,installed,first_name,picture"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if(error == nil) {
            NSDictionary *userData = (NSDictionary *)result;
            //NSLog(@"response === %@",userData);
            
            if([delegate self])
                [delegate fbInstalledAppUsersList:userData[@"data"]];
        }
        else
            NSLog(@"Facebook Error: %@",error.description);
        
    }];

    
    
//    
//    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                  NSDictionary* result,
//                                                  NSError *error) {
//        
//        NSDictionary *userData = (NSDictionary *)result;
//        //NSLog(@"details : %@",[userData description]);
//        
//        
//        NSString *_facebookIdList = @"";
//        
//        NSArray* friends = [result objectForKey:@"data"];
//        
//        for (NSDictionary<FBGraphUser>* friend in friends) {
//            
//            _facebookIdList = [_facebookIdList stringByAppendingString:[NSString stringWithFormat:@"%@,",friend.id]];
//            //NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//        }
//        _facebookIdList = [_facebookIdList substringToIndex:[_facebookIdList length]-1];
//        
//        
//        //NSLog(@"string = %@",_facebookIdList);
//        
//        if([delegate self])
//            [delegate fbFriendsIdList:_facebookIdList];
//        
//    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
