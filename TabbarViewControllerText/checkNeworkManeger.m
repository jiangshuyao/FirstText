//
//  checkNeworkManeger.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "checkNeworkManeger.h"

@interface checkNeworkManeger ()<UIAlertViewDelegate>

@end

@implementation checkNeworkManeger
@synthesize reachablity;

- (id)init{
    if (self = [super init]) {
        //self.reachablity = [Reachability reachabilityWithHostName:@"www.renren.com"];
        self.reachablity = [Reachability reachabilityForInternetConnection];
    }
    return self;
}



- (void)startObserver{
    [self.reachablity startNotifier];
}

- (void)stopObserver{
    [self.reachablity stopNotifier];
}

+ (checkNeworkManeger *)shareNetwork
{
    static checkNeworkManeger *shareNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetworkManager = [[self alloc] init];
    });
    return shareNetworkManager;
}


- (NetworkStatus) checkNowNetWorkStatus
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    return [r currentReachabilityStatus];
}
- (void)checkNetworkRealTimeStatus
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realTimeCheckNetwork) name:kReachabilityChangedNotification object:nil];
    reachablity = [Reachability reachabilityForInternetConnection];
    [self startObserver];
}
- (void)realTimeCheckNetwork
{
    NetworkStatus status = [self checkNowNetWorkStatus];
    if (status == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"网络开小差了..." message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
- (void)showNetWorkMessage
{
    NetworkStatus status = [self checkNowNetWorkStatus];
    if (status == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"网络开小差了..." message:@"老板去设置网络?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"赶快", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void) stopNetWorkWatch
{
     //defaultManager = nil;
}

@end
