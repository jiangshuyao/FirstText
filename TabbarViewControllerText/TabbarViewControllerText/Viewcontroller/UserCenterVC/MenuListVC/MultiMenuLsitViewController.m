//
//  MultiMenuLsitViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/20.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "MultiMenuLsitViewController.h"

@interface MultiMenuLsitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView    *menuListLeftTableView;
@property (nonatomic,strong)UITableView    *menuListRightTableView;
@property (nonatomic,strong)NSArray *menuListLeftArray;
@property (nonatomic,strong)NSArray *menuListRightArray;

@property (nonatomic,assign)int leftIndex;

@end

@implementation MultiMenuLsitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [z_UI colorWithHexString:@"#c1a173"];
    self.navBar.navigationBarTitle.text = @"多级菜单显示";
    
    _leftIndex = 0;
    [self.view addSubview:self.menuListLeftTableView];
    [self.view addSubview:self.menuListRightTableView];
}

- (UITableView *)menuListLeftTableView
{
    if (!_menuListLeftTableView) {
        _menuListLeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 100, HEIGHT-64)];
        _menuListLeftTableView.delegate = self;
        _menuListLeftTableView.dataSource = self;
        _menuListLeftTableView.backgroundColor = [z_UI colorWithHexString:@"#4d4f36"];
    }
    return _menuListLeftTableView;
}

- (UITableView *)menuListRightTableView
{
    if (!_menuListRightTableView) {
        _menuListRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(_menuListLeftTableView.frame.size.width, 64, WIDTH-_menuListLeftTableView.frame.size.width, HEIGHT-64)];
        _menuListRightTableView.dataSource = self;
        _menuListRightTableView.delegate = self;
        _menuListRightTableView.backgroundColor = [z_UI colorWithHexString:@"#d1c7b7"];
    }
    return _menuListRightTableView;
}

- (NSArray *)menuListLeftArray
{
    if (!_menuListLeftArray) {
        _menuListLeftArray = [[NSMutableArray alloc] initWithCapacity:0];
        _menuListLeftArray = @[@"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面",@"这是一级页面",
                               @"这是一级页面"];
    }
    return _menuListLeftArray;
}
- (NSArray *)menuListRightArray
{
    if (!_menuListRightArray) {
        _menuListRightArray = [[NSMutableArray alloc] initWithCapacity:0];
        _menuListRightArray = @[@"这是二级页面1",@"这是二级页面2",
                                @"这是二级页面3",@"这是二级页面4",
                                @"这是二级页面5",@"这是二级页面6",
                                @"这是二级页面7",@"这是二级页面8",
                                @"这是二级页面9",@"这是二级页面10",
                                @"这是二级页面11",@"这是二级页面12",
                                @"这是二级页面13",@"这是二级页面14",
                                @"这是二级页面15",@"这是二级页面16",
                                @"这是二级页面17",@"这是二级页面18"];
    }
    return _menuListRightArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_menuListLeftTableView]) {
        return self.menuListLeftArray.count;
    } else {
        return self.menuListRightArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_menuListLeftTableView]) {
        return 49;
    } else {
        return 69;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([tableView isEqual:_menuListLeftTableView]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    } else {
        NSString *text = [NSString stringWithFormat:@"%@=%d",_menuListRightArray[indexPath.row],_leftIndex];
        cell.textLabel.text = text;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_menuListLeftTableView]) {
        //根据点击的左边的cell来安排cell的位置居上还是居下
        [_menuListLeftTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        _leftIndex = (int)indexPath.row;
        //右边的cell回到最上面
        [_menuListRightTableView scrollRectToVisible:CGRectMake(0, 0, _menuListRightTableView.frame.size.width, _menuListRightTableView.frame.size.height) animated:YES];
        [_menuListRightTableView reloadData];
    }
}


@end

