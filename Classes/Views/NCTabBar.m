//
//  NCTabBar.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 25.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCTabBar.h"

#import <FXBlurView/FXBlurView.h>

@interface NCTabBar ()
@property (nonatomic, copy) UIImage *shadowLine;
@end

@implementation NCTabBar

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private

- (void)setup {
    [self saveLineView];
    [self customizeTabBar];
    self.backgroundImage = [UIImage new];
}

- (void)saveLineView {
    self.shadowLine = [self shadowImage];
}

- (void)customizeTabBar {
    NSArray *items = [self items];
    
    [items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        UIImage *itemImage = [item image];
        
        item.image = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if(idx != 2)
        {
            [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
        }
        else
        {
            [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateNormal];
        }
        [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateSelected];
    }];
    self.tintColor = [UIColor redColor];
}

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - NCBar

- (void)separatorLineHide:(BOOL)isHide {
    self.shadowImage = isHide ? [UIImage new] : [self shadowLine];
}

@end
