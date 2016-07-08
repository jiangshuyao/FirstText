//
//  seleteView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/4.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "seleteView.h"

@interface seleteView ()

@end

@implementation seleteView

- (id)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemTitle
{
    if (self == [super initWithFrame:frame]) {
        _itemArray = itemTitle;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [[UIColor colorWithRed:48/255.0f green:127/255.0f blue:202/255.0f alpha:1.0f]colorWithAlphaComponent:0.5];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self initLineView];
    [self initButtonView];
}
#pragma mark -- 竖直的线
- (void)initLineView
{
    for (int i = 1; i<_itemArray.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/(_itemArray.count)*i, 8, 1, self.frame.size.height-16)];
        [self addSubview:line];
        line.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark -- 四个分段按钮
- (void)initButtonView
{
    for (int i = 0; i<_itemArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIDTH/(_itemArray.count)*i, 0, WIDTH/_itemArray.count, self.frame.size.height);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setTitle:_itemArray[i] forState:0];
        [btn setImage:[UIImage imageNamed:@"jiantou_down_p"] forState:0];
        [btn setImage:[UIImage imageNamed:@"jiantou_down_p"] forState:UIControlStateHighlighted];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, WIDTH/_itemArray.count-30, 0, 10)];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
#pragma mark -- 按钮点击事件
- (void)selectClick:(UIButton *)sender
{
    for (int i = 0; i<_itemArray.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i+100];
        if (i == sender.tag-100) {
            btn.selected = !btn.selected;
            [btn setTitleColor:[z_UI colorWithHexString:@"#225aef"] forState:0];
            [btn setImage:[UIImage imageNamed:@"jiantou_down_h"] forState:0];
            [btn setImage:[UIImage imageNamed:@"jiantou_down_h"] forState:UIControlStateHighlighted];
            if (btn.selected) {
                [self showAnimationWithUpButton:btn];
            } else {
                [self showAnimationWithDownButton:btn];
            }
        } else {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[z_UI colorWithHexString:@"#ffffff"] forState:0];
            [btn setImage:[UIImage imageNamed:@"jiantou_down_p"] forState:0];
            [btn setImage:[UIImage imageNamed:@"jiantou_down_p"] forState:UIControlStateHighlighted];
        }
    }
    //block
    UIButton *btn = (UIButton *)[self viewWithTag:sender.tag];
    if (self.seleteBlock) {
        self.seleteBlock(sender.tag-100,btn.selected);
    }
}
#pragma mark -- 向上的动画
- (void)showAnimationWithUpButton:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- 向下的动画
- (void)showAnimationWithDownButton:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI*2);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    } completion:^(BOOL finished) {
        
    }];

}


@end
