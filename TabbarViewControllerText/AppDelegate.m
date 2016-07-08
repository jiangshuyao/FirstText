//
//  AppDelegate.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "AppDelegate.h"

#import "RDVTabBarItem.h"

#import "HomeViewController.h"
#import "MessageViewController.h"
#import "UserCenterViewController.h"
#import "InfoMessageViewController.h"

#import "Reachability.h"
#import "AdViewController.h"
#import "GuideViewController.h"



@interface AppDelegate ()
@property (nonatomic, strong) Reachability *conn;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //实时监测网络状态
    //单例模式的网络提示
    //[[checkNeworkManeger shareNetwork] checkNetworkRealTimeStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [NSThread sleepForTimeInterval:1.0f];
    
    NSUserDefaults *isGuide = [[NSUserDefaults standardUserDefaults] objectForKey:isGuideFirst];
    if (!isGuide) {
        [self applicationLaunchedGuide];
    } else {
        [self applicationLaunched];
    }

    int cacheSizeMemory = 1*1024*1024; // 4MB
    int cacheSizeDisk = 5*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] ;
    [NSURLCache setSharedURLCache:sharedCache];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -- 有引导页
- (void)applicationLaunchedGuide
{
    GuideViewController *guideVC = [[GuideViewController alloc] init];
    
    //现在引导页目前只能用这个添加
    [self.window setRootViewController:guideVC];

    //这个方式添加会导致UIScrollview的代理不执行，为啥？
    //[self.window.rootViewController.view addSubview:guideVC.view];
    
    //这种方式使APP直接进入主页
    //[self.window.rootViewController addChildViewController:guideVC];
    
}
- (void)LoadHomeViewController
{
    self.window.rootViewController = self.SYTabBarController;
}
#pragma mark -- 无引导页启动
- (void)applicationLaunched
{
    self.window.rootViewController = self.SYTabBarController;
    
    //添加广告业
    AdViewController *adVC = [[AdViewController alloc] init];
    [adVC showAdImageView];
    
    [self.window.rootViewController.view addSubview:adVC.view];
    
    adVC.adBlock =  ^(NSString *url){
        UINavigationController *na = (UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        [na presentViewController:detailVC animated:YES completion:^{
            [adVC removeAdVC];
        }];
    };
}

#pragma mark -- 获取启动图片
- (void)getLanchImage
{
    CGSize viewSize = self.window.bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.window.rootViewController.view addSubview:launchView];
    [self.window.rootViewController.view bringSubviewToFront:launchView];
    
    AdViewController *adVC = [[AdViewController alloc] init];
    [adVC getAdImage];

    [UIView animateWithDuration:1.0f animations:^{
        launchView.alpha = 0.0f;
        launchView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
        [self.window.rootViewController.view addSubview:adVC.view];
        [self.window.rootViewController.view bringSubviewToFront:adVC.view];
    }];
//    [UIView animateWithDuration:2.0f
//                          delay:0.0f
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         
//                         launchView.alpha = 0.0f;
//                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
//                         
//                     }
//                     completion:^(BOOL finished) {
//                         
//                         [launchView removeFromSuperview];
//                         
//                     }];

}
- (void)checkNetworkState
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        
    } else { // 没有网络
        
        NSLog(@"没有网络");
        [[[UIAlertView alloc] initWithTitle:@"现在的网络状态是" message:@"网络开小差了~~~" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}
- (void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (RDVTabBarController *)SYTabBarController
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UIViewController *homeNV = [[UINavigationController alloc]
                                                   initWithRootViewController:homeVC];
    
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UIViewController *messageNV = [[UINavigationController alloc]
                                initWithRootViewController:messageVC];

    
    UserCenterViewController *infoVC = [[UserCenterViewController alloc] init];
    UIViewController *infoNV = [[UINavigationController alloc]
                                   initWithRootViewController:infoVC];
    
//    infoVC.needShowTabBar    = YES;
//    messageVC.needShowTabBar = YES;
//    infoVC.needShowTabBar    = YES;
    
    
    _SYTabBarController = [[RDVTabBarController alloc] init];
    [_SYTabBarController setViewControllers:@[homeNV,messageNV,infoNV]];
    [self setTabBarItemImage];
    return _SYTabBarController;
}

- (void)setTabBarItemImage
{
    UIImage *selecteBackgroundImage = [UIImage imageNamed:@""];
    UIImage *unselectBackgroundImage = [UIImage imageNamed:@""];
    
    NSArray *tabBarItemImages = @[@"home_icon",@"news_icon",@"me_icon"];
    NSArray *tabbarItemSelectImages = @[@"home_icon_xuanzhong",@"news_icon_xuanzhong",@"me_icon_xuanzhong@3x"];
    NSArray *tabbarItemTitle =  @[@"首页",@"消息",@"个人中心"];
    
    RDVTabBar *tabbarView = [_SYTabBarController tabBar];
    //设置tabbar背景颜色
    tabbarView.backgroundColor = [UIColor grayColor];
    tabbarView.backgroundView.backgroundColor = [z_UI colorWithHexString:@"#2E8B57"];
    //设置tabbar高度
    [tabbarView setHeight:59];
    
    NSInteger index = 0;
    for (RDVTabBarItem *SYitem in [[_SYTabBarController tabBar] items]) {
        
        [SYitem setBackgroundSelectedImage:selecteBackgroundImage withUnselectedImage:unselectBackgroundImage];
        
        [SYitem setFinishedSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",tabbarItemSelectImages[index]]] withFinishedUnselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",tabBarItemImages[index]]]];
        
        SYitem.title = [NSString stringWithFormat:@"%@",tabbarItemTitle[index]];
        //设置字体的位置向下10个像素
        SYitem.titlePositionAdjustment = UIOffsetMake(0, 5);
        
        //设置Item被选中时的字体颜色
        SYitem.selectedTitleAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor cyanColor]};
        
        //设置正常状态下的字体颜色
        SYitem.unselectedTitleAttributes =  @{ NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        if (index == 1) {
            //[item setBadgeBackgroundColor:[UIColor blackColor]];
            [SYitem setBadgeValue:@"2"];
            [SYitem setBadgePositionAdjustment:UIOffsetMake(10, 5)];
            [SYitem setBadgeBackgroundImage:[UIImage imageNamed:@"tishi_icon"]];
            
//            [item setBadgeValue:@""];
        }
        index++;
    }
}

/*
 *   由Widget根据指定的按钮跳转到指定的页
 *   需要注意的：1、在主应用的Plist文件里面设置URL types（创建Widget时会创建一个plist为辅）
 *             2、指定跳转的URL，进行相关的跳转
 *
 **/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* prefix = @"iOSWidgetApp://action=";
    if ([[url absoluteString] rangeOfString:prefix].location!=NSNotFound) {
        NSString *action = [[url absoluteString] substringFromIndex:prefix.length];
            //跳转到home
        if ([action isEqualToString:@"GotoHomePage"]) {
            RDVTabBarController *tabBarController = (RDVTabBarController*)self.window.rootViewController;
            [tabBarController setSelectedIndex:0];
            //跳转到Message
        } else if ([action isEqualToString:@"GotoMessage"]){
            RDVTabBarController *tabBarController = (RDVTabBarController*)self.window.rootViewController;
            [tabBarController setSelectedIndex:1];
            //跳转到详情页
        } else {
            UINavigationController *na = (UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController];
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            [na presentViewController:detailVC animated:YES completion:^{
                
            }];
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
