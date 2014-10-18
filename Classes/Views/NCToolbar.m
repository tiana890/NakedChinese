//
//  NCToolbar.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 25.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCToolbar.h"

@interface NCToolbar ()
@property (nonatomic, weak) UIView *barLineView;
@end

@implementation NCToolbar

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
    self.barLineView.hidden = isHide;
}

#pragma mark - Private

- (void)setup {
    [self safeLineView];
    
    [self setBackgroundImage:[UIImage new] forToolbarPosition:[self barPosition] barMetrics:UIBarMetricsDefault];
}

- (void)safeLineView {
    [self.subviews enumerateObjectsUsingBlock:
     ^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (![view isMemberOfClass:[UIImageView class]]) {
            return;
        }
        self.barLineView = view;
     }];
}

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

@end
