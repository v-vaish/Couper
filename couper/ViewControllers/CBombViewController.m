//
//  CBombViewController.m
//  couper
//
//  Created by vinay on 23/07/15.
//  Copyright © 2015 Couper. All rights reserved.
//

#import "CBombViewController.h"
#import "CTags.h"


@interface CBombViewController ()

@end

@implementation CBombViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)displayEmojiInGame
{
    emojiArray = [[NSMutableArray alloc] initWithObjects:@"shield_1.png",@"shield_2.png",@"shield_3.png",@"shield_4.png", nil];
    
}


-(void)generateEmojis
{
    float emojiBtnWidth = 50;
    float emojiBtnHeight = 50;
    
    int maxEmojiInRow = SCREEN_WIDTH/4;
    int maxEmojiInColumn = SCREEN_HEIGHT/4;
    
    for (int i = 0; i < maxEmojiInColumn; i++) {
    
        for (int j=0; maxEmojiInRow; j++) {
            
            UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            emojiBtn.frame = CGRectMake(j*emojiBtnWidth, i*emojiBtnHeight, emojiBtnWidth, emojiBtnHeight);
            [emojiBtn setBackgroundImage:[UIImage imageNamed:emojiArray[j]] forState:UIControlStateNormal];
            [emojiBtn setBackgroundColor:[UIColor clearColor]];
        }
    }
}


-(IBAction)selectWeaponAction:(UIButton *)sender
{
    selectWeaponStr = [NSString stringWithFormat:@"%d",(int)sender.tag];
}

-(IBAction)confirmBtnAction:(UIButton *)sender
{
    
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
