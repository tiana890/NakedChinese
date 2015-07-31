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
#import "NCMaterial.h"
#import "NCExplanation.h"
#import "NCJoke.h"
#import "NCStaticData.h"
#import "NCExplanation.h"

#define SERVER_ADDRESS @"http://nakedchineseapp.com/upload/picture/"

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

- (BOOL) ifInternetIsReachable
{
    if([[NCDataManager sharedInstance].internetMode isEqualToString:ONLINE_MODE])
        return YES;
    else
        return NO;
}

#pragma mark first Launch Methods

- (void)firstDBInitialization
{
    NCPack *pack = [[NCPack alloc] init];
    pack.ID = @1;
    pack.partition = @"sex";
    pack.paid = @1;
    pack.downloaded = @1;
    [self.dbHelper setPackToDB:pack];
    [self.dbHelper setPackDownloaded:pack];
    [self.dbHelper setPackPaid:pack];
    [self.dbHelper setWordsToDB:[NCStaticData wordsArray] withImages:NO];
    [self.dbHelper setMaterialsToDB:[NCStaticData materialsArray] andExplanations:[NCStaticData explanationsArray]];
}

- (void)getPacksWithNewLaunch
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        [requester requestPath:@"pack" withParameters:nil isPOST:NO delegate:@selector(getPacksWithNewLaunchResponse:)];
    }
}

- (void) getPacksWithNewLaunchResponse:(NSDictionary *) jsonDict
{
    NSArray *array = (NSArray *)jsonDict;
    
    NSMutableArray *packArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dict in array)
    {
        NCPack *pack = [NCPack getNCPackFromJson:dict];
        if(![pack.ID isEqualToNumber:@16])
        {
            [packArray addObject:pack];
            [self.dbHelper setPackToDB:[NCPack getNCPackFromJson:dict]];
        }
        
    }
    for(NCPack *pack in packArray)
    {
        if([pack.ID isEqualToNumber:@16])
        {
            [packArray removeObject:pack];
        }
    }
}

- (void)getJokesWithNewLaunch
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:16] forKey:@"pack_id"];
        [requester requestPath:@"word" withParameters:dict isPOST:NO delegate:@selector(getJokesWithPackIDResponse:)];
    }
}

- (void) getJokesWithPackIDResponse:(NSDictionary *)jsonDict
{
    NSArray *jsonArray = (NSArray *)jsonDict;
    NSMutableArray *wordArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in jsonArray)
    {
        [wordArray addObject:[NCWord getNCWordFromJSON:dict]];
    }
    
    if(wordArray.count > 0)
        [[NCDataManager sharedInstance].dbHelper setWordsToDB:wordArray];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackID:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetWordsWithPackID:wordArray];
    }
}


#pragma mark Pack Launch
- (void) getLocalPacks
{
    NSArray *packsArray = [self.dbHelper getPacks];
    
    NSMutableArray *packArray = [[NSMutableArray alloc] init];
    for(NCPack *p in packsArray)
    {
        if(![p.ID isEqualToNumber:@16])
            [packArray addObject:p];
    }
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetLocalPacks:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetLocalPacks:packArray];
    }
}


#pragma mark Word Launch

- (void) getWordsWithPackID:(int)packID
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:packID] forKey:@"pack_id"];
        [requester backgroundRequest:@"word" withParameters:dict delegate:@selector(getWordsWithPackIDResponse:)];
    }
    else
    {
        if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolFailure:)])
        {
            [[NCDataManager sharedInstance].delegate ncDataManagerProtocolFailure:NSLocalizedString(@"internet_no_connection", nil)];
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
    
    NCWord *w = [[NCWord alloc] init];
    if (wordArray.count > 0)
    {
        [[NCDataManager sharedInstance].dbHelper setWordsToDB:wordArray withImages:YES];
        for(int i = 0; i < wordArray.count; i++)
        {
            w = wordArray[i];
            [self performSelectorInBackground:@selector(getExplanationsWithWordID:) withObject:w.ID];
            
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, w.image];
            
            
            NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
            //If there isn't an App Support Directory yet ...
            if (![[NSFileManager defaultManager] fileExistsAtPath:appSupportDir isDirectory:NULL]) {
                NSError *error = nil;
                //Create one
                if (![[NSFileManager defaultManager] createDirectoryAtPath:appSupportDir withIntermediateDirectories:YES attributes:nil error:&error]) {
                    NSLog(@"%@", error.localizedDescription);
                }
                else {
                    // *** OPTIONAL *** Mark the directory as excluded from iCloud backups
                    NSURL *url = [NSURL fileURLWithPath:appSupportDir];
                    if (![url setResourceValue:@YES
                                        forKey:NSURLIsExcludedFromBackupKey
                                         error:&error])
                    {
                        NSLog(@"Error excluding %@ from backup %@", url.lastPathComponent, error.localizedDescription);
                    }
                    else {
                        NSLog(@"Yay");
                    }
                }
            }
            
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",appSupportDir, w.image];
            
            Requester *req = [[Requester alloc] init];
            req.delegate = self;
            [req downloadTaskFromURL:imageURLString toFile:pngFilePath progressBarDelegate:@selector(getWordsWithPackIDProgressBarResponse:) andWordID:w.ID];
        }
        [self performSelectorInBackground:@selector(downloadPreviewImages:) withObject:wordArray];
    
    }
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackID:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetWordsWithPackID:nil];
    }
}


- (void) downloadPreviewImages:(NSArray *)wordsArray
{
    for(int i = 0; i < wordsArray.count; i++)
    {
        NCWord *w = wordsArray[i];
        Requester *req = [[Requester alloc] init];
        req.delegate = self;
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSString *imageURLStringHalfBlur = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, [w.image stringByReplacingOccurrencesOfString:@".png" withString:@"_halfblur.png"]];
         NSString *newPngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, [w.image stringByReplacingOccurrencesOfString:@".png" withString:@"_halfblur.png"]];
        [req downloadTaskFromURL:imageURLStringHalfBlur toFile:newPngFilePath progressBarDelegate:nil andWordID:w.ID];
        
    }
}

- (void) getWordsWithPackIDProgressBarResponse:(NSDictionary *) dict
{
    if([[NCDataManager sharedInstance].productDownloadDelegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackIDProgressBarDeltaValue:)])
    {
        [[NCDataManager sharedInstance].productDownloadDelegate ncDataManagerProtocolGetWordsWithPackIDProgressBarDeltaValue:dict];
    }
}

//Explanations
- (void) getExplanationsWithWordID:(NSNumber *) wordID
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:wordID forKey:@"word_id"];
        [requester backgroundRequest:@"explanation" withParameters:dict delegate:@selector(getExplanationsWithWordIDResponse:)];
    }
}

- (void) getExplanationsWithWordIDResponse:(NSArray *)explanationsArray
{
    NSMutableArray *materialsArray = [[NSMutableArray alloc] init];
    NSMutableArray *expArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in explanationsArray)
    {
        NCExplanation *exp = [NCExplanation getNCExplanationFromJSON:dict];
        [expArray addObject:exp];
        [materialsArray addObject:exp.material];
    }
    [self.dbHelper setMaterialsToDB:materialsArray andExplanations:expArray];
    
}


- (void) getLocalWordsWithPackIDs:(NSArray *)idsArray
{
    NSMutableArray *arrayOfWords = [[NSMutableArray alloc] init];
    for(int i = 0; i < idsArray.count; i++)
    {
        NSArray *array = [self.dbHelper getWordsFromDBWithPackID:[(NSNumber *)idsArray[i] intValue]];
        [arrayOfWords addObjectsFromArray:array];
    }
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetLocalWordsWithPackIDs:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetLocalWordsWithPackIDs:arrayOfWords];
    }
}

- (void) getLocalWordsWithPackID:(NSNumber *)packID
{
    NSArray *arrayOfWords = [self.dbHelper getWordsFromDBWithPackID:packID.intValue];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetLocalWordsWithPackID:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetLocalWordsWithPackID:arrayOfWords];
    }
}

- (void)getWordsWithPackIDPreview:(int)packID
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:packID] forKey:@"pack_id"];
        [requester requestPath:@"word" withParameters:dict isPOST:NO delegate:@selector(getWordsWithPackIDPreviewResponse:)];
    }
    else
    {
        [self getWordsWithPackIDPreviewResponse:nil];
    }
}

-(void) getWordsWithPackIDPreviewResponse:(NSDictionary *)jsonDict
{
    NSArray *jsonArray = (NSArray *)jsonDict;
    NSMutableArray *wordArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in jsonArray)
    {
        [wordArray addObject:[NCWord getNCWordFromJSON:dict]];
    }
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackIDPreview:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetWordsWithPackIDPreview:wordArray];
    }
}


- (void)getMaterialsWithWordID:(int)wordID
{
    NSArray *materials = [self.dbHelper getMaterialsWithWordID:wordID];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetMaterialsWithWordID:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetMaterialsWithWordID:materials];
    }
}


#pragma mark Favorites

- (void)setWordToFavorites:(NCWord *)word
{
    [self.dbHelper setWordToFavorites:word];
}

- (void)removeWordFromFavorites:(NCWord *)word
{
    [self.dbHelper deleteWordFromFavorites:word];
}

- (void)getFavorites
{
    NSArray *favourites = [self.dbHelper getFavorites];
    NSMutableArray *favWords = [[NSMutableArray alloc] init];
    for(NSNumber *number in favourites)
    {
        NCWord *word = [self.dbHelper getWordWithID:[number intValue]];
        if(word)
        {
            [favWords addObject:word];
        }
    }
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetFavorites:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetFavorites:favWords];
    }
}

- (BOOL) ifExistsInFavorites:(NCWord *)word
{
    return [self.dbHelper ifExistsInFavorites:word];
}

#pragma mark Search 

- (void)searchWordContainsString:(NSString *)string
{
    NSArray *arrayOfWords = [self.dbHelper searchWordContainsString:string];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetSearchWordContainsString:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetSearchWordContainsString:arrayOfWords];
    }
}

#pragma mark set methods
- (void) setPackIsPaid:(NCPack *)pack
{
    [self.dbHelper setPackPaid:pack];
}

- (BOOL) ifPaidPack:(NCPack *) pack
{
    return [self.dbHelper ifPaidPack:pack];
}

- (void) setPackIsDownloaded:(NCPack *)pack
{
    [self.dbHelper setPackDownloaded:pack];
}

- (BOOL) ifPackDownloaded:(NCPack *) pack
{
    return [self.dbHelper ifPackDownloaded:pack];
}

#pragma mark Requester protocol methods
- (void)requesterProtocolRequestFailure:(NSString *)failureDescription
{
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolFailure:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolFailure:failureDescription];
    }
}

@end
