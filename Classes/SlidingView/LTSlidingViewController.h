//
//  LTSlidingContainerViewController.h
//  PageViewControllerTest
//
//  Created by ltebean on 14/10/31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSlidingView.h"

@interface LTSlidingViewController : UIViewController<LTSlidingViewProtocol>
@property(nonatomic,strong) id<LTSlidingViewTransition> animator;
-(void) setOpenedIndex:(int) currentIndex;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
