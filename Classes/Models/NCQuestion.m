//
//  NCQuestion.m
//  NakedChinese
//
//  Created by IMAC  on 21.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCQuestion.h"

@implementation NCQuestion

/*- (instancetype)init
{
    self = [super init];
    if(!self)
    {
        self.answerArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.rightIndex = [[NSIndexSet alloc] init];
        self.word = [[NSString alloc] init];
    }
    
    return self;
}*/
- (instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        self.word = [[NCWord alloc] init];
    }
    return self;
}

@end
