//
//  ConmonStysem.m
//  iLife
//
//  Created by 赵兵旗 on 15-5-23.
//
//

#import "ConmonStysem.h"

#import "CommonSystemInterface.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ConmonStysem

+ (void)dispatchOnce:(dispatch_once_t)onceToken action:(dispatch_block_t)block
{
    if(!block){
        return;
    }
    dispatch_once(&onceToken, block);
}

+ (CGFloat)appVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    return [infoDict[@"CFBundleShortVersionString"] floatValue];
}


+ (CGFloat)appFloatVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    return [infoDict[@"CFBundleShortVersionString"] floatValue];
}

+ (NSString *)appStringVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    return infoDict[@"CFBundleShortVersionString"];
}

+ (NSString *)appBundleIdentifier
{
    return [[NSBundle mainBundle]bundleIdentifier];
}

+ (BOOL)isSystemVersionOver:(CGFloat)versionValue
{
    return [ConmonStysem currentSystemVersion] >= versionValue;
}

+ (CGRect)screenBounds
{
    return [UIScreen mainScreen].bounds;
}

+ (CGFloat)currentSystemVersion
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (CGFloat)currentScreenScale
{
    return [UIScreen mainScreen].scale;
}

+ (BOOL)iPadDevice
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)iPhone4Device
{
    return CGSizeEqualToSize((CGSize){320,480}, [ConmonStysem deviceScreenSize]);
}

+ (BOOL)iPhone5Device
{
    return CGSizeEqualToSize((CGSize){320,568}, [ConmonStysem deviceScreenSize]);
    
}

+ (BOOL)iPhone6Device
{
    return CGSizeEqualToSize((CGSize){375,667}, [ConmonStysem deviceScreenSize]);
}

+ (BOOL)iPhone6PlusDevice
{
    return CGSizeEqualToSize((CGSize){414,736}, [ConmonStysem deviceScreenSize]);
}

+ (CGSize)deviceScreenSize
{
    return [UIScreen mainScreen].bounds.size;
}

+ (CGFloat)naivationBarHeight
{
    return 44.f;
}

+ (NSNotificationCenter *)defaultCenter
{
    return [NSNotificationCenter defaultCenter];
}

+ (void)postNoti:(NSString *)notiName
{
    [ConmonStysem postNoti:notiName withObject:nil];
}

+ (void)postNoti:(NSString *)notiName withObject:(id)obj
{
    [ConmonStysem postNoti:notiName withObject:obj withUserInfo:nil];
}

+ (void)postNoti:(NSString *)notiName withObject:(id)obj withUserInfo:(NSDictionary *)infoDict
{
    if (StringIsNull(notiName)) {
        NSLog(@"ConmonStysem 不可以发送空的通知名:%@",notiName);
        return;
    }
    [[ConmonStysem defaultCenter]postNotificationName:notiName object:obj userInfo:infoDict];
}

+ (NSString *)bundle:(NSString *)bundle file:(NSString *)file
{
    if (StringIsNull(bundle)||StringIsNull(file)) {
        return nil;
    }
    return [bundle stringByAppendingPathComponent:file];
}

+ (void)showNetworkIndicatorActivity:(BOOL)state
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:state];
}

+ (BOOL)cameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)frontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)cameraFlashAvailable
{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)canSendSMS
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
}

+ (BOOL)canMakePhoneCall
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

+ (BOOL)isAppCameraAccessAuthorized
{
    /* iOS7以上才有相机隐私控制 */
    if (!SystemIsOver7) {
        return YES;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus !=  AVAuthorizationStatusAuthorized) {
        
        return authStatus == AVAuthorizationStatusNotDetermined;
        
    }else{
        
        return YES;
    }
}

+ (BOOL)isAppPhotoLibraryAccessAuthorized
{
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authStatus != ALAuthorizationStatusAuthorized) {
        
        return authStatus == ALAuthorizationStatusNotDetermined;
        
    }else{
        
        return YES;
    }
}

/**
 *  获取屏幕Y轴起始点
 */
+(double)getSelfViewFrameOrangeY
{
    double orangeY = 0.0;
    
    float verson = [[UIDevice currentDevice].systemVersion floatValue];
    if (verson >= (float)7.0 && verson < (float)7.1) {
        // 7.0 ViewY轴源点从屏幕顶部开始
        orangeY = 20 + 46;
    }
    return orangeY;
}

+(NSComparisonResult)getResultCompareWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *nowDate = [NSDate date];
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //NSLog(@" nowDate is %@, theDate is %@ ",nowDate,theDate);
    
    NSComparisonResult compare = [nowDate compare:theDate];
    //NSLog(@" compare is %ld ",(long)compare);
    
    return compare;
}

/**
 *  获取 指定时间与现在时间对比
 */
+(NSComparisonResult)getResultCompareWithDate:(NSDate *)theDate
{
    NSDate *nowDate = [NSDate date];
    //NSLog(@" nowDate is %@, theDate is %@ ",nowDate,theDate);
    
    NSComparisonResult compare = [nowDate compare:theDate];
    if (compare == NSOrderedAscending) {
        //NSLog(@" 第一个时间小 ");
    }
    else if (compare == NSOrderedSame) {
        //NSLog(@" 一样大小 ");
    }
    else {
        //NSLog(@" 第一个时间大 ");
    }
    //NSLog(@" compare is %ld ",compare);
    
    return compare;
}

/**
 *  获取 指定时间与现在时间 间隔
 */
+(NSInteger)getTimeIntervalBetweenEarly:(NSDate*)eDate lately:(NSDate*)lDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    if (![eDate isKindOfClass:[NSDate class]] || ![lDate isKindOfClass:[NSDate class]]) {
        return 0;
    }
    NSDateComponents *d = [cal components:unitFlags fromDate:eDate toDate:lDate options:0];
    NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
    NSLog(@" getTimeIntervalBetweenEarly second = %ld",(long)sec);
    
    return sec;
}

+(NSString *)detailTimeAgoString:(NSDate *)date
{
    if (CFCheckObjectNull(date)) {
        return nil;
    }
    long long timeNow = [date timeIntervalSince1970];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    [calendar setFirstWeekday:2];
    //NSCalendar * calendar=[GJCFDateUitil sharedCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    
    NSString*string=nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    return string;
}

+ (NSDate *)dateFromTimeInterval:(long long)timeInterval
{
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSString *)detailTimeAgoStringByInterval:(long long)timeInterval
{
    return [ConmonStysem detailTimeAgoString:CFDateFromTimeInterval(timeInterval)];
}

@end
