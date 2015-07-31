//
//  NCStaticData.m
//  NakedChinese
//
//  Created by IMAC  on 21.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "NCStaticData.h"
#import "NCPack.h"
#import "NCWord.h"
#import "NCExplanation.h"

@implementation NCStaticData
#pragma mark Content

+ (NSArray *) wordsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *chinese = @[@"假阳具", @"同志", @"拉拉", @"小姐", @"婊子", @"打飞机",
                         @"射", @"高潮", @"阳痿", @"屄", @"鸡巴", @"色狼"];
    NSArray *pinyin = @[@"jǐayángjǜ", @"tóngzhì", @"lāla", @"xiǎojiě", @"biǎozi", @"dǎfēijī",
                        @"shè", @"gāocháo", @"yángwěi", @"bī", @"jībā", @"sèláng"];
    NSArray *russian = @[@"Фаллоимитатор", @"Гей", @"Лесбиянка", @"Проститутка", @"Шлюха", @"Мастурбировать", @"Кончить", @"Оргазм", @"Импотент", @"Пи*да", @"Х*й", @"Извращенец"];
    NSArray *english = @[@"Dildo", @"Gay", @"Lesbian", @"Prostitute", @"Whore", @"Handjob",
                         @"Cum", @"Orgasm", @"Impotent", @"C*nt", @"Dick", @"Pervert"];
    
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

+ (NSArray *) materialsArray
{
    NSDictionary *chDict =
    @{@1:@[@"她过生日的时候, 她好朋友邮给她一个假阳具.",
           @"她认为每个女生都应该有假鸡巴.",
           @"有的女生喜欢收集假阳具.",
           @"保健品店里有很多电动鸡巴，你可以随便挑.",
           @"有的女生认为，假鸡巴不如真的舒服."],
      
      @2:@[@"你看那边那两个男的，举止那么亲密， 一看就是同性恋",
           @"我妹妹给我说他们班有很多同性恋，所以她还单身.",
           @"美国某地方同性恋是可以合法结婚的.",
           @"我和我最好的朋友天天腻在一起，人家都以为我们俩是同志呢.",
           @"很多女生想把同志变成闺蜜."],
      @3:@[@"看着俩女孩穿成这样， 肯定是拉拉",
           @"你没机会跟她过夜，她是个拉拉，只喜欢女生",
           @"最近在地铁里两个拉拉亲亲是很正常的事情",
           @"虽然现在的社会还不能接受同性恋，但最近同志和拉拉似乎越来越多了",
           @"第一次见这两个女孩，我曾以为她们是拉拉，不过现在我知道了，她们只是很好的朋友"],
      
      @4:@[@"很多洗浴中心的按摩师都是小姐.",
           @"你可以给这个小姐打电话， 她可以给你最好的服务.",
           @"最近在全国各地的大街上，不时就能看到”包小姐”的小广告.",
           @"我去找小姐干嘛？ 我很爱我的老婆.",
           @"有的大学生因为没有钱就做了小姐."],
      
      @5:@[@"这个婊子太不要脸了.",
           @"这个婊子跟你就是为了钱!",
           @"现在的学生也会去找鸡.",
           @"她从小就是个妓女，已经跟几百男人打跑了.",
           @"你打这个电话号码， 给我们叫三个鸡."],
      
      @6:@[@"他妈妈进屋的时候，他正在打飞机.",
           @"在按摩店有些按摩女可以给你打飞机.",
           @"打飞机特别容易上瘾，还阻碍交女朋友.",
           @"很多高中生经常在早上打飞机.",
           @"他打飞机时候被他女朋友碰见了，她很生气."],
      
      @7:@[@"他女朋友还没高潮，他就射了.",
           @"他喜欢射在他女朋友身体里.",
           @"他第一次跟他女朋友做爱的时候，他射了好多精液.",
           @"这个男生一宿可以射四次.",
           @"他喜欢在他射了的时候让他女朋友抓他的后背."],
      
      @8:@[@"不是所有的女生都会高潮.",
           @"你是第一个送我到高潮的男朋友.",
           @"她的男朋友昨夜射了三次， 不过她一次也没有高潮.",
           @"科学家说高潮对健康很好",
           @"最好的状态就是男女朋友同时高潮了"],
      
      @9:@[@"昨天我看到了我喜欢的姑娘的裸体，但我完全硬不起来。我怕我阳痿了.",
           @"我妈妈一直问我什么时候怀孕了。我不敢告诉她我老公性无能.",
           @"都等你半小时了，还硬不起来，你阳痿啊 !",
           @"我的男友坚持不了几分钟就不行了， 对我来说他就阳痿.",
           @"我的老婆还不了解为什么我跟她一起的时候阳痿了。原因是我不爱她了，跟别的女生没有这个问题。",],
      
      @10:@[@"这个女生有很脏的屄.",
            @"有时候她一天去洗手间洗屄好多次.",
            @"她的男朋友觉得她的屄好香.",
            @"这个男生很喜欢舔女生的屄.",
            @"这个女生的逼上有很多毛."],
      
      @11:@[@"他有一个大鸡巴， 其他朋友都很羡慕他.",
            @"女孩不是都喜欢有大鸡巴的男孩， 因为怕太痛.",
            @"有大鸡巴的男孩很难买到合适的套子.",
            @"很多人认为非洲人的鸡巴比亚洲人和欧洲人大.",
            @"有小鸡巴的男生会感觉很自卑， 但是大多数女生不在乎这点."],
      
      @12:@[@"昨天晚上警察抓到两个色鬼.",
            @"晚上不要在公园一个人散步，很容易遇到色鬼.",
            @"我们的老师是个色鬼， 上课的时候一直看着女生，不理男生.",
            @"正常男生太无聊，我想一个色鬼做我的男朋友。这样我的性生活肯定变有意思的了.",
            @"网络上有很多色狼， 他们经常要求射频."]
      };
    
    NSDictionary *ruDict = @{@1:@[@"Дословно \"искусственный инструмент для влагалища\".\n\nСинонимы:\n电动鸡巴 diàndòngjībā\n假鸡巴 jiǎjībā\n假阴茎 jiǎyīnjīng",
                                  @"На день рождения её хорошая подруга послала фаллоимитатор.",
                                  @"Она считает, что каждая девушка должна иметь фаллоимитатор.",
                                  @"Некоторым девушкам нравится коллекционировать фаллосы.",
                                  @"В секс-шопах огромный выбор фаллоимитаторов, ты можешь выбрать любой.",
                                  @"Многие девушки считают, что искусственный пенис не способен сравниться с настоящим."],
                             
                             @2:@[@"Не смотря на то, что традиционные словари дадут вам только одно значение для этого слова - “товарищ”, в последние годы это так же очень популярный сленг для обозначения гея. Дословно 同志 обозначает “иметь общие цели”, и потому используется преимущественно между геями. Когда люди традиционной сексуальной ориентации называют геев, то используются другие синонимы.\n\nСинонимы:\n同性恋者 tóngxìngliànzhě\n屁精 pìjīng (редко используется в настоящее время)\n玻璃 bōli (созвучно английскому “boy love”)\n不是直男 búshìzhínán",
                                  @"Взгляни как тех двух парней влечёт друг к другу. По-любому, геи.",
                                  @"Моя сестрёнка сказала, что в её группе очень много геев, потому она все еще свободна.",
                                  @"В некоторых городах Америки геи могут официально вступить в брак.",
                                  @"Я и мой лучший друг вместе каждый день, поэтому все вокруг думают, что мы геи.",
                                  @"Очень многие девушки хотят иметь близкого друга гея."],
                             @3:@[@"Синонимы:\n拉子 lāzi\n女同性恋者 nǚtóngxìngliànzhě\n女同 nǚtóng\n蕾丝边 lěisībiān (созвучно английскому lesbian)",
                                  @"Взгляни, как те две девушки одеты. Наверняка лесбиянки.",
                                  @"У тебя ни единого шанса переспать с ней. Она ведь лесбиянка, и потому ей нравятся только другие девушки.",
                                  @"В последнее время стало нормой увидеть двух целующихся лесби в метро.",
                                  @"Несмотря на то, что современное общество всё ещё не сильно приветствует однополую любовь, в последнее время количество геев и лесбиянок только увеличивается.",
                                  @"Глядя на тех двух девушек я всегда думал, что они лесбиянки, но теперь я знаю, что они просто близкие подруги."],
                             
                             @4:@[@"Существует очень много слов со значением “проститутка”, и это, пожалуй, одно из самых безобидных. Это слово должно использоваться с определённой осторожностью, потому как оно также обозначает “мисс” или “юная леди”. Очень часто на улице или даже у себя на двери вы можете найти объявления с тремя иероглифами 包小姐, что обозначает “вызвать проститутку”.",
                                  @"Многие массажистки в саунах на самом деле проститутки.",
                                  @"Позвони вот этой проститутке, и она даст тебе высочайший сервис и для тела, и для души.",
                                  @"В последнее время по всей стране можно увидеть множество объявлений по вызову девушек лёгкого поведения.",
                                  @"И зачем мне нужна проститутка? Я очень сильно люблю свою жену.",
                                  @"Некоторые студентки уходят в проституцию из-за нехватки денег."],
                             
                             
                             @5:@[@"婊子 и другие его синонимы, представленные ниже, является куда более грубым и вульгарным термином для “проститутки”. В русском языке наиболее близкий аналог - “шлюха”. Это слово может обозначать как реальную проститутку, так и может выступать в роли очередного ругальства. К примеру  婊子的儿子 (сукин сын)\n\nСинонимы:\n鸡 jī (дословно “курица”, очень распространённый термин)\n妓女 jìnǚ\n娼妓 chāngjì\n援交妹 yuánjiāo mèi (распространено на юге Китая)",
                                  @"Это шлюха вообще без капли стыда.",
                                  @"Эта шлюха с тобой только ради денег!",
                                  @"Сейчас даже школьники вызывают себе девочек.",
                                  @"Она с малых лет работает проституткой и перетр*халась уже с несколькими сотнями мужиков.",
                                  @"Позвони по этому номеру, и вызови нам трёх баб."],
                             
                             @6:@[@"Дословно переводится \"поймать самолет\" или \"сбить самолет\". Главным образом используется, когда мужчина сам себя хочет удовлетворить. Также может быть использовано в ситуации, когда кто-то другой удовлетворяет мужчину рукой. В Китае это один из видов проституции, скрывающийся под вывесками массажа. В таких салонах мужчине сперва сделают массаж весьма сомнительного качества, после чего предложат \"побить его самолет\". ",
                                  @"Он мастурбировал как раз в тот момент, когда вошла его мама.",
                                  @"Некоторые работницы массажных салонов легко могут подрочить тебе.",
                                  @"Пристраститься к мастурбированию очень легко, а это мешает завести настоящую девушку.",
                                  @"Очень многие старшеклассники мастурбируют по утрам.",
                                  @"Его девушка застала его за мастурбированием. Она была просто в гневе."],
                             
                             @7:@[@"Дословно обозначает \"выстрелить\", \"запустить\" и может быть использовано в очень многих ситуациях от забития гола в ворота до запуска космического шаттла.\n\nСинонимы:\n发射 fāshè\n射出 shèchū\n来了 láil",
                                  @"Его девушка еще не достигла оргазма, а он уже кончил.\
                                  e",
                                  @"Ему нравится кончать внутрь своей девушки.",
                                  @"При их первом занятии любовью, из него вышло немало спермы.",
                                  @"Этот парень за одну ночь способен кончить 4 раза.",
                                  @"Ему нравится, что девушка царапает его спину в тот момент, когда он кончает."],
                             
                             
                             @8:@[@"Дословно переводится \"высокая волна\", что достаточно хорошо описывает то, что  происходит с девушкой во время оргазма. Не используется для мужского оргазма. \n\nСинонимы:\n性高潮 xìnggāocháo",
                                  @"Не каждая девушка способна достичь оргазма.",
                                  @"Ты первый парень, который довёл меня до оргазма.",
                                  @"Прошлой ночью её парень кончил 3 раза, она же так и не дошла до оргазма.",
                                  @"Учёные утверждают, что оргазм полезен для здоровья.",
                                  @"Лучше всего, когда парень и девушка достигают оргазма одновременно."],
                             
                             
                             
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
                                  @"Вчера я смотрел на обнажённую девушку, которая мне очень нравится, и мой член не мог подняться. Боюсь, что я стал импотентом.",
                                  @"Моя мама постоянно спрашивает меня когда же я забеременею. Но не могу же я ей сказать, что мой муж стал импотентом.",
                                  @"Я уже пол часа жду, когда же у тебя встанет. Ты импотент!",
                                  @"Мой парень не может продержаться и несколько минут. По-моему, он просто импотент.",
                                  @"Моя жена никак не может понять, почему с ней у меня не встаёт. Причина в том, что я больше не люблю её, с другими девушками таких проблем нет"],
                             
                             @10:@[@"Это вульгарное и грязное слово означает женскую вагину, и наиболее подходящий в русском языке аналог - пи*да. Зачастую этот иероглиф в силу своей визуальной вульгарности (尸 - тело, 穴 - дыра, впадина) не используется, а вместо него пишут 逼, 比 или используют английскую букву \"В\". На некоторых операционных системах, если вы попытаетесь напечатать этот иероглиф с помощью пиньиня, то вы его, вероятно, не найдёте в числе предлагаемых. В таких случаях единственный выход - написать его от руки, и тогда система всё-таки предложит вам его напечатать. Что ещё более удивительно, так это то, что многие китайцы понятия не имеют о существовании этого иероглифа, но это не мешает им употреблять его в речи. Также часто используется в различных ругательствах и в составе других фраз разговорного китайского языка. Подробнее об этом можно узнать в разделах \"Ругательства\" и “Сленг\".\n\nСинонимы:\n阴道 yīndào (официальное обозначение для \"вагины\", досл. \"женский путь\")\n小妹妹 xiǎomèimei  (имеет оттенок невинности и ласки, досл. \"маленькая сестричка”)\n白虎 báihǔ (бритая киска, досл. “белый тигр”)",
                                   @"У этой девушки очень грязная пи**а.",
                                   @"Порой она несколько раз на дню моет свою пи**у.",
                                   @"Её парень уверен, что у неё очень ароматное влагалище.",
                                   @"Этому мужчине нравится лизать женское влагалище.",
                                   @"У неё между ног очень много волос."],
                             
                             @11:@[@"Является сравнительно нейтральным словом обозначающим пенис. Это слово также может выступать в роли определения в значении “ох*енный”, к примеру：\n这是啥鸡吧东西？(Что за х*ета тут?)\n真鸡巴爽了。(Просто ох*енно)\n我太鸡巴累了。(Я ох*енно устал)\n\nСинонимы:\n阴茎 или 阴径 yīnjīng, yīnjìng (официальный термин)\n阳具 yángjù\n阳道 yángdào\n鸡鸡 jījī (“детская“ версия от 鸡巴)\n小鸟  xiǎoniǎo (досл. “маленький птенчик”)\n小弟弟 xiǎo dìdì (досл. “маленький братец”)\nПолезные слова:\n鸡巴蛋 jībādàn\n鸡巴毛 jībāmáo",
                                   @"У него такой большой пенис, что все друзья завидуют ему.",
                                   @"Не всем девушкам нравятся большие члены, потому как они боятся, что будет больно.",
                                   @"Парням с большими членами нелегко подобрать подходящие презервативы.",
                                   @"Многие считают, что у африканцев члены больше, чем у азиатов и европейцев.",
                                   @"Парни с маленькими членами могут чувствовать себя неуверенно, но большинство девушек не обращают внимание на размер."],
                             
                             @12:@[@"Дословно переводится “цветной волк”.\nСинонимы:\n色鬼 sèguǐ",
                                   @"Вчера вечером полиция поймала двух извращенцев.",
                                   @"Не надо вечермо гулять в одиночку, можно встретить извращенца.",
                                   @"Наш учитель извращенец. Во время урока постоянно пялится на девушек, и полностью игнорирует парней.",
                                   @"Обычные парни мне не интересны. Мне хочется, что бы моим парнем был извращенец, и тогда моя сексуальная жизнь точно станет интереснее.",
                                   @"В интернете очень много извращенцев. Они постоянно просят у меня включить камеру."]
                             };
    
    NSDictionary *enDict = @{@1:@[@"Literally \"fake instrument for vagina\".\n\nSynonyms:\n电动鸡巴 diàndòngjībā\n假鸡巴 jiǎjībā\n假阴茎 jiǎyīnjīng",
                                  @"Her good friend sent her a dildo as a birthday gift.",
                                  @"She thinks every girl should have a dildo.",
                                  @"Some girls like to collect dildos.",
                                  @"There's a good choice of dildos in sex shops, you can pick any.",
                                  @"Many girls believe a dildo to be inferior to an actual penis."],
                             
                             @2:@[@"Though traditional dictionaries translate this word as “comrade”, recently it’s a very popular slang for “gay”. Literally 同志 means “having the same goal”, so is usually used among gay men to call each other. When heterosexuals talk about homosexuals usually other synonyms are used.\n\nSynonyms:\n同性恋者 tóngxìngliànzhě\n玻璃 bōli (sounds like “boy love”)\n屁精 pìjīng (not very useful nowadays)\n不是直男 (lit. “not straight man”)\n不是直男 búshìzhínán",
                                  @"Look how intimate those two guys are. They are gay for sure.",
                                  @"My sister said there are too many gay men in her class, so she is still single.",
                                  @"In some parts of America homosexuals can legally marry.",
                                  @"My best friend and I spent a lot of time together, everybody thinks we are a gay couple.",
                                  @"Many girls want to have a gay man as a closest friend."],
                             
                             @3:@[@"Synonyms:\n拉子 lāzi\n女同性恋者 nǚtóngxìngliànzhě\n女同 nǚtóng\n蕾丝边 lěisībiān (sounds like “lesbian”)",
                                  @"Look at how those two girls dress, I am sure they are lesbians.",
                                  @"You have no chance of spending a night with her. She’s a lesbian, so only likes the girls.",
                                  @"Recently it’s quite normal to see two lesbians kissing on the subway.",
                                  @"Though our society still doesn't really tolerate homosexuality, 4. it seems to be more and more lesbian and gay couples.",
                                  @"When I first looked at those two girls I thought they were lesbians, but now I know they are just good friends."],
                             
                             
                             @4:@[@"There are many words to describe a prostitute and this one is perhaps the most innocent. This word should be used very carefully as it literally means “miss” or “little lady” but is also a synonym for “prostitute”. It is very common to find advertisement flyers around the streets and indeed the front door of your apartment. This is an escort service. The ads are recognizable by 3 characters 包小姐, which means “to call a prostitute”.",
                                  @"Many masseuses employed in saunas are actually prostitutes.",
                                  @"You should call that prostitute, she will give you the best experience in your life.",
                                  @"Recently it is particularly common to find the ads for prostitution all around the country",
                                  @"Why should I call a prostitute? I love my wife too much",
                                  @"Some students become prostitutes because of lack of money"],
                             
                             @5:@[@"婊子 and its symonyms which listed below are more vulgar ways to say “prostitute” just like English “whore”. This word can be used to call a real prostitute as well as be just an abuse. For example, 婊子的儿子 (son of a bitch).\n\nSynonims:\n鸡 jī (literally “chick”, commonly used)\n妓女 jìnǚ\n娼妓 chāngjì\n援交妹 yuánjiāo mèi (more popular in the South of China)",
                                  @"That whore is shameless.",
                                  @"That whore is with you just because of your money!",
                                  @"Nowadays students also call prostutes.",
                                  @"She's been a prostitute since very young age, and f*cked with lots of men.",
                                  @"Call that number and let three chicks come for us."],
                             
                             
                             @6:@[@"Literally translates as \"catch a plane\" or \"hit a plane\". Usually refers to male masturbation, but can also be used when somebody else manually stimulates a man to the point of orgasm. In China it is one of the most common prostitution services that can be found in massage parlors. In such places a man can first enjoy a “massage”, and then will be asked if he wants his \"plane to be bitten\". ",
                                  @"He was masturbating when his mom came into the room.",
                                  @"Some masseuses can give you a handjob.",
                                  @"It's easy to get addicted to masturbation, and also it may inhibit finding a girlfriend.",
                                  @"Many high school students masturbate in the morning.",
                                  @"His girlfriend caught him masturbating, she was really pissed off."],
                             
                             @7:@[@"Literally means \"shoot\", \"launch\" and can be used in many situations from scoring a goal to launching space shuttle.\n\nSynonyms:\n发射 fāshè\n射出 shèchū\n来了 láile",
                                  @"His girlfriend hasn't cum yet, but he has already ejaculated.",
                                  @"He likes to cum inside his girlfriend.",
                                  @"The first time they made love he ejaculated quite a lot of semen.",
                                  @"During one night he can cum 4 times.",
                                  @"He likes his girlfriend to scratch his back as he ejaculates."],
                             
                             
                             @8:@[@"Literally translates as \"high tide\", which is a really quite a good description of the sensation felt by women. It can’t be used for men however. \n\nSynonyms:\n性高潮 xìnggāocháo",
                                  @"Not every girl can reach orgasm.",
                                  @"You're the first boyfriend that made me reach orgasm.",
                                  @"Last night her boyfriend ejaculated 3 times, but she didn’t cum at all.",
                                  @"Scientists claim that orgasms are good for your health.",
                                  @"It's perfect when two sexual partners climax together."],
                             
                             @9:@[@"Synonyms:\n性无能 (lit. “sexually incapable”)\n弯了 (lit. “bent”)",
                                  @"Yesterday I was looking at a naked woman that I like very much, but my dick couldn't get hard. I’m afraid I am impotent.",
                                  @"My mom  keeps asking me when I’ll get pregnant. But I can’t tell her that my husband is impotent.",
                                  @"I’ve been waiting for your dick to became erect for half an hour. You are impotent!",
                                  @"If a man and a girl make love, and the man is unable to maintain an erection for even a few minutes then he is an impotent.",
                                  @"5. My wife can't understand why I become impotent when I am with her. The reason is I don't love her anymore, there're no such problems when I am with other women."],
                             
                             @10:@[@"Very vulgar term for the vagina, the closest English equivalent is \"c*nt\". Very often this character is not used because of its visual vulgarity (尸 - body, 穴 - hole). In this case 逼, 比 or \"B\" are used instead. On some computer operational systems if you try to type that character using pinyin you won't find it. In this case the only way is to use handwriting method, only then the system will let you type it. More surprising is that many Chinese don't know that character but they still use it in conversational language. This word is also very often used as a part of many different phrases of spoken language. You can learn more about it in sections \"Swearing\" and \"Slang\". \n\nSynonyms:\n阴道 yīndà - medical term for vagina (lit. \"Woman's path\")\n小妹妹 xiǎomèimei - Innocent term for vagina, pussy (lit. \"Little sister\")\n白虎 báihǔ - shaved pussy (lit. “white tiger”)",
                                   @"That girl has a very dirty c*nt.",
                                   @"Some days she washes her c*nt several times.",
                                   @"Her boyfriend thinks her vagina is very fragrant.",
                                   @"This man likes to lick pussies.",
                                   @"She's got lots of hair between her legs."],
                             
                             @11:@[@"Relatively neutral word for penis. This word can also serve as a definition meaning “f*cking”. For example:\n这是啥鸡吧东西？(What the f*uck is that?)\n真鸡巴爽了。(It's f*cking awesome)\n我太鸡巴累了。(I'm f*cking tired)\n\nSynonyms:\n阴茎 or 阴径 yīnjīng, yīnjìng (oficial term)\n阳具 yángjù\n阳道 yángdào\n鸡鸡 jījī  (“childish” version of 鸡巴)\n小鸟  xiǎoniǎo  (lit. “little bird”)\n小弟弟 xiǎo dìdì  (lit. “little brother”)\n\nUseful words:\n鸡巴蛋 jībādàn (balls)\n鸡巴毛 jībāmáo (hair on the dick)",
                                   @"His dick is really big and all his friends envy him.",
                                   @"Not all the girls like big cocks because it may hurt.",
                                   @"It's not easy for guys with big cocks to choose the right condom",
                                   @"Many people believe that Africans have much larger penises than Europeans or Asians.",
                                   @"Guys with smaller dicks may lose confidence, but most girls don't care about the size."],
                             
                             @12:@[@"Literally translates “colorful wolf”.\nSynonyms:\n色鬼 sèguǐ",
                                   @"Yesterday night police cought two perverts.",
                                   @"Don't walk alone in the evening in the park, you may meet a pervert.",
                                   @"Our teacher is a pervert. He stares at the girls all the time and ignores the boys.",
                                   @"Normal boys are too boring, I want to have a pervert as my boyfriend and then my sexual life will become more interesting.",
                                   @"There're too many perverts in the internet, they always ask me to turn the camera on."]
                             };
    
    NSDictionary *pinDict = @{@1:@[
                                      @"Tāguò shēngrì de shíhòu, tā hǎo péngyǒu yóu gěi tā yīgè jiǎ yángjù.",
                                      @"Tā rènwéi měi gè nǚshēng dōu yīnggāi yǒu jiǎ jībā.",
                                      @"Yǒu de nǚshēng xǐhuān shōují jiǎ yángjù.",
                                      @"Bǎojiàn pǐn diàn li yǒu hěnduō diàndòng jībā, nǐ kěyǐ suíbiàn tiāo.",
                                      @"Yǒu de nǚshēng rènwéi, jiǎ jībā bu rú zhēn de shūfú."],
                              
                              @2:@[
                                      @"Nǐ kàn nà biān nà liǎng gè nán de, jǔzhǐ nàme qīnmì, yī kàn jiùshì tóngxìngliàn.",
                                      @"Wǒ mèimei gěi wǒ shuō tāmen bān yǒu hěnduō tóngxìngliàn, suǒyǐ tā hái dānshēn.",
                                      @"Měiguó mǒu dìfāng tóngxìngliàn shì kěyǐ héfǎ jiéhūn de.",
                                      @"Wǒ hé wǒ zuì hǎo de péngyǒu tiāntiān nì zài yīqǐ, rénjiā dōu yǐwéi wǒmen liǎ shì tóngzhì ne.",
                                      @"Hěnduō nǚshēng xiǎng bǎ tóngzhì biàn chéng guīmì."],
                              
                              @3:@[
                                      @"Kànzhe liǎ nǚhái chuān chéng zhèyàng, kěndìng shì lā lā.",
                                      @"Nǐ méi jīhuì gēn tā guòyè, tā shìgè lā lā, zhǐ xǐhuān nǚshēng.",
                                      @"Zuìjìn zài dìtiě lǐ liǎng gè lā lā qīn qīn shì hěn zhèngcháng de shìqíng.",
                                      @"Suīrán xiànzài de shèhuì hái bùnéng jiēshòu tóngxìngliàn, dàn zuìjìn tóngzhì hé lā lā sìhū yuè lái yuè duō.",
                                      @"Dì yī cì jiàn zhè liǎng gè nǚhái, wǒ céng yǐwéi tāmen shì lā lā, bùguò xiànzài wǒ zhīdàole, tāmen zhǐshì hěn hǎo de péngyǒu."],
                              
                              @4:@[
                                      @"Hěnduō xǐyù zhōngxīn de ànmó shī dōu shì xiǎojiě.",
                                      @"Nǐ kěyǐ gěi zhège xiǎojiě dǎ diànhuà, tā kěyǐ gěi nǐ zuì hǎo de fúwù.",
                                      @"Zuìjìn zài quánguó gèdì de dàjiē shàng, bùshí jiù néng kàn dào” bāo xiǎojiě” de xiǎo guǎnggào.",
                                      @"Wǒ qù zhǎo xiǎojiě gàn ma? Wǒ hěn ài wǒ de lǎopó.",
                                      @"Yǒu de dàxuéshēng yīnwèi méiyǒu qián jiù zuòle xiǎojiě."],
                              
                              @5:@[
                                      @"Zhège biǎo zi tài bùyào liǎnle.",
                                      @"Zhège biǎo zǐ gēn nǐ jiùshì wèile qián!",
                                      @"Xiànzài de xuéshēng yě huì qù zhǎo jī.",
                                      @"Tā cóngxiǎo jiùshì gè jìnǚ, yǐjīng gēn jǐ bǎi nánrén dǎ pǎole.",
                                      @"Nǐ dǎ zhège diànhuà hàomǎ, gěi wǒmen jiào sān gè jī."],
                              
                              @6:@[
                                      @"Tā māmā jìn wū de shíhòu, tā zhèngzài dǎ fēijī.",
                                      @"Zài ànmó diàn yǒuxiē ànmó nǚ kěyǐ gěi nǐ dǎ fēijī.",
                                      @"Dǎ fēijī tèbié róngyì shàngyǐn, hái zǔ'ài jiāo nǚ péngyǒu.",
                                      @"Hěnduō gāozhōng shēng jīngcháng zài zǎoshang dǎ fēijī.",
                                      @"Tā dǎ fēijī shíhòu bèi tā nǚ péngyǒu pèngjiànle, tā hěn shēngqì."],
                              
                              @7:@[
                                      @"Tā nǚ péngyǒu hái méi gāocháo, tā jiù shèle.",
                                      @"Tā xǐhuān shè zài tā nǚ péngyǒu shēntǐ lǐ.",
                                      @"Tā dì yī cì gēn tā nǚ péngyǒu zuò'ài de shíhòu, tā shèle hǎoduō jīngyè.",
                                      @"Zhège nánshēng yī sù kěyǐ shè sì cì.",
                                      @"Tā xǐhuān zài tā shèle de shíhòu ràng tā nǚ péngyǒu zhuā tā de hòu bèi."],
                              
                              @8:@[
                                      @"Bùshì suǒyǒu de nǚshēng dūhuì gāocháo.",
                                      @"Nǐ shì dì yī gè sòng wǒ dào gāocháo de nán péngyǒu.",
                                      @"Tā de nán péngyǒu zuóyè shèle sāncì, bùguò tā yīcì yě méiyǒu gāocháo.",
                                      @"Kēxuéjiā shuō gāocháo duì jiànkāng hěn hǎo.",
                                      @"Zuì hǎo de zhuàngtài jiùshì nán nǚ péngyǒu tóngshí gāocháole."],
                              
                              @9:@[
                                      @"Zuótiān wǒ kàn dàole wǒ xǐhuān de gūniáng de luǒtǐ, dàn wǒ wánquán yìng bù qǐlái. Wǒ pà wǒ yángwěile.",
                                      @"Wǒ māmā yīzhí wèn wǒ shénme shíhòu huáiyùnle. Wǒ bù gǎn gàosù tā wǒ lǎogōng xìng wúnéng.",
                                      @"Dōu děng nǐ bàn xiǎoshíliǎo, hái yìng bù qǐlái, nǐ yángwěi a!",
                                      @"Wǒ de nányǒu jiānchí bùliǎo jǐ fēnzhōng jiù bùxíngle, duì wǒ lái shuō tā jiù yángwěi.",
                                      @"Wǒ de lǎopó hái bù liǎojiě wèishéme wǒ gēn tā yīqǐ de shíhòu yángwěile. Yuányīn shì wǒ bù ài tāle, gēn bié de nǚshēng méiyǒu zhège wèntí."],
                              
                              @10:@[
                                      @"Zhège nǚshēng yǒu hěn zàng de bī.",
                                      @"Yǒu shíhòu tā yītiān qù xǐshǒujiān xǐ bī hǎoduō cì.",
                                      @"Tā de nán péngyǒu juédé tā de bī hǎo xiāng.",
                                      @"Zhège nánshēng hěn xǐhuān tiǎn nǚshēng de bī.",
                                      @"Zhège nǚshēng de bī shàng yǒu hěnduō máo."],
                              
                              @11:@[
                                      @"Tā yǒu yīgè dà jībā, qítā péngyǒu dōu hěn xiànmù tā.",
                                      @"Nǚhái bùshì dōu xǐhuān yǒu dà jībā de nánhái, yīnwèi pà tài tòng.",
                                      @"Yǒu dà jībā de nánhái hěn nán mǎi dào héshì de tàozi.",
                                      @"Hěnduō rén rènwéi fēizhōu rén de jībā bǐ yǎ zhōu rén hé ōuzhōu réndà.",
                                      @"Yǒu xiǎo jībā de nánshēng huì gǎnjué hěn zìbēi, dànshì dà duōshù nǚshēng bùzàihū zhè diǎn."],
                              
                              @12:@[
                                      @"Zuótiān wǎnshàng jǐngchá zhuā dào liǎng gè sè guǐ.",
                                      @"Wǎnshàng bùyào zài gōngyuán yīgè rén sànbù, hěn róngyì yù dào sè guǐ.",
                                      @"Wǒmen de lǎoshī shìgè sè guǐ, shàngkè de shíhòu yīzhí kànzhe nǚshēng, bù lǐ nánshēng.",
                                      @"Zhèngcháng nánshēng tài wúliáo, wǒ xiǎng yīgè sè guǐ zuò wǒ de nán péngyǒu. Zhèyàng wǒ dì xìng shēnghuó kěndìng biàn yǒuyìsi dele.",
                                      @"Wǎngluò shàng yǒu hěnduō sèláng, tāmen jīngcháng yāoqiú shèpín."]
                              };
    
    
    
    int materialCount = 1;
    NSMutableArray *materialsArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 12; i++)
    {
        NSArray *chArray = chDict[[NSNumber numberWithInt:i+1]];
        NSArray *ruArray = ruDict[[NSNumber numberWithInt:i+1]];
        NSArray *enArray = enDict[[NSNumber numberWithInt:i+1]];
        NSArray *pinArray = pinDict[[NSNumber numberWithInt:i+1]];
        
        for(int j = 0; j < 6; j++)
        {
            NCMaterial *material = [[NCMaterial alloc] init];
            material.materialID = [NSNumber numberWithInt:12+materialCount];
            materialCount ++;
            material.materialEN = enArray[j];
            material.materialRU = ruArray[j];
            if(j > 0)
            {
                material.materialZH = chArray[j-1];
                material.materialZH_TR = pinArray[j-1];
            }
            [materialsArray addObject:material];
        }
    }
    return materialsArray;
}

+ (NSArray *) explanationsArray
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
