//
//  TodayViewController.m
//  SYLOVE
//
//  Created by Rongheng on 16/4/27.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "AppDelegate.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置widget高度
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 100);
   // [self initView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initView];
}
- (void)initView
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    iconImageView.image = [UIImage imageNamed:@"about_logo"];
    [self.view addSubview:iconImageView];
    
    NSArray *btnTitle = @[@"打开应用",@"打开消息",@"打开详情"];
    
    for (int i = 0 ; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(30+105*i, 10, 90, 30);
        btn.tag = i;
        [btn setTitle:btnTitle[i] forState:0];
        [self.view addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"group.love"];
    NSString *text = [ud objectForKey:@"group.love.message"];

    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 30)];
    textLable.textColor = [UIColor whiteColor];
    textLable.textAlignment = 1;
    [self.view addSubview:textLable];
    textLable.text = text;
    
    //设置图片时如果是纯代码实现，将显示的本地图片加载到SYLOVE这个文件夹下
    UIImageView *loveImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 30, 30)];
    loveImage.image = [UIImage imageNamed:@"0yjd"];
    [self.view addSubview:loveImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickAction:(UIButton *)sender
{
    sender.backgroundColor = [UIColor redColor];
    if (sender.tag == 0) {
        [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoHomePage"] completionHandler:^(BOOL success) {
            NSLog(@"open URL %d",success);
        }];

    } else if (sender.tag == 1){
        [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoMessage"] completionHandler:^(BOOL success) {
            NSLog(@"open URL %d",success);
        }];
    } else {
        [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoDetail"] completionHandler:^(BOOL success) {
            NSLog(@"open URL %d",success);
        }];

    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
//缩进消除
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

@end
