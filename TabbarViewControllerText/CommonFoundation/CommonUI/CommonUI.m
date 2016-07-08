//
//  CommonUI.m
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import "CommonUI.h"

#import "CommonUIInterface.h"
#import "CommonStringInterface.h"

@implementation CommonUI

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [CommonUI colorFromRed:red green:green blue:blue withAlpha:1.0];
}

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue withAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    if (StringIsNull(hexString)) {
        return nil;
    }
    
    unsigned hexNum;
    if ( ![[NSScanner scannerWithString:hexString] scanHexInt:&hexNum] ) {
        return nil;
    }
    
    return [UIColor colorWithRed:((float)((hexNum & 0xFF0000) >> 16))/255.0 green:((float)((hexNum & 0xFF00) >> 8))/255.0 blue:((float)(hexNum & 0xFF))/255.0 alpha:1.0];
}

+ (UIImage*)imageForColor:(UIColor *)aColor withSize:(CGSize)aSize
{
    CGRect rect = CGRectMake(0, 0, aSize.width, aSize.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
