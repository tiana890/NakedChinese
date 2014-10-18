//
//  NCPackView.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 26.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCPackView.h"

@implementation NCPackView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

+ (instancetype)packViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

#pragma mark - Private

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.borderWidth = 1.5f;
}

#pragma mark - Custom Accessors

- (void)setPackNumber:(NSInteger)packNumber {
    if (_packNumber == packNumber) {
        return;
    }
    _packNumber = packNumber;
    [self setNeedsDisplay];
}

- (void)setNumberFontSize:(CGFloat)fontSize {
    if (_fontSize == fontSize) {
        return;
    }
    _fontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth == borderWidth) {
        return;
    }
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setFill:(BOOL)fill {
    if (_fill == fill) {
        return;
    }
    _fill = fill;
    [self setNeedsDisplay];
}

#pragma mark - NSObject

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //// Color Declarations
    UIColor *const redColor = [UIColor redColor];
    UIColor *const whiteColor = [UIColor whiteColor];
    UIColor *const fontColor = [self isFill] ? whiteColor : redColor;
    
    //// Math Declarations
    const CGFloat offset = 1.f;
    const CGFloat circleDiameter = CGRectGetHeight(rect) - offset*2;
    
    //// Group
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(offset, offset, circleDiameter, circleDiameter)];
        
        if ([self isFill]) {
            [redColor setFill];
            [ovalPath fill];
        }
        [redColor setStroke];
        ovalPath.lineWidth = [self borderWidth];
        [ovalPath stroke];
        
        
        //// packNumber Drawing
        CGRect packNumberRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
        {
            NSString* textContent = [@(self.packNumber) stringValue];
            NSMutableParagraphStyle* packNumberStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            packNumberStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* packNumberFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-UltraLight" size: self.fontSize], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: packNumberStyle};
            
            [textContent drawInRect: CGRectOffset(packNumberRect, 0, (CGRectGetHeight(packNumberRect) - [textContent boundingRectWithSize: packNumberRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: packNumberFontAttributes context: nil].size.height) / 2) withAttributes: packNumberFontAttributes];
        }
    }
    
}

@end
