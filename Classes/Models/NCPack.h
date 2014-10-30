//
//  NCPack.h
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NCPack : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *partition;

+ (NCPack *) getNCPackFromJson:(NSDictionary *)jsonDict;
+ (NCPack *) getNCPackFromNSManagedObject:(NSManagedObject *)object;
@end
