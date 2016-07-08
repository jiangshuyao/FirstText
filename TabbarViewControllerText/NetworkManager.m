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
//视频列表
- (void)getVideoListDateWithParameterDic:(NSDictionary *)parametes
                requestFinished:(void (^)(NSDictionary *))requestFinishedBlock
                  requestFailed:(void (^)(NSDictionary *))requestFailedBlock
{
    
}
//美女列表
- (void)getGirlListDateWithParameterDic:(NSDictionary *)parametes
               requestFinished:(void (^)(NSDictionary *))requestFinishedBlock
                 requestFailed:(void (^)(NSDictionary *))requestFailedBlock
{

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
    session.responseSerializer= [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
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
