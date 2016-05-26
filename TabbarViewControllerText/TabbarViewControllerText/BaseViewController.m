//
//  BaseViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "BaseViewController.h"
#import "RDVTabBarController.h"

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
    [self initNavigationBar];
}
- (void)initNavigationBar
{
    _navBar = [[SYNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:_navBar];
    [self.navBar.leftButton addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leftButtonPress:(id)sender
{
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
