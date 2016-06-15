//
//  SPSLaunchGuideController.m
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//  新特性页面控制器

#import "SPSLaunchGuideController.h"
#import "SPSLaunchGuideView.h"
#import "SPSApplePay.h"
#import <Masonry.h>

@interface SPSLaunchGuideController ()

@end

@implementation SPSLaunchGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[[SPSApplePay alloc] init] startApplePayWithController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)launchGuideController {
    SPSLaunchGuideController * launchGuideCtr = [[SPSLaunchGuideController alloc] init];
    return launchGuideCtr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self beginGuide];
    }
    return self;
}


- (void)beginGuide{
    SPSLaunchGuideView * launchGuideView = nil;
    // 判断是否需加载引导界面
    if ([self isNeedShowGuideView]) {
        launchGuideView = [[SPSLaunchGuideView alloc] init];
        launchGuideView.x = launchGuideView.width;
        [self.view addSubview:launchGuideView];
    }
    
    UIImage * image = [UIImage imageNamed:@"STARTIMAGE.jpg"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:imageView];
    
    UIView * launchScreenView = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    launchScreenView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:launchScreenView];
    
    
    [UIView animateWithDuration:1 animations:^{
        launchScreenView.alpha = 0.01;
    } completion:^(BOOL finished) {
        [launchScreenView removeFromSuperview];
        [UIView animateWithDuration:1 animations:^{
            imageView.x = imageView.x - imageView.width;
            launchGuideView.frame = [UIScreen mainScreen].bounds;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

- (BOOL)isNeedShowGuideView {
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    
//    [self.view setNeedsLayout];
//}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
}

@end
