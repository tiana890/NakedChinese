//
//  NCTestResultViewController.h
//  NakedChinese
//
//  Created by IMAC  on 29.11.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCTestResultViewController : UIViewController

@property (nonatomic, strong) NSString *rightResults;
@property (nonatomic, strong) IBOutlet UILabel *rightResultsLabel;

@property (nonatomic, strong) NSNumber *rightResult;
@property (nonatomic, strong) NSNumber *badResult;
@end
