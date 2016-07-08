//
//  AnimationDetailViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "AnimationDetailViewController.h"

#import "shapeView.h"
#import "windWillView.h"
#import "QiyAnimationView.h"

@interface AnimationDetailViewController ()

@end

@implementation AnimationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.navigationBarTitle.text = self.animationName;
    
    switch (_animation) {
        case 0:
            [self initShapeAnimationView];
            break;
        case 1:
            [self initBezierAnimationView];
            break;
        case 2:
            [self initBaseAnimation];
            break;
        case 3:
            [self initCoreAnimation];
        default:
            break;
    }
}

- (void)initShapeAnimationView
{
    NSLog(@"0");
    [self creatTideAnimntion];
    [self creatQyiAnimation];
    [self windmillAnimation];
}
#pragma mark -- 仿潮汐APP旋转动画
- (void)creatTideAnimntion
{
    shapeView *view = [[shapeView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    [self.view addSubview:view];
    NSLog(@"%f---%f",view.center.x,view.center.y);
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    la.center = CGPointMake(view.center.x, view.center.y);
    la.text = @"空";
    la.textAlignment = 1;
    la.textColor = [UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f];
    la.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:la];
}
#pragma amrk -- f仿爱奇艺加载动画
- (void)creatQyiAnimation
{
    QiyAnimationView *view = [[QiyAnimationView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    [self.view addSubview:view];
}
#pragma mark -- 风车动画
- (void)windmillAnimation
{
    windWillView *windmill = [[windWillView alloc] initWithFrame:CGRectMake(0, 250, WIDTH, 120)];
    [self.view addSubview:windmill];
}


- (void)initBezierAnimationView
{
    NSLog(@"1");
}

- (void)initBaseAnimation
{
    NSLog(@"2");
}

- (void)initCoreAnimation
{
    NSLog(@"3");
}

- (void)initPieChartView
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
