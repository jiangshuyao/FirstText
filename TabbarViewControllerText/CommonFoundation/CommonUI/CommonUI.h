//
//  CommonUI.h
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import <Foundation/Foundation.h>

@interface CommonUI : NSObject

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue withAlpha:(CGFloat)alpha;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

/* 根据颜色创建图片 */
+ (UIImage *)imageForColor:(UIColor*)aColor withSize:(CGSize)aSize;

@end
