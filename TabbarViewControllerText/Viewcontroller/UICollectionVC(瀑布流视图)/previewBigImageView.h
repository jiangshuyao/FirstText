//
//  previewBigImageView.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface previewBigImageView : UIView

@property (nonatomic,strong)UIImageView *previewImageView;
@property (nonatomic,strong)UIImage *previewImage;  //图片UIimage
@property (nonatomic,assign)CGFloat imageHeight;    //图片高度
@property (nonatomic,copy)  NSString *imageTitle;   //图片Title
@property (nonatomic,assign)CGRect  imageRect;      //图片rect

+ (previewBigImageView *)sharePreview;

- (void)showBigImage:(UIImage *)previewImage imageRect:(CGRect)imageRect imageHeight:(CGFloat)imageH imageTitle:(NSString *)imageTitle;

@end
