//
//  GreetingView.m
//  CustomScroll
//
//  Created by IMAC  on 22.10.14.
//  Copyright (c) 2014 Zayceva. All rights reserved.
//

#import "GreetingView.h"
#import "CollectionCell.h"
#import <math.h>

@interface GreetingView()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *itemsArray;

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSNumber *currentPage;
@end

@implementation GreetingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */

- (void)setCurrentPage:(NSNumber *)currentPage
{
    _currentPage = currentPage;
    if([currentPage intValue] < self.itemsArray.count)
    {
        NSDictionary *dict = self.itemsArray[[currentPage intValue]];
        [self.firstLabel setText:dict[@"upperText"]];
    }
    
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    /*NSDictionary *dict = self.itemsArray[0];
    [self.firstLabel setText:dict[@"upperText"]];
    
    NSDictionary *dict1 = self.itemsArray[1];
    [self.secondLabel setText:dict1[@"upperText"]];
    
    [self.secondLabel setAlpha:0.0f];*/
}

- (NSMutableArray *)imagesArray
{
    if(!_imagesArray)
    {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

- (void)setBackgroundImage:(NSString *)imageName
{
    [self.backgroundView setImage:[UIImage imageNamed:imageName]];
}

#pragma mark add Items methods
- (void)addItemWithUpperText:(NSString *)upperText andBottomText:(NSString *)bottomText andImage:(NSString *)imageString
{
    if(!self.itemsArray)
    {
        self.itemsArray = [[NSMutableArray alloc] init];
    }
    NSDictionary *dict = @{@"upperText":upperText, @"bottomText":bottomText, @"image":imageString};
    [self.itemsArray addObject:dict];
}

- (void) removeAllItems
{
    [self.itemsArray removeAllObjects];
}

#pragma mark UICollectionView delegate methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == self.itemsArray.count)
    {
        CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell2" forIndexPath:indexPath];
        if(!cell)
        {
            cell = [(CollectionCell *)[CollectionCell alloc] init];
        }
        [cell.textLabel setText:NSLocalizedString(@"greet_text", nil)];
        [cell.textLabel setAlpha:1.0f];
        [cell.nextButton setTitle:NSLocalizedString(@"next", nil) forState:UIControlStateNormal];
        [cell.nextButton setAlpha:1.0f];
        
        
        return cell;
    }
    else
    {
        CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
        if(!cell)
        {
            cell = [(CollectionCell *)[CollectionCell alloc] init];
        }
        NSDictionary *dict = self.itemsArray[indexPath.item];
        [cell.image setImage:[UIImage imageNamed: dict[@"image"]]];
        [cell.image setAlpha:1.0f];
        [cell.upperLabel setText:dict[@"upperText"]];
        [cell.upperLabel setAlpha:1.0f];
        [cell.bottomLabel setText:dict[@"bottomText"]];
        [cell.bottomLabel setAlpha:1.0f];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsArray.count+1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    [self.collectionView setContentSize:CGSizeMake(screen.size.width*self.itemsArray.count, screen.size.height)];
    return CGSizeMake(screen.size.width, screen.size.height);
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    //NSLog(@"%@", NSStringFromCGSize(CGSizeMake(self.collectionView.contentSize.width, self.collectionView.contentSize.height)));
    
}*/
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    /*
    CGPoint currentOffset = scrollView.contentOffset;
    NSLog(@"%f", currentOffset.x - lastOffset.x);
    lastOffset = currentOffset;
     */
    float pageWidth = scrollView.frame.size.width;
    float mod = fmodf(scrollView.contentOffset.x, pageWidth);
    
    float percentage = 100 * mod/pageWidth;
    //NSLog(@"%f", percentage);
    
    int page = scrollView.contentOffset.x/pageWidth;
    if(page != [self.currentPage intValue])
    {
        self.currentPage = [NSNumber numberWithInt:page];
        //NSLog(@"%i", [self.currentPage intValue]);
    }
    
    //чтобы альфа у последней страницы не менялся
    if(page+1 <= self.itemsArray.count-1)
    {
        CollectionCell *cell1 = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page+1 inSection:0]];
        [cell1.image setAlpha:percentage/100];
        [cell1.upperLabel setAlpha:percentage/100];
        [cell1.bottomLabel setAlpha:percentage/100];
        
        CollectionCell *cell2 = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
        [cell2.image setAlpha:1-percentage/100];
        [cell2.upperLabel setAlpha:1-percentage/100];
        [cell2.bottomLabel setAlpha:1-percentage/100];
        
    }
    else
    {
        CollectionCell *cell1 = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page+1 inSection:0]];
        [cell1.textLabel setAlpha:percentage/100];
        
        CollectionCell *cell2 = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
        
        [cell2.image setAlpha:1 - percentage/100];
        [cell2.upperLabel setAlpha:1 - percentage/100];
        [cell2.bottomLabel setAlpha:1 - percentage/100];
    }
        
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}



@end
