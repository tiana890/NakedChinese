//
//  GreetingView.h
//  CustomScroll
//
//  Created by IMAC  on 22.10.14.
//  Copyright (c) 2014 Zayceva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GreetingView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

{
    CGPoint lastOffset;
    
}

@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;

-(void) setBackgroundImage:(NSString *)imageName;
-(void) addItemWithUpperText:(NSString *)upperText andBottomText:(NSString *) bottomText andImage:(NSString *)imageString;
-(void) removeAllItems;
@end
