//
//  NCJokeItemViewController.h
//  NakedChinese
//
//  Created by IMAC  on 22.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCJoke.h"

@interface NCJokeItemViewController : UIViewController

@property (nonatomic, strong) NCJoke *joke;
@property (nonatomic, strong) NSNumber *number;
@end
