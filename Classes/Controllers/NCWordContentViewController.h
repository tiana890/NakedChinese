//
//  NCWordContentViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 03.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCExplanationViewController.h"
#import "NCWord.h"

@interface NCWordContentViewController : UIViewController

@property (strong, nonatomic) NCWord *word;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) IBOutlet UIView *hiddenView;
@property (strong, nonatomic) IBOutlet UIImageView *hiddenViewPicture;

@property (nonatomic) BOOL ifFavourite;
@end
