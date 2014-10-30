//
//  NCPack.m
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCPack.h"

@implementation NCPack

+ (NCPack *) getNCPackFromJson:(NSDictionary *)jsonDict;
{
    NCPack *pack = [[NCPack alloc] init];
    
    if([jsonDict objectForKey:@"id"] != [NSNull null])
    {
        pack.ID = [jsonDict objectForKey:@"id"];
    }
    
    if([jsonDict objectForKey:@"partition"] != [NSNull null])
    {
        pack.partition = [jsonDict objectForKey:@"partition"];
    }
    
    return pack;
}

+ (NCPack *) getNCPackFromNSManagedObject:(NSManagedObject *)object
{
    NCPack *pack = [[NCPack alloc] init];
    
    pack.ID = [object valueForKey:@"id"];
    pack.partition = [object valueForKey:@"partition"];
    
    return pack;
}

@end
