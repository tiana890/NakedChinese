//
//  NCMaterial.m
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCMaterial.h"

@implementation NCMaterial


+ (NCMaterial *) getNCMaterialFromNSManagedObject:(NSManagedObject *)object
{
    NCMaterial *material = [[NCMaterial alloc] init];
    
    material.materialID = [object valueForKey:@"id"];
    material.materialZH = [object valueForKey:@"zh"];
    material.materialZH_TR = [object valueForKey:@"zh_tr"];
    material.materialEN = [object valueForKey:@"en"];
    material.materialRU = [object valueForKey:@"ru"];
    material.materialSound = [object valueForKey:@"sound"];
    
    return material;
}
+ (NCMaterial *) getNCMaterialFromJSON:(NSDictionary *)jsonDict
{
    NCMaterial *material = [[NCMaterial alloc] init];
    
    if([jsonDict objectForKey:@"zh"] != [NSNull null])
    {
        material.materialZH = [jsonDict objectForKey:@"zh"];
    }
    
    if([jsonDict objectForKey:@"zh_tr"] != [NSNull null])
    {
        material.materialZH_TR = [jsonDict objectForKey:@"zh_tr"];
    }
    
    if([jsonDict objectForKey:@"en"] != [NSNull null])
    {
        material.materialEN = [jsonDict objectForKey:@"en"];
    }
    
    if([jsonDict objectForKey:@"ru"] != [NSNull null])
    {
        material.materialRU = [jsonDict objectForKey:@"ru"];
    }
    
    if([jsonDict objectForKey:@"sound"] != [NSNull null])
    {
        material.materialSound = [jsonDict objectForKey:@"sound"];
    }
    
    if([jsonDict objectForKey:@"last_update"] != [NSNull null])
    {
        material.materialLastUpdate = [jsonDict objectForKey:@"last_update"];
    }

    return material;
}

- (NSString *)materialWord
{
    if([NSLocalizedString(@"lang", nil) isEqualToString:@"ru"])
    {
        return self.materialRU;
    }
    else
    {
        return self.materialEN;
    }

}

@end
