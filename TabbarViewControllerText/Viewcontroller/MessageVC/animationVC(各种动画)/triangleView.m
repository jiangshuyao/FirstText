//
//  triangleView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/20.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "triangleView.h"

@implementation triangleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat sideW = self.frame.size.width/2;//等边三角形的边长
    CGFloat sideH=sideW/(sqrt(3));//等边三角形的高
    
    CGPoint pointA = CGPointMake(sideW-sideH/2, sideW/2);
    CGPoint pointB = CGPointMake(sideW-sideH/2, sideW*3/2);
    CGPoint pointC = CGPointMake(sideW+sideH/2, sideW);
    
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addLineToPoint:pointC];
    // 最后的闭合线是可以通过调用closePath方法来自动生成的，也可以调用-addLineToPoint:方法来添加
    [path closePath];
    
    path.lineWidth = 2;
    // 设置填充颜色
    UIColor *fillColor = [UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f];
    [fillColor set];
    // 设置画笔颜色
//    UIColor *strokeColor = [UIColor blueColor];
//    [strokeColor set];
    
    [path fill];
    // 根据我们设置的各个点连线
    [path stroke];
}

@end
