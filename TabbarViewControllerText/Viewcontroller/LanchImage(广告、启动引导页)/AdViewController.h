//
//  AdViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/5/30.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^AdClickBlock) (NSString *adUrl);

@interface AdViewController : BaseViewController

@property (nonatomic,strong)AdClickBlock adBlock;

- (void)getAdImage;

- (void)removeAdVC;

- (void)showAdImageView;

@end
