//
//  SYHeadView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/17.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYHeadView.h"
#import "SYHeadModel.h"

@implementation SYHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSectionHeadView];
    }
    return self;
}

- (void)initSectionHeadView
{
    _sectionName = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 20)];
    _sectionName.textColor = [UIColor whiteColor];
    _sectionName.textAlignment = 1;
    _sectionName.center = CGPointMake(WIDTH/2, 22);
    [self.contentView addSubview:_sectionName];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:18/255.0 green:53/255.0 blue:85/255.0 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewTap:)];
    [self addGestureRecognizer:tap];
}
- (void)setHeadModel:(SYHeadModel *)headModel
{
    _sectionName.text = headModel.sectionTitle;
//    if (_headModel != headModel) {
//        _headModel = headModel;
//    }
    _headModel = headModel;
}
- (void)headViewTap:(UITapGestureRecognizer *)tap
{
    _headModel.isExpanded = !_headModel.isExpanded;
    if (self.expandBlock) {
        self.expandBlock(self.headModel.isExpanded);
    }
}

@end
