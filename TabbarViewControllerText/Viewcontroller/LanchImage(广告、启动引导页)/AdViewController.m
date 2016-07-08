//
//  AdViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/30.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "AdViewController.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"

@interface AdViewController ()
{
    NSTimer        *adTimeer;
    UIButton       *timeButton;   //倒计时按钮
    NSTimeInterval countDownTime;//倒计时时间
    UIImageView    *adImageView;
    UIImage        *imageV;
    NSString       *adClickUrl;
}
@end


@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    [self setStatusBarHidden:YES];
}
#pragma mark -- 网络上获取广告链接
- (void)getAdImage
{
    NSString *adURL = @"http://api.rrslj.com/v4/index.php?act=index&op=get_advinfo";

    [[NetworkManager shareNetworkManager] getHomeListWithUrl:adURL parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
        if ([resultDic[@"state"] intValue] == 1001) {
            NSString *AdImageURL = resultDic[@"result"][@"data"];
            adClickUrl = resultDic[@"result"][@"url"];
            [[NSUserDefaults standardUserDefaults] setObject:AdImageURL forKey:@"imageurl"];
           [adImageView sd_setImageWithURL:[NSURL URLWithString:AdImageURL] placeholderImage:nil];
        } else {
            NSLog(@"获取广告失败");
        }
    } requestFailed:^(NSDictionary *resultDic) {
        NSString *AdImageURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageurl"];
        imageV = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:AdImageURL];
        adImageView.image = imageV;
    }];
}

- (void)adTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击了广告");
    if (self.adBlock) {
        self.adBlock(adClickUrl);
//        [self removeAdVC];
    }
}
#pragma amrk -- 展示广告页
- (void)showAdImageView
{
    countDownTime = 4.0f;
    
    CGFloat ratio = WIDTH/320;
    CGFloat adHeight = ratio*150;
    
    UIImageView *adBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT-adHeight, WIDTH, adHeight)];
    adBottomView.image = [UIImage imageNamed:@"mineHead"];
    [self.view addSubview:adBottomView];
    
    adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-adHeight)];
    adImageView.userInteractionEnabled  = YES;
    NSString *AdImageURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageurl"];
    imageV = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:AdImageURL];
    NSLog(@"%@",imageV);
    [adImageView sd_setImageWithURL:[NSURL URLWithString:AdImageURL]];
    [self.view addSubview:adImageView];
    
    [self getAdImage];
    
    UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTap:)];
    [adImageView addGestureRecognizer:adTap];
    
    
    UILabel *adLable = [[UILabel alloc] initWithFrame:adBottomView.bounds];
    adLable.text = @"海尔集团@日日顺乐家\n你身边的特产小管家";
    adLable.textAlignment = 1;
    adLable.numberOfLines = 0;
    adLable.textColor = [UIColor whiteColor];
    adLable.font = [UIFont systemFontOfSize:ratio*15];
    [adBottomView addSubview:adLable];
    
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(WIDTH-100, 40, 80, 30);
    timeButton.layer.cornerRadius = 7;
    [timeButton setTitle:@"跳过" forState:0];
    [timeButton setTitleColor:[UIColor whiteColor] forState:0];
    timeButton.titleLabel.font = [UIFont systemFontOfSize:ratio*13];
    timeButton.backgroundColor = [UIColor colorWithRed:.3f green:.1f blue:.1f alpha:0.4f];
    [timeButton addTarget:self action:@selector(timeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
    
    adTimeer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(initHome) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:adTimeer forMode:NSRunLoopCommonModes];
}
#pragma mark -- 倒计时点击
- (void)timeButtonClick
{
    [self removeAdVC];
}
#pragma mark -- 倒计时显示
- (void)initHome
{
    if (countDownTime==0) {
        [self removeAdVC];
    } else {
        NSString *time = [NSString stringWithFormat:@"跳过 %.0fs",countDownTime];
        [timeButton setTitle:time forState:0];
        countDownTime--;
    }
}
#pragma mark -- 移除广告
- (void)removeAdVC
{
    [UIView animateWithDuration:0.8 animations:^{
        self.view.alpha = 0.0f;
        self.view.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self setStatusBarHidden:NO];
        [adTimeer invalidate];
    }];

}
#pragma mark -- 隐藏状态栏
- (void)setStatusBarHidden:(BOOL)hidden {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = hidden;
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
