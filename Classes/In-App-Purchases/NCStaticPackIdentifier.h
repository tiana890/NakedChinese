//
//  NCStaticPackIdentifier.h
//  NakedChinese
//
//  Created by IMAC  on 23.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCPack.h"

@interface NCStaticPackIdentifier : NSObject

+ (NSString *) getProductIdentifierByPackID:(int) packID;
+ (NCPack *) getPackByProductIdentifier:(NSString *) identifier;
@end
