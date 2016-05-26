//
//  NetworkManager.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject


+ (NetworkManager *)shareNetworkManager;


- (void)getHomeListWithUrl:(NSString *)homeListUrl
              parameterDic:(NSDictionary *)parametes
           requestFinished:(void(^)(NSDictionary *resultDic))requestFinishedBlock
             requestFailed:(void(^)(NSDictionary *resultDic))requestFailedBlock;

@end
