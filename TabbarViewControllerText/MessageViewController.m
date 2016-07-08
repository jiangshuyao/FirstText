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
    UIScrollView       *segmentScrollView;
    UIProgressView     *textProgress1;
}
@end


@implementation MessageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHMSegmentedControl];

    [self initTextButton];
    [self initStkriteLable];
    [self drawThirdBezierPath];
}
#pragma mark -- 初始化textButton
- (void)initTextButton
{
    UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    textBtn.frame = CGRectMake(160, 230, 50, 30);
    [textBtn setTitle:@"点击" forState:0];
    textBtn.backgroundColor = [UIColor blackColor];
    [textBtn addTarget:self action:@selector(textBtn:) forControlEvents:UIControlEventTouchUpInside];
    [segmentScrollView addSubview:textBtn];
    
    textProgress1 = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 280, 200, 20)];
    textProgress1.progressViewStyle = UIProgressViewStyleBar;
    textProgress1.backgroundColor = [UIColor orangeColor];
    [segmentScrollView addSubview:textProgress1];
}

#pragma amrk -- 初始化HMSegmentedControl
- (void)initHMSegmentedControl
{
    NSArray *titleArray = @[@"汽车",@"美女",@"大不列达",@"视频",@"历史",@"改下",@"美丽",@"电影"];
    segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40,WIDTH, HEIGHT-64-40)];
    segmentScrollView.contentSize = CGSizeMake(WIDTH*titleArray.count, segmentScrollView.frame.size.height);
    segmentScrollView.delegate =self;
    segmentScrollView.showsHorizontalScrollIndicator = YES;
    segmentScrollView.pagingEnabled = YES;
    segmentScrollView.bounces = YES;
    [self.view addSubview:segmentScrollView];
    
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *la= [[UILabel alloc] initWithFrame:CGRectMake(100+WIDTH*i, 100, 200, 100)];
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

#pragma mark -- 初始化Lable下划线
- (void)initStkriteLable
{
    float num = 12386.98;
    UILabel * strikeLabel = [[UILabel alloc] initWithFrame:(CGRectMake(100, 300, 200, 30))];
    strikeLabel.textColor = [UIColor orangeColor];
    NSString *textStr = [NSString stringWithFormat:@"%f 元",num];
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    [attribtStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, textStr.length-1)];
    
    [attribtStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, textStr.length-1)];
    
    // 赋值
    strikeLabel.attributedText = attribtStr;
    
    [segmentScrollView addSubview:strikeLabel];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 320, 200, 30)];
    [segmentScrollView addSubview:lable];
    NSString *oldPrice = @"¥ 999999";
    NSUInteger length = [oldPrice length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(2, length-2)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
    [lable setAttributedText:attri];
}
- (void)drawThirdBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 设置起始端点
    [path moveToPoint:CGPointMake(20, 150)];
    
    [path addCurveToPoint:CGPointMake(300, 150)
            controlPoint1:CGPointMake(160, 0)
            controlPoint2:CGPointMake(160, 250)];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 5.0;
    
    UIColor *strokeColor = [UIColor redColor];
    [strokeColor set];
    
    [path stroke];
    
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

#pragma mark -- 多线程测试
- (void)textBtn:(UIButton *)sender
{
    NSLog(@"点击了");
    sender.userInteractionEnabled = NO;
    //阻塞了主线程，10秒后UI才变化
//    for (int i = 0; i<10; i++) {
//        sleep(1);
//        textProgress1.progress = (CGFloat)(i+1)/10;
//    }
    
    //第二个常见的错误是把要通过 UI 与用户交互的代码也放在非主线程中使得 UI 无任何变化，用户并不清楚操作到底做了没有，又或者操作进度到了哪里
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            for (int i = 0; i<10; i++) {
//                sleep(1);
//                textProgress1.progress = (CGFloat)(i+1)/10;
//            }
//    });
    
    //正确方式
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i<10; i++) {
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                textProgress1.progress = (CGFloat)(i+1)/10;
                if (textProgress1.progress == 1) {
                    sender.userInteractionEnabled = YES;
                }
            });
        }
    });
}

@end
