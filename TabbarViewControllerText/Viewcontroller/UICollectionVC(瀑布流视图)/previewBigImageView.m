//
//  previewBigImageView.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "previewBigImageView.h"
#import "promptView.h"

NSTimeInterval  const dutionAnimationTime = 0.5f;

@interface previewBigImageView ()<UIActionSheetDelegate>

{
    BOOL isTransform;
    UILabel *titleLable;
}

@end

@implementation previewBigImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [KeyWindow addSubview:self];
        self.alpha = 0.0f;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

+ (previewBigImageView *)sharePreview
{
    static previewBigImageView *sharePromptView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePromptView = [[self alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    });
    return sharePromptView;
}

- (void)showBigImage:(UIImage *)previewImage
           imageRect:(CGRect)imageRect
         imageHeight:(CGFloat)imageH
          imageTitle:(NSString *)imageTitle
{
    _previewImage = previewImage;
    _imageRect    = imageRect;
    _imageHeight  = imageH;
    
    [self showAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideAnimation:nil];
}

- (void)showAnimation
{
    [self initGestureRecognizer];
    
    [UIView animateWithDuration:dutionAnimationTime animations:^{
        self.alpha = 0.8f;
        _previewImageView.image = _previewImage;
        _previewImageView.frame = CGRectMake(0, 0, WIDTH, _imageHeight);
        _previewImageView.center = CGPointMake(WIDTH/2, HEIGHT/2);
        //注意这里不能加载self上，因为self透明度问题会造成模糊
        [KeyWindow addSubview: _previewImageView];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- 添加手势
- (void)initGestureRecognizer
{
    _previewImageView = [[UIImageView alloc] initWithFrame:_imageRect];
    _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    _previewImageView.clipsToBounds = YES;
    _previewImageView.userInteractionEnabled = YES;
    _previewImageView.layer.cornerRadius = 10;
    
    //单击手势
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation:)];
    singleRecognizer.numberOfTouchesRequired = 1;
    singleRecognizer.numberOfTapsRequired = 1;
    [_previewImageView addGestureRecognizer:singleRecognizer];
    
    //长按手势
    UILongPressGestureRecognizer *longGestture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveCurrentImageToPhoto:)];
    [_previewImageView addGestureRecognizer:longGestture];
    
    //双击手势
    UITapGestureRecognizer *transformTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomCurrentImage:)];
    transformTap.numberOfTapsRequired = 2;//手指点击次数
    transformTap.numberOfTouchesRequired = 1;//手指数
    [_previewImageView addGestureRecognizer:transformTap];
    
    /*添加拖动手势*/
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panCurrentImage:)];
    [_previewImageView addGestureRecognizer:panGesture];
    
    //解决点击与双击手势冲突
    [singleRecognizer requireGestureRecognizerToFail:transformTap];
    [transformTap requireGestureRecognizerToFail:panGesture];
}

#pragma mark--隐藏图片
- (void)hideAnimation:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:dutionAnimationTime animations:^{
        _previewImageView.frame = _imageRect;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_previewImageView removeFromSuperview];
        [_previewImageView removeGestureRecognizer:tap];
    }];
}
#pragma mark--保存图片
- (void)saveCurrentImageToPhoto:(UILongPressGestureRecognizer *)longGesture
{
    //由于连续手势此方法会调用多次，所以需要判断其手势状态
    if (longGesture.state==UIGestureRecognizerStateBegan) {
        NSLog(@"保存图片");
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"保存图片到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:KeyWindow];
    }
}
#pragma mark -- 代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //0是保存，1是取消
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_previewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
#pragma mark -- 图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [[promptView sharePrompt] showPromptViewMessage:@"保存成功"];
        [[promptView sharePrompt] hidePromptViewAfterDelay:1.0f];
    } else {
        [[promptView sharePrompt] showPromptErroMessage:@"保存失败"];
    }
}

#pragma mark -- 放大图片
- (void)zoomCurrentImage:(UITapGestureRecognizer *)tap
{
    isTransform = !isTransform;
    if (isTransform) {
        [UIView animateWithDuration:0.4f animations:^{
            _previewImageView.transform = CGAffineTransformMakeScale(3.0, 3.0);
        }];
    } else {
        [UIView animateWithDuration:0.4f animations:^{
            _previewImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
}

- (void)panCurrentImage:(UIPanGestureRecognizer *)gesture
{
    if(isTransform){
        if (gesture.state==UIGestureRecognizerStateChanged) {
            CGPoint translation=[gesture translationInView:gesture.view];//利用拖动手势的translationInView:方法取得在相对指定视图（控制器根视图）的移动
            _previewImageView.transform=CGAffineTransformMakeTranslation(translation.x, translation.y);
        }else if(gesture.state==UIGestureRecognizerStateEnded){
            [UIView animateWithDuration:0.5 animations:^{
                _previewImageView.transform=CGAffineTransformIdentity;
            }];
        }
    }
}

@end
