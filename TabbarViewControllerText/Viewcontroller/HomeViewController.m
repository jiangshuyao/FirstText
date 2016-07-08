//
//  HomeViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "HomeViewController.h"

#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import <objc/runtime.h>

#import "checkNeworkManeger.h"
#import "UIView+SDAutoLayout.h"
#import "HMSegmentedControl.h"
#import "SDCycleScrollView.h"
#import "UserCenterViewController.h"
#import "VideoViewController.h"
#import "MultiMenuLsitViewController.h"
#import "AnimationViewController.h"
#import "ScanningViewController.h"

#import "JDVTNewsDetailViewController.h"
#import "JDNewsDetailViewController.h"
#import "JDMagicViewController.h"
#import "EffectImageViewController.h"
#import "InfoMessageViewController.h"
#import "PinterestViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UITableView  *homeListTableView;
@property (nonatomic, strong) NSArray      *homeListArray;
@property (nonatomic, strong) NSArray      *homeListVCArray;
@property (nonatomic, strong) SDCycleScrollView *flashView;

@end

@implementation HomeViewController

//设置home页状态栏颜色（其他页还是黑色）1、plist设置2、appdelegate设置3、具体页设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    //设置导航栏按钮
    [self setNavBarButton];
    
    [self initHomeDate];
    //设置widget数据共享
    [self shareWidgetDate];
    
    //初始化tableview
    [self.view addSubview:self.homeListTableView];
    self.homeListTableView.tableHeaderView = self.flashView;
    self.homeListTableView.tableFooterView = [UIView new];
    
    //为轮播图添加数据
    [self initFlashScrollViewData];
    [self initGradientColor];
    
    [self initRuntimeText];
}
#pragma mark -- Runtime测试
- (void)initRuntimeText
{
    unsigned int count = 0;
    Ivar *members = class_copyIvarList([UIAlertController class], &count);
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        const char *memberName = ivar_getName(var);//属性名
        const char *memberType = ivar_getTypeEncoding(var);//类型
        NSLog(@"%s----%s", memberName, memberType);
    }
    
    //函数方法名
    Method *memberFuncs = class_copyMethodList([UIAlertController class], &count);//所有在.m文件显式实现的方法都会被找到
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(memberFuncs[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        NSLog(@"member method:%@", methodName);
    }
}

#pragma mark -- 初始化home数据
- (void)initHomeDate
{
    _homeListArray = @[@"JS与OC的交互",
                       @"个人中心头像下拉放大",
                       @"视频播放列表",
                       @"各种动画效果集合",
                       @"各种折线图集合",
                       @"系统相册选择",
                       @"自定义相册选择",
                       @"多级菜单显示",
                       @"二维码扫描",
                       @"长按H5保存图片、浏览图片",
                       @"仿京东商品详情页",
                       @"仿京东商品详情页(三个标签)",
                       @"图片的高斯模糊",
                       @"TouchID点击",
                       @"瀑布流效果"];
    
    _homeListVCArray = @[@"DetailViewController",
                         @"UserCenterViewController",
                         @"VideoViewController",
                         @"AnimationViewController",
                         @"VideoViewController",
                         @"VideoViewController",
                         @"VideoViewController",
                         @"MultiMenuLsitViewController",
                         @"ScanningViewController",
                         @"DetailViewController",
                         @"JDNewsDetailViewController",
                         @"JDMagicViewController",
                         @"EffectImageViewController",
                         @"InfoMessageViewController",
                         @"PinterestViewController"];

}

- (void)initGradientColor
{
    //设置图片渐变颜色
    UIColor *topleftColor = [UIColor colorWithRed:48/255.0f green:127/255.0f blue:202/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:35/255.0f green:195/255.0f blue:95/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(WIDTH, HEIGHT-64)];
    self.homeListTableView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
}

/** 设置navBar的左右按钮 */
- (void)setNavBarButton
{
    [self.navBar.leftButton setImage:[UIImage imageNamed:@"search_icon"] forState:0];
    
    [self.navBar.rightButton setImage:[UIImage imageNamed:@"set_icon"] forState:0];
    self.navBar.navigationBarTitle.text = @"首页";
    self.navBar.textColor = [UIColor cyanColor];
    
    __weak typeof(self)weakSelf = self;
    
//    [self.navBar setLeftButtonClickBlock:^{
//        DetailViewController *detailVC = [[DetailViewController alloc] init];
//        [weakSelf.navigationController pushViewController:detailVC animated:YES];
//    }];
    
    self.navBar.leftButtonClickBlock  = ^(){
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.webviewType = webViewTypeJS;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    [self.navBar setRightButtonClickBlock:^{
        NSLog(@"应用内打开第三方应用");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"canvasText://"]];
    }];
}

/** widget数据共享 */
- (void)shareWidgetDate
{
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"group.love"];
    NSString *str = @"This is a text!!!!!!!!!!!!!";
    [ud setObject:str forKey:@"group.love.message"];
    [ud synchronize];
}

/** 无限轮播代理点击事件 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了%ld张",(long)index);
}

/** 初始化tanleview */
- (UITableView *)homeListTableView
{
    if (!_homeListTableView) {
        _homeListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-59)];
        _homeListTableView.dataSource = self;
        _homeListTableView.delegate = self;
        //去除cell原生的分割线
        _homeListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [_homeListTableView reloadData];
    return _homeListTableView;
}

/** 设置tableview的headView 无限轮播视图 */
- (SDCycleScrollView *)flashView
{
    if (!_flashView) {
        
        //初始化无限轮播图
        _flashView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"geren_touxiang"]];
    }
    return _flashView;
}

/** 为轮播图设置轮播图片数据源 */
- (void)initFlashScrollViewData
{
    //设置轮播文字
    NSArray *cycleTitleArray    = @[@"我从你的全世界路过",
                                    @"岛上书店只为你开启",
                                    @"做天长地久的朋友",
                                    @"才能拥有一段永不分手的感情"];
    //设置轮播图
    NSArray *locationImageArray = @[@"IMG_0964.JPG",
                                    @"IMG_0965.JPG",
                                    @"IMG_0966.JPG",
                                    @"IMG_0967.JPG"];
    //设置本地轮播图片
    _flashView.localizationImageNamesGroup = locationImageArray;
    //设置轮播的pageControl样式
    _flashView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    //设置轮播文字
    _flashView.titlesGroup = cycleTitleArray;
    //设置分页控制器的位置
    _flashView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //block点击事件
    [_flashView setClickItemOperationBlock:^(NSInteger index) {
        NSLog(@"block点击了%ld",(long)index);
    }];
    
    _flashView.clickItemOperationBlock = ^(NSInteger index){
        NSLog(@"block点击了第%ld张",(long)index);
    };
}

#pragma mark -- tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.homeListArray objectAtIndex:indexPath.row];
    UIView * cellLine = [[UIView alloc] initWithFrame:CGRectMake(0, 58, WIDTH, 0.5)];
    cellLine.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell addSubview:cellLine];
    
    //cell点击无反应状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initGradientColorWithView:cell.contentView];
    return cell;
}
- (void)initGradientColorWithView:(UIView *)cell
{
    //设置图片渐变颜色
    UIColor *topleftColor = [UIColor colorWithRed:48/255.0f green:127/255.0f blue:202/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:35/255.0f green:195/255.0f blue:95/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(WIDTH, HEIGHT-64)];
    cell.backgroundColor = [UIColor colorWithPatternImage:bgImg];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcName = [_homeListVCArray objectAtIndex:indexPath.row];
    [self runTimePushViewController:vcName cellAtIndex:indexPath];
}
#pragma mark -- 从列表页跳转到viewcontroller详情页
- (void)runTimePushViewController:(NSString *)PushVC cellAtIndex:(NSIndexPath *)indexPath
{
    NSString *class = PushVC;
    
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    BaseViewController *instance = [[newClass alloc] init];
    if (indexPath.row == 0) {
        instance.webviewType = webViewTypeJS;
    }
    if (indexPath.row == 9) {
         instance.webviewType = webViewTypeImage;
    }
    [self.navigationController pushViewController:instance animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    

}
//iOS8之后的方法（自定义左滑编辑菜单）
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *modifyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了修改");
        //收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    modifyAction.backgroundColor = [UIColor brownColor];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        //收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    deleteAction.backgroundColor = [UIColor magentaColor];
    return @[ modifyAction,deleteAction];
}


@end
