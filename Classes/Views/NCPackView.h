//
//  NCPackView.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 26.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCPackView : UIView

@property (assign, nonatomic) NSInteger packNumber;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic, getter = isFill) BOOL fill;

+ (instancetype)packViewWithFrame:(CGRect)frame;

@end
