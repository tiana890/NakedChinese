//
//  NCVisuallyPackViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 28.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCVisuallyPackViewController : UIViewController

@property (strong, nonatomic) NSArray *arrayOfWords;
@property (assign, nonatomic) NSInteger openedWordIndex;
@property (nonatomic) BOOL ifFavorite;
@end
