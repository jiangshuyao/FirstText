//
//  AnimationViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "AnimationViewController.h"
#import "AnimationDetailViewController.h"

@interface AnimationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *animationTableView;
@property (nonatomic,strong)NSArray     *animationNameArray;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.navigationBarTitle.text = @"动画列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _animationNameArray = @[@"CAShapeLayer",@"贝塞尔曲线",@"基础动画",@"核心动画"];
    [self.view addSubview:self.animationTableView];
    [self.animationTableView reloadData];
}

- (UITableView *)animationTableView
{
    if (!_animationTableView) {
        _animationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _animationTableView.delegate = self;
        _animationTableView.dataSource = self;
    }
    return _animationTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.animationNameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _animationNameArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击后设置cell没有阴影效果
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationDetailViewController *animationVC = [[AnimationDetailViewController alloc] init];
    animationVC.animationName = _animationNameArray[indexPath.row];
    animationVC.animation = indexPath.row;
    [self.navigationController pushViewController:animationVC animated:YES];
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
