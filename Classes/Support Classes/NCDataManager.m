//
//  NCDataManager.m
//  NakedChinese
//
//  Created by IMAC  on 28.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCDataManager.h"
#import "Requester.h"

@implementation NCDataManager

+(NCDataManager*) sharedInstance
{
    static NCDataManager* sDataManager = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sDataManager = [ [ self alloc ] init ];
        sDataManager.packsCount = [[NSMutableDictionary alloc] init];
        
    } );
    return sDataManager;
}


#pragma mark methods
- (void)getNumberOfPacks:(NSString *)type
{
    Requester *requester = [[Requester alloc] init];
    requester.delegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:type forKey:@"type"];
    [requester requestPath:@"pack" withParameters:dict isPOST:NO delegate:@selector(getNumberOfPacksResponse:)];
}

- (void)getNumberOfPacksResponse:(NSDictionary *) jsonDict
{
    NSArray *array = (NSArray *)jsonDict;
    
    if([self.delegate respondsToSelector:@selector(ncDataManagerProtocolGetNumberOfPacks:)])
    {
        [self.delegate ncDataManagerProtocolGetNumberOfPacks:3];
    }
}
@end
