//
//  NCPackCell.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 26.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCPackCell.h"
#import "NCPackView.h"

const CGFloat NCPackCellDefaultFontSize = 48.f;

@interface NCPackCell ()
@property (strong, nonatomic, readwrite) NCPackView *packView;
@end

@implementation NCPackCell

//@dynamic packNumber, fontSize;

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
    self.backgroundColor = [UIColor clearColor];
    
    self.packView = [NCPackView packViewWithFrame:[self bounds]];
    self.packView.fontSize = NCPackCellDefaultFontSize;
    [self addSubview:self.packView];
}

#pragma mark - Custom Accessors

//- (void)setPackNumber:(NSInteger)packNumber {
//    self.packCircleView.packNumber = packNumber;
//}
//
//- (void)setFontSize:(CGFloat)fontSize {
//    self.packCircleView.fontSize = fontSize;
//}

#pragma mark - NSObject

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

@end
