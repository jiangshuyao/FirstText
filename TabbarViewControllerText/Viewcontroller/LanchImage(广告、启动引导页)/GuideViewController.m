//
//  GuideViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/31.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController (){
    UIImageView  *guideImageView;
    UIPageControl *pageControl;
}

@property (nonatomic,strong)UIScrollView *guideScrollView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    
    [self initGuideView];
    [self initPageControlView];
}

- (void)initPageControlView
{
    int pagesCount =4;
    pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(WIDTH/2, HEIGHT-15);  // 设置pageControl的位置
    pageControl.numberOfPages = pagesCount;
    pageControl.currentPage = 0;
    
    [pageControl setBounds:CGRectMake(0,0,16*(pagesCount-1)+16,16)]; //页面控件上的圆点间距基本在16左右。
    [pageControl.layer setCornerRadius:8]; // 圆角层
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];//选中的小圆点颜色
    pageControl.pageIndicatorTintColor        = [UIColor lightGrayColor];//未选中的小圆点颜色
    [self.view addSubview:pageControl];
    
    for (UIView *pageView in pageControl.subviews) {
        NSLog(@"");
        pageView.frame = CGRectMake(pageView.frame.origin.x, pageView.frame.origin.y, 10, 10);
    }
}

#pragma mark -- 设置引导页
- (void)initGuideView
{
    [self.view addSubview:self.guideScrollView];
    
    for (int i = 0; i<4; i++) {
        guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT)];
        guideImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%.2d.jpg",i+1]];
        [_guideScrollView addSubview:guideImageView];
        guideImageView.userInteractionEnabled = YES;
        if (i == 3) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView)];
            [guideImageView addGestureRecognizer:tap];
        }
    }
}

- (UIScrollView *)guideScrollView
{
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _guideScrollView.contentSize = CGSizeMake(WIDTH*4, HEIGHT);
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.showsHorizontalScrollIndicator = YES;
        _guideScrollView.delegate = self;
    }
    return _guideScrollView;
}

- (void)dismissGuideView
{
    [UIView animateWithDuration:1.0f animations:^{
        CGPoint point = CGPointMake(WIDTH / 2, HEIGHT / 2);
        self.view.center = point;
        guideImageView.alpha = 0.0f;
        guideImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setObject:@"isFirst" forKey:isGuideFirst];
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegate LoadHomeViewController];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x/WIDTH);
    pageControl.currentPage = scrollView.contentOffset.x/WIDTH;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%f",scrollView.contentOffset.x/WIDTH);
    if ((scrollView.contentSize.width-scrollView.frame.size.width)+50<scrollView.contentOffset.x) {
        [self dismissGuideView];
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
