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

@interface NCProductDownloader()<NCDataManagerProtocol>
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
    [[NCDataManager sharedInstance] getWordsWithPackID:pack.ID.intValue];
    [[NCDataManager sharedInstance] setPackIsPaid:pack];
    self.pack = pack;
}

#pragma mark NCDataManagerProtocol methods
- (void)ncDataManagerProtocolGetLocalPacks:(NSArray *)arrayOfPacks
{
    
}

- (void)ncDataManagerProtocolGetWordsWithPackIDProgressBarDeltaValue:(NSDictionary *) dict
{
    /*
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
     [dict setObject:wordID forKey:@"wordID"];
     NSNumber *bytesPercentage = [NSNumber numberWithFloat:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
     [dict setObject:bytesPercentage forKey:@"percent"];
     [_delegate performSelector:method withObject:dict];
     */
    
    NSNumber *wordID = [dict objectForKey:@"wordID"];
    NSNumber *percentage = [dict objectForKey:@"percent"];
    //NSLog(@"percentage = %f", percentage.floatValue);
    [self.percentDict setObject:percentage forKey:wordID];
    
    float sum = 0;
    for(NSNumber *num in [self.percentDict allValues])
    {
        sum += num.floatValue;
        
    }
    if([self.delegate respondsToSelector:@selector(ncProductDownloaderProtocolProductProgressPercentValue:)])
    {
        [self.delegate ncProductDownloaderProtocolProductProgressPercentValue:[NSNumber numberWithFloat:(100*sum/12)]];
        //[[NSNotificationCenter defaultCenter] postNotificationName:NCProductDownloaderNotificationProgressBarValue object:[NSNumber numberWithFloat:(100*sum/12)] userInfo:nil];
    }
    if(sum >= 12.0f)
    {
        [self.percentDict removeAllObjects];
        if([self.delegate respondsToSelector:@selector(ncProductDownloaderProtocolProductDownloaded:)])
        {
            [self.delegate ncProductDownloaderProtocolProductDownloaded:self.pack];
            //[[NSNotificationCenter defaultCenter] postNotificationName:NCProductDownloaderNotificationProductDownloaded object:nil];
        }
    }
}

- (void)ncDataManagerProtocolGetWordsWithPackID:(NSArray *)arrayOfWords
{
    [[NCDataManager sharedInstance] setPackIsPaid:self.pack];
    /*
    if([self.delegate respondsToSelector:@selector(ncProductDownloaderProtocolProductDownloaded:)])
    {
        [self.delegate ncProductDownloaderProtocolProductDownloaded:self.pack];
    }
     */
}
@end
