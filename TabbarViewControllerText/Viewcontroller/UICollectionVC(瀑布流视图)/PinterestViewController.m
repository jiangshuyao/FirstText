//
//  PinterestViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/29.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "PinterestViewController.h"

#import "ItemCell.h"
#import "ItemModel.h"
#import "collectionFooterView.h"
#import "collectionHeaderView.h"
#import "ImageViewLayout.h"
#import "UIImageView+WebCache.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "previewBigImageView.h"
#import "UIImage+GradientColor.h"

#import <YYCache.h>

#define pinterestUrl(A)        [NSString stringWithFormat:@"http://www.tngou.net/tnfs/api/list?page=%d&rows=10",A]//图片的URL

NSString * const SYGirleCache = @"SPGirlHttpCache";
NSString * const SYGirlCacheKey = @"cacheGirlKey";
NSTimeInterval  const dutionTime = 0.5f;
#define columnsNumber       3
NSString *const SYCollectionViewID = @"SYCollectionView";
NSString *const SYCollectionSectionFooter = @"SYCollectionSectionFooter";
NSString *const SYCollectionSectionHeader = @"SYCollectionSectionHeader";

@interface PinterestViewController ()<UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegateFlowLayout>
{
    UIImage *bigImage;//大图Image
    YYCache *girlCache;//缓存设置
    int page;
    CGRect imageRect;//点击的图片的rect
    CGFloat bgImageHeight;//图片高度
}
@property (nonatomic, strong) NSMutableArray   *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *layOut;

@end

@implementation PinterestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navBar.navigationBarTitle.text = @"美女瀑布流";
    
    page = 1;
    girlCache = [[YYCache alloc] initWithName:SYGirleCache];
    girlCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    girlCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;

    [self initCollectionView];
    [self setRefresh];
    [self initMemoryData];
    [self initGradientColor];
}
#pragma mark -- 设置刷新、加载更多
- (void)setRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self initMoreData];
    }];
}
#pragma mark -- 加载缓存数据
- (void)initMemoryData
{
    if ([girlCache objectForKey:SYGirlCacheKey]) {
        NSArray *dateArray = (NSArray *)[girlCache objectForKey:SYGirlCacheKey];
        for (NSDictionary *dic in dateArray) {
            ItemModel *model = [[ItemModel alloc] init];
            model.imageUrl = [dic objectForKey:@"img"];
            model.imageTitle = [dic objectForKey:@"title"];
            DLog(@"%@",model.imageTitle);
            NSString *timeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
            timeString = [timeString substringToIndex:10]; //从字符A中分隔成2个元素的数组
            model.imageTime = timeString;
            
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
    } else {
        [self initData];
    }
}
#pragma mark -- 初始化collectionView
- (void)initCollectionView
{
    _layOut = [[CHTCollectionViewWaterfallLayout alloc] init];
    //设置边界最小值
    _layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //_layOut.minimumColumnSpacing  = 0;  //列间距
    //_layOut.minimumInteritemSpacing = 0;//行间距
    _layOut.columnCount = columnsNumber;
    [self.view addSubview:self.collectionView];
    //注册cell:
    [self.collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:SYCollectionViewID];
    
    [self.collectionView registerClass:[collectionFooterView class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
               withReuseIdentifier:SYCollectionSectionFooter];
    
    [self.collectionView registerClass:[collectionFooterView class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:SYCollectionSectionHeader];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:_layOut];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark -- 设置渐变颜色
- (void)initGradientColor
{
    //设置图片渐变颜色
    UIColor *topleftColor = [UIColor colorWithRed:48/255.0f green:127/255.0f blue:202/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:35/255.0f green:195/255.0f blue:95/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(WIDTH, HEIGHT-64)];
    _collectionView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
}
#pragma mark--初始数据
- (void)initData
{
    page = 1;
    [[NetworkManager shareNetworkManager] getHomeListWithUrl:pinterestUrl(page) parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"status"] intValue] == 1) {
            if (self.dataArray.count>0) {
                [self.dataArray removeAllObjects];
            }
            NSArray *arr = [resultDic objectForKey:@"tngou"];
            [girlCache removeObjectForKey:SYGirlCacheKey];
            [girlCache setObject:arr forKey:SYGirlCacheKey];
            
            for (NSDictionary *dic in arr) {
                ItemModel *model = [[ItemModel alloc] init];
                model.imageUrl = [dic objectForKey:@"img"];
                model.imageTitle = [dic objectForKey:@"title"];
                NSString *timeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
                timeString = [timeString substringToIndex:10]; //从字符A中分隔成2个元素的数组
                model.imageTime = timeString;
                
                [self.dataArray addObject:model];
            }
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        } else {
            NSLog(@"请求接口出错");
            [self.collectionView.mj_header endRefreshing];
        }
    } requestFailed:^(NSDictionary *resultDic) {
        [self.collectionView.mj_header endRefreshing];
        NSLog(@"数据请求出错");
    }];
}
#pragma mark -- 上拉加载更多
- (void)initMoreData
{
    page++;
    [[NetworkManager shareNetworkManager] getHomeListWithUrl:pinterestUrl(page) parameterDic:nil requestFinished:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"status"] intValue] == 1) {
            NSArray *arr = [resultDic objectForKey:@"tngou"];
            for (NSDictionary *dic in arr) {
                ItemModel *model = [[ItemModel alloc] init];
                model.imageUrl = [dic objectForKey:@"img"];
                model.imageTitle = [dic objectForKey:@"title"];
                NSString *timeString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
                timeString = [timeString substringToIndex:10]; //从字符A中分隔成2个元素的数组
                model.imageTime = timeString;
                
                [self.dataArray addObject:model];
            }
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        } else {
            NSLog(@"请求接口出错");
            [self.collectionView.mj_footer endRefreshing];
        }
    } requestFailed:^(NSDictionary *resultDic) {
        [self.collectionView.mj_footer endRefreshing];
        NSLog(@"数据请求出错");
    }];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (!CGSizeEqualToSize(model.imageSize, CGSizeZero)) {
        return model.imageSize;
    }
    return CGSizeMake(150, 150);
}
- (CGFloat)collectionItemHeightsizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.titleHeight;
}

#pragma mark -------------------- 实现collectionView协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYCollectionViewID forIndexPath:indexPath];
    
    ItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    model.titleHeight = [self getItemTitleHeightWithView:cell.contentView itemTitle:model.imageTitle];
    cell.model = model;
    
    NSString *imgUrlString = [pinterestImageUrl stringByAppendingString:model.imageUrl];
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            if (!CGSizeEqualToSize(model.imageSize, image.size)) {
                model.imageSize = image.size;
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
    }];
    return cell;
}
#pragma mark-- 获取文字的高度
-(CGFloat)getItemTitleHeightWithView:(UIView *)cell itemTitle:(NSString *)title
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(cell.frame.size.width-8, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:SYCollectionSectionHeader
                                                                 forIndexPath:indexPath];
    }
    if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:SYCollectionSectionFooter
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemModel *model = self.dataArray[indexPath.row];
    //获取当前点击的cell
    ItemCell *cell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIView *imageView = cell.imageView;

    //得到图片UIImage
    NSString *img = [pinterestImageUrl stringByAppendingString:model.imageUrl];
    bigImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:img];
    if (!bigImage) {
        bigImage = [UIImage imageNamed:@"IMG_0966.JPG"];
    }
    
    //判断图片的长宽比，>1则占满整个屏幕
    CGFloat imageRation = bigImage.size.height/bigImage.size.width;
    bgImageHeight = imageRation>1?HEIGHT:imageRation*WIDTH;
    
    //这里使用 self.collectionView.superview 可以无缝衔接
    imageRect = [self.collectionView.superview convertRect:imageView.bounds fromView:cell];
    
    //调用自定义图片预览
    [[previewBigImageView sharePreview] showBigImage:bigImage imageRect:imageRect imageHeight:bgImageHeight imageTitle:model.imageTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
