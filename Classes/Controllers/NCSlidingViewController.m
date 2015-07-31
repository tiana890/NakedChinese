//

//  NCSlidingViewController.m
//  NakedChinese
//
//  Created by IMAC  on 05.02.15.
//  Copyright (c) 2015 ZM. All rights reserved.
//

#import "NCSlidingViewController.h"
#import "LTSlidingViewCoverflowTransition.h"
#import <QuartzCore/QuartzCore.h>

@interface NCSlidingViewController ()
@end

@implementation NCSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addController:(UIViewController *)controller
{
    if(!self.animator)
     self.animator = [[LTSlidingViewCoverflowTransition alloc]init];
    
    [self addChildViewController:controller];
}

- (void)ltSlidingViewProtocolCurrentIndexChanged:(int)newIndex
{
    if([self.delegate respondsToSelector:@selector(ncSLidingViewControllerProtocolCurrentIndexChanged:)])
    {
        [self.delegate ncSLidingViewControllerProtocolCurrentIndexChanged:newIndex];
    }
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
