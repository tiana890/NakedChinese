//
//  NCGreetingViewController.m
//  NakedChinese
//
//  Created by IMAC  on 03.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCGreetingViewController.h"
#import "GreetingView.h"

@interface NCGreetingViewController ()
@property (strong, nonatomic) IBOutlet GreetingView *greetingView;
@property (strong, nonatomic) UIColor *tintColor;
@end

@implementation NCGreetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.greetingView setBackgroundImage:@"greet_background"];
    [self.greetingView addItemWithUpperText:@"НЕВАЖНО КАК ДОЛГО ТЫ УЧИШЬ" andBottomText:@"КИТАЙСКИЙ ЯЗЫК" andImage:@"greet_photo1"];
    [self.greetingView addItemWithUpperText:@"НО ПРИЕХАВ В КИТАЙ, ТЫ СТОЛКНЁШЬСЯ" andBottomText:@"С НАСТОЯЩИМ КИТАЙСКИМ ЯЗЫКОМ" andImage:@"greet_photo2"];
    [self.greetingView addItemWithUpperText:@"МЫ ДАДИМ ТЕБЕ САМОЕ СИЛЬНОЕ ОРУЖИЕ -" andBottomText:@"ЗНАНИЕ!" andImage:@"greet_photo3"];
    [self.greetingView addItemWithUpperText:@"ЭТОМУ НЕ УЧАТ В ИНСТИТУТЕ" andBottomText:@"ОБ ЭТОМ НЕ ПИШУТ В УЧЕБНИКАХ" andImage:@"greet_photo4"];
    [self.greetingView addItemWithUpperText:@"МЫ ОБНАЖИМ ВЕСЬ КИТАЙСКИЙ ЯЗЫК" andBottomText:@"ДЛЯ ТЕБЯ!" andImage:@"greet_photo5"];
    
    if(!self.openFromMenu)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
        self.tintColor = self.navigationController.navigationBar.tintColor;
        [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTintColor:self.tintColor];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
