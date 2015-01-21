//
//  NCExplanationCell.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 02.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NCExplanationCellDelegate;

@interface NCExplanationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet id<NCExplanationCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *translateLabel;
@end

@protocol NCExplanationCellDelegate <NSObject>
- (void)sayFromExplanationCell:(NCExplanationCell *)cell;
@end