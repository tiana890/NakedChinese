//
//  NCJokeItemViewController.m
//  NakedChinese
//
//  Created by IMAC  on 22.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCJokeItemViewController.h"
#import "NCPackView.h"
#import "UIViewController+nc_interactionImageSetuper.h"
#import <FXBlurView.h>

@interface NCJokeItemViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet FXBlurView *backgroundBlurView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation NCJokeItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationItem];
    [self setupBackgroundImage];
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    float width = frame.size.width-20.0f;
    
    NSString *htmlLine = [NSString stringWithFormat:@"<hr align=\"center\" width=\"%f\" size=\"1\" color=\"#433a39\" />", width];
    NSString *str = [NSString stringWithFormat:@"<html>\
                     <head>\
                     </head>\
                     <body>\
                     <style>\
                     li {\
                         list-style-type: none; /* Убираем маркеры */\
                     }\
                     ul {\
                         margin-left: 0; /* Отступ слева в браузере IE и Opera */\
                         padding-left: 0; /* Отступ слева в браузере Firefox, Safari, Chrome */\
                     }\
                     </style>\
                     <ul>\
                     <li><p><font color=\"#433a39\">一对夫妇参观一个养牛场, 农场主为他们介绍，说：\
                     “这头公牛一星期可交配三次。”\
                     　　老婆回头瞪了一眼丈夫说：“你看人家。”\
                     　　到第二头公牛前，农场主说：“这头牛一星期交配五次。”\
                     　　老婆又瞪了丈夫说“你看人家。”\
                     　　到了第三头牛跟前，\
                     农场主说：“这头牛一星期里天天都可交配。”\
                     　　老公问农场主：“你这公牛每天是跟不同的母牛交配呢，\
                     还是同一头母牛？”\
                     　　农场主：“当然不同的母牛了。”\
                     　　老公对老婆大吼：“你看人家！”</font></p></li>\
                     %@\
                     <li><p><font color=\"#433a39\">Yī duì fūfù cānguān yīgè yǎng niú chǎng,\
                     nóngchǎng zhǔ wèi tāmen jièshào, shuō:\
                     “Zhè tóu gōngniú yī xīngqí kě jiāopèi sāncì.”\
                     Lǎopó huítóu dèngle yīyǎn zhàngfū shuō:“Nǐ kàn rénjiā.”\
                     Dào dì èr tóu gōngniú qián, nóngchǎng zhǔ shuō:\
                     “Zhè tóu niú yī xīngqí jiāopèi wǔ cì.”\
                     Lǎopó yòu dèngle zhàngfū shuō “nǐ kàn rénjiā.”\
                     Dàole dì sān tóu niú gēnqián,\
                     nóngchǎng zhǔ shuō:\
                     “Zhè tóu niú yī xīngqí lǐ tiāntiān dū kě jiāopèi.”\
                     Lǎogōng wèn nóngchǎng zhǔ:\
                     “Nǐ zhè gōngniú měitiān shì gēn bùtóng de mǔ niú jiāopèi ne,\
                     háishì tóngyī tóu mǔ niú?”\
                     Nóngchǎng zhǔ:“Dāngrán bùtóng de mǔ niúle.”\
                     Lǎogōng duì lǎopó dà hǒu:“Nǐ kàn rénjiā!”</font></p></li>\
                     %@\
                     <li><p><font color=\"#433a39\">Супружеская пара пришла с экскурсией на ферму по\
                     выращиванию крупного рогатого скота\
                     Работник фермы говорит: “Этот бык каждую неделю\
                     совокупляется три раза.”\
                     Жена, глядя на мужа говорит: “Вот где надо учиться.”\
                     Дойдя до второго быка фермер объясняет: “Этот бык\
                     кажду неделю совокупляется пять раз.”\
                     Жена вновь говорит мужу: “Вот где надо учиться.”\
                     Около третьего быка фермер говорит: “Этот бык\
                     совокупляется каждый ден.”\
                     Муж его спрашивает: “А этот бык каждый день \
                     совокупляется с разными самками или с одной и той же \
                     коровой?”\
                     Хермер: “Конечно же с разными.”\
                     Муж кричит своей жене: “Вот где надо учится!”</font></p></li>\
                     </ul>\
                     <br />\
                     </body>\
                     </html>",htmlLine, htmlLine];
    [self.webView loadHTMLString:str baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationItem {
    UIView *titleView = nil;

    const CGRect circleRect = CGRectMake(0, 0, 32, 32);
    NCPackView *circleView = [NCPackView packViewWithFrame:circleRect];
    circleView.packNumber = self.number.integerValue+1;
    circleView.fontSize = 22.f;
    circleView.borderWidth = 0.8f;
    titleView = circleView;
    
    self.navigationItem.titleView = titleView;
}

- (IBAction)toBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Web View

@end
