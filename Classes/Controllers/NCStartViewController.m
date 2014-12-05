//
//  NCStartViewController.m
//  NakedChinese
//
//  Created by IMAC  on 06.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCStartViewController.h"
#import "NCAppDelegate.h"

@interface NCStartViewController ()


@end

@implementation NCStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.startViewController = self;
    if(!appDelegate.ifFirstLaunch)
    {
        self.mainView.hidden = YES;
        self.greetingView.hidden = NO;
    }
    else
    {
        self.greetingView.hidden = YES;
        self.mainView.hidden = NO;
    }
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
