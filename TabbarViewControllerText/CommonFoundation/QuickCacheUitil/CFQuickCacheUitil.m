//
//  CFQuickCacheUitil.m
//  CommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import "CFQuickCacheUitil.h"
#import "CFQuickCacheMacrocDefine.h"
//#import "CFDispatchMacrocDefine.h"
//#import "CFStringMacrocDefine.h"
#import "CommonStringInterface.h"
#import "CommonSystemInterface.h"

@implementation CFQuickCacheUitil

+ (BOOL)isNullObject:(id)anObject
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)checkValue:(id)value key:(id)key
{
    if(CFCheckObjectNull(value)||CFCheckObjectNull(key)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSUserDefaults *)standDefault
{
    return [NSUserDefaults standardUserDefaults];
}

+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key
{
    if (CFCheckKeyValueHasNull(key, value)) {
        return;
    }
    [[CFQuickCacheUitil standDefault]setObject:value forKey:key];
}

+ (void)userDefaultRemove:(id)key
{
    if (CFCheckObjectNull(key)) {
        return;
    }
    [[CFQuickCacheUitil standDefault]removeObjectForKey:key];
}

+ (id)userDefaultGetValue:(id)key
{
    if (CFCheckObjectNull(key)) {
        return nil;
    }
    return [[CFQuickCacheUitil standDefault]objectForKey:key];
}

+ (BOOL)userDefaultEmptyValue:(id)key
{
    return [CFQuickCacheUitil userDefaultGetValue:key] == nil;
}

+ (NSCache *)shareCache
{
    static NSCache *_cfNSCacheInstance = nil;
    static dispatch_once_t onceToken;
    
    CFDispatchOnce(onceToken, ^{
        
        if (!_cfNSCacheInstance) {
            _cfNSCacheInstance = [[NSCache alloc]init];
        }
        
    });
    
    return _cfNSCacheInstance;
}

+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key
{
    if (CFCheckKeyValueHasNull(value, key)) {
        return;
    }
    [[CFQuickCacheUitil shareCache]setObject:value forKey:key];
}

+ (void)systemMemoryCacheRemove:(id)key
{
    if (CFCheckObjectNull(key)) {
        return;
    }
    [[CFQuickCacheUitil shareCache]removeObjectForKey:key];
}

+ (id)systemMemoryCacheGetValue:(id)key
{
    if (CFCheckObjectNull(key)) {
        return nil;
    }
    return [[CFQuickCacheUitil shareCache]objectForKey:key];
}

+ (BOOL)systemMemoryCacheEmptyValue:(id)key
{
    if (CFCheckObjectNull(key)) {
        return NO;
    }
    return [CFQuickCacheUitil systemMemoryCacheGetValue:key] == nil;
}

+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

+ (BOOL)fileExist:(NSString*)path
{
    if (StringIsNull(path)) {
        return NO;
    }
    return [[CFQuickCacheUitil fileManager] fileExistsAtPath:path];
}

+ (BOOL)directoryExist:(NSString*)dirPath
{
    if (StringIsNull(dirPath)) {
        return NO;
    }
    BOOL isDir = YES;
    
    return [[CFQuickCacheUitil fileManager]fileExistsAtPath:dirPath isDirectory:&isDir];
}

+ (BOOL)createDirectory:(NSString*)dirPath
{
    if (CFCheckObjectNull(dirPath)) {
        return NO;
    }
    if (CFFileDirectoryIsExist(dirPath)) {
        return YES;
    }
    return [[CFQuickCacheUitil fileManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)writeFileData:(NSData*)data toPath:(NSString *)path
{
    if (CFCheckKeyValueHasNull(data, path)) {
        return NO;
    }
    
    return [data writeToFile:path atomically:YES];
}

+ (NSData *)readFromFile:(NSString *)path
{
    if (CFCheckObjectNull(path)) {
        return nil;
    }
    
    return [NSData dataWithContentsOfFile:path];
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath
{
    if (StringIsNull(filePath)) {
        return NO;
    }
    return [CFFileManager removeItemAtPath:filePath error:nil];
}

+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath
{
    if (StringIsNull(dirPath)) {
        return NO;
    }
    return [CFFileManager removeItemAtPath:dirPath error:nil];
}

+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove
{
    if (StringIsNull(fromPath) || StringIsNull(toPath) ) {
        return NO;
    }
    if (!CFFileIsExist(fromPath)) {
        return NO;
    }
    
    BOOL copyResult = [CFFileManager copyItemAtPath:fromPath toPath:toPath error:nil];
    if (copyResult) {
        
        if (isRemove) {
            return [CFFileManager removeItemAtPath:fromPath error:nil];
        }
        return YES;
        
    }else{
        return NO;
    }
}

+ (BOOL)archieveObject:(id<NSCoding>)anObject toFilePath:(NSString *)toPath
{
    if (CFCheckObjectNull(anObject) || StringIsNull(toPath)) {
        return NO;
    }
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:anObject];
    if (archieveData) {
        
        return CFFileWrite(archieveData, toPath);
        
    }else{
        return NO;
    }
}

+ (id)unarchieveFromPath:(NSString *)filePath
{
    if (StringIsNull(filePath)) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)documentDirectoryPath:(NSString *)file
{
    if (StringIsNull(file)) {
        return nil;
    }
    return [[CFQuickCacheUitil documentDirectory]stringByAppendingPathComponent:file];
}

+ (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)cacheDirectoryPath:(NSString *)file
{
    if (StringIsNull(file)) {
        return nil;
    }
    return [[CFQuickCacheUitil cacheDirectory]stringByAppendingPathComponent:file];
}

+ (BOOL)cacheDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file
{
    if (CFCheckObjectNull(anObject) || StringIsNull(file)) {
        return NO;
    }
    
    return CFArchieveObject(anObject, [CFQuickCacheUitil cacheDirectoryPath:file]);
}

+ (BOOL)cacheDirectoryDelete:(NSString *)file
{
    if (StringIsNull(file)) {
        return NO;
    }
    return CFFileDeleteFile([CFQuickCacheUitil cacheDirectoryPath:file]);
}


+ (BOOL)documentDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file
{
    if (CFCheckObjectNull(anObject) || StringIsNull(file)) {
        return NO;
    }
    
    return CFArchieveObject(anObject, [CFQuickCacheUitil documentDirectoryPath:file]);
}

+ (BOOL)documentDirectoryDelete:(NSString *)file
{
    if (StringIsNull(file)) {
        return NO;
    }
    return CFFileDeleteFile([CFQuickCacheUitil documentDirectoryPath:file]);
}

@end
