//
//  NCCollectionViewCenterLayout.m
//  NakedChinese
//
//  Created by IMAC  on 13.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCCollectionViewCenterLayout.h"
#import <math.h>

@interface NCCollectionViewCenterLayout()
@property (nonatomic, strong) NSNumber *numberOfElements;
@end

@implementation NCCollectionViewCenterLayout



//the opportunity to make initial calculations
- (void)prepareLayout
{
    [super prepareLayout];
    self.numberOfElements = @0;
    for(NSUInteger i = 0; i < [self.collectionView numberOfSections]; i++)
    {
        for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            int value = [self.numberOfElements intValue];
            value ++;
            self.numberOfElements = [NSNumber numberWithInt:value];
        }
    }
}

// calculate the total size that the content will occupy
- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}


//determine the position and size of all visible cells
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
     NSMutableArray* elementsInRect = [NSMutableArray array];
    
    
     //iterate over all cells in this collection
     for(NSUInteger i = 0; i < [self.collectionView numberOfSections]; i++)
     {
         for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++)
         {
             float x = 0.f;
             float y = 0.f;
             
             long quotient = j/3;
             y = 30.f + 95.f*quotient;
             
             int ost = fmod(self.numberOfElements.intValue, 3);
             int q = (self.numberOfElements.intValue - ost)/3;
             
             //это последняя строка и эл-тов меньше чем 3
             if(q == quotient && ost != 0)
             {
                 if(ost == 2)
                 {
                     if(j%3 == 0)
                     {
                         x = 60.0f;
                     }
                     else if(j%3 == 1)
                     {
                         x = 190.0f;
                     }
                 }
                 else if(ost == 1)
                 {
                     x = 125.0f;
                 }
             }
             else
             {
                 if(j%3 == 0)
                 {
                     x = 30.0f;
                 }
                 else if(j%3 == 1)
                 {
                     x = 125.0f;
                 }
                 else if(j%3 == 2)
                 {
                     x = 220.0f;
                 }
             }
             
            //this is the cell at row j in section i
             CGRect cellFrame = CGRectMake(x , y, 70.0f, 70.0f);

            //see if the collection view needs this cell
            if(CGRectIntersectsRect(cellFrame, rect))
            {
                //create the attributes object
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
                [elementsInRect addObject:attr];
            }
         }
    }

return elementsInRect;
}
@end
