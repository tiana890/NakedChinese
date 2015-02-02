//
//  NCTestViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 30.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCTestViewController.h"
#import "UIViewController+nc_interactionImageSetuper.h"

#import <FXBlurView/FXBlurView.h>
#import "NCNavigationBar.h"
#import "NCPackCell.h"
#import "NCDataManager.h"
#import "NCPack.h"
#import "NCQuestionViewController.h"
#import "NCTest.h"
#import "NCNavigationBar.h"

@interface NCTestViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NCDataManagerProtocol, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *sexCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *invectiveCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *slangCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *favButton;

@property (nonatomic, strong) NSArray *numbersAndPacks;
@property (nonatomic, strong) NSArray *packsArray;
@property (strong, nonatomic) NSMutableIndexSet *sexIndexes;
@property (strong, nonatomic) NSMutableIndexSet *invectiveIndexes;
@property (strong, nonatomic) NSMutableIndexSet *slangIndexes;

@property (strong, nonatomic) NSMutableArray *sexArray;
@property (strong, nonatomic) NSMutableArray *invectiveArray;
@property (strong, nonatomic) NSMutableArray *slangArray;

@property (nonatomic) BOOL ifFavorite;


@end

@implementation NCTestViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundImage];
    [self updateNavigationItemsIfNeeded];
    
    self.sexArray = [[NSMutableArray alloc] init];
    self.invectiveArray = [[NSMutableArray alloc] init];
    self.slangArray = [[NSMutableArray alloc] init];
    
    [self initializeIndexes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self updateNavigationItemsIfNeeded];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [NCDataManager sharedInstance].delegate = self;
    [[NCDataManager sharedInstance] getLocalPacks];
    
    [[NCDataManager sharedInstance] getFavorites];
}

- (void)ncDataManagerProtocolGetLocalPacks:(NSArray *)arrayOfPacks
{
    self.packsArray = arrayOfPacks;
    
    [self.sexArray removeAllObjects];
    [self.slangArray removeAllObjects];
    [self.invectiveArray removeAllObjects];
    
    for(NCPack *pack in arrayOfPacks)
    {
        if([pack.paid isEqualToNumber:@1])
        {
            if([pack.partition isEqualToString:@"sex"])
            {
                [self.sexArray addObject:pack];
            }
            else if([pack.partition isEqualToString:@"swear"])
            {
                [self.invectiveArray addObject:pack];
            }
            if([pack.partition isEqualToString:@"slang"])
            {
                [self.slangArray addObject:pack];
            }
        }
    }
    
    [self.sexCollectionView reloadData];
    [self.invectiveCollectionView reloadData];
    [self.slangCollectionView reloadData];
}

- (void)ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites
{
    if(arrayOfFavorites.count < 4)
    {
        self.favButton.userInteractionEnabled = NO;
        [self.favButton setAlpha:0.3f];
        self.ifFavorite = NO;
    }
    else
    {
        self.ifFavorite = YES;
    }
}

#pragma mark - IBActions

- (IBAction)popToPartitionControllerAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popToMenuController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)heartButtonAction:(UIButton *)heartButton {
    heartButton.selected = !heartButton.selected;
    if(heartButton.selected)
    {
        [self setCollectionViewInteractionEnabled:NO];
    }
    else
    {
        [self setCollectionViewInteractionEnabled:YES];
    }
}

- (void)setCollectionViewInteractionEnabled:(BOOL) value
{
    self.invectiveCollectionView.userInteractionEnabled = value;
    self.slangCollectionView.userInteractionEnabled = value;
    self.sexCollectionView.userInteractionEnabled = value;
    
    
    if(value)
    {
        //[self.sexArray removeAllObjects];
        //[self.slangArray removeAllObjects];
        //[self.invectiveArray removeAllObjects];
        
        [UIView animateWithDuration:0.5f animations:^{
            [self.invectiveCollectionView setAlpha:1.0f];
            [self.slangCollectionView setAlpha:1.0f];
            [self.sexCollectionView setAlpha:1.0f];
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            [self.invectiveCollectionView setAlpha:0.3f];
            [self.slangCollectionView setAlpha:0.3f];
            [self.sexCollectionView setAlpha:0.3f];
            
        }];
    }
}

#pragma mark - Private

- (void)initializeIndexes {
    self.sexIndexes = [NSMutableIndexSet indexSet];
    self.invectiveIndexes = [NSMutableIndexSet indexSet];
    self.slangIndexes = [NSMutableIndexSet indexSet];
}

- (void)updateNavigationItemsIfNeeded {
    
    if (![self isOpenFromMenu]) {
        self.navigationItem.leftBarButtonItem = [self.navigationItem rightBarButtonItem];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nc_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(popToPartitionControllerAction:)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == [self sexCollectionView])
    {
        return self.sexArray.count;
    }
    else if (collectionView == [self invectiveCollectionView])
    {
        return self.invectiveArray.count;
    } else if (collectionView == [self slangCollectionView])
    {
        return self.slangArray.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"Cell";
    
    NCPackCell *packCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    packCell.packView.fontSize = 30.f;
    packCell.packView.borderWidth = 1.f;
    
    NSIndexSet *currentIndexes = nil;
    
    if (collectionView == [self sexCollectionView]) {
        currentIndexes = [self sexIndexes];
    } else if (collectionView == [self invectiveCollectionView]) {
        currentIndexes = [self invectiveIndexes];
    } else if (collectionView == [self slangCollectionView]) {
        currentIndexes = [self slangIndexes];
    }

    packCell.packView.fill = [currentIndexes containsIndex:indexPath.row];
    packCell.packView.packNumber = indexPath.row+1;
    
    return packCell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath row];
    __weak NSMutableIndexSet *currentIndexes = nil;
    if (collectionView == [self sexCollectionView]) {
        currentIndexes = [self sexIndexes];
    } else if (collectionView == [self invectiveCollectionView]) {
        currentIndexes = [self invectiveIndexes];
    } else if (collectionView == [self slangCollectionView]) {
        currentIndexes = [self slangIndexes];
    }
    
    NCPackCell *packCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([currentIndexes containsIndex:index]) {
        [currentIndexes removeIndex:index];
    } else {
        [currentIndexes addIndex:index];
    }
    
    packCell.packView.fill = [currentIndexes containsIndex:index];
    
    if(self.ifFavorite)
    {
        if([currentIndexes count] == 0)
        {
            self.favButton.userInteractionEnabled = YES;
            [UIView animateWithDuration:0.5f animations:^{
                    [self.favButton setAlpha:1.0f];
            }];
        }
        else
        {
            self.favButton.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.5f animations:^{
                    [self.favButton setAlpha:0.3f];
            }];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NCQuestionViewController *qc = [segue destinationViewController];
    qc.packsArray = [self preparePassPacksArrayForQuestionViewController];
    if([sender tag] == 0)
    {
        qc.type = NCTestTypeLanguageChinese;
    }
    else
    {
        qc.type = NCTestTypeChineseLanguage;
    }
    if(self.favButton.selected)
    {
        qc.ifFavorites = YES;
    }
}

- (NSArray *)preparePassPacksArrayForQuestionViewController
{
    NSMutableArray *passPacksArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.sexIndexes.count; i++)
    {
        [passPacksArray addObjectsFromArray:[self.sexArray objectsAtIndexes:self.sexIndexes]];
    }
    
    for(int i = 0; i < self.invectiveIndexes.count; i++)
    {
        [passPacksArray addObjectsFromArray:[self.invectiveArray objectsAtIndexes:self.invectiveIndexes]];
    }
    
    for(int i = 0; i < self.slangIndexes.count; i++)
    {
        [passPacksArray addObjectsFromArray:[self.slangArray objectsAtIndexes:self.slangIndexes]];
    }
    
    
    return passPacksArray;

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self preparePassPacksArrayForQuestionViewController].count > 0)
        return YES;
    else if(self.favButton.selected)
        return YES;
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"empty_test_alert", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
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
