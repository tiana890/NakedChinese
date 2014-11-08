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
- (void) ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites;

@end

@interface NCDataManager : NSObject<RequesterProtocol>


+(NCDataManager*) sharedInstance;

- (void) getWordsWithPackID:(int)packID;
- (void) getFavorites;
- (void) getPacks;
- (void) setWordToFavorites:(NCWord *)word;
- (void)firstDBInitialization;

@property (nonatomic, weak) id<NCDataManagerProtocol> delegate;

@end
