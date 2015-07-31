//
//  NCPartitionViewController.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 18.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCPack.h"

#import "NCInteractionView.h"

@interface NCPartitionViewController : UIViewController

- (void) changePack:(NCPack *)pack;
@end
