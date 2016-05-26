//
//  NetworkManager.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

@implementation NetworkManager


+ (NetworkManager *)shareNetworkManager
{
    static NetworkManager *shareNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetworkManager = [[self alloc] init];
    });
    return shareNetworkManager;
}

- (void)getHomeListWithUrl:(NSString *)homeListUrl
              parameterDic:(NSDictionary *)parametes
           requestFinished:(void (^)(NSDictionary *))requestFinishedBlock
             requestFailed:(void (^)(NSDictionary *))requestFailedBlock
{
    [self sendGetMethod:homeListUrl parameterDic:parametes requestFinished:requestFinishedBlock requestFailed:requestFailedBlock];
}
- (void)sendGetMethod:(NSString *)url
         parameterDic:(NSDictionary *)parametes
      requestFinished:(void (^)(NSDictionary *))requestFinishedBlock
        requestFailed:(void (^)(NSDictionary *))requestFailedBlock
{
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = 10.0f;//设置请求超时
    __weak typeof(self)weakSelf = self;
    [session GET:url parameters:parametes progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        if (requestFinishedBlock) {
            requestFinishedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handelFailWithError:error requestFailed:requestFailedBlock];
    }];
}

-(void)handelFailWithError:(NSError *)aError
             requestFailed:(void(^)(NSDictionary *resultDic))requestFailedBlock

{
    NSDictionary *errorDic = [NSDictionary dictionaryWithObject:aError forKey:KEY_Request_FailedDic];
    if (requestFailedBlock) {
        requestFailedBlock(errorDic);
    }
}


@end
