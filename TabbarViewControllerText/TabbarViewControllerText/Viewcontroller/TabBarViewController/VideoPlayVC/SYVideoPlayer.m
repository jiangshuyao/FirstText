//
//  SYVideoPlayer.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/23.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYVideoPlayer.h"

#import <AVFoundation/AVFoundation.h>


@interface SYVideoPlayer ()
{
    BOOL isShowBar;
}
@property (nonatomic,strong)AVPlayer      *videoPlayer;
@property (nonatomic,strong)AVPlayerLayer *videoPlayerLayer;
@property (nonatomic,strong)AVPlayerItem  *videoPlayerItem;

@property (nonatomic,strong)UIButton      *playButton;

@end

@implementation SYVideoPlayer

- (instancetype)init
{
    if ([super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHidenBar)];
        [self addGestureRecognizer:tap];
        isShowBar = YES;
    }
   return self;
}

/*
 
 layoutSubviews在以下情况下会被调用：
 
 1、init初始化不会触发layoutSubviews
 
 但是是用initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发
 
 2、addSubview会触发layoutSubviews
 
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 
 4、滚动一个UIScrollView会触发layoutSubviews
 
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.videoPlayerLayer.frame = self.bounds;
}

- (AVPlayerLayer *)videoPlayerLayer
{
    if (!_videoPlayerLayer) {
        _videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        _videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _videoPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _videoPlayerLayer.frame = self.bounds;
    }
    return _videoPlayerLayer;
}
- (AVPlayer *)videoPlayer
{
    if (!_videoPlayer) {
        AVPlayerItem *playerItem = [self getAVPlayItem];
        self.videoPlayerItem = playerItem;
        _videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    }
    return _videoPlayer;

}
- (void)setVideoURL:(NSString *)videoURL
{
    _videoURL = videoURL;
    [self.layer addSublayer:self.videoPlayerLayer];
    
    [self videoPlayOrPause:self.playButton];
    [self addSubview:self.playButton];
    
}
//initialize AVPlayerItem
- (AVPlayerItem *)getAVPlayItem{
    
    //crash日志打印
    NSAssert(self.videoURL != nil, @"必须先传入视频url！！！");
    
    if ([self.videoURL rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.videoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.videoURL] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}
- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(0, 0, 60, 60);
        _playButton.layer.opacity = 0.0f;
        UIImage *playImage = [UIImage imageNamed:@"ImageResources.bundle/play"];
        UIImage *pauseImage = [UIImage imageNamed:@"ImageResources.bundle/pause"];
        [_playButton setImage:playImage forState:0];
        [_playButton setImage:pauseImage forState:UIControlStateSelected];
        _playButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [_playButton addTarget:self action:@selector(videoPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)videoPlayOrPause:(UIButton *)sender
{
    NSLog(@"==%f",self.videoPlayer.rate);
    if(self.videoPlayer.rate == 0){      //pause
        sender.selected = YES;
        [self.videoPlayer play];
    }else if(self.videoPlayer.rate == 1){    //playing
        [self.videoPlayer pause];
        sender.selected = NO;
    }
}

- (void)videoPalyOrPause
{
    [self videoPlayOrPause:self.playButton];
}
- (void)showOrHidenBar
{
    if (isShowBar) {
        self.playButton.layer.opacity = 1.0f;
        isShowBar = NO;
    } else {
        self.playButton.layer.opacity = 0.0f;
        isShowBar = YES;
    }
}

- (void)destroyPlayer
{
    [self.videoPlayer pause];
    [self removeFromSuperview];
}

@end
