//
//  NCQuestionViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 31.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCTest.h"

@interface NCQuestionViewController : UIViewController
@property (nonatomic, strong) NSArray *packsArray;
@property (nonatomic) BOOL ifFavorites;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *soundButton;
@property (nonatomic) NCTestType type;
@end
