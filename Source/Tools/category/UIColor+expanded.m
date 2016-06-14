//
//  UIColor+expanded.m
//  superSet
//
//  Created by yao on 16/5/25.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "UIColor+expanded.h"

@implementation UIColor (expanded)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0f];
}

@end
