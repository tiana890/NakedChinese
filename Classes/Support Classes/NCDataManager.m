//
//  NCDataManager.m
//  NakedChinese
//
//  Created by IMAC  on 28.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCDataManager.h"
#import "Reachability.h"


@interface NCDataManager()

@property (nonatomic, strong) NSString *internetMode;
@property (nonatomic, strong) Reachability *internetReachability;
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
        [sDataManager.internetReachability startNotifier];
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


#pragma mark methods
- (void)getNumberOfPacks:(NSString *)type
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:type forKey:@"type"];
        [requester requestPath:@"pack" withParameters:dict isPOST:NO delegate:@selector(getNumberOfPacksResponse:)];
    }
    else if ([self.internetMode isEqualToString:OFFLINE_MODE])
    {
        
    }
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
