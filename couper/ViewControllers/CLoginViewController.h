//
//  CLoginViewController.h
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "FBGraphViewController.h"


@interface CLoginViewController : UIViewController <FBLoginDelegate>
{
    IBOutlet UIButton       *facebookBtn;
    NSDictionary *fbResponse;
}
@end
