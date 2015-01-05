//
//  NCJoke.h
//  NakedChinese
//
//  Created by IMAC  on 22.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCJoke : NSObject

@property (nonatomic, strong) NSNumber *jokeID;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *chinese;
@property (nonatomic, strong) NSString *translation;
@end
