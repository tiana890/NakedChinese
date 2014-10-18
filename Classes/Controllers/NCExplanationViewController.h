//
//  NCExplanationViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 02.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FXBlurView/FXBlurView.h>

typedef NS_ENUM(NSUInteger, NCExplanationSliderState) {
    NCExplanationSliderHidden,
    NCExplanationSliderVisible,
    NCExplanationSliderDragToUp,
    NCExplanationSliderDragToDown
};

@interface NCExplanationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfExplanations;

@property (assign, nonatomic) NCExplanationSliderState state;

@end
