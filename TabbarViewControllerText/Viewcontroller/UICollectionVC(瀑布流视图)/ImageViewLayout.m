//
//  ImageViewLayout.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/29.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "ImageViewLayout.h"

static CGFloat CHTFloorCGFloat(CGFloat value) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

@interface ImageViewLayout ()

/**
 *  列高
 */
@property (nonatomic, strong) NSMutableArray *columnsHeights;

/**
 *  item的数量
 */
@property (nonatomic, assign) NSInteger numberOfItems;

/**
 *  存放每个item的位置信息的数组
 */
@property (nonatomic, strong) NSMutableArray *itemAttributes;

/**
 *  临时存储当前item的x值
 */
@property (nonatomic, assign) CGFloat item_X;

/**
 *  临时存储当前item的Y值
 */
@property (nonatomic, assign) CGFloat item_Y;

/**
 *  最矮列下标
 */

@property (nonatomic, assign) NSInteger shortestIndex;

@end

@implementation ImageViewLayout

#pragma mark -------------------- 懒加载
- (NSMutableArray *)columnsHeights
{
    if (!_columnsHeights)
    {
        self.columnsHeights = [NSMutableArray array];
    }
    return _columnsHeights;
}

- (NSMutableArray *)itemAttributes
{
    if (!_itemAttributes)
    {
        self.itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

#pragma mark -- 获取最矮列的下标
- (NSInteger)getShortestColumnIndex
{
    //最矮列下标
    NSInteger shortestIndex = 0;
    
    //column高度
    CGFloat shortestHeight = MAXFLOAT;
    
    //遍历高度数组获得最矮列下标
    for (NSInteger i = 0; i < self.numberOfColumns; i ++)
    {
        CGFloat currentHeight = [[self.columnsHeights objectAtIndex:i] floatValue];
        if (currentHeight < shortestHeight)
        {
            shortestHeight = currentHeight;
            shortestIndex = i;
        }
    }
    return shortestIndex;
}

#pragma mark -- 获取最高列的下标
- (NSInteger)getHighestColumnIndex
{
    //最高列下标
    NSInteger highestIndex = 0;
    
    //column高度
    CGFloat highestHeight = 0;
    
    //遍历高度数组获得最高列下标
    for (NSInteger i = 0; i < self.numberOfColumns; i ++)
    {
        CGFloat currentHeight = [[self.columnsHeights objectAtIndex:i] floatValue];
        if (currentHeight > highestHeight)
        {
            highestHeight = currentHeight;
            highestIndex = i;
        }
    }
    return highestIndex;
}

#pragma mark -- 添加顶部内边距的值
- (void)addTopValueForColumns
{
    for (NSInteger i = 0; i < self.numberOfColumns; i ++)
    {
        self.columnsHeights[i] = @(self.sectionInSet.top);
    }
}

#pragma mark -- 计算每个item的X和Y
- (void)getOriginInShortestColumn
{
    //获取最矮列下标
    self.shortestIndex = [self getShortestColumnIndex];
    
    //获取最矮列的高度
    CGFloat shortestHeight = [[self.columnsHeights objectAtIndex:self.shortestIndex] floatValue];
    
    //设置item的X
    self.item_X = self.sectionInSet.left + (self.itemSize.width + self.ItemSpacing) * self.shortestIndex;
    
    //设置item的Y
    self.item_Y = shortestHeight + self.ItemSpacing;
}

#pragma mark -- 计算width和height --> 生成frame
- (void)setFrame:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layOutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //存放item的高度
    CGFloat itemHeight = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForItemAtIndexPath:)])
    {
        itemHeight = [self.delegate heightForItemAtIndexPath:indexPath];
    }
    
    layOutAttribute.frame = CGRectMake(_item_X, _item_Y, self.itemSize.width, itemHeight);
    
    //将位置信息加入数组
    [self.itemAttributes addObject:layOutAttribute];
    
    //更新当前列的高度
    self.columnsHeights[_shortestIndex] = @(self.item_Y + itemHeight);
}

#pragma mark -- 重写父类布局方法
- (void)prepareLayout
{
    [super prepareLayout];
    
    //为高度数组添加上边距
    [self addTopValueForColumns];
    
    //获取item个数
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    //循环布局
    for (NSInteger i = 0; i < self.numberOfItems; i ++)
    {
        //计算item的X和Y
        [self getOriginInShortestColumn];
        
        //生成indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        //生成frame
        [self setFrame:indexPath];
    }
}

#pragma mark -- 获取contentView尺寸
- (CGSize)collectionViewContentSize
{
    //获取最高列下标
    NSInteger highestIndex = [self getHighestColumnIndex];
    
    //获取最高列高度
    CGFloat highestHeight = [[self.columnsHeights objectAtIndex:highestIndex] floatValue];
    
    //构造contentView的size
    CGSize size = self.collectionView.frame.size;
    
    if (size.height > 0 && size.width > 0) {
        highestHeight = CHTFloorCGFloat(size.height * (WIDTH-40)/3-10 / size.width);
    }

    
    //修改高度
    size.height = highestHeight;
    
    //返回size
    return size;
}

#pragma mark -- 返回位置信息数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.itemAttributes;
}

@end
