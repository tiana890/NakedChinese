//
//  NCNavigationDelegateController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 30.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCNavigationDelegateController.h"

#import "BNRFadeAnimator.h"

#import "NCMenuViewController.h"

#import "NCLanguageViewController.h"
#import "NCSubscribeViewController.h"

@interface NCNavigationDelegateController ()
@property (strong, nonatomic) BNRFadeAnimator *animator;
@end

@implementation NCNavigationDelegateController

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

#pragma mark - <UINavigationControllerDelegate>

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:[NCMenuViewController class]]
        || [fromVC isKindOfClass:[NCMenuViewController class]]
        || [fromVC isKindOfClass:[NCLanguageViewController class]]
        || [fromVC isKindOfClass:[NCSubscribeViewController class]] ) {
        if (!self.animator) {
            self.animator = [BNRFadeAnimator new];
        }
        return [self animator];
    }
    return nil;
}

@end
