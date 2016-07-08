//
//  CommonSystemInterface.h
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import "ConmonStysem.h"

/**
 *  去除performSelector警告
 *
 *  @param code 需要屏蔽警告的代码
 *
 *  @return
 */
#define SystemRemovePerformSelectorLeakWarning(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")                                         \


/**
 *  当前App的版本号
 */
#define SystemAppVersion [ConmonStysem appVersion]

/**
 *  当前App的版本号 float型
 */
#define SystemAppFloatVersion [ConmonStysem appFloatVersion]

/**
 *  当前App的版本号 字符串型
 */
#define SystemAppStringVersion [ConmonStysem appStringVersion]

/**
 *  当前App的bundleIdentifier
 */
#define SystemAppBundleIdentifier [ConmonStysem appBundleIdentifier]

/**
 *  屏幕绝对画布
 */
#define SystemScreenBounds [ConmonStysem screenBounds]

/**
 *  获取系统版本号
 */
#define SystemVersion [ConmonStysem currentSystemVersion]

/**
 *  当前屏幕缩放倍数
 */
#define ScreenScale [ConmonStysem currentScreenScale]

/**
 *  系统是否超过5.0
 */
#define SystemIsOver5 [ConmonStysem isSystemVersionOver:5.0]

/**
 *  系统是否超过6.0
 */
#define SystemIsOver6 [ConmonStysem isSystemVersionOver:6.0]

/**
 *  系统是否超过7.0
 */
#define SystemIsOver7 [ConmonStysem isSystemVersionOver:7.0]

/**
 *  系统是否超过8.0
 */
#define SystemIsOver8 [ConmonStysem isSystemVersionOver:8.0]

/**
 *  获取屏幕大小
 */
#define SystemScreenSize [ConmonStysem deviceScreenSize]

/**
 *  获取屏幕宽度
 */
#define SystemScreenWidth [ConmonStysem deviceScreenSize].width

/**
 *  获取屏幕高度
 */
#define SystemScreenHeight [ConmonStysem deviceScreenSize].height

/**
 *  是否iPhone4
 */
#define SystemiPhone4 [ConmonStysem iPhone4Device]

/**
 *  是否iPhone5
 */
#define SystemiPhone5 [ConmonStysem iPhone5Device]

/**
 *  是否iPhone6
 */
#define SystemiPhone6 [ConmonStysem iPhone6Device]

/**
 *  是否iPhone6 plus
 */
#define SystemiPhone6Plus [ConmonStysem iPhone6PlusDevice]

/**
 *  是否iPad
 */
#define SystemiPad [ConmonStysem iPadDevice]

/**
 *  系统UINavigationBar高度
 */
#define SystemNavigationBarHeight [ConmonStysem naivationBarHeight]

/**
 *  Y轴增量
 */
#define SystemOriginYDelta 20.f

/**
 *  AppDelegate
 */
#define ApplicationDelegate [UIApplication shareApplication].delegate

/**
 *  创建对象弱引用
 */
#define WeakObject(anObject)  __weak __typeof(anObject)

/**
 *  创建对象强引用
 */
#define StrongObject(anObject) __strong __typeof(anObject)

/**
 *  创建self弱引用
 */
#define WeakSelf WeakObject(self)

/**
 *  创建self强引用
 */
#define StrongSelf StrongObject(WeakSelf)

/**
 *  系统通知中心
 */
#define NotificationCenter [ConmonStysem defaultCenter]

/**
 *  系统通知中心发noti名字的通知
 */
#define NotificationPost(noti) [ConmonStysem postNoti:noti]

/**
 *  系统通知中心发noti名字的通知，携带参数对象object
 */
#define NotificationPostObj(noti,object) [ConmonStysem postNoti:noti withObject:object]

/**
 *  系统通知中心发noti名字的通知，携带参数对象object ,携带用户自定义信息userInfo
 */
#define NotificationPostObjUserInfo(noti,object,userInfo) [ConmonStysem postNoti:noti withObject:object withUserInfo:userInfo]

/**
 *  照相机是否可用
 */
#define CFCameraIsAvailable [ConmonStysem cameraAvailable]

/**
 *  前置摄像头是否可用
 */
#define CFFrontCameraAvailable [ConmonStysem frontCameraAvailable]

/**
 *  照相机闪光灯是否可用
 */
#define CFCameraFlashAvailable [ConmonStysem cameraFlashAvailable]

/**
 *  是否支持发短信
 */
#define CFSystemCanSendSMS [ConmonStysem canSendSMS]

/**
 *  是否支持打电话
 */
#define CFSystemCanMakePhoneCall [ConmonStysem canMakePhoneCall]

/**
 *  App是否有权限访问照片库
 */
#define CFAppCanAccessPhotoLibrary [ConmonStysem isAppPhotoLibraryAccessAuthorized]

/**
 *  App是否有权限访问相机
 */
#define CFAppCanAccessCamera [ConmonStysem isAppCameraAccessAuthorized]

/**
 *  获取屏幕Y轴起始点
 */
#define CFAppSelfViewFrameOrangeY [ConmonStysem getSelfViewFrameOrangeY]

/**
 *  获取指定时间戳与现在时间对比
 */
#define CFComparisonResultNowWithTimeInterval(timeInterval) [ConmonStysem getResultCompareWithTimeInterval:timeInterval]

/**
 *  获取 指定时间与现在时间对比
 */
#define CFComparisonResultNowWithDate(aDate) [ConmonStysem getResultCompareWithDate:aDate]

/**
 *  只执行一次block,创建单例使用
 */
#define CFDispatchOnce(onceToken,block) [ConmonStysem dispatchOnce:onceToken action:block]

/**
 *  获取 指定时间与现在时间 间隔 单位:秒
 */
#define CFTimeIntervalBetweenEarly(earlyDate,latelyDate) [ConmonStysem getTimeIntervalBetweenEarly:earlyDate lately:latelyDate]

/**
 *  将时间戳转成日期
 */
#define CFDateFromTimeInterval(timeInterval) [ConmonStysem dateFromTimeInterval:timeInterval]

/**
 *  获取一个时间与当前时间间隔详情字符串
 */
#define CFDateTimeAgoString(aDate) [ConmonStysem detailTimeAgoString:aDate]

/**
 *  获取一个时间戳与当前时间的间隔详情字符串
 */
#define CFDateTimeAgoStringByTimeInterval(timeInterval) [ConmonStysem detailTimeAgoStringByInterval:timeInterval]






