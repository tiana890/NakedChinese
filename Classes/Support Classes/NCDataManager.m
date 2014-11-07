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

- (void)firstDBInitialization
{
    NCPack *pack = [[NCPack alloc] init];
    pack.ID = @1;
    pack.partition = @"sex";
    [self.dbHelper setPackToDB:pack];
    [self.dbHelper setWordsToDB:[self words]];
}

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
        //берем из БД
        NSArray *packsArray = [[NCDataManager sharedInstance].dbHelper getPacks];
        if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetPacks:)])
        {
            [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetPacks:packsArray];
        }
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
    //добавляем бесплатный пакет
    NCPack *pack = [[NCPack alloc] init];
    pack.partition = @"sex";
    pack.ID = @1;
    [packArray addObject:pack];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetPacks:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetPacks:packArray];
    }
    
}


- (NSArray *) words
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *chinese = @[@"假阳具", @"小姐", @"高潮", @"打飞机", @"射", @"同志", @"拉拉", @"鸡巴", @"阳痿", @"屄", @"有一腿", @"开包"];
    NSArray *pinyin = @[@"jǐayángjǜ", @"xiǎojiě", @"gāo cháo", @"dǎfēijī", @"shè", @"tóngzhì", @"lāla", @"jībā", @"yángwěi", @"bī", @"yǒuyītuǐ", @"kāibāo"];
    NSArray *russian = @[@"Фаллоимитатор", @"Проститутка", @"Оргазм", @"Мастурбировать", @"Эякулировать, кончить", @"Гей", @"Лесбиянки", @"Пенис", @"Импотент", @"Вагина", @"Изменять", @"Лишить девственности"];
    
    for(int i = 0; i < 12; i++)
    {
        NCWord *word = [[NCWord alloc] init];
        word.ID = [NSNumber numberWithInt: i+1];
        word.packID = @1;
        word.image = [NSString stringWithFormat:@"%i_img_small", i+1];
        word.material.materialZH = chinese[i];
        word.material.materialZH_TR = pinyin[i];
        word.material.materialRU = russian[i];
        word.material.materialID = word.ID;
        word.paid = @0;
        word.show = @0;
       
        [array addObject:word];
    }
    
    return array;
}
@end
