//
//  CommonStringInterface.h
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import "CommonString.h"

/**
 *  字符串是否为空
 */
#define StringIsNull(string) [CommonString stringIsNull:string]

/**
 *  字符串是否全为空格
 */
#define StringIsAllWhiteSpace(string) [CommonString stringIsAllWhiteSpace:string]

/**
 *  返回去除字符串首的空格的字符串
 */
#define StringClearLeadingWhiteSpace(string) [CommonString stringByTrimingLeadingWhiteSpace:string]

/**
 *  返回去除字符串结尾的空格的字符串
 */
#define StringClearTailingWhiteSpace(string) [CommonString stringByTrimingTailingWhiteSpace:string]

/**
 *  字符串是否合法邮箱
 */
#define StringIsEmail(string) [CommonString stringIsValidateEmailAddress:string]

/**
 *  字符串是否合法手机号码
 */
#define StringIsMobilePhone(string) [CommonString stringISValidateMobilePhone:string]

/**
 *  字符串是否合法url
 */
#define StringIsUrl(string) [CommonString stringIsValidateUrl:string]

/**
 *  字符串是否合法座机
 */
#define StringIsPhone(string) [CommonString stringIsValidatePhone:string]

/**
 *  字符串是否合法邮政编码
 */
#define StringIsMailCode(string) [CommonString stringIsValidateMailCode:string]

/**
 *  字符串是否合法身份证号
 */
#define StringIsPersonCardNumber(string) [CommonString stringISValidatePersonCardNumber:string]

/**
 *  字符串是否合法车牌号
 */
#define StringIsCarNumber(string) [CommonString stringISValidateCarNumber:string]

/**
 *  字符串是否只有中文字符
 */
#define StringChineseOnly(string) [CommonString stringIsAllChineseWord:string]

/**
 *  字符串是否只有英文字符
 */
#define StringCharNumOnly(string) [CommonString stringJustHasNumberAndCharacter:string]

/**
 *  字符串是否只包含字符，中文，数字
 */
#define StringCharNumChineseOnly(string) [CommonString stringChineseNumberCharacterOnly:string]

/**
 *  字符串是否纯数字
 */
#define StringNumOnly(string) [CommonString stringJustHasNumber:string]

/**
 *  获取一个当前时间戳字符串
 */
#define StringCurrentTimeStamp [CommonString currentTimeStampString]
