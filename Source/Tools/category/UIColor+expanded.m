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

+ (UIColor*)ColorFromHexString:(NSString *)hexColor { // 0XFFFF3300
    
    if (hexColor == nil || [hexColor isEqualToString:@""]) {
        return nil;
    }
    
    if ([hexColor length] != 7 && [hexColor length] != 9) {
        return nil;
    }
    
    unsigned int alpha = 255, red = 255, green = 255, blue = 255;
    NSRange range;
    unsigned int index = 1;
    range.length = 2;
    
    if ([hexColor length] == 9) {
        range.location = index;
        index += 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
    }
    
    range.location = index;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = index + 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = index + 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(CGFloat)(red/255.0f) green:(CGFloat)(green/255.0f) blue:(CGFloat)(blue/255.0f) alpha:(CGFloat)(alpha/255.0f)];
}
@end
