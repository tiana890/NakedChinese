//
//  BackgroundSessionManager.h
//  NakedChinese
//
//  Created by IMAC  on 24.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BackgroundSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@property (nonatomic, copy) void (^savedCompletionHandler)(void);

@end
