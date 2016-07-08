//
//  shopClassItem.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/6.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopClassItem : NSObject

@property (nonatomic,copy)NSString *shopTitle;
@property (nonatomic,copy)NSString *shopID;

@end

@interface shopClassDetailItem : NSObject

@property (nonatomic,copy)NSString *shopDetailTitle;
@property (nonatomic,copy)NSString *shopDetailImage;
@property (nonatomic,copy)NSString *shopDetailID;

@end

