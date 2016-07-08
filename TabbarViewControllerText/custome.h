//
//  custome.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

//这里的HBLog是一个宏，需要在PCH文件中配置 只有在开发阶段才会打印log 正式上线是不会打印log的
#ifdef DEBUG // 处于开发阶段
#define HBLog(...) NSLog(__VA_ARGS__)
#else // 出去发布阶段
#define HBLog(...)
#endif

#define HEIGHT     [UIScreen mainScreen].bounds.size.height
#define WIDTH    [UIScreen mainScreen].bounds.size.width

#define KEY_Request_FailedDic @"KEY_Request_FailedDic"          // 失败字典
#define isGuideFirst          @"isGuideFirst"                   //是否第一次启动App
#define IPHONE [[UIScreen mainScreen] bounds].size.height < 568?YES:NO

//UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
#define KeyWindow [[UIApplication sharedApplication] keyWindow]

#define WHITECOLOR(A)         [UIColor colorWithRed:255 green:255 blue:255 alpha:A]

//NSUserDeafault
#define GETUSERDEAFAULT(KEY)     [[NSUserDefaults standardUserDefaults] objectForKey:KEY];
