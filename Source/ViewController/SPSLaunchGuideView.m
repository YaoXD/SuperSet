//
//  SPSLaunchGuideView.m
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//  新特性页面视图

#import "SPSLaunchGuideView.h"
#import "SPSLaunchGuideViewModel.h"
#import "SPSLoginView.h"
#import <Masonry.h>

static const NSInteger guidePhotoCount = 6;
static const NSString * figureName = @"intro_icon_";
static const NSString * figureTextName = @"intro_tip_";
static const CGFloat buttonGroupHeight = 80.0;


@interface SPSLaunchGuideView () <UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)SPSLaunchGuideBottomView * bottomView;
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
    self.backgroundColor = [UIColor ColorFromHexString:@"#f1f1f1"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.bounces = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    self.pagControl = [[UIPageControl alloc] init];
    self.pagControl.numberOfPages = guidePhotoCount;
    self.pagControl.pageIndicatorTintColor = [UIColor ColorFromHexString:@"#28303b"];
    self.pagControl.currentPageIndicatorTintColor = [UIColor ColorFromHexString:@"f1f1f1"];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pagControl];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.bottom.equalTo(self);
    }];
    [self.pagControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-buttonGroupHeight + 10);
    }];
    
    
    CGRect headerViewFrame = self.frame;
    headerViewFrame.size.height -= buttonGroupHeight;
    
    for (int i = 0; i < guidePhotoCount; i++) {
        headerViewFrame.origin.x = i * headerViewFrame.size.width;
        SPSLaunchGuideHeaderView * headerView = [[SPSLaunchGuideHeaderView alloc] initWithPhotoCount:i andFrame:headerViewFrame];
        headerView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:headerView];
    }
    
    self.bottomView = [[SPSLaunchGuideBottomView alloc] init];
    [self addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo([NSNumber numberWithFloat:buttonGroupHeight]);
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.frame = [UIScreen mainScreen].bounds;
    self.scrollView.contentSize = CGSizeMake(self.width * guidePhotoCount, self.height);
    CGPoint scrPoint = CGPointMake((self.pagControl.currentPage)* self.width, 0);
    self.scrollView.contentOffset = scrPoint;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pagControl.currentPage = (int)(self.scrollView.contentOffset.x + self.width * 0.5)/ (int)self.width;
    // 让view滑动时透明度改变的算法
    for (int i = 0; i < scrollView.subviews.count; i++) {
        if (i == (int)(self.scrollView.contentOffset.x) / (int)self.width) {
            scrollView.subviews[i].alpha = (int)(self.scrollView.contentOffset.x) / (int)self.width - (self.scrollView.contentOffset.x)/ self.width + 1;
        } else if (i == (int)(self.scrollView.contentOffset.x) / (int)self.width + 1){
            scrollView.subviews[i].alpha = (self.scrollView.contentOffset.x) / self.width - (int)(self.scrollView.contentOffset.x) / (int)self.width ;
        }
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
    frame.size.height -= buttonGroupHeight;
    self.frame = frame;
    [self updateConstraintsIfNeeded];
    if (self.width > self.height) {
        self.figure.height *= self.figure.height / self.height * 0.2;
        self.figureText.height *= self.figureText.height / self.height * 0.2;
        NSInteger space = (self.width - self.figure.width - self.figureText.width) / 3;
        [self.figure mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo([NSNumber numberWithInteger:space]);
        }];
        
        [self.figureText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(0-space);
        }];
        
    } else {
        self.figure.width = self.width * 0.2;
        self.figureText.width = self.figureText.width / self.width * 0.2;
        NSInteger space = (self.height - self.figure.height - self.figureText.height) / 3;
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


@end

@implementation SPSLaunchGuideBottomView : UIView
-(instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView {
    UIButton * regiesteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regiesteBtn setTitle:@"注册" forState:UIControlStateNormal];
    regiesteBtn.layer.borderWidth = 1;
    [regiesteBtn setTitleColor:[UIColor ColorFromHexString:@"#28303b"]forState:UIControlStateNormal];
    regiesteBtn.layer.borderColor = [UIColor blackColor].CGColor;
    regiesteBtn.layer.cornerRadius = 20;
    regiesteBtn.clipsToBounds = YES;
    regiesteBtn.titleLabel.textColor = [UIColor whiteColor];
    regiesteBtn.backgroundColor = [UIColor ColorFromHexString:@"#f1f1f1"];
    [regiesteBtn addTarget:self action:@selector(regieste) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:regiesteBtn];
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.textColor = [UIColor whiteColor];
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.clipsToBounds = YES;
    loginBtn.backgroundColor = [UIColor blackColor];
    [loginBtn addTarget:self action:@selector(logint) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    
    [regiesteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-30);
        make.width.equalTo(@120);
        make.centerX.equalTo(self).offset(-80);
    }];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-30);
        make.width.equalTo(@120);
        make.centerX.equalTo(self).offset(80);
    }];
    
}

-(void)regieste {
    
}
-(void)logint{
    
}
@end