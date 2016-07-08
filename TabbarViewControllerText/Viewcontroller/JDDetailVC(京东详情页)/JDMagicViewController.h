//
//  JDMagicViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/15.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "BaseViewController.h"
#import <VTMagic/VTMagic.h>

@interface JDMagicViewController : BaseViewController

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;


@end
