//
//  promptView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "promptView.h"

@implementation promptView

+ (promptView *)sharePrompt
{
    static promptView *sharePromptView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePromptView = [[self alloc] init];
    });
    return sharePromptView;
}

- (void)showPromptViewMessage:(NSString *)message
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.progressHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText= message;
}

- (void)showPromptErroMessage:(NSString *)message
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.progressHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText= message;
    
    [self.progressHUD hide:YES afterDelay:1.0f];
}

- (void)hidePromptViewAfterDelay:(NSTimeInterval)delay
{
    [self.progressHUD hide:YES afterDelay:delay];
}



@end
