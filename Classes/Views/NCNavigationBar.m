//
//  NCNavigationBar.m
//  GradientNavigationBarDemo
//
//  Created by Dmitriy Karachentsov on 24.06.14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "NCNavigationBar.h"

const CGFloat NCNavigationBarStatusBarHeight = 20.f;

@interface NCNavigationBar ()
@property (nonatomic, weak) UIView *lineView;
@end

@implementation NCNavigationBar

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - NCBar 

- (void)separatorLineHide:(BOOL)isHide {
    self.lineView.hidden = isHide;
}

#pragma mark - Private

- (void)setup {
    [self saveLineView];
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)saveLineView {
    [self.subviews enumerateObjectsUsingBlock:
     ^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            if ([view subviews].count > 0) {
                self.lineView = view.subviews[0];
                *stop = YES;
            }
        }
    }];
}

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

@end
