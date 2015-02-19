//
//  LTSlideView.h
//  PageViewControllerTest
//
//  Created by ltebean on 14/10/31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SlideDirection) {
    left,
    right
};

@protocol LTSlidingViewProtocol <NSObject>

- (void) ltSlidingViewProtocolCurrentIndexChanged:(int) newIndex;

@end

@protocol LTSlidingViewTransition <NSObject>
-(void) updateSourceView:(UIView*) sourceView destinationView:(UIView*) destView withPercent:(CGFloat)percent direction:(SlideDirection)direction;
@end

@interface LTSlidingView : UIView
@property(nonatomic,strong) id<LTSlidingViewTransition> animator;
@property (nonatomic, strong) id<LTSlidingViewProtocol> delegate;
-(void) addView:(UIView*) view;
-(void) setOpenedIndex:(int) index;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
