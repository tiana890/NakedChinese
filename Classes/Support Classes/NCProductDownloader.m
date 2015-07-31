//
//  NCProductDownloader.m
//  NakedChinese
//
//  Created by IMAC  on 21.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "NCProductDownloader.h"
#import "NCDataManager.h"
#import "NCStaticPackIdentifier.h"
#import "Requester.h"

 NSString *const NCProductDownloaderNotificationProgressBarValue = @"NCProductDownloaderNotificationProgressBarValue";
 NSString *const NCProductDownloaderNotificationProductDownloaded = @"NCProductDownloaderNotificationProductDownloaded";


#define SERVER_ADDRESS @"http://www.nakedchineseapp.com/api/get/"

@interface NCProductDownloader()<NCDataManagerProtocol, NCDataManagerProductDownloadProtocol>
@property (nonatomic, strong) NCPack *pack;
@property (nonatomic, strong) NSMutableDictionary *percentDict;
@property (nonatomic, strong) NSNumber *summ;
@end

@implementation NCProductDownloader

+(NCProductDownloader*) sharedInstance
{
    static NCProductDownloader* sProductDownloader = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sProductDownloader = [ [ self alloc ] init ];
        sProductDownloader.observers = [[NSMutableSet alloc] init];
    } );
    return sProductDownloader;
}

- (NSNumber *)summ
{
    if(!_summ) _summ = [[NSNumber alloc] init];
    return _summ;
}

- (NSMutableDictionary *)percentDict
{
    if(!_percentDict)
        _percentDict = [[NSMutableDictionary alloc] init];
    
    return _percentDict;
}
- (void)loadBoughtProduct:(NSString *)identifier
{
    NCPack *pack = [NCStaticPackIdentifier getPackByProductIdentifier:identifier];
    pack.paid = @1;
    [NCDataManager sharedInstance].delegate = self;
    [NCDataManager sharedInstance].productDownloadDelegate = self;
    [[NCDataManager sharedInstance] getWordsWithPackID:pack.ID.intValue];
    [[NCDataManager sharedInstance] setPackIsPaid:pack];
    self.pack = pack;
    [self.percentDict removeAllObjects];
}

#pragma mark NCDataManagerProtocol methods

- (void)ncDataManagerProtocolGetWordsWithPackIDProgressBarDeltaValue:(NSDictionary *) dict
{
    NSNumber *wordID = [dict objectForKey:@"wordID"];
    NSNumber *percentage = [dict objectForKey:@"percent"];
    [self.percentDict setObject:percentage forKey:wordID];
    
    float sum = 0;
    for(NSNumber *num in [self.percentDict allValues])
    {
        sum += num.floatValue;
        
    }
    for(id obj in self.observers.allObjects)
    {
        if([obj respondsToSelector:@selector(ncProductDownloaderProtocolProductProgressPercentValue:)])
        {
            [obj ncProductDownloaderProtocolProductProgressPercentValue:[NSNumber numberWithFloat:(100*sum/12)]];
        }
    }
    for(id obj in self.observers.allObjects)
    {
        if(sum >= 12.0f)
        {
            [self.percentDict removeAllObjects];
             [[NCDataManager sharedInstance] setPackIsDownloaded:self.pack];
            if([obj respondsToSelector:@selector(ncProductDownloaderProtocolProductDownloaded:)])
            {
               
                [obj ncProductDownloaderProtocolProductDownloaded:self.pack];
            }
        }
    }
}

- (void)ncDataManagerProtocolGetWordsWithPackID:(NSArray *)arrayOfWords
{
    [[NCDataManager sharedInstance] setPackIsPaid:self.pack];
}


- (void)ncDataManagerProtocolFailure:(NSString *)message
{
    for(id obj in self.observers.allObjects)
    {
        [self.percentDict removeAllObjects];
        
        if([obj respondsToSelector:@selector(ncProductDownloaderProtocolProductFailure:)])
        {
            [obj ncProductDownloaderProtocolProductFailure:message];
        }
        
    }
}
- (void)addObserver:(id)observer
{
    if(![self.observers containsObject:observer])
    {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id)observer
{
    if([self.observers containsObject:observer])
    {
        [self.observers removeObject:observer];
    }
}

- (void) setProductIsBought:(NSString *)identifier
{
    NCPack *pack = [NCStaticPackIdentifier getPackByProductIdentifier:identifier];
    pack.paid = @1;
    [[NCDataManager sharedInstance] setPackIsPaid:pack];
}
@end
