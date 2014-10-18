//
//  NCInteractionManager.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 21.08.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NCInteractionView.h"

typedef NS_ENUM(NSInteger, NCSoundLanguage) {
    NCSoundLanguageRussian = 1,
    NCSoundLanguageEnglish
};

@interface NCInteractionManager : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) NCHell interactionHell;
@property (assign, nonatomic) NCSoundLanguage soundLanguage;

- (void)playRandomSoundAtInteractionHell:(NCHell)hell;

@end
