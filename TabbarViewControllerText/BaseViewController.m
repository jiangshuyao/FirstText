//
//  BaseViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "BaseViewController.h"
#import "RDVTabBarController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@implementation BaseViewController


- (id)init
{
    self = [super init];
    if (self) {
        _needShowTabBar = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    //设置全屏手势返回（设置为YES手势关闭）
    self.fd_interactivePopDisabled = NO;
    //相当于隐藏原有的导航栏
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initNavigationBar];
}
- (void)initNavigationBar
{
    _navBar = [[SYNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:_navBar];
//    // 当前顶层窗口
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    //将导航控制器加载到最顶层窗口
//    [window addSubview:_navBar];
    
    [self.navBar.leftButton addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leftButtonPress:(id)sender
{
    //如果从上页push的pop回去，如果present就dismiss
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (vc == nil) {
        [self  dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    if (self.navBar.leftButtonClickBlock) {
        self.navBar.leftButtonClickBlock();
    }
}
- (void)rightButtonPress:(id)sender
{
    if (self.navBar.rightButtonClickBlock) {
        self.navBar.rightButtonClickBlock();
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //非根视图默认添加返回按钮
    if ([self.navigationController.viewControllers count] > 0
        && self != [self.navigationController.viewControllers objectAtIndex:0])
    {
        [self.navBar.leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:0];
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    } else {
        [[self rdv_tabBarController]setTabBarHidden:NO animated:YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 是否显示TabBar
    //[[self rdv_tabBarController] setTabBarHidden:!_needShowTabBar animated:YES];
}
@end
