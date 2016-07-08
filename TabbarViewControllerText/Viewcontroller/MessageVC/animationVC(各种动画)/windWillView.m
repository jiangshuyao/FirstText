//
//  windWillView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/21.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "windWillView.h"

@interface windWillView ()
{
    UIImageView *bgImage;
    float       progress;
    NSTimer     *timer;
}
@property (nonatomic,strong)UIImageView *flowerImageView;  //花
@property (nonatomic,strong)UIImageView *leafImageView;    //树叶
@property (nonatomic,strong)UIImageView *progressImageView;//进度条
@property (nonatomic,strong)UILabel     *textLabel;

@end

@implementation windWillView

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
        self.backgroundColor = [UIColor orangeColor];
        [self initImageView];
    }
    return self;
}
- (void)initImageView
{
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width-40, 34)];
    bgImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bgImage.image = [[UIImage imageNamed:@"wind_bgimage"] stretchableImageWithLeftCapWidth:50 topCapHeight:34];
    [self addSubview:bgImage];
    NSLog(@"==%f",bgImage.frame.size.width);
    
    progress = 0.1f;
    //每0.5s执行一次树叶动画
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
    _progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 1, 0, bgImage.frame.size.height)];
    //它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
    _progressImageView.image = [UIImage imageNamed:@"wind_progress"] ;
    _progressImageView.clipsToBounds = YES;
    _progressImageView.contentMode = UIViewContentModeLeft;
    [bgImage addSubview:_progressImageView];
    
    _flowerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImage.frame.size.width-32, 2, 30, 30)];
    _flowerImageView.image = [[UIImage imageNamed:@"wind_flower"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [bgImage addSubview:_flowerImageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_flowerImageView.frame.origin.x,_flowerImageView.frame.origin.y, 30, 30)];
    _textLabel.text = @"100\%";
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont boldSystemFontOfSize:11];
    _textLabel.hidden = YES;
    [bgImage addSubview:_textLabel];
}

- (void)drawRect:(CGRect)rect
{
    [self flowerAnimation];
}
#pragma amrk -- 花瓣转动动画
- (void)flowerAnimation
{
    //这两种方式都可以
//    CABasicAnimation *flowerAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    flowerAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    flowerAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_flowerImageView.layer.transform, M_PI, 0, 0, 1)];
//    flowerAnimation.duration = 0.5f;
//    flowerAnimation.cumulative = YES;
//    flowerAnimation.repeatCount = MAXFLOAT;
//    [_flowerImageView.layer addAnimation:flowerAnimation forKey:@"flowerAnimation"];
    
    CABasicAnimation *flowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    flowAnimation.toValue = @(M_PI);
    flowAnimation.duration = 0.5f;
    flowAnimation.repeatCount = MAXFLOAT;
    [_flowerImageView.layer addAnimation:flowAnimation forKey:@"flowerAnimation"];
}
#pragma mark -- 树叶的关键帧和旋转组合动画
- (void)leadKeyAnimation
{
    _leafImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImage.frame.size.width-45, bgImage.frame.size.height/2-7, 10, 10)];
    _leafImageView.image = [UIImage imageNamed:@"wind_leaf"];
    [bgImage addSubview:_leafImageView];
    _progressImageView.clipsToBounds = YES;
    
    //开始树叶的动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *p1 = [NSValue valueWithCGPoint:_leafImageView.layer.position];
    NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(bgImage.frame.origin.x + bgImage.frame.size.width*3/4.0 + arc4random()%(int)(bgImage.frame.size.width/5.0), _progressImageView.frame.origin.y +5+ arc4random()%(int)_progressImageView.frame.size.height)];
    NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(bgImage.frame.origin.x + bgImage.frame.size.width/2.0 + arc4random()%(int)(bgImage.frame.size.width/4.0), _progressImageView.frame.origin.y +5+ arc4random()%(int)_progressImageView.frame.size.height)];
    NSValue *p4 = [NSValue valueWithCGPoint:CGPointMake(bgImage.frame.origin.x + bgImage.frame.size.width/4.0 + arc4random()%(int)(bgImage.frame.size.width/4.0),_progressImageView.frame.origin.y +5+ arc4random()%(int)_progressImageView.frame.size.height)];
    NSValue *p5 = [NSValue valueWithCGPoint:CGPointMake(bgImage.frame.origin.x+2, _progressImageView.frame.origin.y +5+ arc4random()%(int)_progressImageView.frame.size.height)];
    keyAnimation.values = @[p1, p2, p3, p4, p5];
    
    CABasicAnimation *roateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    roateAnimation.fromValue = @0;
    roateAnimation.toValue = @(M_PI/18.0 * (arc4random()%(36*6) ));
    
    CAAnimationGroup  *group = [CAAnimationGroup animation];
    group.animations = @[roateAnimation, keyAnimation];
    group.duration = 8;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [group setValue:_leafImageView.layer forKey:@"leafLayer"];
    
    [_leafImageView.layer addAnimation:group forKey:nil];
    _progressImageView.clipsToBounds = YES;
    progress  = progress + 0.1;
    [UIView animateWithDuration:1.0 animations:^{
        self.progressImageView.frame = CGRectMake(_progressImageView.frame.origin.x, _progressImageView.frame.origin.y, self.frame.size.width * progress, _progressImageView.frame.size.height);
    }];
    
    if (progress >= 0.99) {
        [timer invalidate];
        [self stopLoading];
    }
}

- (void)startAnimation
{
    progress  = progress + 0.1;
    [UIView animateWithDuration:1.0 animations:^{
        self.progressImageView.frame = CGRectMake(_progressImageView.frame.origin.x, _progressImageView.frame.origin.y, bgImage.frame.size.width * progress, _progressImageView.frame.size.height);
    }];
    NSLog(@"%f==",_progressImageView.frame.size.width);
    if (progress >= 0.99) {
        [timer invalidate];
        [self stopLoading];
    }
}
- (void)stopLoading{
    [_flowerImageView.layer removeAllAnimations];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0;
    scaleAnimation.duration = 0.5;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.flowerImageView.layer addAnimation:scaleAnimation forKey:nil];
    
    _textLabel.hidden = NO;
    scaleAnimation.fromValue = @0;
    scaleAnimation.toValue = @1;
    [_textLabel.layer addAnimation:scaleAnimation forKey:nil];
}

@end
