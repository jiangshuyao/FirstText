//
//  CommonUIInterface.h
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import "CommonUI.h"

/**
 *  快速得到RGB颜色
 */
#define RGBColor(redValue,greenValue,blueValue) [CommonUI colorFromRed:redValue green:greenValue blue:blueValue]

/**
 *  获取带alpha值的RGB颜色
 */
#define RGBColorAlpha(redValue,greenValue,blueValue,alpha) [CommonUI colorFromRed:redValue green:greenValue blue:blueValue withAlpha:alpha]

/**
 *  从16进制字符中得到颜色
 */
#define HexColor(hexString) [CommonUI colorFromHexString:hexString]

/**
 *  根据颜色创建图片
 */
#define ImageForColor(aColor,aSize) [CommonUI imageForColor:(UIColor*)aColor withSize:(CGSize)aSize]

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]




