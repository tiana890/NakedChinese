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
#import "NCPack.h"

@protocol NCDataManagerProtocol <NSObject>
@optional
- (void) ncDataManagerProtocolGetWordsWithPackID:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetLocalPacks:(NSArray *)arrayOfPacks;
- (void) ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites;
- (void) ncDataManagerProtocolGetLocalWordsWithPackIDs:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetLocalWordsWithPackID:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetSearchWordContainsString:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetMaterialsWithWordID:(NSArray *)arrayOfMaterials;
- (void) ncDataManagerProtocolGetJokes:(NSArray *)arrayOfJokes;
- (void) ncDataManagerProtocolGetWordsWithPackIDPreview:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolFailure:(NSString *)message;
@end

@protocol NCDataManagerProductDownloadProtocol <NSObject>

- (void) ncDataManagerProtocolGetWordsWithPackIDProgressBarDeltaValue:(NSDictionary *) dict;
@end


@interface NCDataManager : NSObject<RequesterProtocol>


+(NCDataManager*) sharedInstance;

//NCDataManagerProtocol
//First initialization and Pack launch
- (void) firstDBInitialization;
- (void) getPacksWithNewLaunch;
- (void) getLocalPacks;
- (void) getJokesWithNewLaunch;

//Word launch
- (void) getWordsWithPackID:(int)packID;
- (void) getLocalWordsWithPackID:(NSNumber *)packID;
- (void) getLocalWordsWithPackIDs:(NSArray *)idsArray;
- (void) getWordsWithPackIDPreview:(int)packID;

//Favorites
- (void) getFavorites;
- (void) setWordToFavorites:(NCWord *)word;
- (void) removeWordFromFavorites:(NCWord *)word;
- (BOOL) ifExistsInFavorites:(NCWord *)word;

//Search
- (void) searchWordContainsString:(NSString *)string;
- (void) getMaterialsWithWordID:(int) wordID;

//set methods
- (void) setPackIsPaid:(NCPack *)pack;
- (void) setPackIsDownloaded:(NCPack *)pack;
- (BOOL) ifPaidPack:(NCPack *) pack;
- (BOOL) ifPackDownloaded:(NCPack *) pack;

//Internet is Reachable
- (BOOL) ifInternetIsReachable;

@property (nonatomic, weak) id<NCDataManagerProtocol> delegate;
@property (nonatomic, weak) id<NCDataManagerProductDownloadProtocol> productDownloadDelegate;

@end
