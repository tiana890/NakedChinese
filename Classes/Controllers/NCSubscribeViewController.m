//
//  NCSubscribeViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 29.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCSubscribeViewController.h"
#import "UIViewController+nc_interactionImageSetuper.h"
#import "NCNavigationBar.h"

@interface NCSubscribeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *siteLink;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UILabel *descr;

@end

@implementation NCSubscribeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackgroundImage];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if([NSLocalizedString(@"lang", nil) isEqualToString:@"en"])
    {
        self.scroll.hidden = YES;
        self.siteLink.hidden = YES;
        self.lineView.hidden = YES;
        self.descriptionLabel.hidden = YES;
        self.descr.hidden = YES;
    }
    else
    {
        self.scroll.hidden = NO;
        self.siteLink.hidden = NO;
        self.lineView.hidden = NO;
        self.descriptionLabel.hidden = NO;
        self.descr.hidden = NO;
    }
    NSLog(@"frame = %@", NSStringFromCGRect(self.descr.frame));
}

#pragma mark - IBActions

- (IBAction)toBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideMenuAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
- (IBAction)goToSite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://newwaytochina.com"]];
}


@end
