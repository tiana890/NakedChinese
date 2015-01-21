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
- (void) ncDataManagerProtocolGetJokes:(NSArray *)arrayOfJokes;
- (void) ncDataManagerProtocolGetWordsWithPackIDPreview:(NSArray *)arrayOfWords;
@end

@protocol NCDataManagerLoadBuyProductProtocol <NSObject>

- (void) ncDataManagerLoadBuyProductProtocolProductLoaded;

@end

@interface NCDataManager : NSObject<RequesterProtocol>


+(NCDataManager*) sharedInstance;

//NCDataManagerProtocol
- (void) firstDBInitialization;
- (void) getWordsWithPackID:(int)packID;
- (void) getFavorites;
- (void) getPacks;
- (void) getPacksWithNewLaunch;
- (void) getJokesWithNewLaunch;
- (void) getLocalPacks;
- (void) getLocalWordsWithPackIDs:(NSArray *)idsArray;
- (void) setWordToFavorites:(NCWord *)word;
- (void) removeWordFromFavorites:(NCWord *)word;
- (BOOL) ifExistsInFavorites:(NCWord *)word;
- (void) searchWordContainsString:(NSString *)string;
//- (void) setMaterials:(NSArray *)materials andExplanations:(NSArray *)explanations;
- (void) getMaterialsWithWordID:(int) wordID;
- (void) getJokes;
- (void) getWordsWithPackIDPreview:(int)packID;

//NCDataManagerLoadBuyProductProtocol
- (void) loadBuyProduct:(NSString *) productIdentifier;

@property (nonatomic, weak) id<NCDataManagerProtocol> delegate;
@property (nonatomic, weak) id<NCDataManagerLoadBuyProductProtocol> delegateLoadProduct;
@end
