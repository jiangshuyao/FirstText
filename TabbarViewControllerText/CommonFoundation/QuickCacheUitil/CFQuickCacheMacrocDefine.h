//
//  CFQuickCacheMacrocDefine.h
//  CommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

/**
 *  文件描述
 *
 *  这个工具类宏定义封装了对
 *  NSUserDefault,NSCache,NSFileManager
 *  NSKeyedArchieve,NSDocumentDirectory,NSCacheDirectory的便捷操作
 */

#import "CFQuickCacheUitil.h"

/* 写宏定义的时候，前面变量参数的名字，多参数的时候不能方法名和后面调用方法的参数名字一样 */

/**
 *  检查一个valueObj,keyObj对象是否有一个是空的
 */
#define CFCheckKeyValueHasNull(keyObj,valueObj) [CFQuickCacheUitil checkValue:valueObj key:keyObj]

/**
 *  检查一个对象是否为空
 */
#define CFCheckObjectNull(object) [CFQuickCacheUitil isNullObject:object]

/**
 *  NSUserDefault 保存键值对 keyObj,valueObj
 */
#define CFUDFCache(keyObj,valueObj) [CFQuickCacheUitil userDefaultCache:valueObj key:keyObj]

/**
 *  NSUserDefault 删除键keyObj对应的值
 */
#define CFUDFRemove(keyObj) [CFQuickCacheUitil userDefaultRemove:keyObj]

/**
 *  NSUserDefault 获取键keyObj对应的值
 */
#define CFUDFGetValue(keyObj) [CFQuickCacheUitil userDefaultGetValue:keyObj]

/**
 *  NSUserDefault 判断键keyObject对应的值是否为空
 */
#define CFUDFEmptyValue(keyObj) [CFQuickCacheUitil userDefaultEmptyValue:keyObj]

/**
 *  NSCache 存储键值对 keyObj,valueObj
 */
#define CFNSCacheSet(keyObj,valueObj) [CFQuickCacheUitil systemMemoryCacheSet:valueObj key:keyObj]

/**
 *  NSCache 删除键keyObj对应的值
 */
#define CFNSCacheRemove(keyObj) [CFQuickCacheUitil systemMemoryCacheRemove:keyObj]

/**
 *  NSCache 获取键keyObj对应的值
 */
#define CFNSCacheGetValue(keyObj) [CFQuickCacheUitil systemMemoryCacheGetValue:keyObj]

/**
 *  NSCache 判断键keyObject对应的值是否为空
 */
#define CFNSCacheEmptyValue(keyObj) [CFQuickCacheUitil systemMemoryCacheEmptyValue:keyObj]

/**
 *  获取系统默认文件管理
 */
#define CFFileManager [CFQuickCacheUitil fileManager]

/**
 *  指定路径pathObj是否存在文件
 */
#define CFFileIsExist(pathObj) [CFQuickCacheUitil fileExist:pathObj]

/**
 *  指定路径pathObj是否存在目录
 */
#define CFFileDirectoryIsExist(pathObj) [CFQuickCacheUitil directoryExist:pathObj]

/**
 *  读取某个路径的二进制数据，返回 NSData
 */
#define CFFileRead(pathObj) [CFQuickCacheUitil readFromFile:pathObj]

/**
 *  将二进制数据写入文件 dataObj:NSData pathObj:NSString
 */
#define CFFileWrite(dataObj,pathObj) [CFQuickCacheUitil writeFileData:dataObj toPath:pathObj]

/**
 *  在指定路径创建目录，返回BOOL结果
 */
#define CFFileDirectoryCreate(pathObj) [CFQuickCacheUitil createDirectory:pathObj]

/**
 *  删除指定路径文件
 */
#define CFFileDeleteFile(path) [CFQuickCacheUitil deleteFileAtPath:path]

/**
 *  删除指定目录
 */
#define CFFileDeleteDirectory(path) [CFQuickCacheUitil deleteDirectoryAtPath:path]

/**
 *  从fromFilePath复制文件到toFilePath,shouldRemove标示是否删除复制源文件
 */
#define CFFileCopyFileIsRemove(fromFilePath,toFilePath,shouldRemove) [CFQuickCacheUitil copyFileFromPath:fromFilePath toPath:toFilePath isRemoveOld:shouldRemove]

/**
 *  将某个对象归档到指定路径
 */
#define CFArchieveObject(object,filePath) [CFQuickCacheUitil archieveObject:object toFilePath:filePath]

/**
 *  从指定路径读取被归档过的对象
 */
#define CFUnArchieveObject(fromFilePath) [CFQuickCacheUitil unarchieveFromPath:fromFilePath]

/**
 *  获取NSDocumentDirectory目录
 */
#define CFAppDocumentDirectory [CFQuickCacheUitil documentDirectory]

/**
 *  获取NSCacheDirectory目录
 */
#define CFAppCacheDirectory [CFQuickCacheUitil cacheDirectory]

/**
 *  返回文件名为fileName在NSDocumentDirectory中的路径
 */
#define CFAppDoucmentPath(fileName) [CFQuickCacheUitil documentDirectoryPath:fileName]

/**
 *  返回文件名为fileName在NSCacheDirectory中的路径
 */
#define CFAppCachePath(fileName) [CFQuickCacheUitil cacheDirectoryPath:fileName]

/**
 *  将object对象用fileName名字保存到NSDocumentDirectory目录下
 */
#define CFAppDocumentSave(object,fileName) [CFQuickCacheUitil documentDirectorySave:object withFileName:fileName]

/**
 *  将object对象用fileName名字保存到NSCacheDirectory目录下
 */
#define CFAppCacheSave(object,fileName) [CFQuickCacheUitil cacheDirectorySave:object withFileName:fileName]

/**
 *  删除NSDocumentDirectory目录下名为fileName的文件
 */
#define CFAppDocumentDelete(fileName)  [CFQuickCacheUitil documentDirectoryDelete:fileName]

/**
 *  删除NSCacheDirectory目录下名为fileName的文件
 */
#define CFAppCacheDelete(fileName) [CFQuickCacheUitil cacheDirectoryDelete:fileName]




