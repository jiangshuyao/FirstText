//
//  ImageViewLayout.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/29.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewLayoutDelegate <NSObject>

/**
 *  获取item的高度
 *
 *  @param indexPath 下标
 *
 *  @return item高度
 */
- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ImageViewLayout : UICollectionViewLayout

/**
 *  单元格尺寸
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 *  列数
 */
@property (nonatomic, assign) NSInteger numberOfColumns;

/**
 *  内边距
 */
@property (nonatomic, assign) UIEdgeInsets sectionInSet;

/**
 *  item间隔
 */
@property (nonatomic, assign) CGFloat ItemSpacing;

/**
 *  代理人属性
 */
@property (nonatomic, assign) id<ImageViewLayoutDelegate>delegate;

@end
