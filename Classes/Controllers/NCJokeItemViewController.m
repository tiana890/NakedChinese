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
#import "NCNavigationBar.h"

@interface NCJokeItemViewController ()<UIWebViewDelegate, UIScrollViewDelegate>
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
    self.webView.scrollView.delegate = self;
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
                     <li><p><font color=\"#2B2727\" size=\"4\">%@</font></p></li>\
                     %@\
                     <li><p><font color=\"#2B2727\" size=\"4\">%@</font></p></li>\
                     %@\
                     <li><p><font color=\"#2B2727\" size=\"4\">%@</font></p></li>\
                     </ul>\
                     <br />\
                     </body>\
                     </html>",self.joke.material.materialZH, htmlLine, self.joke.material.materialZH_TR, htmlLine, self.joke.material.materialWord];
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
- (void)hideBarsLinesAlgorithmFromCalculationScrollView:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    BOOL isHideNavLine = !(scrollOffset > 0);
    [((NCNavigationBar *)self.navigationController.navigationBar) separatorLineHide:isHideNavLine];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBarsLinesAlgorithmFromCalculationScrollView:scrollView];
}
#pragma mark - Web View

@end
