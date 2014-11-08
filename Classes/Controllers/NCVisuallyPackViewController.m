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

static CGFloat const NCVisuallyPackMaxBlurRadius = 20.f;
static CGFloat const NCVisuallySlideViewHeight = 60.f;

@interface NCVisuallyPackViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;

@property (strong, nonatomic) NSMutableSet *userIndexesFavoriteWords;

@property (strong, nonatomic) NCExplanationViewController *explanationViewController;

@property (strong, nonatomic) FXBlurView *frontBlurView;

@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

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
    if(self.ifFavorite)
    {
        self.favoriteButton.hidden = YES;
    }
    else
    {
        self.favoriteButton.hidden = NO;
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
}

- (void)setupExplanationViewController {
    NCExplanationViewController *explanationController = [self explanationViewController];
    explanationController.arrayOfExplanations = [self _explanations];
    
    explanationController.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - NCVisuallySlideViewHeight, CGRectGetWidth(explanationController.view.bounds), CGRectGetHeight(explanationController.view.bounds));
    
    [self.navigationController.view addSubview:[explanationController view]];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(explanationGesture:)];
    [explanationController.view addGestureRecognizer:panRecognizer];
    
    [self.navigationController.view addSubview:[self frontBlurView]];
    [self.navigationController.view addSubview:[explanationController view]];
}

#warning Test data
- (NSArray *)_explanations {
    return @[@{NCWordChineseKey: @"讓我們來看看他喜歡什麼，才能發表評論",
               NCWordPinyinKey: @"Ràng wǒmen lái kàn kàn tā xǐhuān shénme, cáinéng fābiǎo pínglùn",
               NCWordTranslateKey: @"Lorem ipsum dolor sit amet, consectetur adipiscing elit"},
             @{NCWordChineseKey: @"該薄膜為絕緣",
               NCWordPinyinKey: @"Gāi bómó wèi juéyuán",
               NCWordTranslateKey: @"Mauris in enim velit"},
             @{NCWordChineseKey: @"市長說貓生活的國家。",
               NCWordPinyinKey: @"Shìzhǎng shuō māo shēnghuó de guójiā.",
               NCWordTranslateKey: @"In euismod felis vitae adipiscing dictum"},
             @{NCWordChineseKey: @"這不止，門廊或設計師的下巴，發酵的非常的事",
               NCWordPinyinKey: @"Zhè bùzhǐ, ménláng huò shèjì shī de xiàbā, fāxiào de fēicháng de shì",
               NCWordTranslateKey: @"Etiam lacus quam, vestibulum vel faucibus gravida, fermentum id ipsum"},
             @{NCWordChineseKey: @"現在，前橄欖球隊。在廣泛的活動數據。",
               NCWordPinyinKey: @"Xiànzài, qián gǎnlǎnqiú duì. Zài guǎngfàn de huódòng shùjù.",
               NCWordTranslateKey: @"Nunc eu eleifend ante. Mauris rhoncus congue hendrerit. "}];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
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
    sender.selected = !sender.selected;
    NSLog(@"%@ -> %ld", ( sender.selected ) ? @"Like" : @"Dislike", (long)self.openedWordIndex );
    
    NSNumber *index = @(self.openedWordIndex);
    BOOL hasWord = [self.userIndexesFavoriteWords containsObject:index];
    if (sender.selected) {
        if (!hasWord) {
            [self.userIndexesFavoriteWords addObject:index];
            [[NCDataManager sharedInstance] setWordToFavorites:self.arrayOfWords[[index intValue]]];
        }
    } else {
        if (hasWord) {
            [self.userIndexesFavoriteWords removeObject:index];
        }
    }
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
    self.addFavoriteButton.selected = [self.userIndexesFavoriteWords containsObject:@(currentIndex)];
}

@end
