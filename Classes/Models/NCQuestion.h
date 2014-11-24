//
//  NCQuestion.h
//  NakedChinese
//
//  Created by IMAC  on 21.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWord.h"
#import <Foundation/Foundation.h>

@interface NCQuestion : NSObject

@property (nonatomic, strong) NCWord *word;
@property (nonatomic, strong) NSMutableArray *answerArray;
@property (nonatomic, strong) NSIndexSet *rightIndex;

@end
