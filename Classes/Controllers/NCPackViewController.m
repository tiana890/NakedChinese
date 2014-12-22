//
//  NCPackViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 27.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCPackViewController.h"
#import "UIImageView+AFNetworking.h"

#import "NCNavigationBar.h"
#import "NCWordCell.h"
#import "NCWordLockCell.h"
#import "NCPackView.h"
#import "NCToolbar.h"

#import <FXBlurView/FXBlurView.h>

#import "NCConstants.h"

#import "NCVisuallyPackViewController.h"

#import "NCDataManager.h"
#import "NCWord.h"


#define SERVER_ADDRESS @"http://china:8901/upload/picture/"

static NSString *const NCPackControllerWordIndexKey = @"NCPackControllerWordIndexKey";

static NSString *const NCVisuallyPackControllerSegueIdentifier = @"toVisuallyPackController";
static NSString *const NCVisuallyPackControllerSearchSegueIdentifier = @"toVisuallyPackController";

#pragma mark Table view cell identifiers
static NSString *const NCWordCellIdentifier = @"wordCell";
static NSString *const NCWordLockCellIdentifier = @"wordLockCell";

#pragma mark Constants
const CGFloat KeyboardHeight = 216.f;
const NSTimeInterval SearchCollectionViewAnimationDuration = 0.3;

@interface NCPackViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIToolbarDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, NCDataManagerProtocol>

@property (weak, nonatomic) IBOutlet FXBlurView *navigationBlurView;
@property (weak, nonatomic) IBOutlet FXBlurView *searchBlurView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

@property (nonatomic, strong) NSArray *arrayOfWords;
@property (nonatomic, strong) NSArray *arrayOfFavorites;
@property (nonatomic, strong) NSMutableArray *searchArrayOfWords;
@end

@implementation NCPackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self disableBlurView];
    
    switch ([self type]) {
        case NCPackControllerOfNumber:
        {
            [NCDataManager sharedInstance].delegate = self;
            if([self.pack.paid isEqualToNumber:@1])
            {
                [[NCDataManager sharedInstance] getWordsWithPackID:[self.pack.ID intValue]];
            }
            break;
        }
        case NCPackControllerOfFavorite:
        {
            [NCDataManager sharedInstance].delegate = self;
            [[NCDataManager sharedInstance] getFavorites];
            break;
        }
        default:
            break;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self disableBlurView];
}

#pragma mark getter
- (NSMutableArray *)searchArrayOfWords
{
    if(!_searchArrayOfWords) _searchArrayOfWords = [[NSMutableArray alloc] init];
    
        return _searchArrayOfWords;
}
#pragma  mark DataManager Protocol methods

- (void)ncDataManagerProtocolGetWordsWithPackID:(NSArray *)arrayOfWords
{
    self.arrayOfWords = arrayOfWords;
    [self.collectionView reloadData];
}

- (void)ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites
{
    self.arrayOfFavorites = arrayOfFavorites;
    [self.collectionView reloadData];
}

- (void)ncDataManagerProtocolGetSearchWordContainsString:(NSArray *)arrayOfWords
{
    [self.searchArrayOfWords removeAllObjects];
    [self.searchArrayOfWords addObjectsFromArray:arrayOfWords];
    [self.searchCollectionView reloadData];
}
#pragma mark - IBActions

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(id)sender {
    [self startSearch];
}

#pragma mark - Private

- (void)hideSearchCollectionViewWithCompletion:(void (^)(void))completion {
    self.navigationController.navigationBar.hidden = NO;
    [UIView animateWithDuration:SearchCollectionViewAnimationDuration animations:^{
        self.navigationController.navigationBar.alpha = 1;
        
        self.searchBlurView.alpha = 0;
        self.searchBlurView.blurRadius = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.searchBlurView.hidden = YES;
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)showSearchCollectionViewWithCompletion:(void (^)(void))completion {
    self.searchBlurView.hidden = NO;
    [UIView animateWithDuration:SearchCollectionViewAnimationDuration animations:^{
        self.navigationController.navigationBar.alpha = 0;
        
        self.searchBlurView.alpha = 1;
        self.searchBlurView.blurRadius = 20;
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationController.navigationBar.hidden = YES;
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)startSearch {
    [self.searchArrayOfWords removeAllObjects];
    [self.searchBar setText:@""];
    
    [self.searchCollectionView reloadData];
    self.searchBlurView.blurEnabled = YES;
    [self showSearchCollectionViewWithCompletion:^{
        [self.searchBar becomeFirstResponder];
    }];
}

- (void)cancelSearch {
    self.searchBlurView.blurEnabled = NO;
    [self.searchBar resignFirstResponder];
    [self hideSearchCollectionViewWithCompletion:nil];

}

- (void)disableBlurView {
    self.navigationBlurView.blurEnabled = NO;
}

- (void)setupNavigationItem {
    UIView *titleView = nil;
    switch ([self type]) {
        case NCPackControllerOfNumber:
        {
            const CGRect circleRect = CGRectMake(0, 0, 32, 32);
            NCPackView *circleView = [NCPackView packViewWithFrame:circleRect];
            circleView.packNumber = [self packNumber];
            circleView.fontSize = 22.f;
            circleView.borderWidth = 0.8f;
            titleView = circleView;
        }break;
        case NCPackControllerOfFavorite:
        {
            UIImage *favIcon = [UIImage imageNamed:@"nc_heart_a_nav"];
            UIImageView *favoriteView = [[UIImageView alloc] initWithImage:favIcon];
            titleView = favoriteView;
        }break;
    }
    
    self.navigationItem.titleView = titleView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.collectionView)
    {
        switch ([self type]) {
            case NCPackControllerOfNumber:
            {
                if([self.pack.paid isEqualToNumber:@1])
                    return self.arrayOfWords.count;
                else
                    return 12;
            }
                break;
            case NCPackControllerOfFavorite:
                return self.arrayOfFavorites.count;
            default:
                break;
        }
    }
    else if(collectionView == self.searchCollectionView)
    {
        return self.searchArrayOfWords.count;
    }
    
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.collectionView)
    {
        switch ([self type]) {
            case NCPackControllerOfNumber:
            {
                NCWordCell *openCell = nil;
                
                NCWord *word = self.arrayOfWords[indexPath.item];
                if([self.pack.paid isEqualToNumber:@1])
                {
                    openCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordCellIdentifier forIndexPath:indexPath];
                    UIImage *image = [UIImage imageNamed:word.image];
                    [openCell.pictureView setImage:image];
                    [openCell.chineseLabel setText:word.material.materialZH];
                    [openCell.pinyinLabel setText:word.material.materialZH_TR];
                    NSString *str = [self cutFirstWord:word.material.materialWord];
                    [openCell.translateLabel setText:str];
                    return openCell;
                }
                else
                {
                    NCWordLockCell *lockCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordLockCellIdentifier forIndexPath:indexPath];
                   
                    
                    return lockCell;
                }
                break;
            }
                
            case NCPackControllerOfFavorite:
            {
                NCWordCell *openCell = nil;
                NCWord *word = self.arrayOfFavorites[indexPath.item];
                if([word.packID isEqualToNumber:@1])
                {
                    openCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordCellIdentifier forIndexPath:indexPath];
                    UIImage *image = [UIImage imageNamed:word.image];
                    [openCell.pictureView setImage:image];
                    [openCell.chineseLabel setText:word.material.materialZH];
                    [openCell.pinyinLabel setText:word.material.materialZH_TR];
                    [openCell.translateLabel setText:word.material.materialWord];
                }
                return openCell;
            }
            default:
                break;
        }
    }
    else if(collectionView == self.searchCollectionView)
    {
        NCWordCell *openCell = nil;
        
        NCWord *word = self.searchArrayOfWords[indexPath.item];
        openCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordCellIdentifier forIndexPath:indexPath];
        UIImage *image = [UIImage imageNamed:word.image];
        [openCell.pictureView setImage:image];
        [openCell.chineseLabel setText:word.material.materialZH];
        [openCell.pinyinLabel setText:word.material.materialZH_TR];
        [openCell.translateLabel setText:word.material.materialWord];
        return openCell;
    }
    return nil;
}

- (NSString *) cutFirstWord:(NSString *) str
{
    NSArray * words = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words)
    {
        return word;
    }
    return str;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    if (collectionView == [self searchCollectionView]) {
        [self cancelSearch];
    }*/
    if(collectionView == self.collectionView)
    {
        if ([self.pack.paid isEqualToNumber:@1]) {
            [self performSegueWithIdentifier:NCVisuallyPackControllerSegueIdentifier sender:@{NCPackControllerWordIndexKey: @(indexPath.item), @"search":@0}];
        }
    }
    else if(collectionView == self.searchCollectionView)
    {
        [self performSegueWithIdentifier:NCVisuallyPackControllerSearchSegueIdentifier sender:@{NCPackControllerWordIndexKey: @(indexPath.item), @"search":@1}];
        
    }
    
}

//Enable blur effect before scrolls
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == [self collectionView]) {
        self.navigationBlurView.blurEnabled = YES;
    }
}

//Disabling blur after scrolling to prevent power shortage due to the effect of renovation
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == [self collectionView]) {
        self.navigationBlurView.blurEnabled = NO;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelSearch];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, KeyboardHeight, 0);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [NCDataManager sharedInstance].delegate = self;
    [[NCDataManager sharedInstance] searchWordContainsString:searchBar.text];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender[@"search"] intValue] == 0)
    {
        
        NSInteger openedWordIndex = [sender[NCPackControllerWordIndexKey] integerValue];
        NCVisuallyPackViewController *packViewController = [segue destinationViewController];
        
        packViewController.openedWordIndex = openedWordIndex;
        switch ([self type]) {
            case NCPackControllerOfNumber:
            {
                packViewController.arrayOfWords = self.arrayOfWords;
                break;
            }
            case NCPackControllerOfFavorite:
            {
                packViewController.arrayOfWords = self.arrayOfFavorites;
                packViewController.ifFavorite = YES;
                break;
            }
            
            default:
                break;
        }
    
    }
    else
    {
        NSInteger openedWordIndex = [sender[NCPackControllerWordIndexKey] integerValue];
        NCVisuallyPackViewController *packViewController = [segue destinationViewController];
        
        packViewController.openedWordIndex = openedWordIndex;
        packViewController.arrayOfWords = self.searchArrayOfWords;
        [self cancelSearch];
    }
    
}

@end
