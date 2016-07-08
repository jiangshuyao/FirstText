//
//  promptView.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface promptView : NSObject

@property (nonatomic,strong) MBProgressHUD *progressHUD;

+ (promptView *)sharePrompt;

/**
 * 加载Loading提示框
 */
- (void)showPromptViewMessage:(NSString *)message;

/**
 * 加载信息错误提示框
 */
- (void)showPromptErroMessage:(NSString *)message;

/**
 * 隐藏Loading提示框
 */
- (void)hidePromptViewAfterDelay:(NSTimeInterval)delay;

@end
