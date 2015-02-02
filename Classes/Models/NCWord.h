//
//  NCWord.h
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NCMaterial.h"

@interface NCWord : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *packID;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *bigImage;
@property (nonatomic, strong) NSString *imageBlur;
@property (nonatomic, strong) NSString *imageHalfBlur;
@property (nonatomic, strong) NSNumber *paid;
@property (nonatomic, strong) NSNumber *show;
//material
/*
@property (nonatomic, strong) NSString *materialZH;
@property (nonatomic, strong) NSString *materialZH_TR;
@property (nonatomic, strong) NSString *materialEN;
@property (nonatomic, strong) NSString *materialRU;
@property (nonatomic, strong) NSString *materialSound;
#warning передалать в NSDate
@property (nonatomic, strong) NSString *materialLastUpdate;
 */
@property (nonatomic, strong) NCMaterial *material;

+ (NCWord *) getNCWordFromJSON:(NSDictionary *)jsonDict;
+ (NCWord *) getNCWordFromNSManagedObject:(NSManagedObject *)object;

@end
