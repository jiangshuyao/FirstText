//
//  SYVideoTableViewCell.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/11.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYVideoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@implementation SYVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initTableViewCell];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)initTableViewCell
{
    CGFloat videoHeight = 25;
    
    //topic图片
    _videoTopicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, videoHeight, videoHeight)];
    _videoTopicImageView.layer.cornerRadius = videoHeight/2;
    _videoTopicImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_videoTopicImageView];
    //topic点击
    UITapGestureRecognizer *topicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicImageTap:)];
    _videoTopicImageView.userInteractionEnabled = YES;
    [_videoTopicImageView addGestureRecognizer:topicTap];
    topicTap.view.tag = 1;

    
    //topic文字标题
    _videoAliasTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 300, videoHeight)];
    _videoAliasTitle.textAlignment = 0;
    _videoAliasTitle.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_videoAliasTitle];
    
    videoHeight += 20;
    
    //视频图片
    _videoCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, videoHeight, WIDTH-16, 180)];
    [self.contentView addSubview:_videoCoverImageView];
    //开始视频按钮
    UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    playView.image = [UIImage imageNamed:@"ImageResources.bundle/play"];
    playView.center = CGPointMake(_videoCoverImageView.frame.size.width/2, _videoCoverImageView.frame.size.height/2);
    [_videoCoverImageView addSubview:playView];
    
    UITapGestureRecognizer *videoPlayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicImageTap:)];
    _videoCoverImageView.userInteractionEnabled = YES;
    [_videoCoverImageView addGestureRecognizer:videoPlayTap];
#warning 必须在addGestureRecognizer之后设置tag值
    videoPlayTap.view.tag = 2;
    
    videoHeight += _videoCoverImageView.frame.size.height+10;
    
    //视频文字说明
    _videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, videoHeight, 200, 20)];
    _videoTitle.textAlignment = 0;
    _videoTitle.textColor = [UIColor magentaColor];
    [self.contentView addSubview:_videoTitle];
    
    UILabel *detalLable = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-215, videoHeight, 200, 20)];
    detalLable.textAlignment = 2;
    detalLable.text = @"点击查看详情 > ";
    [self.contentView addSubview:detalLable];
}

- (void)videoSetItem:(SYVideoItemModel *)videoItem
{
    
    _itemVideo = videoItem;
    
    [_videoTopicImageView sd_setImageWithURL:[NSURL URLWithString:videoItem.videoTopicImage] placeholderImage:[UIImage imageNamed:@"juhe_moren"]];
    
    if (videoItem.videoAlias||videoItem.videoAlias != nil) {
        _videoAliasTitle.text = videoItem.videoAlias;
    }
    _videoAliasTitle.text = @"没有Topic标题？";
    _videoTitle.text = videoItem.videoTitle;
    
    [_videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:videoItem.videoCoverImage] placeholderImage:[UIImage imageNamed:@"geren_touxiang"]];
}
- (void)topicImageTap:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1) {
        if (_topicImageBlock) {
            _topicImageBlock(_index);
        }
    } else if (tap.view.tag == 2){
        if (_coverImageBlock) {
            _coverImageBlock(_index,_videoCoverImageView);
        }
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
