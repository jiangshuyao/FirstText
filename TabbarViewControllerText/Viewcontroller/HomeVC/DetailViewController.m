//
//  DetailViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "DetailViewController.h"
#import "ScanningViewController.h"
#import "OrderPayViewController.h"


@interface DetailViewController ()<UIWebViewDelegate,JSExportDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *progressHUD;
    NSString      *urlToSave;//H5网页图片
}
@property (nonatomic,strong)JSContext *jsContext;
@property (nonatomic,strong)UIWebView *SYwebview;

@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navBar.lefftImage = [UIImage imageNamed:@"back_icon"];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.SYwebview];
    
    if (self.webviewType == webViewTypeJS) {
        [self loadWebviewJSWithOC];
    } else if (self.webviewType == webViewTypeImage){
        [self loadWebviewWithHtmlImage];
    }
    [self refreshWebview];
}
#pragma mark -- 给UIWebView添加下拉刷新
- (void)refreshWebview
{
    self.SYwebview.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadWebviewWithHtmlImage];
    }] ;
}

#pragma mark -- 加载JS与OC的交互
- (void)loadWebviewJSWithOC
{
    self.navBar.navigationBarTitle.text = @"OC与JavaScript交互的那些事";
    NSURL *jsUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsUrl];
    [_SYwebview loadRequest:request];
}
#pragma mark -- 加载带图片的H5
- (void)loadWebviewWithHtmlImage
{
    self.navBar.navigationBarTitle.text = @"H5长按保存图片以及浏览图片";
    NSString *imageUrl = @"http://m.rrslj.com/h5/pages/shopstatic/store/goodDetails.html?goods_commonid=101261";
    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]];
    [_SYwebview loadRequest:imageRequest];
    
    UILongPressGestureRecognizer *imageLong = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longImageSave:)];
    [_SYwebview addGestureRecognizer:imageLong];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImagePreview:)];
    tapImage.numberOfTapsRequired = 1;
    tapImage.numberOfTouchesRequired = 1;
    [_SYwebview addGestureRecognizer:tapImage];
}

#pragma mark -- 点击预览图片
- (void)tapImagePreview:(UITapGestureRecognizer *)tap
{
    
}
#pragma mark -- 长按手势
- (void)longImageSave:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gesture locationInView:self.SYwebview];
    NSString *imageURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    urlToSave = [_SYwebview stringByEvaluatingJavaScriptFromString:imageURL];
    if (urlToSave.length == 0) {
        return;
    }
    [self showImageOptions];
}
#pragma mark -- UIActionSheet长按保存图片
- (void)showImageOptions
{
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"确定要保存图片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:@"不保存", nil];
    [imageSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"保存图片");
        [self saveImageWithUrl:urlToSave];
    }
}
#pragma mark -- 下载保存图片
- (void)saveImageWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });   
    }];
    [task resume];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *saveHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    saveHUD.mode = MBProgressHUDModeText;
    if (error) {
        saveHUD.labelText = @"保存失败";
        [saveHUD hide:YES afterDelay:1.0];
    }else{
        saveHUD.labelText = @"保存成功";
        [saveHUD hide:YES afterDelay:1.0];
    }
}

#pragma mark -- 懒加载Webview
- (UIWebView *)SYwebview
{
    if (!_SYwebview) {
        _SYwebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _SYwebview.delegate =self;
//        _SYwebview.scalesPageToFit = YES;
    }
    return _SYwebview;
}
#pragma mark -- webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"正在加载...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.SYwebview.scrollView.mj_header endRefreshing];
    progressHUD.hidden = YES;
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //先说JSModel是iOS和Android这两边在本地要注入的一个对象，充当原生应用和web页面之间的一个桥梁。JS也有这个对象
    /*
     HTML页面上定义了两个按钮名字分别为CallCamera和Share。点击CallCamera会通过JSModel这个桥梁调用本地应用的方法- (void)callCamera，没有传参；而点击Share会先调用本文件中的JavaScript方法callShare这里将要分享的内容格式转成JSON字符串格式（这样做是为了适配Android，iOS可以直接接受JSON对象）然后再通过Toyun这个桥梁去调用原生应用的- (void)share:(NSString *)shareInfo方法这个是有传参的，参数为shareInfo。而下面的两个方法为原生方法调用后的回调方法，其中picCallback为获取图片成功的回调方法，并且传回拿到的图片photos；shareCallback为分享成功的回调方法。
     */
    __weak typeof(self) weakSelf = self;
    self.jsContext[@"scanCode"] = ^(){
        [weakSelf JSChangeOCClick];
    };

    
    self.jsContext[@"JSModel"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Disable user selection
    [_SYwebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [_SYwebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];

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
    // 获取到照片之后在回调js的方法picCallback把图片传出去,通过下标的方式获取到方法
    JSValue *picCallBack = self.jsContext[@"picCallback"];
    [picCallBack callWithArguments:@[@"照片被传到JS上了。。。"]];
    
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
    [self.jsContext evaluateScript:@"shareCallback()"];
    
    self.jsContext[@"shareCallback"] = ^(){
        NSLog(@"分享成功");
    };
    
}

- (void)JSChangeOCClick
{
    NSLog(@"JS调用OC方法");
    ScanningViewController *scanVC = [[ScanningViewController alloc] init];
    [self.navigationController presentViewController:scanVC animated:YES completion:^{
        
    }];
    scanVC.scanStype = @"1";
    scanVC.scaingResultBlock = ^(NSString *result){
        NSLog(@"扫描成功%@",result);
        //必须加这个？
        //通过JS调用Objective-C的方法 (Block方法)
        self.jsContext[@"message"] = ^(NSString *message){
            NSLog(@"提示信息：%@",message);
            NSMutableString *mutableString = [message mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
            return mutableString;
        };
        //OC调用JS方法
        JSValue *picCallBack = [self.jsContext evaluateScript:@"picCallback"];
        [picCallBack callWithArguments:@[result]];
        
    };
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
