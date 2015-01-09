//
//  NCTestResultViewController.m
//  NakedChinese
//
//  Created by IMAC  on 29.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCTestResultViewController.h"
#import <FXBlurView/FXBlurView.h>
#import "UIViewController+nc_interactionImageSetuper.h"
#import "NCNavigationBar.h"
#import "NCTestViewController.h"

@interface NCTestResultViewController ()
@property(weak, nonatomic) IBOutlet FXBlurView *backgroundBlurView;
@property (weak, nonatomic) IBOutlet NCNavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UILabel *badResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightResultLabel;
@end

@implementation NCTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rightResultsLabel setText:[NSString stringWithFormat:@"“%@”", self.rightResults]];
    [self setupBackgroundImage];
    
    [self.rightResultLabel setText:[NSString stringWithFormat:@"%i", self.rightResult.intValue]];
    [self.badResultLabel setText:[NSString stringWithFormat:@"%i", self.badResult.intValue]];
    
}

- (void)setRightResult:(NSNumber *)rightResult
{
    _rightResult = rightResult;
   
}

- (void)setBadResult:(NSNumber *)badResult
{
    _badResult = badResult;
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toBackAction:(id)sender {
    
   /*
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NCTestViewController * tc = (NCTestViewController *)[sb instantiateViewControllerWithIdentifier:@"testViewController"];
    [self.navigationController pushViewController:tc animated:YES];
    */
    for(UIViewController *vc in self.navigationController.childViewControllers)
    {
        if([vc isKindOfClass:[NCTestViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
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
