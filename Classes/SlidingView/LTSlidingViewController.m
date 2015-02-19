//
//  LTSlidingContainerViewController.m
//  PageViewControllerTest
//
//  Created by ltebean on 14/10/31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "LTSlidingViewController.h"

@interface LTSlidingViewController ()
@property(nonatomic,strong) LTSlidingView* slidingView;

@end

@implementation LTSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(LTSlidingView*) slidingView
{
    if(!_slidingView){
        _slidingView = [[LTSlidingView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _slidingView.animator = self.animator;
        [self.view addSubview:_slidingView];
        _slidingView.delegate = self;
    }
    return _slidingView;
}

-(void) addChildViewController:(UIViewController *)childController
{
    [self.slidingView addView:childController.view];
    [super addChildViewController:childController];
}

-(void) setOpenedIndex:(int) currentIndex
{
    [self.slidingView setOpenedIndex:currentIndex];
}

- (void)ltSlidingViewProtocolCurrentIndexChanged:(int)newIndex
{
    //NSLog(@"%i", newIndex);
}
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
