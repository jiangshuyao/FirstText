//
//  checkNeworkManeger.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "checkNeworkManeger.h"

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

- (void) stopNetWorkWatch
{
     //defaultManager = nil;
}

@end
