//
//  NCQuestionViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 31.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCTestViewController.h"

@interface NCQuestionViewController : UIViewController
@property (nonatomic, strong) NSArray *packsArray;
@property (nonatomic) NCTestType type;
@end
