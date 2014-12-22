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

@interface NCJokesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FXBlurView *backgroundBlurView;
@end

@implementation NCJokesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackgroundImage];
    
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 5;
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
@end
