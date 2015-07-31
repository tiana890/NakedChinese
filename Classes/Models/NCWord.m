//
//  NCWord.m
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWord.h"
#import "NCMaterial.h"

@implementation NCWord

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.material = [[NCMaterial alloc] init];
    }
    return self;
}

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
    if([jsonDict objectForKey:@"imageBig"] != [NSNull null])
    {
        word.bigImage = [jsonDict objectForKey:@"image"];
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
        word.material = [NCMaterial getNCMaterialFromJSON:materialDict];
        word.material.materialID = word.ID;
    }
    return word;
}

+ (NCWord *) getNCWordFromNSManagedObject:(NSManagedObject *)object;
{
    NCWord *word = [[NCWord alloc] init];
    
    word.ID = [object valueForKey:@"id"];
    word.packID = [object valueForKey:@"pack_id"];
    word.image = [object valueForKey:@"image"];
    word.paid = [object valueForKey:@"paid"];
    word.show = [object valueForKey:@"show"];
    word.bigImage = [object valueForKey:@"imageBig"];
    word.imageBlur = [object valueForKey:@"image"];
    word.imageHalfBlur = [object valueForKey:@"image"];
    //NSLog(@"DEBUG word id %i", [word.ID intValue]);
    //NSLog(@"DEBUG word pack id %i", [word.packID intValue]);
    //NSLog(@"DEBUG word image %@", word.image);
    //NSLog(@"DEBUG word material %@", word.material.materialZH);
    
    return word;
}

- (NSString *)bigImage
{
    if(_packID.intValue != 1)
    {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        return [NSString stringWithFormat:@"%@/%@", docDir, _bigImage];
    }
    else
    {
        return _bigImage;
    }
}

- (NSString *)imageHalfBlur
{
    /*_imageHalfBlur = [self.bigImage stringByReplacingOccurrencesOfString:@".png" withString:@"_halfblur.png"];
    if(_packID.intValue != 1)
    {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        return [NSString stringWithFormat:@"%@/%@", docDir, _imageHalfBlur];
    }
    else
    {*/
    if(self.packID.intValue != 1)
    {
        _imageHalfBlur = [self.bigImage stringByReplacingOccurrencesOfString:@".png" withString:@"_halfblur.png"];
            return _imageHalfBlur;
    }
    return _imageHalfBlur;
    //}
}

- (NSString *)imageBlur
{
    if(self.packID.intValue != 1)
    {
    _imageBlur = [self.image stringByReplacingOccurrencesOfString:@".png" withString:@"_blur.png"];
        return _imageBlur;
    }
    return _imageBlur;
}

@end
