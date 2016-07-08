//
//  checkNeworkManeger.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@interface checkNeworkManeger : NSObject



@property (retain,nonatomic) Reachability *reachablity;

- (void)startObserver;
- (void)stopObserver;

/**
 * 获取网络管理器
 */
+ (checkNeworkManeger *) shareNetwork;

/**
 * 检测当前网络状态
 */
- (NetworkStatus)checkNowNetWorkStatus;

/**
 * 停止检测网络
 */
- (void) stopNetWorkWatch;

/**
 *网络差的时候的网络提示
 */
- (void) showNetWorkMessage;

/**
 *实时监测网络状态给予提示
 */
- (void)checkNetworkRealTimeStatus;

@end
