//
//  NCWordContentViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 03.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCExplanationViewController.h"

@interface NCWordContentViewController : UIViewController

@property (strong, nonatomic) NSDictionary *dictionaryWithWord;
@property (assign, nonatomic) NSInteger pageIndex;

@end
