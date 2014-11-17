//
//  CollectionCell.h
//  CustomScroll
//
//  Created by IMAC  on 22.10.14.
//  Copyright (c) 2014 Zayceva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *upperLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomLabel;
@property (nonatomic, strong) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@end
