//
//  BaseViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNavigationBar.h"


@interface BaseViewController : UIViewController

@property (nonatomic,strong)SYNavigationBar *navBar;
@property (nonatomic,assign)BOOL needShowTabBar;


@end
