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

@interface NCTestViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *sexCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *invectiveCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *slangCollectionView;

@property (strong, nonatomic) NSMutableIndexSet *sexIndexes;
@property (strong, nonatomic) NSMutableIndexSet *invectiveIndexes;
@property (strong, nonatomic) NSMutableIndexSet *slangIndexes;

@end

@implementation NCTestViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundImage];
    [self updateNavigationItemsIfNeeded];
    
    [self initializeIndexes];
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
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    if (collectionView == [self sexCollectionView]) {
        numberOfItems = 3;
    } else if (collectionView == [self invectiveCollectionView]) {
        numberOfItems = 5;
    } else if (collectionView == [self slangCollectionView]) {
        numberOfItems = 7;
    }
    return numberOfItems;
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
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}


@end
