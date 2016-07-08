//
//  BaseViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNavigationBar.h"


typedef NS_ENUM(NSInteger, webViewType)
{
    webViewTypeJS = 1,
    webViewTypeImage,
};

@interface BaseViewController : UIViewController

@property (nonatomic,strong)SYNavigationBar *navBar;
@property (nonatomic,copy)  NSString *TitleName;
@property (nonatomic,assign)BOOL needShowTabBar;

@property (nonatomic,assign) webViewType webviewType;

@end
