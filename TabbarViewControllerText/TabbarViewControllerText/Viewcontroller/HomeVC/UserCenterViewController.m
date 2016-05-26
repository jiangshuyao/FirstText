//
//  UserCenterViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/11.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "UserCenterViewController.h"

#import "cirleView.h"

@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userCenterTableView;
    UIImageView *headImage;
}
@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.navBar.navigationBarTitle.text = @"个人中心";
    
//    cirleView *vc = [[cirleView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
//    [self.view addSubview:vc];
    
    [self initTableView];
}

- (void)initTableView
{
    userCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    userCenterTableView.delegate = self;
    userCenterTableView.dataSource = self;
    [self.view addSubview:userCenterTableView];
    
    headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0967.jpg"]];
    //等比例缩放,图片不会变形.填充整个父控件
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat ratio = headImage.frame.size.height/headImage.frame.size.width;
    //CGFloat ratio = WIDTH/HEIGHT;
    CGFloat headW = headImage.frame.size.width;
    CGFloat headH = headImage.frame.size.height;
    headImage.frame = CGRectMake(0, -headH, headW, headH);
    
    //为了不挡住tableView的cell内容所以将顶部的View插入到最下面的一层
    [userCenterTableView insertSubview:headImage atIndex:0];
    //设置tableView 的内边距 这样顶部的view 就能够完全的展示出来,不会挡住cell.
    userCenterTableView.contentInset = UIEdgeInsetsMake(headH*0.3, 0, 0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [userCenterTableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *str = [NSString stringWithFormat:@"这是一个cell"];
    cell.textLabel.text = str;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //由于scrollView 向下拖拽的contentOffset.y的值是负数.并且设置了contentInsets,这里这样设置可以将offset的初始值设置为0,下拉时为正数,方便判断.
    CGFloat offset = -(scrollView.contentOffset.y + headImage.image.size.height*0.3);
    //image的宽高比
    CGFloat scale = headImage.image.size.width / headImage.image.size.height;
    //如果是向上拖动 返回.
    if (offset < 0) return;
    //取出topView的frame
    CGRect frame = headImage.frame;
    //x值向左边移动-offset的距离
    frame.origin.x = -offset;
    //由于在viewDidLoad方法中设置了topView 的图片填充模式,所以宽度拉伸之后,高度也会相应的拉伸.
    frame.size.width =(headImage.image.size.height +3*offset) *scale;
    //重新赋值
    headImage.frame = frame;
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
