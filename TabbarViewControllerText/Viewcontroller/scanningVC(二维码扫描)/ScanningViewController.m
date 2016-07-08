//
//  ScanningViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "ScanningViewController.h"
#import "MTBBarcodeScanner.h"
#import "MBProgressHUD.h"

@interface ScanningViewController ()

@property (nonatomic,strong)UIImageView   *scanCodeImageView;
@property (nonatomic,strong)UIImageView   *scanCodeLineImageView;
@property (nonatomic,strong)MBProgressHUD *mbHUD;
@property (nonatomic,copy)  NSString      *scanResult;
@property (nonatomic,strong)MTBBarcodeScanner *scanner;

@end

@implementation ScanningViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self isProhibit];
    
    [self.view addSubview:self.scanCodeImageView];
    [self.scanCodeImageView addSubview:self.scanCodeLineImageView];
    [self startScanCode];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    
    //重写返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:0];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    if (![MTBBarcodeScanner cameraIsPresent]) {
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"此设备不支持扫描" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [cameraAlert show];
        return;
    }
    [self getScanResult];
}
#pragma mark -- 判断是否开始相机
- (void)isProhibit
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在'设置->隐私->相机'中开启本应用的扫描二维码服务." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [cameraAlert show];
        return;
    }
}
#pragma amtk -- 返回
- (void)backClick:(UIButton *)sender
{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (vc == nil) {
        [self  dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
#pragma mark -- 扫描框
- (UIImageView *)scanCodeImageView
{
    if (!_scanCodeImageView) {
        _scanCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-60, WIDTH-60)];
        _scanCodeImageView.center = CGPointMake(WIDTH/2, HEIGHT/2);
        UIImage *image = [UIImage imageNamed:@"qrcode_border"];
        CGFloat top    = 25;// 顶端盖高度
        CGFloat bottom = 25;// 底端盖高度
        CGFloat left   = 25;// 左端盖宽度
        CGFloat right  = 25;// 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值,拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        _scanCodeImageView.image = image;
        
        UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 1, _scanCodeImageView.frame.size.height)];
        leftLine.image = [UIImage imageNamed:@"qrcode_navigationbar_background"];
        [_scanCodeImageView addSubview:leftLine];
        
        UIImageView *rightLine = [[UIImageView alloc] initWithFrame:CGRectMake(_scanCodeImageView.frame.size.width-2, 2, 1, _scanCodeImageView.frame.size.height)];
        rightLine.image = [UIImage imageNamed:@"qrcode_navigationbar_background"];
        [_scanCodeImageView addSubview:rightLine];
    }
    return _scanCodeImageView;
}
#pragma mark -- 扫描线
- (UIImageView *)scanCodeLineImageView
{
    if (!_scanCodeLineImageView) {
        _scanCodeLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, _scanCodeImageView.frame.size.width+20, 12)];
        _scanCodeLineImageView.image = [UIImage imageNamed:@"QRCodeScanLine"];
    }
    return _scanCodeLineImageView;
}
#pragma mark -- 重复执行扫描动作
- (void)startScanCode
{
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
        _scanCodeLineImageView.center = CGPointMake(_scanCodeLineImageView.center.x, _scanCodeImageView.frame.size.height);
    } completion:^(BOOL finished) {
        _scanCodeLineImageView.center = CGPointMake(_scanCodeLineImageView.center.x, 0);
    }];
}
#pragma amrk -- 停止扫描
- (void)stopScanCode
{
    [self.view.layer removeAllAnimations];
    [self.scanner stopScanning];
    [self.scanCodeLineImageView.layer removeAllAnimations];
}
- (void)getScanResult
{
    _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            [_scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                _scanResult = code.stringValue;
                [self stopScanCode];
                if ([_scanStype intValue] == 1) {
                    [self getResultBlock];
                } else {
                    [self pushSafraf];
                }
            }];
            
        } else {
            [self loadFailView];
        }
    }];
}
- (void)loadFailView
{
    _mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _mbHUD.mode = MBProgressHUDModeText;
    _mbHUD.labelText= @"二维码扫描失败";
    [_mbHUD hide:YES afterDelay:1.0f];
}
- (void)pushSafraf
{
    NSURL *url = [NSURL URLWithString:_scanResult];
    [[UIApplication sharedApplication] openURL:url];
    [self startScanCode];
}
- (void)getResultBlock
{
    if (self.scaingResultBlock) {
        self.scaingResultBlock(_scanResult);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
