//
//  ItemCell.m
//  UICollectionViewDemo
//
//  Created by develop on 15/11/27.
//  Copyright © 2015年 jicaas. All rights reserved.
//

#import "ItemCell.h"
#import <UIImageView+WebCache.h>

@implementation ItemCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UILabel *)imageTitleLable
{
    if (!_imageTitleLable) {
        _imageTitleLable = [[UILabel alloc] initWithFrame:self.bounds];
        _imageTitleLable.backgroundColor = [UIColor whiteColor];
        _imageTitleLable.textAlignment = 0;
        _imageTitleLable.textColor = [UIColor blackColor];
        _imageTitleLable.font = [UIFont systemFontOfSize:13];
        _imageTitleLable.numberOfLines = 0;
        }
    return _imageTitleLable;
}

- (UILabel *)itemTimeLable
{
    if (!_itemTimeLable) {
        _itemTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _itemTimeLable.backgroundColor = [UIColor blackColor];
        _itemTimeLable.alpha = 0.7f;
        _itemTimeLable.textAlignment = 0;
        _itemTimeLable.textColor = [UIColor whiteColor];
        _itemTimeLable.font = [UIFont systemFontOfSize:12];
    }
    return _itemTimeLable;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.imageTitleLable];
        [self.contentView addSubview:self.itemTimeLable];
    }
    return self;
}
//重新设置高度
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemH = self.contentView.frame.size.height;
    CGFloat itemW = self.contentView.frame.size.width;
    
    _imageView.frame = CGRectMake(0, 0, itemW, itemH-_model.titleHeight);
    _imageTitleLable.frame = CGRectMake(4, itemH-_model.titleHeight, itemW-8, _model.titleHeight);
    _itemTimeLable.frame = CGRectMake(0, itemH-15-_model.titleHeight, itemW, 15);
    
    _imageTitleLable.text = _model.imageTitle;
    //注意类型
    NSString *time = [self timeFormatter:_model.imageTime];
    _itemTimeLable.text = time;

}
- (void)initView

{
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 时间判断方法
- (NSString *)timeFormatter:(NSString *)time
{
    
    //获取时间----有--时分秒
    long long timeString= [time longLongValue];
    
    //获取时间----有--时分秒
    //long long oldtime= [timeString longLongValue];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timeString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *myTime = [formatter stringFromDate:d];
    
    //获取时间----只有日期的时间
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *myTime1 = [formatter1 stringFromDate:d];
    
    //获取时间----只有日期的时间
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"YYYY-MM-dd"];
    NSString *myTime2 = [formatter2 stringFromDate:d];
    
    return myTime2;
}

@end
