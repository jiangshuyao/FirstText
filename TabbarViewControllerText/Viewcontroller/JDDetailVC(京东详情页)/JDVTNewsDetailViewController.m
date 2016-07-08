//
//  JDVTNewsDetailViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/7.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "JDVTNewsDetailViewController.h"
#import "JDMagicViewController.h"

static CGFloat const webviewOffset = 50.0f;
static CGFloat const goodsImageHeight = 250.0f;


@interface JDVTNewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    UITableView *goodsTableView;
    UIWebView   *goodsWebview;
    UIImageView *goodsImage;
    UILabel     *pullLable;
}
@end

@implementation JDVTNewsDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.hidden = YES;
    
    [self initGoodsWebview];
    if (!_isWebviewDetail) {
        [self initTableView];
        [self initPullLable];
    }
    
}
#pragma mark -- 加载图文详情页的提示文字
- (void)initPullLable
{
    pullLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 40)];
    pullLable.text = @"下拉回到JD详情页";
    pullLable.font = [UIFont systemFontOfSize:18];
    pullLable.textAlignment = 1;
    [goodsWebview addSubview:pullLable];
    //这样做可以遮挡提示文字
    [goodsWebview sendSubviewToBack:pullLable];
    pullLable.hidden = YES;
}
#pragma mark -- 加载图文详情网页
- (void)initGoodsWebview
{
    CGFloat webviewHeight = _isWebviewDetail?0:HEIGHT;
    
    goodsWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, webviewHeight, WIDTH, HEIGHT-64)];
    goodsWebview.delegate = self;
    goodsWebview.backgroundColor = [z_UI colorWithHexString:@"84bf96"];
    [self.view addSubview:goodsWebview];
    //webview的Scrollview代理
    goodsWebview.scrollView.delegate = self;
    
    NSString *imageUrl = @"http://m.rrslj.com/h5/pages/shopstatic/store/goodDetails.html?goods_commonid=101261";
    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]];
    [goodsWebview loadRequest:imageRequest];
}
#pragma amrk -- 加载列表
- (void)initTableView
{
    //这里给tableview的headView添加透视图，并且透明度设为0，就能做到仿京东的详情页
    goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, goodsImageHeight)];
    goodsImage.backgroundColor = [z_UI colorWithHexString:@"008792"];
    goodsImage.image = [UIImage imageNamed:@"IMG_0966.JPG"];
    goodsImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:goodsImage];
    
    goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT) style:UITableViewStylePlain];
    goodsTableView.backgroundColor = [UIColor clearColor];//记得设置颜色就能看到图片了
    goodsTableView.delegate = self;
    goodsTableView.dataSource = self;
    [self.view addSubview:goodsTableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, goodsImageHeight+64)];
    headView.backgroundColor = [UIColor clearColor];
    goodsTableView.tableHeaderView =headView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    footView.backgroundColor = [z_UI colorWithHexString:@"892f1b"];
    goodsTableView.tableFooterView = footView;
    
    UILabel *la = [[UILabel alloc] initWithFrame:footView.bounds];
    la.text = @"^^^上拉查看商品详情";
    la.textAlignment = 1;
    la.textColor = [UIColor lightGrayColor];
    la.font = [UIFont systemFontOfSize:20];
    [footView addSubview:la];
    

    
//    [self.view bringSubviewToFront:goodsTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [z_UI colorWithHexString:@"#65c294"];
    NSString *text = [NSString stringWithFormat:@"这是第%ld个cell，噢噢噢噢",(long)indexPath.row];
    cell.textLabel.text = text;
    return cell;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

#pragma mark -- 主要是UIwebview的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isWebviewDetail) {
        return;
    }
    if ([scrollView isEqual:goodsWebview.scrollView]) {
        if (scrollView.contentOffset.y<=-webviewOffset) {
            pullLable.text = @"释放回到JD详情页";
        } else {
            pullLable.text = @"下拉回到JD详情页";
        }
    }
    //实现京东、淘宝详情页 商品图片的滚动方式,根据offset来判断是否跟随tableview移动
    if ([scrollView isEqual:goodsTableView]) {
        CGFloat offset = scrollView.contentOffset.y;
        if (offset>=0) {
            goodsImage.center = CGPointMake(goodsImage.center.x, goodsImageHeight/2-offset/3);
        } else {
            goodsImage.center = CGPointMake(goodsImage.center.x, goodsImageHeight/2-offset);
        }
    }
}

#pragma mark -- 上拉、下拉停止时执行的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isWebviewDetail) {
        return;
    }
    CGFloat pullOffset = (scrollView.frame.size.height+scrollView.contentOffset.y-scrollView.contentSize.height );
    //UItableview，这里判断是否tableview触底
    if ([scrollView isEqual:goodsTableView]) {
        if (pullOffset>80) {
            [UIView animateWithDuration:0.5f animations:^{
                goodsTableView.center = CGPointMake(goodsTableView.center.x, -HEIGHT/2);
                goodsWebview.center = CGPointMake(goodsWebview.center.x, HEIGHT/2-32);
            } completion:^(BOOL finished) {
                pullLable.hidden = NO;
            }];

        }
    }
    //UIWebview执行的操作
    if ([scrollView isEqual:goodsWebview.scrollView]) {
        if (scrollView.contentOffset.y<=-webviewOffset) {
            [UIView animateWithDuration:0.5f animations:^{
                goodsTableView.center = CGPointMake(goodsTableView.center.x, HEIGHT/2-64);
                goodsWebview.center = CGPointMake(goodsWebview.center.x, HEIGHT/2+HEIGHT);
            } completion:^(BOOL finished) {
                pullLable.hidden = YES;
            }];
        }
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
