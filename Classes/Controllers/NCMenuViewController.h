//
//  NCMenuViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 28.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@interface NCMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
