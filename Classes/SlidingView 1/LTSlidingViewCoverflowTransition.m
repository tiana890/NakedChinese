//
//  LTSlidingViewFlipTransition.m
//  LTSlidingViewController
//
//  Created by Yu Cong on 14-10-31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "LTSlidingViewCoverflowTransition.h"
#import <QuartzCore/QuartzCore.h>
#define finalAngel 30.0f
#define perspective 1.0/-600
#define finalAlpha 0.6f

@implementation LTSlidingViewCoverflowTransition

-(void) updateSourceView:(UIView*) sourceView destinationView:(UIView*) destView withPercent:(CGFloat)percent direction:(SlideDirection)direction
{
    NSLog(@"percent = %f", percent);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    
    CGFloat angle =  finalAngel * M_PI / 180.0f*percent;
    if(direction == left){
        angle = -angle;
    }
    transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
    sourceView.layer.transform = transform;
    sourceView.alpha =  1 - percent*(1-finalAlpha);
    NSLog(@"source angle = %f", angle);
    if(destView){
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = perspective;
        CGFloat angle =  - finalAngel * M_PI / 180.0f * (1-percent);
        if(direction == left){
            angle = -angle;
        }
        transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
        destView.layer.transform = transform;
        destView.alpha = finalAlpha + (1-finalAlpha)*percent;
        NSLog(@"dest angle = %f", angle);
    }
    
}
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
