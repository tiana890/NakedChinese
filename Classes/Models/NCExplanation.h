//
//  NCExplanation.h
//  NakedChinese
//
//  Created by IMAC  on 04.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NCExplanation : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *wordID;

+ (NCExplanation *) getNCExplanationdFromNSManagedObject:(NSManagedObject *)object;
@end
