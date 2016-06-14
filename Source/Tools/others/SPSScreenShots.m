//
//  SPSScreenShots.m
//  superSet
//
//  Created by yao on 16/5/26.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "SPSScreenShots.h"

@implementation SPSScreenShots

+ (UIImage *)screenShots:(UIView *)view {
    if (!view) {
        view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


@end
