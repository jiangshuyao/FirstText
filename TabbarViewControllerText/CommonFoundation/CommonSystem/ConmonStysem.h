//
//  ConmonStysem.h
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import <Foundation/Foundation.h>

@interface ConmonStysem : NSObject

+ (void)dispatchOnce:(dispatch_once_t)onceToken action:(dispatch_block_t)block;

+ (CGFloat)appVersion;

+ (CGFloat)appFloatVersion;

+ (NSString *)appStringVersion;

+ (NSString *)appBundleIdentifier;

+ (CGFloat)currentSystemVersion;

+ (CGFloat)currentScreenScale;

+ (CGRect)screenBounds;

+ (BOOL)isSystemVersionOver:(CGFloat)versionValue;

+ (BOOL)iPadDevice;

+ (BOOL)iPhone4Device;

+ (BOOL)iPhone5Device;

+ (BOOL)iPhone6Device;

+ (BOOL)iPhone6PlusDevice;

+ (CGSize)deviceScreenSize;

+ (CGFloat)naivationBarHeight;

+ (NSNotificationCenter *)defaultCenter;

+ (void)postNoti:(NSString *)notiName;

+ (void)postNoti:(NSString *)notiName withObject:(id)obj;

+ (void)postNoti:(NSString *)notiName withObject:(id)obj withUserInfo:(NSDictionary *)infoDict;

+ (NSString *)bundle:(NSString *)bundle file:(NSString *)file;

+ (void)showNetworkIndicatorActivity:(BOOL)state;

+ (BOOL)cameraAvailable;

+ (BOOL)frontCameraAvailable;

+ (BOOL)cameraFlashAvailable;

+ (BOOL)canSendSMS;

+ (BOOL)canMakePhoneCall;

+ (BOOL)isAppCameraAccessAuthorized;

+ (BOOL)isAppPhotoLibraryAccessAuthorized;

/**
 *  获取屏幕Y轴起始点
 */
+(double)getSelfViewFrameOrangeY;

/**
 *  获取指定时间戳与现在时间对比
 */
+(NSComparisonResult)getResultCompareWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  获取 指定时间与现在时间对比
 */
+(NSComparisonResult)getResultCompareWithDate:(NSDate *)theDate;

/**
 *  获取 指定时间与现在时间 间隔 单位:秒
 */
+(NSInteger)getTimeIntervalBetweenEarly:(NSDate*)eDate lately:(NSDate*)lDate;

/**
 *  获取一个时间戳与当前时间的间隔详情字符串
 */
+(NSString *)detailTimeAgoString:(NSDate *)date;

/**
 *  将时间戳转成日期
 */
+ (NSDate *)dateFromTimeInterval:(long long)timeInterval;

+(NSString *)detailTimeAgoStringByInterval:(long long)timeInterval;

@end
