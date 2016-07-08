//
//  seleteView.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/4.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^seleteButtonBlock)(NSInteger index,BOOL isSelete);

@interface seleteView : UIView

@property (nonatomic,strong)NSArray *itemArray;
@property (nonatomic,strong)seleteButtonBlock seleteBlock;

- (id)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemTitle;

@end
