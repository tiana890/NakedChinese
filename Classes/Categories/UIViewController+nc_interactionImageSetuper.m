//
//  UIViewController+launchImageSetuper.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 30.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "UIViewController+nc_interactionImageSetuper.h"

#import "NCInteractionManager.h"

@implementation UIViewController (nc_interactionImageSetuper)

- (void)setupBackgroundImage {
    if ([self.view isKindOfClass:[UIImageView class]]) {
        UIImageView *view = (id)[self view];
        NSString *hellImageName = nil;
        NCHell hell = [[NCInteractionManager sharedInstance] interactionHell];
        switch (hell) {
            case NCHellNotRequired:
                break;
            case NCHellMan:
                hellImageName = @"hellman";
                break;
            case NCHellGirl:
                hellImageName = @"hellgirl";
                break;
        }
        view.image = [UIImage imageNamed:hellImageName];
        view.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        NSAssert(NO, @"setup UIImageView class to ViewController view.");
    }
}

@end
