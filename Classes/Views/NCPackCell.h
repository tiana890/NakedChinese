//
//  NCPackCell.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 26.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCPackView.h"

FOUNDATION_EXTERN const CGFloat NCPackCellDefaultFontSize;

@interface NCPackCell : UICollectionViewCell

@property (strong, nonatomic, readonly) NCPackView *packView;

//@property (assign, nonatomic) NSInteger packNumber;
//
//@property (assign, nonatomic) CGFloat fontSize;
//
//@property (

@end
