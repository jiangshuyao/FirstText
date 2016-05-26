//
//  SYVideoItemModel.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/11.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYVideoItemModel : NSObject

@property (nonatomic,strong)NSString *videoUrl;         //视频的URL
@property (nonatomic,strong)NSString *videoTitle;       //视频的标题
@property (nonatomic,strong)NSString *videoCoverImage;  //视频的图片
@property (nonatomic,strong)NSString *videoTopicImage;  //视频大标题图片
@property (nonatomic,strong)NSString *videoAlias;       //视频大标题

@end
