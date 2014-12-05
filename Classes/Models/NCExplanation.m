//
//  NCExplanation.m
//  NakedChinese
//
//  Created by IMAC  on 04.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCExplanation.h"

@implementation NCExplanation

+ (NCExplanation *) getNCExplanationdFromNSManagedObject:(NSManagedObject *)object
{
    NCExplanation *explanation = [[NCExplanation alloc] init];
    
    explanation.ID =  [object valueForKey:@"id"];
    explanation.wordID = [object valueForKey:@"word_id"];
    
    return explanation;
}
@end
