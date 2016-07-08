//
//  MultiMenuLsitViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/20.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "MultiMenuLsitViewController.h"
#import "MultiMenuTableViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PinterestViewController.h"
#import "seleteView.h"
#import "shopClassItem.h"

float const seleteHeight = 40.0f;
//图片分类的URL
NSString  *const classUrl = @"http://www.tngou.net/tnfs/api/classify";
//某一类别的具体按图片列表
#define classDetailUrl(classID)        [NSString stringWithFormat:@"http://www.tngou.net/tnfs/api/list?page=%@&rows=20",classID]//图片的URL

@interface MultiMenuLsitViewController ()<UITableViewDataSource,UITableViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic,strong)UITableView    *menuListLeftTableView;
@property (nonatomic,strong)UITableView    *menuListRightTableView;
@property (nonatomic,strong)NSMutableArray *menuListLeftArray;
@property (nonatomic,strong)NSMutableArray *menuListRightArray;
@property (nonatomic,strong)seleteView     *seleteView;
@property (nonatomic,strong)PinterestViewController *pinVC;

//判断点击了lefttable第几个
@property (nonatomic,assign)int leftIndex;
//类别ID
@property (nonatomic,copy)  NSString *classId;

@end

@implementation MultiMenuLsitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.navigationBarTitle.text = @"商品分类";
    //点击了第几个左边的
    _leftIndex = 0;
    [self initLeftTableViewData];
    [self initMainView];
}
#pragma amrk -- 加载具体分类的数据源
- (void)initClassDetailDateWithClassid:(NSString *)classID
{
    [[NetworkManager shareNetworkManager] getHomeListWithUrl:classDetailUrl(classID) parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
    
    } requestFailed:^(NSDictionary *resultDic) {
    
    }];
}
#pragma amrk -- 初始化left类别数据
- (void)initLeftTableViewData
{
    [[NetworkManager shareNetworkManager] getHomeListWithUrl:classUrl parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"status"] intValue] == 1) {
            NSArray *arr = [resultDic objectForKey:@"tngou"];
            //获取到最先出现的类别ID
            _classId = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"id"]];
            for (NSDictionary *dic in arr) {
                shopClassItem *model = [[shopClassItem alloc] init];
                model.shopID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                model.shopTitle = [dic objectForKey:@"title"];
                [self.menuListLeftArray addObject:model];
            }
            [self.menuListLeftTableView reloadData];
        } else {
            NSLog(@"数据请求失败");
        }
    } requestFailed:^(NSDictionary *resultDic) {
        
    }];
    [self initClassDetailDateWithClassid:_classId];
}
- (void)initMainView
{
    //初始化筛选器
    [self.view addSubview:self.seleteView];
    self.seleteView.seleteBlock = ^(NSInteger index,BOOL isSelete){
        if (isSelete) {
            NSLog(@"选择了第%ld个,向上",(long)index);
        } else {
            NSLog(@"选择了第%ld个,向下",(long)index);
        }
    };
    [self.view addSubview:self.menuListLeftTableView];
    [self.view addSubview:self.menuListRightTableView];
}

#pragma mark -- 懒加载左边的列表页
- (UITableView *)menuListLeftTableView
{
    if (!_menuListLeftTableView) {
        _menuListLeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+seleteHeight, 100, HEIGHT-64-seleteHeight)];
        _menuListLeftTableView.delegate = self;
        _menuListLeftTableView.dataSource = self;
        _menuListLeftTableView.backgroundColor = [z_UI colorWithHexString:@"#4d4f36"];
        _menuListLeftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _menuListLeftTableView;
}
#pragma mark -- 懒加载筛选视图
- (seleteView *)seleteView
{
    if (!_seleteView) {
        NSArray *itemArray = @[@"综合",@"销量",@"价格",@"评分"];
        _seleteView = [[seleteView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, seleteHeight) itemArray:itemArray];
    }
    return _seleteView;
}
#pragma mark -- 懒加载右边的列表(仿京东后改成加载collectionView)
- (UITableView *)menuListRightTableView
{
    if (!_menuListRightTableView) {
        _menuListRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(_menuListLeftTableView.frame.size.width, 64+seleteHeight, WIDTH-_menuListLeftTableView.frame.size.width, HEIGHT-64-seleteHeight)];
        _menuListRightTableView.dataSource = self;
        _menuListRightTableView.delegate = self;
        _menuListRightTableView.backgroundColor = [z_UI colorWithHexString:@"#d1c7b7"];
    }
    return _menuListRightTableView;
}

- (NSMutableArray *)menuListLeftArray
{
    if (!_menuListLeftArray) {
        _menuListLeftArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _menuListLeftArray;
}
- (NSMutableArray *)menuListRightArray
{
    if (!_menuListRightArray) {
        _menuListRightArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i<20; i++) {
            NSString *str = [NSString stringWithFormat:@"这是二级页面%d",i];
            [_menuListRightArray addObject:str];
        }
    }
    return _menuListRightArray;
}
#pragma mark -- 根据是左边还是右边列表加载数据源(改成仿京东后这个不用判断了直接加载左边列表数据源就行)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_menuListLeftTableView]) {
        return self.menuListLeftArray.count;
    } else {
        return self.menuListRightArray.count;
    }
}
#pragma mark -- 根据是左边还是右边列表高度(改成仿京东后这个不用判断了直接加载左边列表高度就行)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_menuListLeftTableView]) {
        return 49;
    } else {
        return 99;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    MultiMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        if ([tableView isEqual:_menuListLeftTableView]){
            cell = [[MultiMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault cellType:@"1" reuseIdentifier:cellID];
        } else {
            cell = [[MultiMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault cellType:@"2" reuseIdentifier:cellID];
        }
    }
    //如果要设置cell点击之后的颜色就不需要设置它的selectionStyle了
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([tableView isEqual:_menuListLeftTableView]) {
        shopClassItem *model = self.menuListLeftArray[indexPath.row];
        cell.shopClassItemModel = model;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *text = [NSString stringWithFormat:@"%@左边是%d",_menuListRightArray[indexPath.row],_leftIndex];
        if (_leftIndex%2==0) {
            cell.headImage.image = [UIImage imageNamed:@"IMG_0964.JPG"];
        } else {
            cell.headImage.image = [UIImage imageNamed:@"imagesGirl.jpg"];
        }
        cell.titleLable.text = text;
    }
    return cell;
}
#pragma amrk -- 左边的列表点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_menuListLeftTableView]) {
        //根据点击的左边的cell来安排cell的位置居上还是居下
        [_menuListLeftTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _leftIndex = (int)indexPath.row;
        //右边的cell回到最上面
        [_menuListRightTableView scrollRectToVisible:CGRectMake(0, 0, _menuListRightTableView.frame.size.width, _menuListRightTableView.frame.size.height) animated:YES];
        [_menuListRightTableView reloadData];
    }
}
@end

