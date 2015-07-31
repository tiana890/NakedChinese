//
//  NCJokesViewController.m
//  NakedChinese
//
//  Created by IMAC  on 22.12.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCJokesViewController.h"
#import "NCPackCell.h"
#import "FXBlurView.h"
#import "UIViewController+nc_interactionImageSetuper.h"
#import "NCJokeItemViewController.h"
#import "NCDataManager.h"
#import "NCWord.h"
#import "NCNavigationBar.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface NCJokesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, NCDataManagerProtocol, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FXBlurView *backgroundBlurView;
@property (nonatomic, strong) NSArray *arrayOfJokes;
@end

@implementation NCJokesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateNavigationItemsIfNeeded];
    [self setupBackgroundImage];
    if(self.fromAppDelegate == YES)
    {
        self.fromAppDelegate = NO;
        //[self performSegueWithIdentifier:@"toJokeItem" sender:self];
        UIStoryboard *storyboard = self.storyboard;
        NCJokeItemViewController *jc = [storyboard instantiateViewControllerWithIdentifier:@"jokeItemViewController"];
        jc.number = self.jokeNumber;
        [self.navigationController pushViewController:jc animated:YES];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self updateNavigationItemsIfNeeded];
    [NCDataManager sharedInstance].delegate = self;
    [[NCDataManager sharedInstance] getLocalWordsWithPackID:@16];
}
- (IBAction)sendJoke:(id)sender
{
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    [mailViewController setToRecipients:@[@"nakedjokes@yahoo.com"]];
    mailViewController.mailComposeDelegate = self;
    //[mailViewController setSubject:NSLocalizedString(@"send_joke_subject", nil)];
    [mailViewController setMessageBody:NSLocalizedString(@"send_joke_body", nil) isHTML:NO];
    
    [self presentViewController:mailViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"Error sending joke = %@", error.description);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ncDataManagerProtocolGetLocalWordsWithPackID:(NSArray *)arrayOfWords
{
    self.arrayOfJokes = arrayOfWords;
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateNavigationItemsIfNeeded {
    if (![self isOpenFromMenu]) {
        self.navigationItem.leftBarButtonItem = [self.navigationItem rightBarButtonItem];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)popToPartitionControllerAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrayOfJokes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"packCell";
    
    int numberOfItems = [self collectionView:collectionView numberOfItemsInSection:0];
    NCPackCell *packCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    packCell.packView.packNumber = numberOfItems - indexPath.row;
    //  packCell.packNumber = indexPath.row+1;
    return packCell;
}

#pragma mark - UICollectionViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *array = [self.collectionView indexPathsForSelectedItems];
    NCJokeItemViewController *ic = (NCJokeItemViewController *)segue.destinationViewController;
    if(array.count > 0)
    {
        int numberOfItems = [self collectionView:self.collectionView numberOfItemsInSection:0];
        int num = numberOfItems - ((NSIndexPath *)array[0]).row - 1;
        ic.number = [NSNumber numberWithInt:num];
        ic.joke = self.arrayOfJokes[((NSIndexPath *)array[0]).row];
    }
    else
    {
        ic.number = self.jokeNumber;
    }
}

////Enable blur effect before scrolls
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.navigationBlurView.blurEnabled = self.tabBarBlurView.blurEnabled = YES;
//}
//
////Disabling blur after scrolling to prevent power shortage due to the effect of renovation
- (void)disableBlurViews {
    [self.backgroundBlurView updateAsynchronously:NO completion:^{
        self.backgroundBlurView.blurEnabled = NO;
    }];
}

- (IBAction)toBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideBarsLinesAlgorithmFromCalculationScrollView:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    BOOL isHideNavLine = !(scrollOffset > 0);
    [((NCNavigationBar *)self.navigationController.navigationBar) separatorLineHide:isHideNavLine];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBarsLinesAlgorithmFromCalculationScrollView:scrollView];
}
@end
