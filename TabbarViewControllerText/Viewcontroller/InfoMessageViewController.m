//
//  InfoMessageViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "InfoMessageViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation InfoMessageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.navigationBarTitle.text = @"个人中心";
    
    [self initTouchID];
}

- (void)initTouchID
{
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = CGRectMake(0, 0, 250, 100);
    touchBtn.center = CGPointMake(WIDTH/2, HEIGHT/2-100);
    touchBtn.backgroundColor = [UIColor orangeColor];
    [touchBtn setTitle:@"点击触发TouchID指纹识别" forState:0];
    touchBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [touchBtn addTarget:self action:@selector(touchID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchBtn];
}

- (void)touchID
{
    if (![UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        return;
    }
    [self userTouchID];
}

- (void)userTouchID
{
    //创建指纹对象
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"左侧按钮";
    NSError   *errorLA = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&errorLA]) {
        //弹出验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有指纹输入" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
            } else {
                switch (error.code) {
                    case LAErrorSystemCancel:
                        NSLog(@"切换到其他APP, 系统取消验证TouchID");
                        break;
                    case LAErrorUserFallback:
                        NSLog(@"用户选择输入密码,切换到主线程进行处理");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程进行处理
                        }];
                        break;
                    case LAErrorUserCancel:
                        NSLog(@"用户取消TouchID验证");
                        break;
                    default:
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程进行处理
                        }];
                        break;
                }
            }
        }];
    } else {
        switch (errorLA.code) {
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"LAErrorTouchIDNotEnrolled");
                break;
            case LAErrorPasscodeNotSet:
                NSLog(@"LAErrorPasscodeNotSet");
                break;
            default:
                NSLog(@"Touch ID is unaviliable");
                break;
        }
    }
}

@end
