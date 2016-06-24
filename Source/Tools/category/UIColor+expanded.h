//
//  UIColor+expanded.h
//  superSet
//
//  Created by yao on 16/5/25.
//  Copyright © 2016年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (expanded)
/**
 *  获取随机颜色的方法
 *
 *  @return UIColor随机颜色对象
 */
+ (UIColor *)randomColor;
/**
 *  16进制颜色值
 *
 *  @param hexColor 8位、6位颜色值 #11223344
 *
 *  @return UIColor
 */
+ (UIColor*)ColorFromHexString:(NSString *)hexColor;
@end
