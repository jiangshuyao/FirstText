//
//  ScanningViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^getScaningResultBlock) (NSString *resultString);

@interface ScanningViewController : BaseViewController

@property (nonatomic,copy)NSString *scanningTitle;
//扫描的类型（0正常扫描、1由JS页跳转执行扫描，需要回传数据）
@property (nonatomic,strong)NSString *scanStype;
//二维码扫描结果
@property (nonatomic,strong)getScaningResultBlock scaingResultBlock;


@end
