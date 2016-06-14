//
//  SPSLaunchGuideView.h
//  superSet
//
//  Created by yao on 16/5/20.
//  Copyright © 2016年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSLaunchGuideView : UIView

@end

@interface SPSLaunchGuideHeaderView : UIView
@property(nonatomic, strong)UIImageView * figure;
@property(nonatomic, strong)UIImageView * figureText;
@property(nonatomic, assign, readonly)int number;
-(instancetype)initWithPhotoCount:(int)count andFrame:(CGRect)frame;
@end

@interface SPSLaunchGuideBottomView : UIView
@property(nonatomic, strong)UIButton * login;
@property(nonatomic, strong)UIButton * registe;
@end