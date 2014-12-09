//
//  NCDataManager.h
//  NakedChinese
//
//  Created by IMAC  on 28.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requester.h"
#import "NCWord.h"


@protocol NCDataManagerProtocol <NSObject>
@optional
- (void) ncDataManagerProtocolGetWordsWithPackID:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetPacks:(NSArray *)arrayOfPacks;
- (void) ncDataManagerProtocolGetLocalPacks:(NSArray *)arrayOfPacks;
- (void) ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites;
- (void) ncDataManagerProtocolGetLocalWordsWithPackIDs:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetSearchWordContainsString:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetMaterialsWithWordID:(NSArray *)arrayOfMaterials;
@end

@interface NCDataManager : NSObject<RequesterProtocol>


+(NCDataManager*) sharedInstance;

- (void) firstDBInitialization;
- (void) getWordsWithPackID:(int)packID;
- (void) getFavorites;
- (void) getPacks;
- (void) getPacksWithNewLaunch;
- (void) getLocalPacks;
- (void) getLocalWordsWithPackIDs:(NSArray *)idsArray;
- (void) setWordToFavorites:(NCWord *)word;
- (void) removeWordFromFavorites:(NCWord *)word;
- (BOOL) ifExistsInFavorites:(NCWord *)word;
- (void) searchWordContainsString:(NSString *)string;
//- (void) setMaterials:(NSArray *)materials andExplanations:(NSArray *)explanations;
- (void) getMaterialsWithWordID:(int) wordID;
@property (nonatomic, weak) id<NCDataManagerProtocol> delegate;

@end
