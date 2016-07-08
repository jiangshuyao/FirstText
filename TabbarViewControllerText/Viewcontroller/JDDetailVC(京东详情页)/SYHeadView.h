//
//  SYHeadView.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/17.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYHeadModel;

typedef void(^SYHeaderViewExpandBlock)(BOOL isExpand);

@interface SYHeadView : UITableViewHeaderFooterView

@property (nonatomic,strong)UIImageView *arrowImageView;//箭头
@property (nonatomic,strong)UILabel     *sectionName;   //分组名称
@property (nonatomic,strong)UILabel     *sectionNumber; //每个分组数量
@property (nonatomic,strong)SYHeadModel *headModel;
@property (nonatomic,copy)  SYHeaderViewExpandBlock expandBlock;

@end
