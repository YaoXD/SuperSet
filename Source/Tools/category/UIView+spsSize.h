//
//  UIView+spsSize.h
//  superSet
//
//  Created by yao on 16/5/24.
//  Copyright © 2016年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (spsSize)
-(CGFloat)x;
-(void)setX:(CGFloat)x;
-(CGFloat)y;
-(void)setY:(CGFloat)y;

-(CGFloat)width;
-(void)setWidth:(CGFloat)width;
-(CGFloat)height;
-(void)setHeight:(CGFloat)height;

-(CGPoint)origin;
-(void)setOrigin:(CGPoint)origin;
-(CGSize)size;
-(void)setSize:(CGSize)size;

@end
