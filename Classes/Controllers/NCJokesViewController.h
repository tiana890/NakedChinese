//
//  NCJokesViewController.h
//  NakedChinese
//
//  Created by IMAC  on 22.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCJokesViewController : UIViewController

@property (nonatomic) BOOL fromAppDelegate;
@property (nonatomic, strong) NSNumber *jokeNumber;
@property (nonatomic) BOOL isOpenFromMenu;
@end
