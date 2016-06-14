//
//  UIView+spsSize.m
//  superSet
//
//  Created by yao on 16/5/24.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "UIView+spsSize.h"

@implementation UIView (spsSize)
-(CGFloat)x{
    return self.frame.origin.x;
}
-(void)setX:(CGFloat)x {
    CGRect viewFrame = self.frame;
    self.frame = CGRectMake(x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
}
-(CGFloat)y {
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)y {
    CGRect viewFrame = self.frame;
    self.frame = CGRectMake(viewFrame.origin.x, y, viewFrame.size.width, viewFrame.size.height);
}

-(CGFloat)width {
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width {
    CGRect viewFrame = self.frame;
    self.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, width, viewFrame.size.height);
    
    
}
-(CGFloat)height {
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height {
    CGRect viewFrame = self.frame;
    self.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, height);
}

-(CGPoint)origin {
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin {
    CGRect viewFrame = self.frame;
    self.frame = CGRectMake(origin.x, origin.y, viewFrame.size.width, viewFrame.size.height);
}
-(CGSize)size {
    return self.frame.size;
}
-(void)setSize:(CGSize)size {
    CGRect viewFrame = self.frame;
    self.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, size.width, size.height);
}
@end
