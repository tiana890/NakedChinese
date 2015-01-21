//
//  NCWordCell.h.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 27.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWordCell.h"
#import <FXBlurView/FXBlurView.h>

@interface NCWordCell ()

@end

@implementation NCWordCell

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private

- (void)setup {
    self.layer.cornerRadius = 7.f;
}

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
