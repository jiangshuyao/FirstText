//
//  MultiMenuTableViewCell.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/6.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopClassItem.h"

@interface MultiMenuTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel     *titleLable;
@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)shopClassItem *shopClassItemModel;

@property (nonatomic,strong)shopClassDetailItem *shopDetailItemModel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style cellType:(NSString *)cellType reuseIdentifier:(nullable NSString *)reuseIdentifier;

@end
