//
//  SPSLaunchGuideView.m
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "SPSLaunchGuideView.h"
#import "SPSLaunchGuideViewModel.h"

@implementation SPSLaunchGuideView

- (instancetype)init {
    self = [super self];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [[SPSLaunchGuideViewModel alloc] initWithView:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
