//
//  JDMagicViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/15.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "JDMagicViewController.h"
#import "JDVTNewsDetailViewController.h"


#define kSearchBarWidth (30.0f)

@interface JDMagicViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>

@end

@implementation JDMagicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [_magicController didMoveToParentViewController:self];
    [self initMenuDate];
    [_magicController.magicView reloadData];
    
    [self initNavigationBarItem];
}

- (void)initNavigationBarItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigationBarClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    backButton.frame = CGRectMake(10, 0, kSearchBarWidth, kSearchBarWidth);
    [self.magicController.magicView setLeftNavigatoinItem:backButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(navigationBarClick:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    searchButton.frame = CGRectMake(0, WIDTH-3*kSearchBarWidth, kSearchBarWidth, kSearchBarWidth);
    [self.magicController.magicView setRightNavigatoinItem:searchButton];

    backButton.tag = 1;
    searchButton.tag = 2;
}
- (void)navigationBarClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"点击搜索");
    }
}
#pragma mark -- 填充数据
- (void)initMenuDate
{
    _menuList = @[@"商品",@"详情",@"评价"];
}
#pragma mark - accessor methods
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, kSearchBarWidth, 0, 0);
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}
#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (pageIndex == 0) {
        static NSString *gridId = @"table.identifier";
        JDVTNewsDetailViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[JDVTNewsDetailViewController alloc] init];
        }
        return viewController;
    }
    static NSString *gridId = @"webview.identifier";
    JDVTNewsDetailViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[JDVTNewsDetailViewController alloc] init];
    }
    viewController.isWebviewDetail = YES;
    return viewController;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offset = scrollView.contentOffset.x;
    if (offset<-50) {
        [self.navigationController popViewControllerAnimated:YES];
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
