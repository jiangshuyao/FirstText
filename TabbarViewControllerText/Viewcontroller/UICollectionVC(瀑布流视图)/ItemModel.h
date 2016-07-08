//
//  ItemModel.h
//  UICollectionViewDemo
//
//  Created by develop on 15/11/27.
//  Copyright © 2015年 jicaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemModel : NSObject

@property (nonatomic,strong) NSString *imageUrl;            //图片URL
@property (nonatomic,strong) NSString *imageTitle;          //图片标题
@property (nonatomic,strong) NSString *imageTime;           //图片发布时间
@property (nonatomic,strong) NSString *imageCallCount;      //图片预览数
@property (nonatomic,strong) NSString *imageCommentCount;   //图片评论数
@property (nonatomic,strong) NSString *imageCollectCount;   //图片收藏数

@property (nonatomic,assign) CGSize   itemSize;

@property (nonatomic,assign) CGSize   imageSize;
@property (nonatomic,assign) CGFloat  titleHeight;



@end
