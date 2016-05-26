//
//  SYNavigationBar.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYNavigationBar.h"

@implementation SYNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavigationBar];
    }
    return self;
}
- (void)initNavigationBar
{
    self.backgroundColor = [z_UI colorWithHexString:@"#918597"];
    
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
