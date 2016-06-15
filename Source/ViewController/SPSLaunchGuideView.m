//
//  SPSLaunchGuideView.m
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//  新特性页面视图

#import "SPSLaunchGuideView.h"
#import "SPSLaunchGuideViewModel.h"
#import <Masonry.h>

static const NSInteger guidePhotoCount = 6;
static const NSString * figureName = @"intro_icon_";
static const NSString * figureTextName = @"intro_tip_";
@interface SPSLaunchGuideView () <UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView * scrollView;

@property(nonatomic, strong)UIPageControl * pagControl;
@end
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.bounces = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    self.pagControl = [[UIPageControl alloc] init];
    self.pagControl.numberOfPages = guidePhotoCount;
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pagControl];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.bottom.equalTo(self);
    }];
    [self.pagControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-40);
    }];
    
    
    CGRect headerViewFrame = self.frame;
    headerViewFrame.size.height -= 40;
    
    for (int i = 0; i < guidePhotoCount; i++) {
        headerViewFrame.origin.x = i * headerViewFrame.size.width;
        SPSLaunchGuideHeaderView * headerView = [[SPSLaunchGuideHeaderView alloc] initWithPhotoCount:i andFrame:headerViewFrame];
        headerView.backgroundColor = [UIColor randomColor];
        [self.scrollView addSubview:headerView];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.frame = [UIScreen mainScreen].bounds;
    self.scrollView.contentSize = CGSizeMake(self.width * guidePhotoCount, self.height);
    CGPoint scrPoint = CGPointMake((self.pagControl.currentPage)* self.width, 0);
    self.scrollView.contentOffset = scrPoint;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f,,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    self.pagControl.currentPage = (int)(self.scrollView.contentOffset.x + self.width * 0.5)/ (int)self.width;
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
    
    self.figure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self addSubview:self.figure];
    imageName = [NSString stringWithFormat:@"%@%d%@.png",figureTextName,_number,resolution];
    self.figureText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self addSubview:self.figureText];
    self.figure.translatesAutoresizingMaskIntoConstraints = NO;
    self.figureText.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = _number * frame.size.width;
    frame.size.height -= 40;
    self.frame = frame;
    [self updateConstraintsIfNeeded];
    if (self.width > self.height) {
        NSInteger space = (self.width - self.figure.width - self.figureText.width) / 3;
        if (space > 0) {
            [self.figure mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo([NSNumber numberWithInteger:space]);
            }];
            
            [self.figureText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).with.offset(0-space);
            }];
        }
    } else {
        NSInteger space = (self.height - self.figure.height - self.figureText.height) / 3;
        if (space > 0) {
            [self.figure mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo([NSNumber numberWithInteger:space]);
            }];
            
            [self.figureText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).with.offset(0-space);
            }];
            
        }
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