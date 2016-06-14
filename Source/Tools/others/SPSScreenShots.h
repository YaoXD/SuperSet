//
//  SPSScreenShots.h
//  superSet
//
//  Created by yao on 16/5/26.
//  Copyright © 2016年 yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSScreenShots : NSObject
/**
 *  截屏函数
 *  @param view 需要截取的view对象，传nil时表示截取整个屏幕
 *  @return 截取到的UIImage图像
 */
+ (UIImage *)screenShots:(UIView *)view;

@end
