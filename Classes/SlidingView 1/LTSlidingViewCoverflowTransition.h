//
//  LTSlidingViewFlipTransition.h
//  LTSlidingViewController
//
//  Created by Yu Cong on 14-10-31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSlidingView.h"

@protocol LTSlidingViewCoverflowTransitionProtocol <NSObject>

- (void) ltSlidingViewCoverflowTransitionProtocolPercent:(float) percent;

@end

@interface LTSlidingViewCoverflowTransition : NSObject <LTSlidingViewTransition>

@property (nonatomic, weak) id<LTSlidingViewCoverflowTransitionProtocol> delegate;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
