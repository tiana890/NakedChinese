//
//  NCMaterial.h
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NCMaterial : NSObject

@property (nonatomic, strong) NSNumber *materialID;
@property (nonatomic, strong) NSString *materialZH;
@property (nonatomic, strong) NSString *materialZH_TR;
@property (nonatomic, strong) NSString *materialEN;
@property (nonatomic, strong) NSString *materialRU;
@property (nonatomic, strong) NSString *materialWord;
@property (nonatomic, strong) NSString *materialSound;
@property (nonatomic, strong) NSString *materialLastUpdate;

+ (NCMaterial *) getNCMaterialFromNSManagedObject:(NSManagedObject *)object;
+ (NCMaterial *) getNCMaterialFromJSON:(NSDictionary *)jsonDict;
@end
