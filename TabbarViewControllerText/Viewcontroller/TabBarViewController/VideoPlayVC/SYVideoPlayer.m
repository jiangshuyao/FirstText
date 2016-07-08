//
//  SYVideoPlayer.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/23.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYVideoPlayer.h"

#import "XLSlider.h"

#import <objc/runtime.h>

#import <AVFoundation/AVFoundation.h>

static CGFloat const bottomBarHeight = 30.0f;

@interface SYVideoPlayer ()
{
    BOOL    isShowBar;
    BOOL    isFullScreen;      //是否全屏
    UIView  *bottomView;       //底部的View
    NSTimeInterval videoTimeInterval;//总时间
}
@property (nonatomic,strong)AVPlayer      *videoPlayer;
@property (nonatomic,strong)AVPlayerLayer *videoPlayerLayer;
@property (nonatomic,strong)AVPlayerItem  *videoPlayerItem;

@property (nonatomic,strong)UIButton      *playButton;       //播放按钮
@property (nonatomic,strong)UIButton      *fullScreenBotton; //全屏按钮

@property (nonatomic,strong)UILabel       *currentTimeLable; //视频播放时间
@property (nonatomic,strong)UILabel       *videoTimeLable;   //视频时间总长
@property (nonatomic,strong)XLSlider      *slider;           //进度条
@property (nonatomic,strong)UIWindow      *keyWindow;

@property (nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;//白色小菊花

@end

@implementation SYVideoPlayer

- (instancetype)init
{
    if ([super init]) {
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
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

#pragma mark -- 设置播放的URL
- (void)setVideoURL:(NSString *)videoURL
{
    _videoURL = videoURL;
    [self.layer addSublayer:self.videoPlayerLayer];
    [self initBarView];
    [self videoPlayOrPause:self.playButton];
    [self addSubview:self.playButton];
    [self addSubview:self.activityIndicatorView];
    self.activityIndicatorView.center =self.center;
    [_activityIndicatorView startAnimating];
    
    [bottomView addSubview:self.currentTimeLable];
    [bottomView addSubview:self.videoTimeLable];
    [bottomView addSubview:self.fullScreenBotton];
    [self monitoringPlayback:self.videoPlayerItem];
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
        [self addObserverToPlayerItem:playerItem];
    }
    return _videoPlayer;
}

#pragma mark - PlayerItem （status，loadedTimeRanges）
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem
{
    //  监控状态属性，注意AVPlayer也有status属性 通过监控它的status属性可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控视频缓冲状态
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
/*
 然后监听playerItem的status和loadedTimeRange属性，status有三种状态：
 AVPlayerStatusUnknown,
 AVPlayerStatusReadyToPlay,
 AVPlayerStatusFailed
 当status等于AVPlayerStatusReadyToPlay时代表视频已经可以播放了，我们就可以调用play方法播放了。
 loadedTimeRange属性代表已经缓冲的进度，监听此属性可以在UI中更新缓冲进度，也是很有用的一个属性。
 最后添加一个通知，用于监听视频是否已经播放完毕，然后实现KVO的方法：
 */
#pragma mark -- KVO监听总时长
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            videoTimeInterval = CMTimeGetSeconds(playerItem.duration);//获取播放的总时长秒数
            self.videoTimeLable.text = [self timeFormatted:videoTimeInterval];
            [self.activityIndicatorView stopAnimating];
        } else{
            NSLog(@"AVPlayerStatusFailed");
            //[self.activityIndicatorView startAnimating];
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *loadedTimeArray = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadedTimeArray[0] CMTimeRangeValue];//本次缓冲范围
        float startSecond = CMTimeGetSeconds(timeRange.start);
        float durationSecond = CMTimeGetSeconds(timeRange.duration);
        float durationTime = startSecond+durationSecond;//缓冲的总长度
        self.slider.middleValue = durationTime/videoTimeInterval;
        if (self.slider.middleValue <= self.slider.value) {
            [self addSubview:self.activityIndicatorView];
            self.activityIndicatorView.center =self.center;
            [_activityIndicatorView startAnimating];
        } else {
            [_activityIndicatorView removeFromSuperview];
        }
    }
    NSLog(@"%f--%f",self.slider.middleValue,self.slider.value);
}
#pragma mark -- 监听已播放时间
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    
    __weak typeof(self) weakSelf = self;
    [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);//weakSelf.videoPlayer.currentTime也可以得到当前时间
        float total   = CMTimeGetSeconds([playerItem duration]);
        weakSelf.currentTimeLable.text = [weakSelf timeFormatted:current];
        //这里通过比较当前播放视频时间和视频的总时间判断视频是否播放完毕
        if ([weakSelf.currentTimeLable.text isEqualToString:weakSelf.videoTimeLable.text]) {
            if (weakSelf.videoCompleteBlock) {
                weakSelf.videoCompleteBlock(weakSelf);
            }
        }
        
        if (current) {
            weakSelf.slider.value = current/total;
        }
        
    }];
}

#pragma mark -- 时间转换
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds =  totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}
#pragma mark -- 时间转换
- (void)getAVPlayerItemVariable
{
    unsigned int count = 0;
    Ivar *allVariable = class_copyIvarList([self.videoPlayerItem class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = allVariable[i];
        const char *Variablename = ivar_getName(ivar); //获取成员变量名称
        const char *VariableType = ivar_getTypeEncoding(ivar); //获取成员变量类型
    }
}

#pragma mark -- 底部bottomView
- (void)initBarView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-bottomBarHeight, WIDTH, bottomBarHeight)];
    bottomView.layer.opacity = 0.0f;
    bottomView.backgroundColor = [z_UI colorWithHexString:@"#529696"];
    [self addSubview:bottomView];
    
    _slider = [[XLSlider alloc] init];
    _slider.value = 0.0f;
    _slider.middleValue = 0.0f;
    _slider.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:_slider];
    
    __weak typeof(self) weakSelf = self;
    _slider.valueChangeBlock = ^(XLSlider *slider){
        [weakSelf sliderValueChangeCurrentTime:slider];
    };
    //点击
    _slider.finishChangeBlock = ^(XLSlider *slider){
        [weakSelf tapFinishChange:slider];
    };
    //拖拽
    _slider.draggingSliderBlock = ^(XLSlider *slider){
    
    };
    
    //给slider添加约束
    NSLayoutConstraint *sliderLeft = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.currentTimeLable attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
    sliderLeft.priority = UILayoutPriorityDefaultLow;
    NSLayoutConstraint *sliderRight = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.videoTimeLable attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
    NSLayoutConstraint *sliderTop = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0f constant:10];
    NSLayoutConstraint *sliderBottom = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10];
    [bottomView addConstraints:@[sliderLeft, sliderRight, sliderTop, sliderBottom]];
    
    [self updateConstraintsIfNeeded];
}
- (void)sliderValueChangeCurrentTime:(XLSlider *)slider
{
    self.currentTimeLable.text = [self timeFormatted:slider.value*videoTimeInterval];
}
#pragma amrk -- 从点击处开始播放
- (void)tapFinishChange:(XLSlider *)slider
{
    _slider.value = slider.middleValue;
    CMTime currentTime = CMTimeMake(_slider.value*videoTimeInterval, 1);
    [self.videoPlayer seekToTime:currentTime completionHandler:^(BOOL finished) {
        [self.videoPlayer play];
        self.playButton.selected = YES;
    }];
}
- (void)dragFinishChange
{
    
}

#pragma mark -- 设置当前播放时间Lable
- (UILabel *)currentTimeLable
{
    if (!_currentTimeLable) {
        _currentTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 50, 20)];
        _currentTimeLable.textAlignment = 0;
        _currentTimeLable.text = @"00:00";
        _currentTimeLable.textColor = [UIColor whiteColor];
    }
    return _currentTimeLable;
}
#pragma mark -- 视频总时间Lable
- (UILabel *)videoTimeLable
{
    if (!_videoTimeLable) {
        _videoTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.frame.size.width-110, 5, 50, 20)];
        _videoTimeLable.textAlignment = 2;
        _videoTimeLable.text = @"00:00";
        _videoTimeLable.textColor = [UIColor whiteColor];
    }
    return _videoTimeLable;
}
#pragma mark -- 全屏播放按钮
- (UIButton *)fullScreenBotton
{
    if (!_fullScreenBotton) {
        _fullScreenBotton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenBotton.frame = CGRectMake(self.frame.size.width-30, 2.5, 25, 25);
        [_fullScreenBotton setImage:[UIImage imageNamed:@"ImageResources.bundle/btn_zoom_out"] forState:0];
        [_fullScreenBotton setImage:[UIImage imageNamed:@"ImageResources.bundle/btn_zoom_in"] forState:UIControlStateSelected];
        [_fullScreenBotton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBotton;
}
#pragma mark -- 横竖屏点击
- (void)fullScreenButtonClick:(UIButton *)btn
{
    if (!isFullScreen) {
        [self orientationLeftFullScreen];
        NSLog(@"横");
    }else {
        [self smallScreen];
        NSLog(@"书");
    }
}
#pragma  mark -- 全屏播放
- (void)orientationLeftFullScreen {
    
    isFullScreen = YES;
    self.fullScreenBotton.selected = YES;
    self.frame = CGRectMake(0, 0, HEIGHT, WIDTH);
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    self.frame = self.keyWindow.bounds;
    CGFloat windowWidth = self.keyWindow.bounds.size.width;
    CGFloat windowHeight= self.keyWindow.bounds.size.height;
    bottomView.frame = CGRectMake(0, windowHeight - bottomBarHeight, windowWidth, bottomBarHeight);
    self.activityIndicatorView.center = CGPointMake(windowWidth / 2, windowHeight / 2);
    _videoTimeLable.frame = CGRectMake(bottomView.frame.size.width-110, 5, 50, 20);
    _fullScreenBotton.frame = CGRectMake( windowWidth-30, 5, 25, 25);
        _playButton.center = CGPointMake(windowWidth/2, windowHeight/2);
    [self setStatusBarHidden:YES];
}
#pragma mark - status hide(隐藏状态栏)
- (void)setStatusBarHidden:(BOOL)hidden {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = hidden;
}
#pragma amrk -- 竖屏显示
- (void)smallScreen {
    isFullScreen = NO;
    self.fullScreenBotton.selected = NO;
    
    self.frame = CGRectMake(0, 0, HEIGHT, WIDTH);
    [self.keyWindow addSubview:self];

    self.frame = self.keyWindow.bounds;
    bottomView.frame = CGRectMake(0, self.keyWindow.bounds.size.height - bottomBarHeight, self.keyWindow.bounds.size.width, bottomBarHeight);
    self.activityIndicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
    _videoTimeLable.frame = CGRectMake(bottomView.frame.size.width-110, 5, 50, 20);
    _playButton.center = CGPointMake(self.keyWindow.bounds.size.width/2, self.keyWindow.bounds.size.height/2);

    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}
- (void)initBottomViewFrame
{
    CGFloat windowWidth = self.keyWindow.bounds.size.width;
    CGFloat windowHeight= self.keyWindow.bounds.size.height;
    self.frame = CGRectMake(0, 0, windowHeight, windowWidth);
    [self.keyWindow addSubview:self];
    
    self.frame = self.keyWindow.bounds;
    bottomView.frame = CGRectMake(0, windowWidth - bottomBarHeight,windowHeight , bottomBarHeight);
    self.activityIndicatorView.center = CGPointMake(windowHeight / 2, windowWidth / 2);
    _videoTimeLable.frame = CGRectMake(bottomView.frame.size.width-110, 5, 50, 20);
    _fullScreenBotton.frame = CGRectMake( self.keyWindow.bounds.size.width-30, 5, 25, 25);
    _playButton.center = CGPointMake(windowHeight/2, windowWidth/2);
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
#pragma mark--播放按钮
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

#pragma mark -- 开始/暂停
- (void)videoPlayOrPause:(UIButton *)sender
{
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

#pragma mark -- 是否显示进度条和播放按钮
- (void)showOrHidenBar
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isShowBar) {
            self.playButton.layer.opacity = 1.0f;
            bottomView.layer.opacity = 1.0f;
        } else {
            self.playButton.layer.opacity = 0.0f;
            bottomView.layer.opacity = 0.0f;
        }
    } completion:^(BOOL finished) {
        if (isShowBar) {
            isShowBar = !isShowBar;
        } else {
            isShowBar = !isShowBar;
        }
    }];
}

#pragma amrk -- 加载菊花
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _activityIndicatorView;
}

#pragma mark -- 释放播放器
- (void)destroyPlayer
{
    [self.videoPlayer pause];
    [self removeFromSuperview];
}
#warning 播放中的视频点击另一个视频需要释放KVO，否则会崩
- (void)dealloc
{
    [self.videoPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.videoPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
}

@end
