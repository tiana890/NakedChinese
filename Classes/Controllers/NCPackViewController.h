//
//  NCPackViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 27.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCPack.h"

typedef NS_ENUM(NSUInteger, NCPackControllerType) {
    NCPackControllerOfNumber,
    NCPackControllerOfFavorite,
};

@interface NCPackViewController : UIViewController

@property (assign, nonatomic) NSInteger packNumber;

@property (assign, nonatomic) NCPackControllerType type;

@property (strong, nonatomic) NCPack *pack;

@property (nonatomic) BOOL isOpenFromMenu;
@end
