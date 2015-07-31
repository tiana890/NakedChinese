//
//  NCProductDownloader.h
//  NakedChinese
//
//  Created by IMAC  on 21.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCPack.h"

UIKIT_EXTERN NSString *const NCProductDownloaderNotificationProgressBarValue;
UIKIT_EXTERN NSString *const NCProductDownloaderNotificationProductDownloaded;

@protocol NCProductDownloaderProtocol <NSObject>

- (void) ncProductDownloaderProtocolProductDownloaded:(NCPack *)pack;
- (void) ncProductDownloaderProtocolProductProgressPercentValue:(NSNumber *)number;
- (void) ncProductDownloaderProtocolProductFailure:(NSString *)failureDescription;

@end

@interface NCProductDownloader : NSObject

+ (NCProductDownloader *) sharedInstance;
- (void) addObserver:(id) observer;
- (void) removeObserver:(id) observer;

- (void) loadBoughtProduct:(NSString *)identifier;
- (void) setProductIsBought:(NSString *)identifier;

@property (nonatomic, weak) id<NCProductDownloaderProtocol> delegate;
@property (nonatomic, retain) NSMutableSet *observers;

@end
