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
#import "MBProgressHUD.h"

#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/20-30.html"
NSString * const SPHttpCache = @"SPHttpCache";
NSString * const cacheKey = @"cacheKey";

@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    YYCache *videoCache;
    MBProgressHUD *mbHUD;
}
@property (nonatomic,strong)UITableView    *videoTableView;
@property (nonatomic,strong)NSMutableArray *videoArray;

@property (nonatomic,strong)SYVideoPlayer  *videoPlayerView;

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //主动刷新需要在viewWillAppear里面
    [self.videoTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.navigationBarTitle.text = @"视频播放合集";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.videoTableView];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHUD.mode = MBProgressHUDModeText;
    mbHUD.labelText= @"数据加载中...";
    
    [self initCacheMemoey];
    
    //设置下拉刷新，上拉加载
    [self setRefresh];

}

/** 设置刷新 */
- (void)setRefresh
{
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkRequest];
    }] ;
    
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
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
    } else {
        [self networkRequest];
    }
}
/** 视频网络请求 */
- (void)networkRequest
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        } requestFailed:^(NSDictionary *resultDic) {
            NSLog(@"是比数据：%@",resultDic);
            NSLog(@"请求超时le");
            
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoTableView reloadData];
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [mbHUD hide:YES afterDelay:0.6];
            [self.videoTableView.mj_header endRefreshing];
        });
    });
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

- (void)playVideoWithIndex:(NSInteger)index cellView:(UIView *)cell
{
    [_videoPlayerView destroyPlayer];
    _videoPlayerView = nil;
    
    SYVideoItemModel *itemVideo = [[SYVideoItemModel alloc] init];
    itemVideo = [self.videoArray objectAtIndex:index];
    _videoPlayerView = [[SYVideoPlayer alloc] init];
    _videoPlayerView.frame = cell.bounds;
    _videoPlayerView.videoURL = itemVideo.videoUrl;
    [cell addSubview:_videoPlayerView];
    cell.clipsToBounds = YES;

    
//    NSIndexPath *indexCell = [NSIndexPath indexPathForRow:index inSection:0];
//    SYVideoTableViewCell *cell = [self.videoTableView cellForRowAtIndexPath:indexCell];
//    [cell.contentView addSubview:_videoPlayerView];
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
