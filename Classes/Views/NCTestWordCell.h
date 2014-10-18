//
//  NCTestWordCell.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 31.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCTestWordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;

@end
