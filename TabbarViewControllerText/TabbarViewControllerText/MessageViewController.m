//
//  MessageViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/25.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "MessageViewController.h"

#import "HMSegmentedControl.h"

@interface MessageViewController ()<UIScrollViewDelegate>
{
    HMSegmentedControl *SYControl;
}
@end


@implementation MessageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArray = @[@"汽车",@"美女",@"大不列达",@"视频",@"历史",@"改下",@"美丽",@"电影"];
    UIScrollView *segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40,WIDTH, HEIGHT-64-40)];
    segmentScrollView.contentSize = CGSizeMake(WIDTH*titleArray.count, segmentScrollView.frame.size.height);
    segmentScrollView.delegate =self;
    segmentScrollView.showsHorizontalScrollIndicator = YES;
    segmentScrollView.pagingEnabled = YES;
    segmentScrollView.bounces = YES;
    [self.view addSubview:segmentScrollView];
    
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *la= [[UILabel alloc] initWithFrame:CGRectMake(100+WIDTH*i, 100, 200, 200)];
        la.backgroundColor = [UIColor orangeColor];
        la.text = [NSString stringWithFormat:@"这是第%d个",i+1];
        la.textAlignment = 1;
        la.font = [UIFont systemFontOfSize:30];
        [segmentScrollView addSubview:la];
    }
    
    SYControl = [[HMSegmentedControl alloc] initWithSectionTitles:titleArray];
    SYControl.borderType = HMSegmentedControlBorderTypeBottom;
    SYControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    SYControl.frame =CGRectMake(10, 64, WIDTH-20, 40);
    [SYControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"点击了：%ld",(long)index);
        segmentScrollView.contentOffset = CGPointMake(WIDTH*index, 0);
    }];
    [self.view addSubview:SYControl];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int wifff = scrollView.contentOffset.x/WIDTH;
    NSLog(@"%d",wifff);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int wifff = scrollView.contentOffset.x/WIDTH;
    SYControl.selectedSegmentIndex = wifff;
}

@end
