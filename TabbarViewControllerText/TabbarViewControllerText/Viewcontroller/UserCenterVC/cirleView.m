//
//  cirleView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/12.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "cirleView.h"

@implementation cirleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 200, 200)];
    [[UIColor colorWithRed:0.5 green:0.5 blue:0.9 alpha:1.0] setStroke];
    [path setLineWidth:10];
    [path stroke];
    
    
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(150, 150, 100, 100) cornerRadius:50] stroke];
    
    
    centerShow = [[UIView alloc] initWithFrame:CGRectMake(300, 200, 10, 10)];
    centerShow.backgroundColor = [UIColor redColor];
    [self addSubview:centerShow];
    
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef pathA = CGPathCreateMutable();
    CGPathAddEllipseInRect(pathA, NULL, CGRectMake(200, 200, 100, 100));
    ani.path = pathA;
    CGPathRelease(pathA);
    ani.duration = 3;
    ani.speed = 3.0f;
    ani.repeatCount = HUGE;
    //ani.removedOnCompletion = NO;
    ani.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [centerShow.layer addAnimation:ani forKey:@"PostionKeyframePathAni"];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
