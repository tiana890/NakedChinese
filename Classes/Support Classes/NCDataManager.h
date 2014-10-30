//
//  NCDataManager.h
//  NakedChinese
//
//  Created by IMAC  on 28.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requester.h"



@protocol NCDataManagerProtocol <NSObject>

- (void) ncDataManagerProtocolGetWordsWithPackID:(NSArray *)arrayOfWords;
- (void) ncDataManagerProtocolGetPacks:(NSArray *)arrayOfPacks;

@end

@interface NCDataManager : NSObject<RequesterProtocol>


+(NCDataManager*) sharedInstance;

- (void) getWordsWithPackID:(int)packID;
- (void) getWordsWithPackID:(int)packID andMode:(NSString *) mode;

- (void) getPacks;

@property (nonatomic, weak) id<NCDataManagerProtocol> delegate;

@end
