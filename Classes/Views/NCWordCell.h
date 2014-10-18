//
//  NCWordCell.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 27.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <THLabel/THLabel.h>

@interface NCWordCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;
@property (weak, nonatomic) IBOutlet THLabel *translateLabel;
@end
