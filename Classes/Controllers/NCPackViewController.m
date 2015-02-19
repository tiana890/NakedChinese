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

#import "NCIAHelper.h"

#import "NCProductDownloader.h"
#import "NCStaticPackIdentifier.h"

#import "NakedChinese-Swift.h"

#import <UIKit/UIKit.h>

#define SERVER_ADDRESS @"http://nakedchineseapp.com/upload/picture/"

static NSString *const NCPackControllerWordIndexKey = @"NCPackControllerWordIndexKey";

static NSString *const NCVisuallyPackControllerSegueIdentifier = @"toVisuallyPackController";
static NSString *const NCVisuallyPackControllerSearchSegueIdentifier = @"toVisuallyPackController";

#pragma mark Table view cell identifiers
static NSString *const NCWordCellIdentifier = @"wordCell";
static NSString *const NCWordLockCellIdentifier = @"wordLockCell";

#pragma mark Constants
const CGFloat KeyboardHeight = 216.f;
const NSTimeInterval SearchCollectionViewAnimationDuration = 0.3;

@interface NCPackViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIToolbarDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, NCDataManagerProtocol, UIAlertViewDelegate, NCProductDownloaderProtocol>

@property (weak, nonatomic) IBOutlet FXBlurView *navigationBlurView;
@property (weak, nonatomic) IBOutlet FXBlurView *searchBlurView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

@property (nonatomic, strong) NSArray *arrayOfWords;
@property (nonatomic, strong) NSArray *arrayOfFavorites;
@property (nonatomic, strong) NSMutableArray *searchArrayOfWords;

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) SKProduct *prod;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) KYCircularProgress *circularProgress;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic) float progressCount;

@end

@implementation NCPackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.progress.progress = 0.0f;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [NCProductDownloader sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAHelperProductNotPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ncProductDownloaderProtocolProductDownloaded:) name:NCProductDownloaderNotificationProductDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ncProductDownloaderProtocolProductProgressPercentValue:) name:NCProductDownloaderNotificationProgressBarValue object:nil];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    [indicator setFrame:CGRectMake(mainFrame.size.width/2-indicator.frame.size.width/2, 140, indicator.frame.size.width, indicator.frame.size.height)];
    [indicator startAnimating];
    [indicator setTag:1234];
    [self.view addSubview:indicator];

    [self disableBlurView];
    
    switch ([self type]) {
        case NCPackControllerOfNumber:
        {
            [NCDataManager sharedInstance].delegate = self;
            if([self.pack.paid isEqualToNumber:@1])
            {
                [[NCDataManager sharedInstance] getLocalWordsWithPackID:self.pack.ID];
            }
            else
            {
                [[NCDataManager sharedInstance] getWordsWithPackIDPreview:[self.pack.ID intValue]];
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
    [self updateNavigationItemsIfNeeded];
    

}

- (void)updateNavigationItemsIfNeeded
{
    if ([self isOpenFromMenu]) {
        self.navigationItem.rightBarButtonItem = [self.navigationItem leftBarButtonItem];
        [self.navigationItem.rightBarButtonItem setAction:@selector(popToPartitionControllerAction:)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nc_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMenu)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void) backToMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popToPartitionControllerAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self disableBlurView];
}

#pragma mark getter
- (NSMutableArray *)searchArrayOfWords
{
    if(!_searchArrayOfWords) _searchArrayOfWords = [[NSMutableArray alloc] init];
    
        return _searchArrayOfWords;
}

- (void)setPack:(NCPack *)pack
{
    _pack = pack;
    BOOL ifPaid = [[NCDataManager sharedInstance] ifPaidPack:pack];
    if(ifPaid)
    {
        _pack.paid = @1;
    }
}
#pragma  mark DataManager Protocol methods

- (void)ncDataManagerProtocolGetLocalWordsWithPackID:(NSArray *)arrayOfWords
{
    [[self.view viewWithTag:1234] removeFromSuperview];
    [self.collectionView setHidden:NO];
    
    self.arrayOfWords = arrayOfWords;
    [self.collectionView reloadData];
}

- (void)ncDataManagerProtocolGetWordsWithPackIDPreview:(NSArray *)arrayOfWords
{
    [[self.view viewWithTag:1234] removeFromSuperview];
    [self.collectionView setHidden:NO];
    
    self.arrayOfWords = arrayOfWords;
    [self.collectionView reloadData];
}

- (void)ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites
{
    [[self.view viewWithTag:1234] removeFromSuperview];
    [self.collectionView setHidden:NO];
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
                return self.arrayOfWords.count;
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
                
                NCWord *word = [[NCWord alloc] init];
                if(self.arrayOfWords.count > 0)
                {
                   word = self.arrayOfWords[indexPath.item];
                }
                if([self.pack.paid isEqualToNumber:@1])
                {
                    openCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordCellIdentifier forIndexPath:indexPath];
                    [openCell.pictureView setImage:[UIImage imageNamed:@"default"]];
                    if(self.pack.ID.intValue == 1)
                    {
                        UIImage *image = [UIImage imageNamed:word.image];
                        [openCell.pictureView setImage:image];
                    }
                    else
                    {
                       
                        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:word.imageHalfBlur]];
                        [openCell.pictureView setImage:img];
                    }
                    
                    [openCell.chineseLabel setText:word.material.materialZH];
                    [openCell.pinyinLabel setText:word.material.materialZH_TR];
                    openCell.blurView.blurRadius = 10.0f;
                    openCell.blurView.dynamic = YES;
                    NSString *str = [self cutFirstWord:word.material.materialWord];
                    [openCell.translateLabel setText:str];
                    return openCell;
                }
                else
                {
                    NCWordLockCell *lockCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordLockCellIdentifier forIndexPath:indexPath];
                    
                    if(word.image)
                    {
                        //lockCell.blurView.hidden = YES;
                        //[lockCell.pictureView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS,word.image]]];
                        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS,[word.image stringByReplacingOccurrencesOfString:@".png" withString:@"_blur.png"]]]];
                        [lockCell.pictureView setImage:[UIImage imageNamed:@"default"]];
                        //[lockCell.pictureView setImage:[UIImage imageNamed:@"12_img_small"]];
                        __weak typeof(lockCell) weakLockCell = lockCell;
                        weakLockCell.blurView.dynamic = YES;
                        [lockCell.pictureView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"12_img_small"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               [weakLockCell.pictureView setImage:image];
                                weakLockCell.blurView.blurEnabled = YES;
                                weakLockCell.blurView.alpha = 1.0f;
                                weakLockCell.blurView.blurRadius = 10.0f;
                                [weakLockCell.blurView updateAsynchronously:YES completion:nil];
                                weakLockCell.blurView.dynamic = YES;
                            
                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                            
                        }];
                    }
                    
                    return lockCell;
                }
                break;
            }
                
            case NCPackControllerOfFavorite:
            {
                NCWordCell *openCell = nil;
                NCWord *word = self.arrayOfFavorites[indexPath.item];
                [openCell.pictureView setImage:[UIImage imageNamed:@"default"]];
                
                openCell = [collectionView dequeueReusableCellWithReuseIdentifier:NCWordCellIdentifier forIndexPath:indexPath];
                
                if(word.packID.intValue == 1)
                {
                    UIImage *image = [UIImage imageNamed:word.image];
                    [openCell.pictureView setImage:image];
                }
                else
                {
                    
                    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:word.imageHalfBlur]];
                    [openCell.pictureView setImage:img];
                }
                
                [openCell.chineseLabel setText:word.material.materialZH];
                [openCell.pinyinLabel setText:word.material.materialZH_TR];
                openCell.blurView.blurRadius = 10.0f;
                openCell.blurView.dynamic = YES;
                NSString *str = [self cutFirstWord:word.material.materialWord];
                [openCell.translateLabel setText:str];
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
        
        if(word.packID.intValue == 1)
        {
            UIImage *image = [UIImage imageNamed:word.image];
            [openCell.pictureView setImage:image];
        }
        else
        {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:word.imageHalfBlur]];
            [openCell.pictureView setImage:img];
        }
        
        [openCell.chineseLabel setText:word.material.materialZH];
        [openCell.pinyinLabel setText:word.material.materialZH_TR];
        NSString *str = [self cutFirstWord:word.material.materialWord];
        [openCell.translateLabel setText:str];
        return openCell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
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
        else
        {
            [self reload];
            
        }
    }
    else if(collectionView == self.searchCollectionView)
    {
        [self performSegueWithIdentifier:NCVisuallyPackControllerSearchSegueIdentifier sender:@{NCPackControllerWordIndexKey: @(indexPath.item), @"search":@1}];
        
    }
}


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


//Enable blur effect before scrolls
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == [self collectionView]) {
        self.navigationBlurView.blurEnabled = YES;
        
        
    }
}

#pragma mark In-App Purchases
- (void)reload {
        _products = nil;
        [[NCIAHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                _products = products;
                NSString *identifier = [NCStaticPackIdentifier getProductIdentifierByPackID:self.pack.ID.intValue];
                SKProduct *product = [[SKProduct alloc] init];
                for(SKProduct *p in _products)
                {
                    if([p.productIdentifier isEqualToString:identifier])
                    {
                        product = p;
                        self.prod = p;
                    }
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:product.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [alert setTag:1];
                [alert show];
            }
        }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 1)
    {
        if(buttonIndex == 1)
        {
            [[NCIAHelper sharedInstance] buyProduct:self.prod];
        }
        
    }
}


- (void)productPurchased:(NSNotification *)notification {
    if([notification.name isEqualToString:IAPHelperProductPurchasedNotification])
    {
        NSString * productIdentifier = notification.object;
        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
            if ([product.productIdentifier isEqualToString:productIdentifier]) {
                
                *stop = YES;
                [NCProductDownloader sharedInstance].delegate = self;
                
                //[self performSelectorInBackground:@selector(downloadProductWithIdentifier:) withObject:productIdentifier];
                [self downloadProductWithIdentifier:productIdentifier];
                
            }
        }];
    }
    /*
    else if([notification.name isEqualToString:IAHelperProductNotPurchasedNotification])
    {
        
        NSString *str = (NSString *)notification.object;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
  */
}

- (void) downloadProductWithIdentifier:(NSString *) identifier
{
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.razeware.imagegrabber.bgqueue", NULL);
    self.collectionView.hidden = YES;
    //self.progress.hidden = NO;
    
    [self setupCircularProgress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [[NCProductDownloader sharedInstance] loadBoughtProduct:identifier];
        
    });
    self.collectionView.userInteractionEnabled = YES;
    
}
#pragma mark NCProductDownloaderProtocol
- (void)ncProductDownloaderProtocolProductDownloaded:(NCPack*)pack
{
    self.pack = pack;
    self.pack.paid = @1;
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.progress.hidden = YES;
        //UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        //CGRect mainFrame = [[UIScreen mainScreen] bounds];
        //[indicator setFrame:CGRectMake(mainFrame.size.width/2-indicator.frame.size.width/2, 140, indicator.frame.size.width, indicator.frame.size.height)];
        //[indicator startAnimating];
        //[indicator setTag:1234];
        //[self.view addSubview:indicator];
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:@100 waitUntilDone:YES];
        [self.circularProgress removeFromSuperview];
        [self.textLabel removeFromSuperview];
        [self.collectionView reloadData];
        
        [[self.view viewWithTag:1234] removeFromSuperview];
        
        self.collectionView.hidden = NO;
        //self.progress.progress = 0.0f;
    });
    
}

- (void)ncProductDownloaderProtocolProductProgressPercentValue:(NSNumber *)number
{
    self.collectionView.hidden = YES;
    //[self updateProgress:number.floatValue];
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:number waitUntilDone:NO];
    //self.progress.hidden = NO;
    //[self performSelectorOnMainThread:@selector(updateProgressView:) withObject:number waitUntilDone:NO];
    //NSLog(@"Loading ... %f", number.floatValue);
}

- (void) updateProgressView:(NSNumber *)value
{
    NSLog(@"Loading ... %f", value.floatValue);
    [self.progress setProgress:value.floatValue/100 animated:YES];
    
    
}

#pragma mark Progress
/*
func setupKYCircularProgress1() {
    circularProgress1 = KYCircularProgress(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2))
    let center = (CGFloat(160.0), CGFloat(200.0))
    circularProgress1.path = UIBezierPath(arcCenter: CGPointMake(center.0, center.1), radius: CGFloat(circularProgress1.frame.size.width/3.0), startAngle: CGFloat(M_PI), endAngle: CGFloat(0.0), clockwise: true)
    circularProgress1.lineWidth = 8.0
    
    let textLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 30.0, 170.0, 80.0, 32.0))
    textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
    textLabel.textAlignment = .Center
    textLabel.textColor = circularProgress1.colorHex(0xA6E39D)
    textLabel.backgroundColor = UIColor.clearColor()
    self.view.addSubview(textLabel)
    
    circularProgress1.progressChangedBlock({ (progress: Double, circular: KYCircularProgress) in
        println("progress: \(progress)")
        textLabel.text = "\(Int(progress * 100.0))%"
    })
    
    self.view.addSubview(circularProgress1)
}*/

/*
 func updateProgress() {
 progress = progress &+ 1
 let normalizedProgress = Double(progress) / 255.0
 
 circularProgress1.progress = normalizedProgress
 circularProgress2.progress = normalizedProgress
 circularProgress3.progress = normalizedProgress
 }
 */

- (void) setupCircularProgress
{
    self.circularProgress = [[KYCircularProgress alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height/2)];
    CGPoint center = CGPointMake(self.view.frame.size.width/2, 200.0f);
    self.circularProgress.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center.x, center.y) radius:self.circularProgress.frame.size.width/3.0f startAngle:M_PI endAngle:0.0f clockwise:YES];
    self.circularProgress.lineWidth = 8.0f;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40.0f, 170.0f, 80.0f, 32.0f)];
    NSLog(@"%@", NSStringFromCGRect(self.textLabel.frame));
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32.0f];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor lightGrayColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.textLabel];
    
    [self.circularProgress progressChangedBlock:^(double progress, KYCircularProgress *circular) {
       dispatch_async(dispatch_get_main_queue(), ^{
           int result = progress * 100;
           [self.textLabel setText:[NSString stringWithFormat:@"%i%%", result]];
       });
        
    }];
     
    [self.view addSubview:self.circularProgress];
}

- (void) updateProgress:(NSNumber *)number
{
    float normalizedProgress = number.floatValue/100;
    NSLog(@"value = %f", normalizedProgress);
    self.circularProgress.progress = number.floatValue/100;
}

@end
