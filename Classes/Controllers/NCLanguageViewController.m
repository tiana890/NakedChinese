//
//  NCLanguageViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 29.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCLanguageViewController.h"
#import "UIViewController+nc_interactionImageSetuper.h"

@interface NCLanguageViewController ()

@end

@implementation NCLanguageViewController



#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackgroundImage];
}

#pragma mark - IBActions

- (IBAction)toBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideMenuAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Private

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
