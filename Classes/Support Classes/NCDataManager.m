//
//  NCDataManager.m
//  NakedChinese
//
//  Created by IMAC  on 28.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCDataManager.h"
#import "Reachability.h"
#import "DBHelper.h"
#import "NCPack.h"
#import "NCWord.h"

@interface NCDataManager()

@property (nonatomic, strong) NSString *internetMode;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) DBHelper *dbHelper;
@end

@implementation NCDataManager

#pragma mark Constants

#define ONLINE_MODE @"reachable"
#define OFFLINE_MODE @"not_reachable"

#pragma mark Initialization

+(NCDataManager*) sharedInstance
{
    static NCDataManager* sDataManager = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sDataManager = [ [ self alloc ] init ];
        
        [[NSNotificationCenter defaultCenter] addObserver:sDataManager selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        sDataManager.internetReachability = [Reachability reachabilityForInternetConnection];
        if(sDataManager.internetReachability.currentReachabilityStatus != NotReachable)
        {
            sDataManager.internetMode = ONLINE_MODE;
        }
        else
        {
            sDataManager.internetMode = OFFLINE_MODE;
        }

        [sDataManager.internetReachability startNotifier];
        
        sDataManager.dbHelper = [[DBHelper alloc] init];
    } );
    return sDataManager;
}

#pragma mark Reachability

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    if(curReach.currentReachabilityStatus != NotReachable)
    {
        [NCDataManager sharedInstance].internetMode = ONLINE_MODE;
    }
    else
    {
        [NCDataManager sharedInstance].internetMode = OFFLINE_MODE;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[NCDataManager sharedInstance]];
}


#pragma mark first Launch Methods

/*- (void)firstLaunch
{
    Requester *requester = [[Requester alloc] init];
    
    
}*/

#pragma mark commonMethods
- (void) getWordsWithPackID:(int)packID andMode:(NSString *) mode
{
    if([mode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:packID] forKey:@"pack_id"];
        [requester requestPath:@"word" withParameters:dict isPOST:NO delegate:@selector(getWordsWithPackIDResponse:)];
    }
    else if ([mode isEqualToString:OFFLINE_MODE])
    {
        //берем из БД
        NSArray *wordsArray = [[NCDataManager sharedInstance].dbHelper getWordsFromDBWithPackID:packID];
        if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackID:)])
        {
            [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetWordsWithPackID:wordsArray];
        }
    }
}

- (void) getWordsWithPackIDResponse:(NSDictionary *)jsonDict
{
    NSArray *jsonArray = (NSArray *)jsonDict;
    NSMutableArray *wordArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in jsonArray)
    {
        [wordArray addObject:[NCWord getNCWordFromJSON:dict]];
    }
    
    [[NCDataManager sharedInstance].dbHelper setWordsToDB:wordArray];
}

- (void) getPacks
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        [requester requestPath:@"pack" withParameters:nil isPOST:NO delegate:@selector(getPacksResponse:)];
    }
    else if ([self.internetMode isEqualToString:OFFLINE_MODE])
    {
        
    }
}

- (void) getPacksResponse:(NSDictionary *) jsonDict
{
    NSArray *array = (NSArray *)jsonDict;
    NSMutableArray *packArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array)
    {
        [packArray addObject:[NCPack getNCPackFromJson:dict]];
    }
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetPacks:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetPacks:packArray];
    }
    
}
/*
- (void)getNumberOfPacksResponse:(NSDictionary *) jsonDict
{
    NSArray *array = (NSArray *)jsonDict;
    
    if([self.delegate respondsToSelector:@selector(ncDataManagerProtocolGetNumberOfPacks:)])
    {
        [self.delegate ncDataManagerProtocolGetNumberOfPacks:3];
    }
}*/
@end
