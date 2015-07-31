//
//  NCTest.m
//  NakedChinese
//
//  Created by IMAC  on 21.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCTest.h"
#import "NCWord.h"

@interface NCTest()

@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSMutableArray *rightResults;
@property (nonatomic) NCTestType type;
@end

@implementation NCTest

#pragma mark getters and setters
- (NSMutableArray *)questionArray
{
    if(!_questionArray) _questionArray = [[NSMutableArray alloc] init];
    return _questionArray;
}

- (NSMutableArray *)rightResults
{
    if(!_rightResults)
    {
        _rightResults = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.questionArray.count; i++)
        {
            [_rightResults addObject:@0];
        }
    }
    return _rightResults;
}
 
#pragma mark methods

- (int)fillTestWithWordsArray:(NSArray *)words andTestType:(NCTestType) testType
{
    NSMutableArray *questionArray = [[NSMutableArray alloc] init];
    
    NSArray *shuffledArray = [self shuffleArray:words];
    
    
    for(int j = 0; j < shuffledArray.count; j++)
    {
        NCWord *word = (NCWord *)shuffledArray[j];
        
        //формируем вопрос
        NCQuestion *question = [[NCQuestion alloc] init];
        question.answerArray = [[NSMutableArray alloc] init];
        question.word = word;
        int randomRightIndex = arc4random()%4;
        
        
        question.rightIndex = [NSIndexSet indexSetWithIndex:randomRightIndex];
        NSIndexSet *notRightAnswersIndexSet = [self getRandomIndexSetOfArrayWithCount:(int)shuffledArray.count exceptIndex:[NSIndexSet indexSetWithIndex:j]];
        
        NSArray *notRightAnswerArray = [shuffledArray objectsAtIndexes:notRightAnswersIndexSet];
        /*NSLog(@"right = %@", word.material.materialWord);
        for(NCWord *w in notRightAnswerArray)
        {
            NSLog(@"wrong = %@", w.material.materialWord);
        }*/
        
        BOOL ifRightAnswerSet = NO;
        for(int i = 0; i < 4; i++)
        {
            if(testType == NCTestTypeLanguageChinese)
            {
                if(i == randomRightIndex)
                {
                    [question.answerArray addObject:word.material.materialWord];
                    ifRightAnswerSet = YES;
                }
                else
                {
                    if(!ifRightAnswerSet)
                    {
                        [question.answerArray addObject:((NCWord *)notRightAnswerArray[i]).material.materialWord];
                        //NSLog(@"i = %i" ,i);
                    }
                    else
                        [question.answerArray addObject:((NCWord *)notRightAnswerArray[i-1]).material.materialWord];
                        //NSLog(@"i-1 = %i" ,i-1);
                }
               
            }
            else if(testType == NCTestTypeChineseLanguage)
            {
                if(i == randomRightIndex)
                {
                    [question.answerArray addObject:word.material.materialZH];
                    ifRightAnswerSet = YES;
                }
                else
                {
                    
                    if(!ifRightAnswerSet)
                        [question.answerArray addObject:((NCWord *)notRightAnswerArray[i]).material.materialZH];
                    
                    else
                        [question.answerArray addObject:((NCWord *)notRightAnswerArray[i-1]).material.materialZH];
                    
                }
            }
        }
        
        [questionArray addObject:question];
    }//end of for
        
    
    
    self.questionArray = questionArray;
    
    //возвращает количество слов в тесте
    return shuffledArray.count;
}

- (int)getNumberOfQuestions
{
    return (int)self.questionArray.count;
}

- (NCQuestion *)getQuestionWithIndex:(int)index
{
    if (index >= 0 && index < self.questionArray.count)
    {
        return self.questionArray[index];
    }
    else
        return nil;
}

- (BOOL)setAnswerIndex:(int)index forQuestionWithIndex:(int) questionIndex
{
    BOOL ifAnswerIsRight = NO;
    if (questionIndex >= 0 && questionIndex < self.questionArray.count)
    {
        NCQuestion *q = self.questionArray[questionIndex];
        if(index == q.rightIndex.lastIndex)
        {
            [self.rightResults replaceObjectAtIndex:questionIndex withObject:@1];
            ifAnswerIsRight = YES;
        }
    }
    return ifAnswerIsRight;
}

- (int)getNumberOfRightAnswers
{
    int result = 0;
    for(NSNumber *num in self.rightResults)
    {
        if([num isEqualToNumber:@1])
            result ++;
    }
    return result;
}

#pragma mark private methods

- (NSArray*)shuffleArray:(NSArray*)array {

    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
   
    if(array.count > 20)
    {
         NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)];
        return [temp objectsAtIndexes:set];
    }
    else
    {
        return [NSArray arrayWithArray:temp];
    }
}

//берем 3 рэндомных неповторяющихся индекса
- (NSIndexSet *)getRandomIndexSetOfArrayWithCount:(int)count exceptIndex:(NSIndexSet *)indexSet
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < count; i++)
    {
        if(![indexSet containsIndex:i])
        {
            [mutArray addObject:[NSIndexSet indexSetWithIndex:i]];
        }
    }
    NSLog(@"except index %i", (int)indexSet.lastIndex);
    NSMutableIndexSet *resultIndexSet = [[NSMutableIndexSet alloc] init];
    for(int i = 0; i < 3; i++)
    {
        int randomIndex = arc4random()%mutArray.count;
        
        NSIndexSet *inSet = mutArray[randomIndex];
        NSLog(@"index = %i", (int)inSet.lastIndex);
        [resultIndexSet addIndexes:inSet];
        [mutArray removeObjectAtIndex:randomIndex];
    }
    
    
    return resultIndexSet;
}

- (NSString *)getMark
{
    /*
     1-25% УЖАСНО
     26-44% ПЛОХО
     45-59% УДОВЛЕТВОРИТЕЛЬНО
     60-74% ХОРОШО
     75-99% ОТЛИЧНО
     100% ИДЕАЛЬНО
     */
    NSString *result = [[NSString alloc] init];
    float percent = (float)[self getNumberOfRightAnswers]/(float)[self getNumberOfQuestions];
    
    if(percent >= 0.00 && percent <= 0.25)
    {
        result = [self stringTestRandomResultWithBaseString:@"verybad" andModule:5];
    }
    else if(percent >= 0.26 && percent <= 0.43)
    {
        result = [self stringTestRandomResultWithBaseString:@"bad" andModule:4];
    }
    else if(percent >= 0.44 && percent <= 0.59)
    {
        result = [self stringTestRandomResultWithBaseString:@"suit" andModule:3];
    }
    else if(percent >= 0.6 && percent <= 0.74)
    {
        result = [self stringTestRandomResultWithBaseString:@"good" andModule:2];
    }
    else if(percent >= 0.75 && percent <= 0.99)
    {
        result = [self stringTestRandomResultWithBaseString:@"excellent" andModule:3];
    }
    else if(percent == 1)
    {
        result = [self stringTestRandomResultWithBaseString:@"ideal" andModule:6];
    }
    
    return result;
}

- (NSString *)stringTestRandomResultWithBaseString:(NSString *) str andModule:(int)module
{
    int i = arc4random()%module;
    NSString *s = [NSString stringWithFormat:@"test_result_%@_%i", str, i+1];
    return NSLocalizedString(s, nil);
}
@end
