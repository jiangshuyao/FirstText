//
//  DetailViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "DetailViewController.h"

#import "OrderPayViewController.h"


@interface DetailViewController ()<UIWebViewDelegate,JSExportDelegate>

@property (nonatomic,strong)JSContext *jsContext;
@property (nonatomic,strong)UIWebView *SYwebview;


@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navBar.navigationBarTitle.text = @"OC与JavaScript交互的那些事";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.SYwebview];
}

- (UIWebView *)SYwebview
{
    if (!_SYwebview) {
        _SYwebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
        _SYwebview.delegate =self;
        NSURL *jsUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:jsUrl];
        [_SYwebview loadRequest:request];
    }
    return _SYwebview;
}
#pragma mark -- webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //先说JSModel是iOS和Android这两边在本地要注入的一个对象，充当原生应用和web页面之间的一个桥梁。JS也有这个对象
    /*
     HTML页面上定义了两个按钮名字分别为CallCamera和Share。点击CallCamera会通过JSModel这个桥梁调用本地应用的方法- (void)callCamera，没有传参；而点击Share会先调用本文件中的JavaScript方法callShare这里将要分享的内容格式转成JSON字符串格式（这样做是为了适配Android，iOS可以直接接受JSON对象）然后再通过Toyun这个桥梁去调用原生应用的- (void)share:(NSString *)shareInfo方法这个是有传参的，参数为shareInfo。而下面的两个方法为原生方法调用后的回调方法，其中picCallback为获取图片成功的回调方法，并且传回拿到的图片photos；shareCallback为分享成功的回调方法。
     */    
    self.jsContext[@"JSModel"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [_SYwebview loadHTMLString:@"" baseURL:nil];
    _SYwebview.delegate = nil;
    [_SYwebview stopLoading];
}

#pragma mark -- JSExport Delegate
/** 这个需要和JS的方法同名 */
- (void)callCamera
{
    NSLog(@"调用了系统的相机方法");
    
    //block回传JS数据
    self.jsContext[@"message"] = ^(NSString *message){
        NSLog(@"提示信息：%@",message);
        NSMutableString *mutableString = [message mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    NSLog(@"%@",[self.jsContext evaluateScript:@"message('我曹，什么情况')"]);
    
    // 获取到照片之后在回调js的方法picCallback把图片传出去,通过下标的方式获取到方法
    JSValue *picCallBack = self.jsContext[@"picCallback"];
    [picCallBack callWithArguments:@[@"照片被传到JS上了"]];
    
//    self.jsContext[@"picCallback"] = ^(){
//    
//    };
    

}
- (void)share:(NSString *)shareMessage
{
    NSLog(@"点击了分享");
    NSLog(@"%@",shareMessage);
    
    //调用JS方法
    JSValue *shareCallBack = self.jsContext[@"shareCallback"];
    [shareCallBack callWithArguments:nil];
    
    OrderPayViewController *orderPayVC = [[OrderPayViewController alloc] init];
    [self.navigationController pushViewController:orderPayVC animated:YES];
    
    //通过-evaluateScript:方法就可以执行JS代码
    //[self.jsContext evaluateScript:@"shareCallback()"];
    
//    self.jsContext[@"shareCallback"] = ^(){
//        NSLog(@"分享成功");
//    };
    
}

- (void)dealloc
{
    [_SYwebview stopLoading];
    [_SYwebview loadRequest:nil];
    _SYwebview.delegate = nil;
    _SYwebview = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
