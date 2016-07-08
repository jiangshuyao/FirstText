//
//  CommonString.h
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import <Foundation/Foundation.h>

@interface CommonString : NSObject

+ (BOOL)stringIsNull:(NSString *)string;

+ (BOOL)stringIsAllWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingLeadingWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingTailingWhiteSpace:(NSString *)string;

+ (BOOL)stringIsValidateEmailAddress:(NSString *)string;

+ (BOOL)stringISValidateMobilePhone:(NSString *)string;

+ (BOOL)stringIsValidatePhone:(NSString *)string;

+ (BOOL)stringIsValidateMailCode:(NSString *)string;

+ (BOOL)stringIsAllChineseWord:(NSString *)string;

+ (BOOL)stringISValidateCarNumber:(NSString *)string;

+ (BOOL)stringIsValidateUrl:(NSString *)string;

+ (BOOL)stringISValidatePersonCardNumber:(NSString *)string;

+ (BOOL)stringJustHasNumberAndCharacter:(NSString *)string;

+ (BOOL)stringJustHasNumber:(NSString *)string;

+ (BOOL)stringChineseNumberCharacterOnly:(NSString *)string;

+ (NSString*)currentTimeStampString;

@end
