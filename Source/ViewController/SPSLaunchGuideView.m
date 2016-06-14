//
//  SPSLaunchGuideView.m
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//  新特性页面视图

#import "SPSLaunchGuideView.h"
#import "SPSLaunchGuideViewModel.h"


static const NSInteger guidePhotoCount = 6;
static const NSString * figureName = @"intro_icon_";
static const NSString * figureTextName = @"intro_tip_";

@implementation SPSLaunchGuideView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.frame = [UIScreen mainScreen].bounds;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollView.contentSize = CGSizeMake(scrollView.width * guidePhotoCount, scrollView.height);
    scrollView.bounces = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    
    CGRect headerViewFrame = self.frame;
    headerViewFrame.size.height -= headerViewFrame.size.width * 0.2;
    
    for (int i = 0; i < guidePhotoCount; i++) {
        headerViewFrame.origin.x = i * headerViewFrame.size.width;
        
        SPSLaunchGuideHeaderView * headerView = [[SPSLaunchGuideHeaderView alloc] initWithPhotoCount:i andFrame:headerViewFrame];
        
        headerView.backgroundColor = [UIColor randomColor];
        
        [scrollView addSubview:headerView];
    }
}

@end


@implementation SPSLaunchGuideHeaderView : UIView

-(instancetype)initWithPhotoCount:(int)count andFrame:(CGRect)frame{
    self = [self initWithFrame:frame];
    if (self) {
        _number = count;
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString * resolution = scale <= 2 ? @"@2x":@"@3x";
    NSString * imageName = [NSString stringWithFormat:@"%@%d%@.png",figureName,_number,resolution];
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self addSubview:image];
    imageName = [NSString stringWithFormat:@"%@%d%@.png",figureTextName,_number,resolution];
    UIImageView * text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self addSubview:text];
    
    NSInteger space = (self.height - image.height - text.height) / 3;
    if (space > 0) {
        [image addConstraints:@[]];
    } else {
        [image addConstraints:@[]];
    }
    
}


@end

@implementation SPSLaunchGuideBottomView : UIView
-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end