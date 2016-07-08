//
//  JDNewsDetailViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/7.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "JDNewsDetailViewController.h"
#import "SYHeadView.h"
#import "SYHeadModel.h"

static CGFloat const webviewOffset = 50.0f;
static CGFloat const goodsImageHeight = 250.0f;
static NSString *headID = @"headID";

@interface JDNewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *sectionArray;//分组数据
    UITableView *goodsTableView;
    UIWebView   *goodsWebview;
    UIImageView *goodsImage;
    UILabel     *pullLable;
    UIScrollView   *imageScrollView;//循环滚动图
    NSMutableArray *imageCirculateArray;//
    NSArray        *imageArray;//循环图片组
    UIPageControl  *pageControl;
}
@end

@implementation JDNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.navigationBarTitle.text = @"JD详情页";
    self.view.backgroundColor = [UIColor brownColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.alpha = 0.7f;
    
    [self initSectionHeadViewArray];
    [self initTableView];
    [self initGoodsWebview];
    [self initPullLable];
    //将navBar放到上层，在上拉加载图文详情是可以不遮挡
    [self.view bringSubviewToFront:self.navBar];
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
    goodsWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT-64)];
    goodsWebview.delegate = self;
    goodsWebview.backgroundColor = [z_UI colorWithHexString:@"84bf96"];
    [self.view addSubview:goodsWebview];
    //webview的Scrollview代理
    goodsWebview.scrollView.delegate = self;
    
    NSString *imageUrl = @"http://m.rrslj.com/h5/pages/shopstatic/store/goodDetails.html?goods_commonid=101261";
    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]];
    [goodsWebview loadRequest:imageRequest];
}

- (void)initSectionHeadViewArray
{
    sectionArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<20; i++) {
        int row = arc4random()%2+5;
        NSLog(@"%d",row);
        SYHeadModel *headModel = [[SYHeadModel alloc] init];
        headModel.isExpanded = NO;
        headModel.sectionTitle = [NSString stringWithFormat:@"我的好友--%d",i];
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        for (int j=0; j<row; j++) {
            SYCellModel *cellModel = [[SYCellModel alloc] init];
            cellModel.cellTitle = [NSString stringWithFormat:@"生活不止眼前的苟且，还有诗和远方。%d",j];
            [itemArray addObject:cellModel];//注意这里
//           [headModel.cellModel addObject:cellModel];//这种方式添加不上
        }
        headModel.cellModel = itemArray;
        [sectionArray addObject:headModel];
    }
}
#pragma amrk -- 加载列表
- (void)initTableView
{
//    //这里给tableview的headView添加透视图，并且透明度设为0，就能做到仿京东的详情页
    goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, goodsImageHeight)];
    goodsImage.backgroundColor = [z_UI colorWithHexString:@"008792"];
    goodsImage.image = [UIImage imageNamed:@"IMG_0966.JPG"];
    goodsImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:goodsImage];
    
    //设置style为UITableViewStylePlain设置高度 contentView.background有效
    goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    goodsTableView.backgroundColor = [UIColor clearColor];//记得设置颜色就能看到图片了
    [goodsTableView registerClass:[SYHeadView class] forHeaderFooterViewReuseIdentifier:headID];
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
    
    [goodsTableView reloadData];
    //[self initCirculateImageView];
}

- (void)initCirculateImageView
{
    imageArray = @[@"IMG_0964.JPG",@"IMG_0965.JPG",@"IMG_0966.JPG",@"IMG_0967.JPG"];
    imageCirculateArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, goodsImageHeight)];
    imageScrollView.contentSize = CGSizeMake(WIDTH*3, goodsImageHeight);
    imageScrollView.contentOffset = CGPointMake(WIDTH, 0);
    imageScrollView.delegate = self;
    imageScrollView.bounces = YES;
    [self.view addSubview:imageScrollView];
    
    for (int i = 0; i<3; i++) {
        goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, goodsImageHeight)];
        
        NSInteger index = 0;
        if (i == 0) {
            index = imageArray.count-1;
        } else {
            index = i-1;
        }
        
        goodsImage.tag = index;
        [imageCirculateArray addObject:goodsImage];
        [self initImageWithIndex:index];
        [imageScrollView addSubview:goodsImage];
    }
    //初始化pageControl,最后添加,这样它会显示在最前面,不会被遮挡
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageScrollView.frame) - 30, WIDTH, 30)];
    pageControl.numberOfPages = imageArray.count;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
}
- (void)initImageWithIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:imageArray[index]];
    goodsImage.image = image;
}
- (void)startScrollViewImage
{
    CGFloat offset = imageScrollView.contentOffset.x;
    NSInteger scrollIndex = 0;
    if (offset>WIDTH) {
        scrollIndex = 1;
    } else if (offset==0){
        scrollIndex = -1;
    } else {
        return;
    }
    for (UIImageView *indexImage in imageCirculateArray) {
        NSInteger index = scrollIndex+indexImage.tag;
        if (index<0) {
            index = pageControl.numberOfPages-1;
        } else if(index >= pageControl.numberOfPages){
            index = 0;
        }
        goodsImage.tag = index;
        [self initImageWithIndex:index];
    }
    //更新pageControl显示的页码,也就是中间那个imageview的tag值
    pageControl.currentPage = [imageCirculateArray[1] tag];
    
    //使用无动画的效果快速切换,也就是把scrollview的偏移量还设置成一个imageview的宽度
    //这里是通过设置scrollview的偏移量让其来回滑动,时刻更换imageview的图片,每换一次,就立即让scrollview以无动画的方式再回到偏移量为一个imageview宽度的偏移量位置,即还是显示的中间那个imageview,以此给用户产生一种来回切换的错觉,实质一直是在显示中间那个imageview
    imageScrollView.contentOffset = CGPointMake(WIDTH, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SYHeadModel *model = sectionArray[section];
    return model.isExpanded ? model.cellModel.count:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SYHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    SYHeadModel *model = sectionArray[section];
    headView.headModel = model;
    headView.expandBlock = ^(BOOL isExpand){
        [goodsTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor colorWithRed:209/255.0 green:73/255.0 blue:78/255.0 alpha:1];
    SYHeadModel *headModel = sectionArray[indexPath.section];
    SYCellModel *cellModel = headModel.cellModel[indexPath.row];
    cell.textLabel.text = cellModel.cellTitle;
    return cell;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

#pragma mark -- 主要是UIwebview的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:goodsWebview.scrollView]) {
        if (scrollView.contentOffset.y<=-webviewOffset) {
            pullLable.text = @"释放回到JD详情页";
        } else {
            pullLable.text = @"下拉回到JD详情页";
        }
    }
    //实现京东、淘宝详情页 商品图片的滚动方式,根据offset来判断是否跟随tableview移动
    else if ([scrollView isEqual:goodsTableView]) {
        CGFloat offset = scrollView.contentOffset.y;
        if (offset>=0) {
            goodsImage.center = CGPointMake(goodsImage.center.x, 64+goodsImageHeight/2-offset/3);
        } else {
            goodsImage.center = CGPointMake(goodsImage.center.x, 64+goodsImageHeight/2-offset);
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:imageScrollView]) {
        [self startScrollViewImage];
    }
}

#pragma mark -- 上拉、下拉停止时执行的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat pullOffset = (scrollView.frame.size.height+scrollView.contentOffset.y-scrollView.contentSize.height );
    //UItableview，这里判断是否tableview触底
    if ([scrollView isEqual:goodsTableView]) {
        if (pullOffset>80) {
            [UIView animateWithDuration:0.5f animations:^{
                goodsTableView.center = CGPointMake(goodsTableView.center.x, -HEIGHT/2);
                goodsWebview.center = CGPointMake(goodsWebview.center.x, HEIGHT/2+32);
            } completion:^(BOOL finished) {
                self.navBar.navigationBarTitle.text = @"图文详情";
                pullLable.hidden = NO;
                self.navBar.alpha = 1.0f;
            }];

        }
    }
    //UIWebview执行的操作
    if ([scrollView isEqual:goodsWebview.scrollView]) {
        if (scrollView.contentOffset.y<=-webviewOffset) {
            [UIView animateWithDuration:0.5f animations:^{
                goodsTableView.center = CGPointMake(goodsTableView.center.x, HEIGHT/2);
                goodsWebview.center = CGPointMake(goodsWebview.center.x, HEIGHT/2+HEIGHT-32);
            } completion:^(BOOL finished) {
                self.navBar.navigationBarTitle.text = @"JD详情页";
                pullLable.hidden = YES;
                self.navBar.alpha = 0.7f;
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
