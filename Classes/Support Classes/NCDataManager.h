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

- (void) ncDataManagerProtocolGetNumberOfPacks:(int)numberOfPacks;

@end

@interface NCDataManager : NSObject<RequesterProtocol>

-(void) getNumberOfPacks:(NSString *)type;

+(NCDataManager*) sharedInstance;

@property (nonatomic, weak) id<NCDataManagerProtocol> delegate;

@end
