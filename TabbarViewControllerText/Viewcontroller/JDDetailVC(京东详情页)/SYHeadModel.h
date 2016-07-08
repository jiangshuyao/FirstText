//
//  SYHeadModel.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/17.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHeadModel : NSObject

@property (nonatomic,copy)NSString *sectionTitle;
@property (nonatomic,assign)BOOL   isExpanded;//是否展开
@property (nonatomic,strong)NSMutableArray *cellModel;

@end

@interface SYCellModel : NSObject

@property (nonatomic,strong)NSString *cellTitle;

@end
