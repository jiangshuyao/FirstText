//
//  QiyAnimationView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/20.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "QiyAnimationView.h"

#import "triangleView.h"

#define rotationTime 1.0f;

@interface QiyAnimationView ()

@property (nonatomic,strong)CAShapeLayer *maskLayer;
@property (nonatomic,strong)triangleView *imageView;

@end

@implementation QiyAnimationView

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
        [self initQIYAnimation];
    }
    return self;
}

- (void)initQIYAnimation
{
    //画一个等边三角形
    _imageView = [[triangleView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
    [self addSubview:_imageView];
    
    //画一个圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor=[UIColor clearColor].CGColor;
    //将路径赋值给CAShapeLayer
    _maskLayer.path = path.CGPath;
    //设置路径的颜色，设置线条的宽度和颜色
    _maskLayer.strokeColor=[UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f].CGColor;
    _maskLayer.lineWidth=2;
    _maskLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:_maskLayer];

    self.maskLayer.transform=CATransform3DRotate(self.maskLayer.transform, -M_PI_2, 0, 0, 1);
    self.maskLayer.transform=CATransform3DTranslate(self.maskLayer.transform, -self.bounds.size.width,0,0);
    [self animationNumberOne];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if([[anim valueForKey:@"animationName"] isEqualToString:@"BasicAnimationEnd"])
    {
        [self animationTriangle];
        //开始圆消失的动画
        [self animationNumberTwo];
    }
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"BasicAnimationStart"]) {
        [self.layer removeAllAnimations];
        [self animationNumberOne];
    }
}

- (void)animationTriangle
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = rotationTime;
    basicAnimation.delegate = self;
    [basicAnimation setValue:@"triangleAnimation" forKey:@"animationName"];
    [_imageView.layer addAnimation:basicAnimation forKey:@"triangleAnimation"];
}

- (void)animationNumberOne
{
    //设置stroke起始点,stroke用笔画的意思
    _maskLayer.strokeStart=0;
    //设置strokeEnd的最终值，动画的fromValue为0，strokeEnd的最终值为0.98
    _maskLayer.strokeEnd=0.98;
    CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    BasicAnimation.fromValue=@(0);
    BasicAnimation.duration=rotationTime;
    BasicAnimation.delegate=self;
    //BasicAnimation.repeatCount = MAXFLOAT;
    [BasicAnimation setValue:@"BasicAnimationEnd" forKey:@"animationName"];
    [_maskLayer addAnimation:BasicAnimation forKey:@"BasicAnimationEnd"];
}
- (void)animationNumberTwo
{
    _maskLayer.strokeStart=0.98;
    CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"strokeStart"];
    BasicAnimation.fromValue=@(0);
    BasicAnimation.duration=rotationTime;
    
    BasicAnimation.delegate=self;
    [BasicAnimation setValue:@"BasicAnimationStart" forKey:@"animationName"];
    [self.maskLayer addAnimation:BasicAnimation forKey:@"BasicAnimationStart"];
}

@end
