//
//  SYVideoPlayer.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/23.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYVideoPlayer;
typedef void (^videoCompletePlayingBlock) (SYVideoPlayer *videoPlayer);

@interface SYVideoPlayer : UIView


/**
 *视频播放的URL
 */
@property (nonatomic,strong) NSString *videoURL;

/**
 *播放完毕Block
 */
@property (nonatomic,copy) videoCompletePlayingBlock videoCompleteBlock;

/**
 *视频开始或者暂定方法
 */
- (void)videoPalyOrPause;

/**
 *  dealloc 销毁
 */
- (void)destroyPlayer;




@end
