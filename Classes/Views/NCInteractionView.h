//
//  NCInteractionView.h
//  NCInteractionView
//
//  Created by Dmitriy Karachentsov on 15.08.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NCHell) {
    NCHellNotRequired,
    NCHellMan,
    NCHellGirl
};

@protocol NCInteractionViewDelegate;

@interface NCInteractionView : UIView

@property (weak, nonatomic) id<NCInteractionViewDelegate> delegate;

@property (assign, nonatomic) NCHell hell;

+ (instancetype)interactionWithHell:(NCHell)hell;

- (instancetype)initWithHell:(NCHell)hell;

@end

@protocol NCInteractionViewDelegate <NSObject>

- (void)interactionView:(NCInteractionView *)interactionView actionHell:(NCHell)hell;

@end
