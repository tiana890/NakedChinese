//
//  NCIAHelper.m
//  NakedChinese
//
//  Created by IMAC  on 19.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "NCIAHelper.h"


@implementation NCIAHelper

+ (NCIAHelper *)sharedInstance {
    static dispatch_once_t once;
    static NCIAHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.nakedchineseapp.nakedchinese.sex2",
                                      @"com.nakedchineseapp.nakedchinese.slang1",
                                      @"com.nakedchineseapp.nakedchinese.swear1",
                                      
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
