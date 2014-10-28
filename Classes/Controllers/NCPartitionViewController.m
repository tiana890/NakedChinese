//
//  NCPartitionViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 18.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCPartitionViewController.h"
#import "NCPackViewController.h"
#import "NCMenuViewController.h"
#import "UIViewController+nc_interactionImageSetuper.h"

#import "NCNavigationBar.h"
#import "NCTabBar.h"
#import "NCToolBar.h"

#import "NCPackCell.h"

#import "UIImage+h568.h"
#import "FXBlurView.h"

#import "NCNavigationDelegateController.h"

#import "NCInteractionManager.h"
#import "NCInteractionView.h"

#import "NCDataManager.h"

#pragma mark Storyboard segues identifiers
static NSString *const NCPackControllerSegueIdentifier = @"toPackController";
static NSString *const NCMenuControllerSegueIdentifier = @"toMenuController";
static NSString *const NCTestControllerSegueIdentifier = @"toTestController";

#pragma mark Storyboard controllers identifiers
static NSString *const NCMenuStoryboardIdentifier = @"menuNavigationController";

#pragma mark Keys
static NSString *const NCPackControllerNumberKey = @"packNumberKey";
static NSString *const NCPackControllerTypeKey = @"typeKey";


#pragma mark -

@interface NCPartitionViewController () <UIToolbarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate, UINavigationControllerDelegate, NCInteractionViewDelegate, NCDataManagerProtocol>

@property (weak, nonatomic) IBOutlet FXBlurView *backgroundBlurView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NCTabBar *tabBar;
@property (weak, nonatomic) IBOutlet NCToolbar *toolBar;

@property (strong, nonatomic) UIBarButtonItem *leftBarButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *partitionSegmentedControl;

@property (weak, nonatomic) IBOutlet NCInteractionView *interactionView;

@property (strong, nonatomic) NCDataManager *dataManager;
@end

@implementation NCPartitionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableBackInteractive];
    
    [self saveLeftBarButton];
    
    [self.tabBar separatorLineHide:YES];
    [self.toolBar separatorLineHide:YES];
    
    [[NCInteractionManager sharedInstance] setInteractionHell:self.interactionView.hell];
    [[NCInteractionManager sharedInstance] setSoundLanguage:NCSoundLanguageRussian];
    
    self.interactionView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.dataManager = [NCDataManager sharedInstance];
    self.dataManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideBarLine];
    [self disableBlurViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self disableBlurViews];
}


#pragma mark - IBActions

- (IBAction)showInteractionView:(id)sender {
    [self hideShownUIElements];
}

- (IBAction)changedPartitionAction:(UISegmentedControl *)sender {
    NSLog(@"select partition");
    
    [self showHiddenUIElements];
    
    NSString *type = [[NSString alloc] init];
    switch (sender.selectedSegmentIndex) {
        case 0:
            type = @"sex";
            break;
        case 1:
            type = @"swear";
            break;
        case 2:
            type = @"slang";
            break;
        default:
            break;
    }
    [self.dataManager getNumberOfPacks:type];
}

#pragma mark - Custom Accessors

#pragma mark - Private

- (void)saveLeftBarButton {
    self.leftBarButton = [self.navigationItem leftBarButtonItem];
}

- (void)showHiddenUIElements {
    if (![self.backgroundBlurView isHidden]) {
        return;
    }
    
    self.navigationItem.leftBarButtonItem = [self leftBarButton];
    
    self.backgroundBlurView.dynamic = YES;
    self.backgroundBlurView.blurEnabled = YES;
    
    self.backgroundBlurView.hidden = NO;
    self.tabBar.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundBlurView.alpha = 1;
        self.tabBar.alpha = 1;
    } completion:^(BOOL finished) {
        self.backgroundBlurView.dynamic = NO;
        self.backgroundBlurView.blurEnabled = NO;
        [self hideBarsLinesAlgorithmFromCalculationScrollView:self.collectionView];
    }];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)hideShownUIElements {
    if ([self.backgroundBlurView isHidden]) {
        return;
    }
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundBlurView.alpha = 0;
        self.tabBar.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.backgroundBlurView.hidden = YES;
        self.tabBar.hidden = YES;
        
        [self.tabBar separatorLineHide:YES];
        [self.toolBar separatorLineHide:YES];
    }];
    
    [self.partitionSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)hideBarsLinesAlgorithmFromCalculationScrollView:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollHeight = scrollView.contentSize.height;
    CGFloat scrollViewHeight = scrollView.bounds.size.height;
    
    BOOL isHideToolbar = !(scrollOffset > 0);
    BOOL isHideTabBar = (scrollOffset >= scrollHeight-scrollViewHeight);
    
    [self.toolBar separatorLineHide:isHideToolbar];
    [self.tabBar separatorLineHide:isHideTabBar];
}

- (void)enableBackInteractive {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)disableBlurViews {
    [self.backgroundBlurView updateAsynchronously:NO completion:^{
        self.backgroundBlurView.blurEnabled = NO;
    }];
}

- (void)hideBarLine {
    [((NCNavigationBar *)self.navigationController.navigationBar) separatorLineHide:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"packCell";
    
    NCPackCell *packCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    packCell.packView.packNumber = indexPath.row+1;
//    packCell.packNumber = indexPath.row+1;
    
    return packCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Select %ld row", (long)indexPath.row);
    
    [self performSegueWithIdentifier:NCPackControllerSegueIdentifier sender:@{ NCPackControllerTypeKey: @(NCPackControllerOfNumber), NCPackControllerNumberKey: @(indexPath.row+1)}];
}

////Enable blur effect before scrolls
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.navigationBlurView.blurEnabled = self.tabBarBlurView.blurEnabled = YES;
//}
//
////Disabling blur after scrolling to prevent power shortage due to the effect of renovation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBarsLinesAlgorithmFromCalculationScrollView:scrollView];
}

#pragma mark - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    if (bar == [self toolBar]) {
        return UIBarPositionTopAttached;
    }
    return UIBarPositionAny;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger itemIndex = [tabBar.items indexOfObject:item];
    switch (itemIndex) {
        case 1:
            [self performSegueWithIdentifier:NCPackControllerSegueIdentifier sender:@{ NCPackControllerTypeKey: @(NCPackControllerOfFavorite)}];
            break;
        case 2:
            [self performSegueWithIdentifier:NCTestControllerSegueIdentifier sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:NCMenuControllerSegueIdentifier sender:self];
            break;
            
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabBar setSelectedItem:nil];
    });
}

#pragma mark - NCInteractionViewDelegate

- (void)interactionView:(NCInteractionView *)interactionView actionHell:(NCHell)hell {
    [[NCInteractionManager sharedInstance] playRandomSoundAtInteractionHell:hell];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NCPackControllerSegueIdentifier]) {
        NCPackViewController *destinationViewController = [segue destinationViewController];
        NCPackControllerType type = [sender[NCPackControllerTypeKey] unsignedIntegerValue];
        
        if (type == NCPackControllerOfNumber) {
            destinationViewController.packNumber = [sender[NCPackControllerNumberKey] unsignedIntegerValue];
        }
        destinationViewController.type = type;
    }
}

@end