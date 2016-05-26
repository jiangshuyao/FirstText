//
//  OrderPayViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/10.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "OrderPayViewController.h"

@interface OrderPayViewController ()

@end

@implementation OrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.navigationBarTitle.text = @"订单结算页";
    self.view.backgroundColor = [UIColor colorWithRed:40 green:20 blue:0 alpha:1.0];
    
    [self.navBar.leftButton setImage:[UIImage imageNamed:@"0yjd"] forState:0];
    [self.navBar setLeftButtonClickBlock:^{
        NSLog(@"点击了");
    }];
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
