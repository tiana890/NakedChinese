//
//  NCTest.h
//  NakedChinese
//
//  Created by IMAC  on 21.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCQuestion.h"
typedef NS_ENUM(NSUInteger, NCTestType) {
    NCTestTypeLanguageChinese,
    NCTestTypeChineseLanguage
};


@interface NCTest : NSObject

- (int)fillTestWithWordsArray:(NSArray *)words andTestType:(NCTestType) testType;
- (BOOL) setAnswerIndex:(int)index forQuestionWithIndex:(int) index;
- (NCQuestion *) getQuestionWithIndex:(int) questionIndex;
- (int) getNumberOfQuestions;
- (int) getNumberOfRightAnswers;
- (NSString *) getMark;
@end
