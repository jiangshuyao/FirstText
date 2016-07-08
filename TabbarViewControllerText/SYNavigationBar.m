//
//  SYNavigationBar.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYNavigationBar.h"
#import "UIImage+GradientColor.h"

@implementation SYNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavigationBar];
        [self initGradientColor];
    }
    return self;
}
- (void)initNavigationBar
{
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(10, 25, 25, 25);
    [self addSubview:_leftButton];
    
    _rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(WIDTH-35, 25, 25, 25);
    [self addSubview:_rightButton];
    
    _navigationBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 200, 25)];
    _navigationBarTitle.textAlignment = 1;
    _navigationBarTitle.textColor = [UIColor whiteColor];
    _navigationBarTitle.font = [UIFont systemFontOfSize:18];
    _navigationBarTitle.center = CGPointMake(WIDTH/2, _navigationBarTitle.center.y);
    [self addSubview:_navigationBarTitle];
}
#pragma mark -- 设置渐变颜色
- (void)initGradientColor
{
    //设置图片渐变颜色
    UIColor *topleftColor = [UIColor colorWithRed:48/255.0f green:127/255.0f blue:202/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:35/255.0f green:195/255.0f blue:95/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(WIDTH, HEIGHT-64)];
    self.backgroundColor = [UIColor colorWithPatternImage:bgImg];
}

- (void)setTextColor:(UIColor *)textColor
{
    _navigationBarTitle.textColor = textColor;
}
- (void)setLefftImage:(UIImage *)lefftImage
{
    [_leftButton setImage:lefftImage forState:0];
}
- (void)setRightImage:(UIImage *)rightImage
{
    [_rightButton setImage:rightImage forState:0];
}

@end
