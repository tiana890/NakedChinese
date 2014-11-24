//
//  NCTest.h
//  NakedChinese
//
//  Created by IMAC  on 21.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCQuestion.h"

@interface NCTest : NSObject

- (void) fillTestWithWordsArray:(NSArray *)words;
- (BOOL) setAnswerIndex:(int)index forQuestionWithIndex:(int) index;
- (NCQuestion *) getQuestionWithIndex:(int) questionIndex;
- (int) getNumberOfQuestions;
- (int) getNumberOfRightAnswers;
- (NSString *) getMark;
@end
