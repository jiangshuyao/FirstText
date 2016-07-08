//
//  SYNavigationBar.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYNavigationBar : UIView

@property (nonatomic,strong)void(^leftButtonClickBlock)();
@property (nonatomic,strong)void(^rightButtonClickBlock)();

//导航栏左按钮
@property (nonatomic,strong)UIButton *leftButton;
//导航栏右按钮
@property (nonatomic,strong)UIButton *rightButton;
//导航栏Title
@property (nonatomic,strong)UILabel *navigationBarTitle;
//Title颜色
@property (nonatomic,strong)UIColor *textColor;
//设置左边按钮图片
@property (nonatomic,strong)UIImage *lefftImage;
//设置右边按钮图片
@property (nonatomic,strong)UIImage *rightImage;

@end
