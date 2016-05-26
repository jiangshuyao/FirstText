//
//  HomeViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "HomeViewController.h"

#import "MainViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"

#import "checkNeworkManeger.h"
#import "UIView+SDAutoLayout.h"
#import "HMSegmentedControl.h"
#import "SDCycleScrollView.h"
#import "UserCenterViewController.h"
#import "VideoViewController.h"
#import "MultiMenuLsitViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UITableView  *homeListTableView;
@property (nonatomic, strong) NSArray      *homeListArray;
@property (nonatomic, strong) SDCycleScrollView *flashView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    //设置导航栏按钮
    [self setNavBarButton];
    
    _homeListArray = @[@"JS与OC的交互",
                       @"个人中心头像下拉放大",
                       @"视频播放列表",
                       @"各种动画效果集合",
                       @"各种折线图集合",
                       @"系统相册选择",
                       @"自定义相册选择",
                       @"多级菜单显示"];
    
    //设置widget数据共享
    [self shareWidgetDate];
    
    //初始化tableview
    [self.view addSubview:self.homeListTableView];
    self.homeListTableView.tableHeaderView = self.flashView;
    self.homeListTableView.tableFooterView = [UIView new];
    
    //为轮播图添加数据
    [self initFlashScrollViewData];
    
}

/** 设置navBar的左右按钮 */
- (void)setNavBarButton
{
    [self.navBar.leftButton setImage:[UIImage imageNamed:@"search_icon"] forState:0];
    
    [self.navBar.rightButton setImage:[UIImage imageNamed:@"set_icon"] forState:0];
    self.navBar.navigationBarTitle.text = @"首页";
    self.navBar.textColor = [UIColor cyanColor];
    
    __weak typeof(self)weakSelf = self;
    [self.navBar setLeftButtonClickBlock:^{
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    }];
    
    [self.navBar setRightButtonClickBlock:^{
        NSLog(@"点击了右面的");
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
        _homeListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
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
    [cell addSubview:cellLine];
    
    //cell点击无反应状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *pushVC;
    switch (indexPath.row) {
        //JS与OC调用
        case 0:
        pushVC = [[DetailViewController alloc] init];
        break;
        //个人中心
        case 1:
        pushVC = [[UserCenterViewController alloc] init];
        break;
        //视频播放
        case 2:
        pushVC = [[VideoViewController alloc] init];
        break;
            
        case 3:
            pushVC = [[VideoViewController alloc] init];
            break;
        
        case 4:
            pushVC = [[VideoViewController alloc] init];
            break;
        
        case 5:
            pushVC = [[VideoViewController alloc] init];
            break;
            
        case 6:
            pushVC = [[VideoViewController alloc] init];
            break;
        //多级菜单显示
        default:
        pushVC = [[MultiMenuLsitViewController alloc] init];
        break;
    }
    [self.navigationController pushViewController:pushVC animated:YES];
}

@end
