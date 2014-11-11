//
//  NCWordLockCell.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 27.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@interface NCWordLockCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pictureView;
@property (strong, nonatomic) IBOutlet FXBlurView *blurView;
@end
