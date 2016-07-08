//
//  MultiMenuTableViewCell.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/6.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "MultiMenuTableViewCell.h"

@implementation MultiMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style cellType:(NSString *)cellType reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //1代表左边的tableview2代表右边的tableview(仿京东后右边的改成uicollectionView)
        if ([cellType intValue] == 1) {
            [self initLeftTableViewCell];
        } else {
            [self initTableViewCell];
        }
    }
    return self;
}
#pragma mark -- 左边
- (void)initLeftTableViewCell
{
    self.backgroundColor = [z_UI colorWithHexString:@"#50b7c1"];
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 25)];
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLable];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49-0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
}
#pragma mark -- 右边
- (void)initTableViewCell
{
    self.backgroundColor = [z_UI colorWithHexString:@"#9d9087"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 2, WIDTH-116, 99-6)];
    bgView.backgroundColor = [z_UI colorWithHexString:@"#45b97c"];
    [self addSubview:bgView];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 50, 50)];
    _headImage.backgroundColor = [UIColor orangeColor];
    _headImage.layer.cornerRadius = 25;
    _headImage.clipsToBounds = YES;
    _headImage.image = [UIImage imageNamed:@"imagesGirl.jpg"];
    [self addSubview:_headImage];
    
    for (int i = 0; i<3; i++) {
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(80, 5+30*i, 80+50*i, 25)];
        la.backgroundColor = [z_UI colorWithHexString:@"#1d953f"];
        [self addSubview:la];
    }
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, 200, 25)];
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLable];
}
#pragma mark -- 左边的数据源
- (void)setShopClassItemModel:(shopClassItem *)shopClassItemModel
{
    self.titleLable.text = shopClassItemModel.shopTitle;
    self.titleLable.textAlignment = 1;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [z_UI colorWithHexString:@"#9d9087"];
    self.titleLable.highlightedTextColor = [z_UI colorWithHexString:@"#225a1f"];

}
- (void)setShopDetailItemModel:(shopClassDetailItem *)shopDetailItemModel
{

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
