//
//  UIImage+h568.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 24.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "UIImage+h568.h"
#import <objc/runtime.h>

@implementation UIImage (h568)

+ (void)initialize {
    if (self == [UIImage class]) {
        Method origImageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
        Method retina4ImageNamed = class_getClassMethod(self, @selector(retina4ImageNamed:));
        method_exchangeImplementations(origImageNamedMethod, retina4ImageNamed);
    }
}

+ (UIImage *)retina4ImageNamed:(NSString *)imageName {
    NSMutableString *imageNameMutable = [imageName mutableCopy];
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
    if (retinaAtSymbol.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    } else {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-568h@2x"];
            }
        }
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
    return [UIImage retina4ImageNamed: (imagePath) ? imageNameMutable : imageName];
}

@end
