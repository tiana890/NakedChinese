//
//  LTSlideView.m
//  PageViewControllerTest
//
//  Created by ltebean on 14/10/31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "LTSlidingView.h"
#import "NCWordView.h"
#import <QuartzCore/QuartzCore.h>

@interface LTSlidingView()<UIScrollViewDelegate>
@property(nonatomic,strong) NSMutableArray* views;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic) CGFloat beginOffset;
@property (nonatomic) SlideDirection decelerateDirection;
@property int currentIndex;

@end

@implementation LTSlidingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void) setup
{
    self.views = [NSMutableArray array];
}

-(UIScrollView*) scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self addSubview:_scrollView];
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

-(void) addView:(UIView*) view
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    view.frame = CGRectMake(width*self.views.count, 0, width, height);
    [self.scrollView addSubview:view];
    [self.views addObject:view];
    self.scrollView.contentSize=CGSizeMake(width*self.views.count, height);
}

-(void) setOpenedIndex:(int) index
{
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*index, 0.0f)];
    for(UIView *v in self.views)
    {
        ((NCWordView *)v).embedView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}

#pragma mark UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat offset = self.scrollView.contentOffset.x;

    CGFloat percent = MIN(1,fabs((offset - self.beginOffset)/pageWidth));
    
    UIView* sourceView =self.views[self.currentIndex];
    UIView* destView;
    
    int nextIndex = (offset - self.beginOffset)>0? self.currentIndex+1 :self.currentIndex-1;
    if(nextIndex>=0 && nextIndex<self.views.count){
        
        destView = self.views[nextIndex];
    }
    
    if(percent < 0.5f)
    {
        ((NCWordView *)sourceView).embedView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:percent/2] CGColor];
        ((NCWordView *)destView).embedView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.5-percent/2] CGColor];
        
    }
    else
    {
        ((NCWordView *)sourceView).embedView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.5-percent/2] CGColor];
        ((NCWordView *)destView).embedView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:percent/2] CGColor];
    }
    
    
    ((NCWordView *)sourceView).embedView.layer.borderWidth = 1.0f;
    ((NCWordView *)destView).embedView.layer.borderWidth = 1.0f;
    
    SlideDirection direction = (offset - self.beginOffset>0)?right:left;
    self.decelerateDirection = direction;
    if(self.animator){
        [self.animator updateSourceView:sourceView destinationView:destView withPercent:percent direction:direction];
    }
}



-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginOffset = self.scrollView.contentOffset.x;

    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat offset = self.scrollView.contentOffset.x;
    
    int newIndex = floor((offset - pageWidth / self.views.count) / pageWidth) + 1;
    if(newIndex >= 0 && newIndex < self.views.count)
    {
        self.currentIndex = newIndex;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat offset = self.scrollView.contentOffset.x;
    int newIndex = floor((offset - pageWidth / self.views.count) / pageWidth) + 1;
    
    if(newIndex != self.currentIndex)
    {
        for(UIView *v in self.views)
        {
            if(((NCWordView *)v).embedView.layer.borderColor != [[UIColor clearColor] CGColor])
            {
                CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            
                color.fromValue = (id)[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f] CGColor];
                color.toValue = (id)[[[UIColor lightGrayColor] colorWithAlphaComponent:0.0f] CGColor];
                color.duration = 0.5f;
                // ... and change the model value
                [((NCWordView *)v).embedView.layer addAnimation:color forKey:@"borderColor"];
                ((NCWordView *)v).embedView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.0f] CGColor];
            }
        }
    }
    
    if(newIndex >= 0 && newIndex < self.views.count)
    {

        if([self.delegate respondsToSelector:@selector(ltSlidingViewProtocolCurrentIndexChanged:)])
        {
            [self.delegate ltSlidingViewProtocolCurrentIndexChanged:newIndex];
        }
    }
    
    CGFloat percent = MIN(1,fabs((offset - self.beginOffset)/pageWidth));
    
    UIView* sourceView =self.views[self.currentIndex];
    UIView* destView;
    
    int nextIndex = (offset - self.beginOffset)>0? self.currentIndex+1 :self.currentIndex-1;
    if(nextIndex>=0 && nextIndex<self.views.count){
        
        destView = self.views[nextIndex];
    }
    SlideDirection direction = (offset - self.beginOffset>0)?right:left;
    if(newIndex != self.currentIndex)
    {
        if(self.animator)
        {
            if(abs(self.currentIndex-newIndex) > 1)
            {
                [self.animator updateSourceView:sourceView destinationView:destView withPercent:1.0f direction:direction];
            }
            else
            {
                [self.animator updateSourceView:sourceView destinationView:destView withPercent:1.0f direction:direction];
            }
        }
    }
    else
    {

        if(self.animator)
        {
            if(abs(newIndex-nextIndex) > 1)
            {
                [self.animator updateSourceView:sourceView destinationView:destView withPercent:0.0f direction:direction];
            }
            else
            {
                [self.animator updateSourceView:sourceView destinationView:destView withPercent:0.0f direction:direction];
            }
        }

    }
    /*
    SlideDirection direction = (offset - self.beginOffset>0)?right:left;
    if(newIndex == 0 || newIndex == self.views.count-1)
    {
        if(newIndex == nextIndex)
        {
            [self.animator updateSourceView:sourceView destinationView:destView withPercent:1.0f direction:direction];
        }
        else
        {
            [self.animator updateSourceView:sourceView destinationView:destView withPercent:0.0f direction:direction];
        }
    }
    else
    {
        if(abs(newIndex-self.currentIndex) > 1)
        {
            [self.animator updateSourceView:sourceView destinationView:destView withPercent:0.0f direction:direction];
        }
        else if(newIndex == nextIndex)
        {
            [self.animator updateSourceView:sourceView destinationView:destView withPercent:1.0f direction:direction];
        }
        else
        {
            [self.animator updateSourceView:sourceView destinationView:destView withPercent:1.0f direction:direction];
        }
    }*/
    
}



@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
