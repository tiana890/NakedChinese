//
//  NCSlidingViewController.h
//  NakedChinese
//
//  Created by IMAC  on 05.02.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "LTSlidingViewController.h"

@protocol NCSLidingViewControllerProtocol <NSObject>

- (void) ncSLidingViewControllerProtocolCurrentIndexChanged:(int) index;

@end

@interface NCSlidingViewController : LTSlidingViewController

- (void) addController:(UIViewController *)controller;
@property (nonatomic, strong) id<NCSLidingViewControllerProtocol> delegate;
@end
