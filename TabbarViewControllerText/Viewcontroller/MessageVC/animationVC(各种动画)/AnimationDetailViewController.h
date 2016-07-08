//
//  AnimationDetailViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, animationStyle) {
    animationStyleShape = 0,//CAShapeLayer
    animationStyleBezier,   //贝赛尔曲线
    animationStyleBase,     //基础动画
    animationStyleCore,     //核心动画
    chartViewStyleBar,      //柱状图
    chartViewStylePie,      //饼状图
    chartViewStyleFoldline  //折线图
};

@interface AnimationDetailViewController : BaseViewController

@property (nonatomic,copy)   NSString       *animationName;
@property (nonatomic,assign) animationStyle animation;

@end
