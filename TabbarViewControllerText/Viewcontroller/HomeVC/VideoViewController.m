//
//  VideoViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/11.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "VideoViewController.h"

#import "SYVideoItemModel.h"
#import "SYVideoTableViewCell.h"
#import "SYVideoPlayer.h"

#import <YYCache.h>
#import "promptView.h"

#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
NSString * const SPHttpCache = @"SPVideoHttpCache";
NSString * const cacheKey = @"cacheVideoKey";

@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    YYCache *videoCache;
    NSInteger     videoIndex;
}
@property (nonatomic,strong)UITableView    *videoTableView;
@property (nonatomic,strong)NSMutableArray *videoArray;

@property (nonatomic,strong)SYVideoPlayer  *videoPlayerView;

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[checkNeworkManeger shareNetwork] checkNowNetWorkStatus] == 0) {
         [[checkNeworkManeger shareNetwork] showNetWorkMessage];
        return;
    }

    //主动刷新需要在viewWillAppear里面
    [self.videoTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.navigationBarTitle.text = @"视频播放合集";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.videoTableView];
    //加载缓存数据
    [self initCacheMemoey];
    //设置下拉刷新，上拉加载
    [self setRefresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_videoPlayerView destroyPlayer];
}
#pragma amrk -- loading提示框
- (void)loadingView
{
    [[promptView sharePrompt] showPromptViewMessage:@"数据加载中..."];
}
/** 设置刷新 */
- (void)setRefresh
{
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadingView];
        [self networkRequest];
    }] ;
    
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadingView];
        [self loadMoreDateRequest];
    }];
}

/** 加载缓存数据 */
- (void)initCacheMemoey
{
    videoCache = [[YYCache alloc] initWithName:SPHttpCache];
    videoCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    videoCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
    if ([videoCache objectForKey:cacheKey]) {
        NSLog(@"缓存数据：%@",[videoCache objectForKey:cacheKey]);
        NSArray *dateArray = (NSArray *)[videoCache objectForKey:cacheKey];
        for (NSDictionary *dict in dateArray) {
            SYVideoItemModel *itemVideo = [[SYVideoItemModel alloc] init];
            itemVideo.videoUrl        = [dict objectForKey:@"mp4_url"];
            itemVideo.videoTitle      = [dict objectForKey:@"title"];
            itemVideo.videoCoverImage = [dict objectForKey:@"cover"];
            itemVideo.videoTopicImage = [dict objectForKey:@"topicImg"];
            itemVideo.videoAlias      = [[dict objectForKey:@"videoTopic"] objectForKey:@"alias"];
            [self.videoArray addObject:itemVideo];
        }
        [self.videoTableView reloadData];
        [[promptView sharePrompt] hidePromptViewAfterDelay:0.6];
    } else {
        [self networkRequest];
    }
}
/** 视频网络请求 */
- (void)networkRequest
{
        // time-consuming task
        [[NetworkManager shareNetworkManager] getHomeListWithUrl:videoListUrl parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
            if (self.videoArray.count>0) {
                [self.videoArray removeAllObjects];
            }
            NSArray *dataArray = resultDic[@"VAP4BFR16"];
            [videoCache removeObjectForKey:cacheKey];
            [videoCache setObject:dataArray forKey:cacheKey];
            
            for (NSDictionary *dict in dataArray) {
                SYVideoItemModel *itemVideo = [[SYVideoItemModel alloc] init];
                itemVideo.videoUrl        = [dict objectForKey:@"mp4_url"];
                itemVideo.videoTitle      = [dict objectForKey:@"title"];
                itemVideo.videoCoverImage = [dict objectForKey:@"cover"];
                itemVideo.videoTopicImage = [dict objectForKey:@"topicImg"];
                itemVideo.videoAlias      = [[dict objectForKey:@"videoTopic"] objectForKey:@"alias"];
                [self.videoArray addObject:itemVideo];
            }
            [self.videoTableView reloadData];
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [[promptView sharePrompt] hidePromptViewAfterDelay:0.6];
            [self.videoTableView.mj_header endRefreshing];
        } requestFailed:^(NSDictionary *resultDic) {
            [[promptView sharePrompt] hidePromptViewAfterDelay:0.6];
            [[promptView sharePrompt] showPromptErroMessage:@"老板,网络罢工了..."];
            [self.videoTableView.mj_header endRefreshing];
        }];
}

/** 加载更多 */
- (void)loadMoreDateRequest
{
     NSString *videoUrl = [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/%lu-%lu.html",_videoArray.count+1,_videoArray.count+11];
     [[NetworkManager shareNetworkManager] getHomeListWithUrl:videoUrl parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
         for (NSDictionary *dict in resultDic[@"VAP4BFR16"]) {
             SYVideoItemModel *itemVideo = [[SYVideoItemModel alloc] init];
             itemVideo.videoUrl        = [dict objectForKey:@"mp4_url"];
             itemVideo.videoTitle      = [dict objectForKey:@"title"];
             itemVideo.videoCoverImage = [dict objectForKey:@"cover"];
             itemVideo.videoTopicImage = [dict objectForKey:@"topicImg"];
             itemVideo.videoAlias      = [[dict objectForKey:@"videoTopic"] objectForKey:@"alias"];
             [self.videoArray addObject:itemVideo];
         }
         [self.videoTableView reloadData];
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         [[promptView sharePrompt] hidePromptViewAfterDelay:0.6];
         [self.videoTableView.mj_footer endRefreshing];

     } requestFailed:^(NSDictionary *resultDic) {
         [[promptView sharePrompt] hidePromptViewAfterDelay:0.6];
         [[promptView sharePrompt] showPromptErroMessage:@"老板,网络罢工了..."];
         [self.videoTableView.mj_footer endRefreshing];
     }];
}

/** 懒加载数据源 */
- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [[NSMutableArray alloc] init];
    }
    return _videoArray;
}
/** 懒加载 */
- (UITableView *)videoTableView
{
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _videoTableView.dataSource = self;
        _videoTableView.delegate = self;
        //_videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _videoTableView.rowHeight = 260;
    }
    return _videoTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    SYVideoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SYVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYVideoItemModel *itemVideo = [[SYVideoItemModel alloc] init];
    itemVideo = [self.videoArray objectAtIndex:indexPath.row];
    
    [cell videoSetItem:itemVideo];
    cell.index = indexPath.row;
    [cell setTopicImageBlock:^(NSInteger index){
        NSLog(@"点击了第%ld个cell的Topic图片",(long)index);
    }];
    [cell setCoverImageBlock:^(NSInteger index,UIView *videoView){
        NSLog(@"开始播放视频%ld",(long)index);
        [self playVideoWithIndex:index cellView:videoView];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了视频详情");
}
#pragma mark -- cell出现时由小变大动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
    [UIView animateWithDuration:1.0f animations:^{
        cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -- 根据当前cell的位置判断是否结束视频的播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *videoIndexPath = [NSIndexPath indexPathForRow:videoIndex inSection:0];
    CGRect currentPlayCellRect = [self.videoTableView rectForRowAtIndexPath:videoIndexPath];
    CGFloat videoCellCurrentHeightBottom = currentPlayCellRect.size.height+currentPlayCellRect.origin.y;
    CGFloat VideoCellCurrentHeightUp     = currentPlayCellRect.origin.y;
    CGFloat videoCellOffset              = scrollView.contentOffset.y;
    NSLog(@"%f--%f--%f",videoCellCurrentHeightBottom,VideoCellCurrentHeightUp,videoCellOffset);
    if (videoCellOffset+35>=videoCellCurrentHeightBottom || videoCellOffset+self.videoTableView.frame.size.height-45<=VideoCellCurrentHeightUp) {
        [_videoPlayerView destroyPlayer];
    }
}
- (void)playVideoWithIndex:(NSInteger)index cellView:(UIView *)cell
{
    [_videoPlayerView destroyPlayer];
    _videoPlayerView = nil;
    
    videoIndex = index;
    SYVideoItemModel *itemVideo = [[SYVideoItemModel alloc] init];
    itemVideo = [self.videoArray objectAtIndex:index];
    _videoPlayerView = [[SYVideoPlayer alloc] init];
    _videoPlayerView.frame = cell.bounds;
    _videoPlayerView.videoURL = itemVideo.videoUrl;
    [cell addSubview:_videoPlayerView];
    cell.clipsToBounds = YES;
    
    _videoPlayerView.videoCompleteBlock  = ^(SYVideoPlayer *player){
        [player destroyPlayer];
        player = nil;
    };
}
- (SYVideoPlayer *)videoPlayerView
{
    if (!_videoPlayerView) {
        _videoPlayerView = [[SYVideoPlayer alloc] init];
    }
    return _videoPlayerView;
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
