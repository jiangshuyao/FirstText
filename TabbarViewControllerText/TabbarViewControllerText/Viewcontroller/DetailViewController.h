//
//  DetailViewController.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/4/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSExportDelegate <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareMessage;

@end

@interface DetailViewController : BaseViewController



@end
