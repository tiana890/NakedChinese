//
//  NCWord.m
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWord.h"


@implementation NCWord

+ (NCWord *) getNCWordFromJSON:(NSDictionary *)jsonDict
{
    NCWord *word = [[NCWord alloc] init];
    
    if([jsonDict objectForKey:@"id"] != [NSNull null])
    {
        word.ID = [jsonDict objectForKey:@"id"];
    }
    
    if([jsonDict objectForKey:@"pack_id"] != [NSNull null])
    {
        word.packID = [jsonDict objectForKey:@"pack_id"];
    }
    
    if([jsonDict objectForKey:@"image"] != [NSNull null])
    {
        word.image = [jsonDict objectForKey:@"image"];
    }
    
    if([jsonDict objectForKey:@"paid"] != [NSNull null])
    {
        word.paid = [jsonDict objectForKey:@"paid"];
    }
    
    if([jsonDict objectForKey:@"show"] != [NSNull null])
    {
        word.show = [jsonDict objectForKey:@"show"];
    }
    
    if([jsonDict objectForKey:@"material"] != [NSNull null])
    {
        NSDictionary *materialDict = [jsonDict objectForKey:@"material"];
        
        if([materialDict objectForKey:@"zh"] != [NSNull null])
        {
            word.materialZH = [materialDict objectForKey:@"zh"];
        }
        
        if([materialDict objectForKey:@"zh_tr"] != [NSNull null])
        {
            word.materialZH_TR = [materialDict objectForKey:@"zh_tr"];
        }
        
        if([materialDict objectForKey:@"en"] != [NSNull null])
        {
            word.materialEN = [materialDict objectForKey:@"en"];
        }
        
        if([materialDict objectForKey:@"ru"] != [NSNull null])
        {
            word.materialRU = [materialDict objectForKey:@"ru"];
        }
        
        if([materialDict objectForKey:@"sound"] != [NSNull null])
        {
            word.materialSound = [materialDict objectForKey:@"sound"];
        }
        
        if([materialDict objectForKey:@"last_update"] != [NSNull null])
        {
            word.materialLastUpdate = [materialDict objectForKey:@"last_update"];
        }
    }
    return word;
}

+ (NCWord *) getNCWordFromNSManagedObject:(NSManagedObject *)object;
{
    NCWord *word = [[NCWord alloc] init];
    
    word.ID = [object valueForKey:@"id"];
    
    
    return word;
}


@end
