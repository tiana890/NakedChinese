//
//  NCGreetingViewController.m
//  NakedChinese
//
//  Created by IMAC  on 03.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCGreetingViewController.h"
#import "GreetingView.h"
#import "NCAppDelegate.h"

@interface NCGreetingViewController ()
@property (strong, nonatomic) IBOutlet GreetingView *greetingView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) UIColor *tintColor;
@end

@implementation NCGreetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.greetingView setBackgroundImage:@"greet_background"];
    
    for(int i = 0; i < 5; i++)
    {
        
        NSString *upString =[NSString stringWithFormat:@"greet_%i_up", i+1];
        NSString *bottomString = [NSString stringWithFormat:@"greet_%i_bottom", i+1];
        [self.greetingView addItemWithUpperText:NSLocalizedString(upString, nil) andBottomText:NSLocalizedString(bottomString, nil) andImage:[NSString stringWithFormat:@"greet_photo%i", i+1]];
    }
    
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
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
- (IBAction)nextButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.startViewController.mainView.hidden = NO;
    appDelegate.startViewController.greetingView.hidden = YES;
}

@end
