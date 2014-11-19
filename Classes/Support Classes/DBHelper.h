//
//  DBHelper.h
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCPack.h"
#import "NCWord.h"
@protocol DBHelperProtocol <NSObject>


@end

@interface DBHelper : NSObject

- (NSArray *) getWordsFromDBWithPackID:(int)packID;
- (void) setWordsToDB:(NSArray *)wordsArray;
- (NSArray *) getFavorites;
- (void) setWordToFavorites:(NCWord *)word;
- (void) deleteWordFromFavorites:(NCWord *)word;
- (BOOL) ifExistsInFavorites:(NCWord *)word;
- (NSArray *) getPacks;
- (void) setPackToDB:(NCPack *)pack;
- (NCWord *)getWordWithID:(int)wordID;
@end
