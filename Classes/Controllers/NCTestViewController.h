//
//  NCTestViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 30.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NCTestType) {
    NCTestTypeLanguageChinese,
    NCTestTypeChineseLanguage
};

@interface NCTestViewController : UIViewController

@property (assign, nonatomic, getter = isOpenFromMenu) BOOL openFromMenu;

@end
