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
#import "NCMaterial.h"
#import "NCExplanation.h"
#import "NCJoke.h"

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
    pack.paid = @1;
    [self.dbHelper setPackToDB:pack];
    [self.dbHelper setWordsToDB:[self words]];
    [self.dbHelper setMaterialsToDB:[self materials] andExplanations:[self explanations]];
}

- (void)getPacksWithNewLaunch
{
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        Requester *requester = [[Requester alloc] init];
        requester.delegate = self;
        [requester requestPath:@"pack" withParameters:nil isPOST:NO delegate:@selector(getPacksResponse:)];
    }
}

#pragma mark commonMethods

- (void) getWordsWithPackID:(int)packID
{
    //проверяем, есть ли этот пакет в БД
    NSArray *wordsArray = [[NCDataManager sharedInstance].dbHelper getWordsFromDBWithPackID:packID];
    
    if([self.internetMode isEqualToString:ONLINE_MODE])
    {
        //если такого пакета нет в БД то ищем на сервере
        if(wordsArray.count == 0)
        {
            Requester *requester = [[Requester alloc] init];
            requester.delegate = self;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithInt:packID] forKey:@"pack_id"];
            [requester requestPath:@"word" withParameters:dict isPOST:NO delegate:@selector(getWordsWithPackIDResponse:)];
        }
        else
        {
            if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackID:)])
            {
                [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetWordsWithPackID:wordsArray];
            }
        }
    }
    else if ([self.internetMode isEqualToString:OFFLINE_MODE])
    {
        
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
    /*
    //проверяем, есть ли этот пакет в БД
    NSArray *wordsArray = [[NSArray alloc] init];
    
    if(wordArray.count > 0)
    {
        NCWord *word = wordArray[0];
        wordsArray = [[NCDataManager sharedInstance].dbHelper getWordsFromDBWithPackID:[word.packID intValue]];
    }
    if(wordsArray.count > 0)
    {
        [[NCDataManager sharedInstance].dbHelper setWordsToDB:wordArray];
    }
     */
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetWordsWithPackID:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetWordsWithPackID:wordArray];
    }
}

- (void) getPacks
{
    //берем из БД
    NSArray *packsArray = [[NCDataManager sharedInstance].dbHelper getPacks];
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetPacks:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetPacks:packsArray];
    }
    
}

- (void) getLocalPacks
{
    NSArray *packsArray = [self.dbHelper getPacks];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetLocalPacks:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetLocalPacks:packsArray];
    }
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

- (void) getPacksResponse:(NSDictionary *) jsonDict
{
    NSArray *array = (NSArray *)jsonDict;
    NSMutableArray *packArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array)
    {
        [packArray addObject:[NCPack getNCPackFromJson:dict]];
        [self.dbHelper setPackToDB:[NCPack getNCPackFromJson:dict]];
    }
    /*
    //берем из БД неповторяющиеся пакеты
    NSArray *packsArray = [[NCDataManager sharedInstance].dbHelper getPacks];
    for(NCPack *pack in packsArray)
    {
        BOOL packIsInPackArray = NO;
        for(NCPack *p in packArray)
        {
            if([p.ID isEqualToNumber:pack.ID])
            {
                packIsInPackArray = YES;
                break;
            }
        }
        if(!packIsInPackArray)
            [packArray insertObject:pack atIndex:0];
    }
    */
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetPacks:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetPacks:packArray];
    }
    
}

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

- (void)getMaterialsWithWordID:(int)wordID
{
    NSArray *materials = [self.dbHelper getMaterialsWithWordID:wordID];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetMaterialsWithWordID:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetMaterialsWithWordID:materials];
    }
}

- (void)searchWordContainsString:(NSString *)string
{
    NSArray *arrayOfWords = [self.dbHelper searchWordContainsString:string];
    
    if([[NCDataManager sharedInstance].delegate respondsToSelector:@selector(ncDataManagerProtocolGetSearchWordContainsString:)])
    {
        [[NCDataManager sharedInstance].delegate ncDataManagerProtocolGetSearchWordContainsString:arrayOfWords];
    }
}

- (NSArray *) words
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *chinese = @[@"假阳具", @"小姐", @"高潮", @"打飞机", @"射", @"同志", @"拉拉", @"鸡巴", @"阳痿", @"屄", @"有一腿", @"色狼"];
    NSArray *pinyin = @[@"jǐayángjǜ", @"xiǎojiě", @"gāo cháo", @"dǎfēijī", @"shè", @"tóngzhì", @"lāla", @"jībā", @"yángwěi", @"bī", @"yǒuyītuǐ", @"sèláng"];
    NSArray *russian = @[@"Фаллоимитатор", @"Проститутка", @"Оргазм", @"Мастурбировать", @"Эякулировать, кончить", @"Гей", @"Лесбиянки", @"Пенис", @"Импотент", @"Вагина", @"Изменять", @"Извращенец"];
    NSArray *english = @[@"Dildo", @"Prostitute", @"Orgasm", @"Handjob", @"Cum, to ejaculate", @"Gay, Homosexual", @"Lesbian", @"Dick, cock", @"Impotent", @"Vagina", @"To have an affair, to cheat on", @"Pervert"];
    
    for(int i = 0; i < 12; i++)
    {
        NCWord *word = [[NCWord alloc] init];
        word.ID = [NSNumber numberWithInt: i+1];
        word.packID = @1;
        word.image = [NSString stringWithFormat:@"%i_img_preview", i+1];
        word.bigImage = [NSString stringWithFormat:@"%i_img_big", i+1];
        word.material.materialZH = chinese[i];
        word.material.materialZH_TR = pinyin[i];
        word.material.materialRU = russian[i];
        word.material.materialID = word.ID;
        word.material.materialEN = english[i];
        word.paid = @0;
        word.show = @0;
        [array addObject:word];
    }
    
    return array;
}

- (NSArray *) materials
{
    NSDictionary *chDict =
                           @{@1:@[@"她过生日的时候, 她好朋友邮给她一个假阳具.",
                                       @"她认为每个女生都应该有假鸡巴.",
                                       @"有的女生喜欢收集假阳具.",
                                       @"保健品店里有很多电动鸡巴，你可以随便挑.",
                                       @"有的女生认为，假鸡巴不如真的舒服."],
                                  
                           @2:@[@"很多洗浴中心的按摩师都是小姐.",
                                @"你可以给这个小姐打电话， 她可以给你最好的服务.",
                                @"最近在全国各地的大街上，不时就能看到”包小姐”的小广告.",
                                @"我去找小姐干嘛？ 我很爱我的老婆.",
                                @"有的大学生因为没有钱就做了小姐."],
                                  
                           @3:@[@"不是所有的女生都会高潮.",
                                @"你是第一个送我到高潮的男朋友.",
                                @"她的男朋友昨夜射了三次， 不过她一次也没有高潮.",
                                @"科学家说高潮对健康很好.",
                                @"最好的状态就是男女朋友同时高潮了."],
                             
                           @4:@[@"他妈妈进屋的时候，他正在打飞机.",
                                @"在按摩店有些按摩女可以给你打飞机.",
                                @"打飞机特别容易上瘾，还阻碍交女朋友.",
                                @"很多高中生经常在早上打飞机.",
                                @"他打飞机时候被他女朋友碰见了，她很生气."],
                             
                           @5:@[@"他女朋友还没高潮，他就射了.",
                                @"他喜欢射在他女朋友身体里.",
                                @"他第一次跟他女朋友做爱的时候，他射了好多精液.",
                                @"这个男生一宿可以射四次.",
                                @"他喜欢在他射了的时候让他女朋友抓他的后背."],
                             
                           @6:@[@"你看那边那两个男的，举止那么亲密， 一看就是同性恋",
                                @"我妹妹给我说他们班有很多同性恋，所以她还单身.",
                                @"美国某地方同性恋是可以合法结婚的.",
                                @"我和我最好的朋友天天腻在一起，人家都以为我们俩是同志呢.",
                                @"很多女生想把同志变成闺蜜."],
                             
                           @7:@[@"看着俩女孩穿成这样， 肯定是拉拉",
                                @"你没机会跟她过夜，她是个拉拉，只喜欢女生",
                                @"最近在地铁里两个拉拉亲亲是很正常的事情",
                                @"虽然现在的社会还不能接受同性恋，但最近同志和拉拉似乎越来越多",
                                @"第一次见这两个女孩，我曾以为她们是拉拉，不过现在我知道了，她们只是很好的朋友"],
                             
                           @8:@[@"他有一个大鸡巴， 其他朋友都很羡慕他",
                                @"女孩不是都喜欢有大鸡巴的男孩， 因为怕太痛",
                                @"有大鸡巴的男孩很难买到合适的套子",
                                @"很多人认为非洲人的鸡巴比亚洲人和欧洲人大",
                                @"有小鸡巴的男生会感觉很自卑， 但是大多数女生不在乎这点"],
                             
                           @9:@[@"阳痿是指男性在性生活时，阴茎不能勃起或勃起不坚或坚而不久，不能完成正常性生活，阴茎根本无法插入阴道进行性交",
                                @"昨天我看到了我喜欢的姑娘的裸体，但我完全硬不起来。我怕我阳痿了.",
                                @"我妈妈一直问我什么时候怀孕了。我不敢告诉她我老公性无能.",
                                @"都等你半小时了，还硬不起来，你阳痿啊 !",
                                @"我的男友坚持不了几分钟就不行了， 对我来说他就阳痿."],
                             
                           @10:@[@"这个女生有很脏的屄.",
                                 @"有时候她一天去洗手间洗屄好多次.",
                                 @"她的男朋友觉得她的屄好香.",
                                 @"这个男生很喜欢舔女生的屄.",
                                 @"这个女生的逼上有很多毛."],
                             
                           @11:@[@"咱们领导和他的女秘书有一腿.",
                                 @"我猜我的父亲和他的初恋女友现在还有一腿.",
                                 @"看，杂志报道了这个歌手和她的经纪人有一腿.",
                                 @"现在和自己的老师有一腿是很正常的事情.",
                                 @"你看那家店，那两个店员绝对有一腿."],
                             
                           @12:@[@"昨天晚上警察抓到两个色鬼.",
                                 @"晚上不要在公园一个人散步，很容易遇到色鬼.",
                                 @"我们的老师是个色鬼， 上课的时候一直看着女生，不理男生.",
                                 @"正常男生太无聊，我想一个色鬼做我的男朋友。这样我的性生活肯定变有意思的了.",
                                 @"网络上有很多色狼， 他们经常要求射频."]
                           };
    
    NSDictionary *ruDict = @{@1:@[@"Дословно \"искусственный инструмент для влагалища\".\nСинонимы:\n电动鸡巴 diàndòngjībā\n假鸡巴 jiǎjībā",
                                  @"На день рождения её хорошая подруга послала фаллоимитатор.",
                                  @"Она считает, что каждая девушка должна иметь фаллоимитатор.",
                                  @"Некоторым девушкам нравится коллекционировать фаллосы.",
                                  @"В секс-шопах огромный выбор фаллоимитаторов, ты можешь выбрать любой.",
                                  @"Многие девушки считают, что искусственный пенис не способен сравниться с настоящим."],
                             
                             @2:@[@"Существует очень много слов со значением “проститутка”, и это, пожалуй, одно из самых безобидных. Это слово должно использоваться с определённой осторожностью, потому как оно также обозначает “мисс” или “юная леди”. Очень часто на улице или даже у себя на двери вы можете найти объявления с тремя иероглифами 包小姐, что обозначает “вызвать проститутку”.",
                                  @"Многие массажистки в саунах на самом деле проститутки.",
                                  @"Позвони вот этой проститутке, и она даст тебе высочайший сервис для твоего тела и души.",
                                  @"В последнее время по всей стране можно увидеть множество объявлений с проститутками.",
                                  @"И зачем мне надо вызывать проститутку? Я очень сильно люблю свою жену.",
                                  @"Некоторые студентки уходят в проституцию из-за нехватки денег."],
                             
                             @3:@[@"Дословно переводится \"высокая волна\", что достаточно хорошо описывает то, что  происходит с девушкой во время оргазма. Не используется для мужского оргазма.",
                                  @"Не каждая девушка способна достичь оргазма.",
                                  @"Ты первый парень, который довёл меня до оргазма.",
                                  @"Прошлой ночью её парень кончил 3 раза, она же так и не дошла до оргазма.",
                                  @"Учёные утверждают, что оргазм полезен для здоровья.",
                                  @"Лучше всего, когда парень и девушка достигают оргазма одновременно."],
                             
                             @4:@[@"Дословно переводится \"поймать самолет\" или \"сбить самолет\". Главным образом используется, когда мужчина сам себя хочет удовлетворить. Также может быть использовано в ситуации, когда кто-то другой удовлетворяет мужчину рукой. В Китае это один из видов проституции, скрывающийся под вывесками массажа. В таких салонах мужчине сперва сделают массаж весьма сомнительного качества, после чего предложат \"побить его самолет\". ",
                                  @"Он мастурбировал как раз в тот момент, когда вошла его мама.",
                                  @"Некоторые работницы массажных салонов легко могут подрочить тебе.",
                                  @"Пристраститься к мастурбированию очень легко, а это мешает завести настоящую девушку.",
                                  @"Очень многие старшеклассники мастурбируют по утрам.",
                                  @"Его девушка застала его за мастурбированием. Она была просто в гневе."],
                             
                             @5:@[@"Дословно обозначает \"выстрелить\", \"запустить\" и может быть использовано в очень многих ситуациях от забития гола в ворота до запуска космического шаттла.\nСинонимы:\n发射 fāshè\n射出 shèchū\n来了 láil",
                                  @"Его девушка еще не достигла оргазма, а он уже кончил.\
                                  e",
                                  @"Ему нравится кончать внутрь своей девушки.",
                                  @"При их первом занятии любовью, из него вышло немало спермы.",
                                  @"Этот парень за одну ночь способен кончить 4 раза.",
                                  @"Ему нравится, когда он кончает и девушка царапает его спину."],
                             
                             @6:@[@"Не смотря на то, что традиционные словари дадут вам только одно значение для этого слова - “товарищ”, в последние годы это так же очень популярный сленг для обозначения гея. Дословно 同志 обозначает “иметь общие цели”, и потому используется преимущественно между геями. Когда люди традиционной сексуальной ориентации называют геев, то используются другие синонимы.\nСинонимы:\n同性恋者 tóngxìngliànzhě\n屁精 pìjīng (редко используется в настоящее время)\n玻璃 bōli (созвучно английскому “boy love”)",
                                  @"Взгляни как тех двух парней влечёт друг к другу. По-любому, геи.",
                                  @"Моя сестрёнка сказала, что в её группе очень много геев, потому она все еще свободна.",
                                  @"В некоторых городах Америки геи могут официально вступить в брак.",
                                  @"Я и мой лучший друг вместе каждый день, поэтому все вокруг думают, что мы геи.",
                                  @"Очень многие девушки хотят иметь близкого друга гея."],

                             @7:@[@"Достаточно обыденное слово для обозначения лесбиянок без какого-либо негативного оттенка.\nСинонимы:\n拉子 lāzi\n女同性恋者 nǚtóngxìngliànzhě\n女同 nǚtóng\n蕾丝边 lěisībiān (созвучно английскому lesbian)",
                                  @"Взгляни как те две девушки одеты. Наверняка лесбиянки.",
                                  @"У тебя ни единого шанса переспать с ней. Она ведь лесбиянка, и потому ей нравятся только другие девушки.",
                                  @"В последнее время стало нормой увидеть двух целующихся лесби в метро.",
                                  @"Несмотря на то, что современное общество всё ещё не сильно приветствует однополую любовь, в последнее время количество геев и лесбиянок только увеличивается.",
                                  @"Глядя на тех двух девушек я всегда думал, что они лесбиянки, но теперь я знаю, что они просто очень хорошие подруги."],
                             
                             @8:@[@"Является нейтральным словом для обозначения пениса. Другая его вариация 鸡鸡 является более ласкательной и детской.",
                                  @"У него действительно большой пенис и все его друзья завидуют ему.",
                                  @"Не всем девушкам нравятся большие члены, потому как они боятся, что будет больно.",
                                  @"Парням с большими членами не легко подобрать подходящие презервативы.",
                                  @"Многие считают, что у африканцев члены больше, чем у азиатов и европейцев.",
                                  @"Парни с маленькими членами могут чувствовать себя неуверенно, но большинство девушек не обращают внимание на размер."],
                             
                             @9:@[@"Синонимы:\n性无能 (досл. “сексуально беспомощный”)\n弯了 (досл. “кривой”)\n不是直男 (досл. “непрямой мужчина”)",
                                  @"Импотент - это мужчина, чей пенис совсем не может встать, или же встаёт на очень короткий промежуток времени. Он не может вести полноценную половую жизнь и входить в женское влагалище.",
                                  @"Вчера я смотрел на обнажённую девушку, которая мне очень нравится, и мой член не мог подняться. Боюсь, что я стал импотентом.",
                                  @"Моя мама постоянно спрашивает меня когда же я забеременею. Но не могу же я ей сказать, что мой муж стал импотентом.",
                                  @"Я уже пол часа жду, когда же у тебя встанет. Ты импотент!",
                                  @"Мой парень не может продержаться и несколько минут. По-моему, он просто импотент."],
                             
                             @10:@[@"Очень вульгарное и грязное слово для обозначения женской вагины, наиболее подходящий в русском языке аналог - пи**а. Зачастую этот иероглиф, в силу своей даже визуальной вульгарности (尸 - тело, 穴 - дыра, впадина), не используется, а вместо него пишут 逼 или используют английскую букву \"В\". На некоторых операционных системах если вы попытаетесь напечатать этот иероглиф с помощью пиньиня, то вы его просто не найдёте в числе предлагаемых. В таких случаях единственный выход - написать его от руки, и тогда система всё-таки предложит вам его напечатать. Ещё более удивительно то, что многие китайцы вообще не знают этого иероглифа. Также часто используется в различных ругательствах и в составе других фраз разговорного китайского языка. Подробнее об этом можно узнать в разделах \"Ругательства\" и \"Сленг\".\
                                   Синонимы:\n阴道 yīndào  - официальное обозначение для \"вагины\" (досл. \"Женский путь\")\n小妹妹 xiǎomèimei - имеет оттенок невинности и ласки (досл. \"Маленькая сестричка\")\n白虎 báihǔ - \"бритая киска\"",
                                  @"У этой девушки очень грязная пи**а.",
                                  @"Порой она несколько раз на дню моет свою пи**у.",
                                  @"Её парень уверен, что у неё очень ароматное влагалище.",
                                  @"Этому мужчине нравится лизать женское влагалище.",
                                  @"У неё между ног очень много волос."],
                             
                             @11:@[@"Дословно переводится \"иметь одну ногу с кем-то\". Фраза может обозначать как просто романтическую, так и сексуальную связь на стороне.\nСинонимы:\n偷情 tōuqíng\n劈腿pītuǐ\n出轨chūguǐ",
                                   @"Наш начальник спит со своей секретаршей.",
                                   @"Мне кажется мой отец сейчас встречается со своей первой любовью.",
                                   @"Смотри, в новостях пишут, что эта певица спит со своим менеджером.",
                                   @"Сейчас не редко студенты занимаются сексом со своими учителями.",
                                   @"Взгляни на тот магазин, два его работника явно встречаются."],
                             
                             @12:@[@"Дословно переводится “цветной волк”.\
                                   Синонимы:\
                                   色鬼 sèguǐ",
                                   @"Вчера вечером полиция поймала двух извращенцев",
                                   @"Не надо вечермо гулять в одиночку, можно встретить извращенца.",
                                   @"Наш учитель извращенец. Во время урока постоянно пялится на девушек, и полностью игнорирует парней.",
                                   @"Обычные парни мне не интересны. Мне хочется, что бы моим парнем был извращенец, и тогда моя сексуальная жизнь точно станет интереснее.",
                                   @"В интернете очень много извращенцев. Они постоянно просят у меня включить камеру."]
                             };
    
    NSDictionary *enDict = @{@1:@[@"Literally \"fake instrument for vagina\".\nSynonyms:\n电动鸡巴 diàndòngjībā\n假鸡巴 jiǎjībā",
                                  @"Her good friend sent her a dildo as a birthday gift.",
                                  @"She thinks every girl should have a dildo.",
                                  @"Some girls like to collect dildos.",
                                  @"There's a good choice of dildos in sex shops, you can pick any.",
                                  @"Many girls believe a dildo to be inferior to an actual penis."],
                             
                             @2:@[@"There are many words to describe a prostitute and this one is perhaps the most innocent. This word should be used very carefully as it literally means “miss” or “little lady” but is also a synonym for “prostitute”. It is very common to find advertisement flyers around the streets and indeed the front door of your apartment. This is an escort service. The ads are recognizable by 3 characters 包小姐, which means “to call a prostitute”.",
                                  @"Many masseuses employed in saunas are actually prostitutes.",
                                  @"You should call that prostitute, she will give you the best experience in your life.",
                                  @"Recently it is particularly common to find the ads for prostitution all around the country.",
                                  @"Why should I call a prostitute? I love my wife too much.",
                                  @"Some students become prostitutes because of lack of money."],
                             
                             @3:@[@"Literally translates as \"high tide\", which is a really quite a good description of the sensation felt by women. It can’t be used for men however.",
                                  @"Not every girl can reach orgasm.",
                                  @"You're the first boyfriend that made me reach orgasm.",
                                  @"Last night her boyfriend ejaculated 3 times, but she didn’t cum at all.",
                                  @"Scientists claim that orgasms are good for your health.",
                                  @"It's perfect when two sexual partners climax together."],
                             
                             @4:@[@"Literally translates as \"catch a plane\" or \"hit a plane\". Usually refers to male masturbation, but can also be used when somebody else manually stimulates a man to the point of orgasm. In China it is one of the most common prostitution services that can be found in massage parlors. In such places a man can first enjoy a “massage”, and then will be asked if he wants his \"plane to be bitten\". ",
                                  @"He was masturbating when his mom came into the room.",
                                  @"Some masseuses can give you a handjob.",
                                  @"It's easy to get addicted to masturbation, and also it may inhibit finding a girlfriend.",
                                  @"Many high school students masturbate in the morning.",
                                  @"His girlfriend caught him masturbating, she was really pissed off."],
                             
                             @5:@[@"Literally means \"shoot\", \"launch\" and can be used in many situations from scoring a goal to launching space shuttle.\nSynonyms:\n发射 fāshè\n射出 shèchū\n来了 láile",
                                  @"His girlfriend hasn't cum yet, but he has already ejaculated.",
                                  @"He likes to cum inside his girlfriend.",
                                  @"The first time they made love he ejaculated quite a lot of semen.",
                                  @"During one night he can cum 4 times.",
                                  @"He likes his girlfriend to scratch his back as he ejaculates."],
                             
                             @6:@[@"Though traditional dictionaries translate this word as “comrade”, recently it’s a very popular slang for “gay”. Literally 同志 means “having the same goal”, so is usually used among gay men to call each other. When heterosexuals talk about homosexuals usually other synonyms are used.\nSynonyms:\n同性恋者 tóngxìngliànzhě\n玻璃 bōli (sounds like “boy love”)\n屁精 pìjīng (not very useful nowadays)\n不是直男 (lit. “not straight man”)",
                                  @"Look how intimate those two guys are. They are gay for sure.",
                                  @"My sister said there are too many gay men in her class, so she is still single.",
                                  @"In some parts of America homosexuals can legally marry.",
                                  @"My best friend and I spent a lot of time together, everybody thinks we are a gay couple.",
                                  @"Many girls want to have a gay man as a closest friend."],
                             
                             @7:@[@"Is a very normal and accepted word for female homosexuals. It is not derogatory.\nSynonyms:\n拉子 lāzi\n女同性恋者 nǚtóngxìngliànzhě\n女同 nǚtóng\n蕾丝边 lěisībiān (sounds like “lesbian”)",
                                  @"Look at how those two girls dress, I am sure they are lesbians.",
                                  @"You have no chance of spending a night with her. She’s a lesbian, so only likes the girls.",
                                  @"Recently it’s quite normal to see two lesbians kissing on the subway.",
                                  @"Though our society still doesn't really tolerate homosexuality, recently it there seems to be more and more lesbian and gay couples.",
                                  @"When I first looked at those two girls I thought they were lesbians, but now I know they are just good friends."],
                             
                             @8:@[@"Neutral word for penis. Its variation 鸡鸡 is more puerile.",
                                  @"His dick is really big and all his friends envy him.",
                                  @"Not all the girls like big cocks because it may hurt.",
                                  @"It's not easy for guys with big cocks to choose the right condom.",
                                  @"Many people believe that Africans have much larger penises than Europeans or Asians.",
                                  @"Guys with smaller dicks may lose confidence, but most girls don't care about the size."],
                             
                             @9:@[@"Synonyms:\n性无能 (lit. “sexually incapable”)\n弯了 (lit. “bent”)",
                                 @"Impotent is when a man is unable to engage in sexual intercourse because of inability to have or maintain an erection. He can’t have normal sexual life, his penis can’t enter woman’s vagina.",
                                  @"Yesterday I was looking at a naked woman that I like very much, but my dick couldn't get hard. I’m afraid I am impotent.",
                                  @"My mom  keeps asking me when I’ll get pregnant. But I can’t tell her that my husband is impotent.",
                                  @"I’ve been waiting for your dick to became erect for half an hour. You are impotent!",
                                  @"If a man and a girl make love, and the man is unable to maintain an erection for even a few minutes then he is an impotent."],
                             
                             @10:@[@"Very vulgar term for the vagina, the closest English equivalent is \"c*nt\". Very often this character is not used because of its visual vulgarity (尸 - body, 穴 - hole). In this case 逼 or \"B\" are used instead. On some computer operational systems if you try to type that character using pinyin you won't find it. In this case the only way is to use handwriting method, only then the system will let you type it. More surprising is that many Chinese don't know that character. This word is also very often used as a part of many different phrases of spoken language. You can learn more about it in sections \"Insults\" and \"Slang\".\nSynonyms:\n阴道 yīndà - medical term for vagina (lit. \"Woman's path\")\n小妹妹 xiǎomèimei - Innocent term for vagina, pussy (lit. \"Little sister\")\n白虎 báihǔ - shaved pussy (lit. “white tiger”)",
                                   @"That girl has a very dirty c*nt.",
                                   @"Some days she washes her c*nt several times.",
                                   @"Her boyfriend thinks her vagina is very fragrant.",
                                   @"This man likes to lick pussies.",
                                   @"She's got lots of hair between her legs."],
                             
                             @11:@[@"Literally translates as \"to have one leg with smb\". It may mean just romantic or sexual relationship as well as to cheat on somebody.\nSynonims:\n偷情 tōuqíng\n劈腿pītuǐ\n出轨chūguǐ",
                                   @"Our boss sleeps with his secretary.",
                                   @"I think my father dates his first love now.",
                                   @"Look, the news says that this singer has had an affair with her producer.",
                                   @"Nowadays it’s normal for some students to have an affair with their teachers.",
                                   @"Look at that store, these two workers are definitely having an affair."],
                             
                             @12:@[@"Literally translates “colorful wolf”.\nSynonyms:\n色鬼 sèguǐ",
                                   @"Yesterday night police cought two perverts.",
                                   @"Don't walk alone in the evening in the park, you may meet a pervert.",
                                   @"Our teacher is a pervert. He stares at the girls all the time and ignores the boys.",
                                   @"Normal boys are too boring, I want to have a pervert as my boyfriend and then my sexual life will become more interesting.",
                                   @"There're too many perverts in the internet, they always ask me to turn the camera on."]
                             };

    
    int materialCount = 1;
    NSMutableArray *materialsArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 12; i++)
    {
        NSArray *chArray = chDict[[NSNumber numberWithInt:i+1]];
        NSArray *ruArray = ruDict[[NSNumber numberWithInt:i+1]];
        NSArray *enArray = enDict[[NSNumber numberWithInt:i+1]];
        for(int j = 0; j < 6; j++)
        {
            NCMaterial *material = [[NCMaterial alloc] init];
            material.materialID = [NSNumber numberWithInt:12+materialCount];
            materialCount ++;
            material.materialEN = enArray[j];
            material.materialRU = ruArray[j];
            if(j > 0)
                material.materialZH = chArray[j-1];
            [materialsArray addObject:material];
        }
    }
    return materialsArray;
}

- (NSArray *) explanations
{
    NSMutableArray *explanationsArray = [[NSMutableArray alloc] init];
    
    int count = 1;
    for(int i = 0; i < 12; i++)
    {
        for(int j = 0; j < 6; j++)
        {
            NCExplanation *exp = [[NCExplanation alloc] init];
            exp.ID = [NSNumber numberWithInt:12+count];
            exp.wordID = [NSNumber numberWithInt:i+1];
            count ++;
            [explanationsArray addObject:exp];
        }
    }
    
    return explanationsArray;
}
@end
