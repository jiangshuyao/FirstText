//
//  shapeView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "shapeView.h"

@implementation shapeView

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

/*
 
 drawRect在以下情况下会被调用：
 1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect 调用是在Controller->loadView, Controller->viewDidLoad两方法之后掉用的.所以不用担心在控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View?draw的时候需要用到某些变量 值).
 2、该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3、通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4、直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0。
 5、CAShapeLayer需要和贝塞尔曲线配合使用才有意义。贝塞尔曲线可以为其提供形状，而单独使用CAShapeLayer是没有任何意义的。
 
 */

/**
 贝塞尔曲线与CAShapeLayer的关系
 1，CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
 2，贝塞尔曲线可以创建基于矢量的路径
 3，贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
 4，用于CAShapeLayer的贝塞尔曲线作为Path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线
 */
- (void)drawRect:(CGRect)rect
{
    //画一个圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor=[UIColor clearColor].CGColor;
    //将路径赋值给CAShapeLayer
    maskLayer.path = path.CGPath;
    //设置路径的颜色，设置线条的宽度和颜色
    maskLayer.strokeColor=[UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f].CGColor;
    maskLayer.lineWidth=2;
    maskLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:maskLayer];
    
    CALayer *circle = [[CALayer alloc] init];
    CGFloat circleW = 10;
    CGFloat maskW = self.frame.size.width;
    circle.frame = CGRectMake(maskW/2-circleW/2, maskLayer.frame.size.width/2-circleW/2, circleW, circleW);
    circle.cornerRadius = circleW/2;
    circle.backgroundColor = [UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f].CGColor;
    [maskLayer addSublayer:circle];

    CABasicAnimation *BasicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    BasicAnimation.toValue = @(M_PI*2);
    BasicAnimation.duration=10.0f;
    BasicAnimation.delegate=self;
    BasicAnimation.repeatCount = MAXFLOAT;
    [BasicAnimation setValue:@"BasicAnimationEnd" forKey:@"animationName"];
    //注意这里是self.layer 添加动画
    [self.layer addAnimation:BasicAnimation forKey:@"BasicAnimationEnd"];
}


/*
 
 layoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews。
 2、addSubview会触发layoutSubviews。
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化。
 4、滚动一个UIScrollView会触发layoutSubviews。
 5、旋转Screen会触发父UIView上的layoutSubviews事件。
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。
 7、直接调用setLayoutSubviews。
 
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
}

/*
 setNeedsDisplay//setNeedsLayout
 首先两个方法都是异步执行的。而setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到  UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，
 就可以  处理子视图中的一些数据
 */

@end
