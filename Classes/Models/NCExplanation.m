//
//  NCExplanation.m
//  NakedChinese
//
//  Created by IMAC  on 04.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCExplanation.h"
#import "NCMaterial.h"

@implementation NCExplanation

+ (NCExplanation *) getNCExplanationFromJSON:(NSDictionary *)jsonDict;
{
    NCExplanation *explanation = [[NCExplanation alloc] init];
    
    if([jsonDict objectForKey:@"id"] != [NSNull null])
    {
        explanation.ID = [jsonDict objectForKey:@"id"];
    }
    
    if([jsonDict objectForKey:@"word_id"] != [NSNull null])
    {
        explanation.wordID = [jsonDict objectForKey:@"word_id"];
    }
    
    if([jsonDict objectForKey:@"material"] != [NSNull null])
    {
        NSDictionary *materialDict = [jsonDict objectForKey:@"material"];
        explanation.material = [NCMaterial getNCMaterialFromJSON:materialDict];
        explanation.material.materialID = explanation.ID;
    }
    return explanation;
}

+ (NCExplanation *) getNCExplanationdFromNSManagedObject:(NSManagedObject *)object
{
    NCExplanation *explanation = [[NCExplanation alloc] init];
    
    explanation.ID =  [object valueForKey:@"id"];
    explanation.wordID = [object valueForKey:@"word_id"];
    
    return explanation;
}
@end
