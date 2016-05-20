//
//  SPSLaunchGuideViewModel.m
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "SPSLaunchGuideViewModel.h"
#import <UIKit/UIKit.h>

static const NSInteger guidePhotoCount = 6;

@implementation SPSLaunchGuideViewModel

// 此处修改guide图片显示
- (void)initWithView:(SPSLaunchGuideView *)view {
    
    UIScrollView * guideScrollView = [[UIScrollView alloc] init];
    
    CGRect screenF = [UIScreen mainScreen].bounds;
    
    guideScrollView.frame = screenF;
    guideScrollView.contentSize = CGSizeMake(screenF.size.width * guidePhotoCount,screenF.size.height);
    guideScrollView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:1];
    
    
    
}

@end
