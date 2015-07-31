//
//  NCVisuallyPackViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 28.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCVisuallyPackViewController.h"

#import "NCExplanationViewController.h"
#import "NCWordContentViewController.h"
#import "NCDataManager.h"

#import <FXBlurView/FXBlurView.h>

#import "NCConstants.h"

#import "NCWord.h"
#import "NCMaterial.h"

#import "NCSlidingViewController.h"

static CGFloat const NCVisuallyPackMaxBlurRadius = 20.f;
static CGFloat const NCVisuallySlideViewHeight = 75.f;

@interface NCVisuallyPackViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NCDataManagerProtocol, NCSLidingViewControllerProtocol>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NCSlidingViewController *slidingViewController;

@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;

@property (strong, nonatomic) NSMutableSet *userIndexesFavoriteWords;

@property (strong, nonatomic) NCExplanationViewController *explanationViewController;

@property (strong, nonatomic) FXBlurView *frontBlurView;

@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@property(nonatomic, strong) NSArray *materials;

@end

@implementation NCVisuallyPackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPageViewController];
    [self setupExplanationViewController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavItemFavoriteButton];
    
    NCWord *word = self.arrayOfWords[self.openedWordIndex];
    [NCDataManager sharedInstance].delegate = self;
    [[NCDataManager sharedInstance] getMaterialsWithWordID:word.ID.intValue];
    
    [self setupExplanationViewController];
    
}

- (void)ncDataManagerProtocolGetMaterialsWithWordID:(NSArray *)arrayOfMaterials
{
    self.materials = arrayOfMaterials;
    NCExplanationViewController *explanationViewController = [self explanationViewController];
    explanationViewController.arrayOfExplanations = arrayOfMaterials;
}
//set navItems depending on type of controller: favorite or non-favorite
- (void) setNavItemFavoriteButton
{
    if(self.ifFavorite)
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"nc_heart_a_nav"] forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"nc_heart_nav"] forState:UIControlStateSelected];
    }
    else
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"nc_heart_a_nav"] forState:UIControlStateSelected];
        [self.favoriteButton setImage:[UIImage imageNamed:@"nc_heart_nav"] forState:UIControlStateNormal];
        
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.frontBlurView removeFromSuperview];
    [self.explanationViewController.view removeFromSuperview];
}

#pragma mark - Custom Accessors

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"pageController"];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    
    }
    return _pageViewController;
}

- (NCSlidingViewController *)slidingViewController
{
    if(!_slidingViewController){
        _slidingViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"slidingViewController"];
        _slidingViewController.delegate = self;
    }
    return _slidingViewController;
}

- (NSMutableSet *)userIndexesFavoriteWords {
    if (!_userIndexesFavoriteWords) {
        _userIndexesFavoriteWords = [NSMutableSet set];
    }
    return _userIndexesFavoriteWords;
}

- (NCExplanationViewController *)explanationViewController {
    if (!_explanationViewController) {
        _explanationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"explanationController"];
    }
    return _explanationViewController;
}

- (FXBlurView *)frontBlurView {
    if (!_frontBlurView) {
        _frontBlurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _frontBlurView.tintColor = [UIColor clearColor];
        _frontBlurView.blurRadius = 0.f;
        _frontBlurView.dynamic = NO;
        _frontBlurView.alpha = 0.f;
    }
    return _frontBlurView;
}

#pragma mark - Private

- (void)setupPageViewController {
    
    NCWordContentViewController *contentViewController = (id)[self viewControllerAtIndex:[self openedWordIndex]];
    NSArray *viewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame =
    CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    [self addChildViewController:[self pageViewController]];
    [self.view addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self setupFavButton:[self openedWordIndex]];
     
        /*
    for(int i = 0; i < self.arrayOfWords.count; i++)
    {
        NCWordContentViewController *contentViewController = (id)[self viewControllerAtIndex:i];
        [self.slidingViewController addController:contentViewController];
    }
    
    [self.slidingViewController setOpenedIndex:[self openedWordIndex]];
    //[self.slidingViewController scrollToPage:[self openedWordIndex]];
    
    self.slidingViewController.view.frame =
    CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    
    [self addChildViewController:[self slidingViewController]];
    [self.view addSubview:[self.slidingViewController view]];
    [self.slidingViewController didMoveToParentViewController:self];
    
    [self setupFavButton:[self openedWordIndex]];
     */
}

- (void)setupExplanationViewController {
    NCExplanationViewController *explanationController = [self explanationViewController];
    explanationController.arrayOfExplanations = self.materials;
    
    explanationController.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - NCVisuallySlideViewHeight, CGRectGetWidth(explanationController.view.bounds), CGRectGetHeight(explanationController.view.bounds));
    
    [self.navigationController.view addSubview:[explanationController view]];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(explanationGesture:)];
    [explanationController.view addGestureRecognizer:panRecognizer];
    
    [self.navigationController.view addSubview:[self frontBlurView]];
    [self.navigationController.view addSubview:[explanationController view]];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    NCWord *word = self.arrayOfWords[self.openedWordIndex];
    [NCDataManager sharedInstance].delegate = self;
    [[NCDataManager sharedInstance] getMaterialsWithWordID:word.ID.intValue];
   
    if (([self.arrayOfWords count] == 0) || (index >= [self.arrayOfWords count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    NCWordContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"wordContentViewController"];
    
    //contentViewController.dictionaryWithWord = self.arrayOfWords[index];
    contentViewController.word = self.arrayOfWords[index];
    contentViewController.pageIndex = index;
    return contentViewController;
}

- (void) setupFavButton:(NSUInteger) index
{
    //устанавливаем корректно кнопку "избранное", если слово там есть, то она должна быть в состоянии selected
    if(!self.ifFavorite)
    {
        BOOL ifWordExistsInFavorites = NO;
        NCWord *word = self.arrayOfWords[index];
        ifWordExistsInFavorites = [[NCDataManager sharedInstance] ifExistsInFavorites:word];
        if(ifWordExistsInFavorites)
        {
            self.favoriteButton.selected = YES;
        }
        else
        {
            self.favoriteButton.selected = NO;
        }
    }
}

- (void)enabledInteractivePopGestureRecognizer:(BOOL)enabled {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enabled;
    }
}

- (void)explanationGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    UIGestureRecognizerState gestureState = [gestureRecognizer state];
    
    static BOOL isExplanationHided = NO;
    
    if (gestureState == UIGestureRecognizerStateBegan
        || gestureState == UIGestureRecognizerStateChanged) {
        
        __weak UIView *explanationView = [self.explanationViewController view];
        __weak UIView *mainView = [self.navigationController view];
        CGFloat mainViewHeight = CGRectGetHeight(self.view.frame);
        
        CGPoint translation = [gestureRecognizer translationInView:mainView];
        
        CGFloat explanationY = CGRectGetMinY(explanationView.frame);
        
        const CGFloat maximumY = 0.f;
        const CGFloat minimumY = mainViewHeight - NCVisuallySlideViewHeight;
        CGFloat translationDelta = (explanationY + translation.y);
        //NSLog(@"%f",minY-translationDelta);
        if (translationDelta < minimumY && translationDelta > maximumY ) {
            [explanationView setCenter:CGPointMake([explanationView center].x, [explanationView center].y + translation.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:mainView];
            isExplanationHided = (translation.y > 0);
            
            const CGFloat displayHeightPercents = (minimumY - translationDelta) / (minimumY / 100);
            
            const CGFloat blurPercent = NCVisuallyPackMaxBlurRadius / 100;
            const CGFloat alphaPercent = 1.0 / 100;
            
            self.frontBlurView.blurRadius = displayHeightPercents * blurPercent;
            self.frontBlurView.alpha = displayHeightPercents * alphaPercent;
            
            self.explanationViewController.state = isExplanationHided ? NCExplanationSliderDragToDown : NCExplanationSliderDragToUp;
        }
        
    } else if (gestureState == UIGestureRecognizerStateEnded) {
        if (isExplanationHided) {
            [self animationHideExplanations];
        } else {
            [self animationShowExplanations];
        }
    }
}

- (void)animationHideExplanations {
    [UIView animateWithDuration:0.5 animations:^{
        __weak UIView *explanationView = [self.explanationViewController view];
        explanationView.frame = CGRectMake(0,
                                           CGRectGetHeight(explanationView.frame) - NCVisuallySlideViewHeight,
                                           CGRectGetWidth(explanationView.frame),
                                           CGRectGetHeight(explanationView.frame));
        self.frontBlurView.blurRadius = 0.f;
        self.frontBlurView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.explanationViewController.state = NCExplanationSliderHidden;
        //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }];
}

- (void)animationShowExplanations {
    [UIView animateWithDuration:0.5 animations:^{
        __weak UIView *explanationView = [self.explanationViewController view];
        
        explanationView.frame = (CGRect){
            CGPointZero,
            CGSizeMake(CGRectGetWidth(explanationView.frame),
                       CGRectGetHeight(explanationView.frame))
        };
        self.frontBlurView.blurRadius = NCVisuallyPackMaxBlurRadius;
        self.frontBlurView.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.explanationViewController.state = NCExplanationSliderVisible;
        //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }];
}

#pragma mark IBActions

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addToFavorite:(UIButton *)sender {
    if(!self.ifFavorite)
    {
        sender.selected = !sender.selected;
        NSNumber *index = @(self.openedWordIndex);
        BOOL hasWord = [self.userIndexesFavoriteWords containsObject:index];
        if (sender.selected) {
            if (!hasWord) {
                [self.userIndexesFavoriteWords addObject:index];
                [[NCDataManager sharedInstance] setWordToFavorites:self.arrayOfWords[[index intValue]]];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"add_to_fav_alert", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.8f];
        }
        else
        {
            [[NCDataManager sharedInstance] removeWordFromFavorites:self.arrayOfWords[[index intValue]]];
            [self.userIndexesFavoriteWords removeObject:index];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"remove_from_fav_alert", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.8f];

        }
    }
    else
    {
        NSNumber *index = @(self.openedWordIndex);
        if(!sender.selected)
        {
            [[NCDataManager sharedInstance] removeWordFromFavorites:self.arrayOfWords[[index intValue]]];
            [self.userIndexesFavoriteWords removeObject:index];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"remove_from_fav_alert", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.8f];

        }
        else
        {
            [self.userIndexesFavoriteWords addObject:index];
            [[NCDataManager sharedInstance] setWordToFavorites:self.arrayOfWords[[index intValue]]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"add_to_fav_alert", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.8f];
        }
        sender.selected = !sender.selected;
    }
}

- (void) dismiss:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - UIPageViewControllerDataSource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((NCWordContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
   
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((NCWordContentViewController*) viewController).pageIndex;
    
    if ((index == NSNotFound) || (index+1 == [self.arrayOfWords count])) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    
    NCWordContentViewController *wordContentController = [self.pageViewController.viewControllers firstObject];
    
    NSUInteger currentIndex = [wordContentController pageIndex];
    
    self.openedWordIndex = currentIndex;
    [self setupFavButton:currentIndex];
    //self.addFavoriteButton.selected = [self.userIndexesFavoriteWords containsObject:@(currentIndex)];
    
}

#pragma mark - NCSlidingViewControllerProtocol
- (void)ncSLidingViewControllerProtocolCurrentIndexChanged:(int)index
{
    self.openedWordIndex = index;
    [self setupFavButton:index];
    NCWord *word = self.arrayOfWords[self.openedWordIndex];
    [NCDataManager sharedInstance].delegate = self;
    [[NCDataManager sharedInstance] getMaterialsWithWordID:word.ID.intValue];
}

@end
