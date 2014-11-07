//
//  DBHelper.h
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCPack.h"
@protocol DBHelperProtocol <NSObject>


@end

@interface DBHelper : NSObject

- (NSArray *) getWordsFromDBWithPackID:(int)packID;
- (void) setWordsToDB:(NSArray *)wordsArray;
- (NSArray *) getPacks;
- (void) setPackToDB:(NCPack *)pack;
@end
