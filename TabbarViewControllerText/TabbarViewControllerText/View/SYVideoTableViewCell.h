//
//  SYVideoTableViewCell.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/11.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVideoItemModel.h"

typedef void (^videoTopicImageBlock)(NSInteger index);
typedef void (^videoCoverImageBlock)(NSInteger index,UIView *videoView);

@interface SYVideoTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *videoCoverImageView;
@property (nonatomic,strong)UIImageView *videoTopicImageView;
@property (nonatomic,strong)UILabel     *videoTitle;
@property (nonatomic,strong)UILabel     *videoAliasTitle;
@property (nonatomic,strong)SYVideoItemModel *itemVideo;
@property (nonatomic,assign)NSInteger   index;

@property (nonatomic,strong)videoTopicImageBlock topicImageBlock;//点击Topic图片
@property (nonatomic,strong)videoCoverImageBlock coverImageBlock;//点击视频图片

- (void)videoSetItem:(SYVideoItemModel *)videoItem;


@end
