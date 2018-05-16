//
//  EXConstantMacros.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#ifndef EXConstantMacros_h
#define EXConstantMacros_h

//////////////////////////
/// system properties
//////////////////////////
/**
 *  屏幕高度
 */

#define SCREEN_HEIGHT                                       UIScreen.mainScreen.bounds.size.height

/**
 *  屏幕宽度
 */

#define SCREEN_WIDTH                                        UIScreen.mainScreen.bounds.size.width

/**
 *  屏幕最大边长
 */
#define SCREEN_MAX_LENGTH                                   (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

/**
 *  屏幕最小边长
 */
#define SCREEN_MIN_LENGTH                                   (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define SCREEN_WIDTH_RATIO(width)                           (width * SCREEN_MIN_LENGTH / 375)

#define SCREEN_HEIGHT_RATIO(height)                         (height * SCREEN_MAX_LENGTH / 667)

/**
 *  显示器缩放比例
 */
#define SCREEN_SCALE                                        [[UIScreen mainScreen] scale]

/**
 *  操作系统版本号
 */
#define IOSVersion                                           [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark - 系统属性判断

/**
 *  是否iPhone
 */
#define IS_IPHONE                                           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/**
 *  是否iPad
 */
#define IS_IPAD                                             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  是否retina屏幕
 */
#define IS_RETINA                                           (SCREEN_SCALE >= 2.0)

/**
 *  url参数是否utf-16编码
 */
#define IS_UTF16ENCODE                                      NO

//////////////////////////
/// sandbox directory
//////////////////////////
/**
 *  Doucment 路径
 */
#define SDDocumentDirectory                                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  Cache 路径
 */
#define SDCacheDirectory                                    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/**
 *  Library 路径
 */
#define SDLibraryDirectory                                  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/**
 *  Temporary 路径
 */
#define SDTemporaryDirectory                                NSTemporaryDirectory()
/**
 *  Document 路径 filename 文件/文件夹名称
 */
#define SDDocumentFile(filename)                            [SDDocumentDirectory stringByAppendingPathComponent:filename]
/**
 *  Cache 路径 filename 文件/文件夹名称
 */
#define SDCacheFile(filename)                               [SDCacheDirectory stringByAppendingPathComponent:filename]

/**
 *  Temporary 路径 filename 文件/文件夹名称
 */
#define SDTemporaryFile(filename)                           [SDTemporaryDirectory stringByAppendingPathComponent:filename]

/**
 *  Library 路径 filename 文件/文件夹名称
 */
#define SDLibraryFile(filename)                             [SDLibraryDirectory stringByAppendingPathComponent:filename]

/**
 *  Library/Config 路径 filename 文件/文件夹名称
 */
#define SDConfigFile(filename)                              [SDConfigDirectory stringByAppendingPathComponent:filename]

/**
 *  Library/Config/Archiver 路径 filename 文件/文件夹名称
 */
#define SDArchiverFile(filename)                            [SDArchiverDirectory stringByAppendingPathComponent:filename]

/**
 *  网络数据缓存文件夹名
 */
#define SDWebCacheFolderName                                @"web_cache"

/**
 *  图片数据缓存文件夹名
 */
#define SDImageCacheFolderName                              @"image_cache"

/**
 *  配置文件存储文件夹名
 */
#define SDConfigFolderName                                  @"config"

/**
 *  归档文件存储文件夹名
 */
#define SDArchiverFolderName                                @"archiver"

/**
 *  网络数据缓存文件夹路径
 */
#define SDWebCacheDirectory                                 SDCacheFolder(SDWebCacheFolderName)
/**
 *  网络数据临时缓存文件夹路径
 */
#define SDWebTemporaryCacheDirectory                        SDTemporaryFolder(SDWebCacheFolderName)
/**
 *  图片数据缓存文件夹路径
 */
#define SDImageCacheDirectory                               SDCacheFolder(SDImageCacheFolderName)
/**
 *  图片数据临时缓存文件夹路径
 */
#define SDImageTemporaryCacheDirectory                      SDTemporaryFolder(ImageCacheFolderName)
/**
 *  配置文件存储文件夹路径
 */
#define SDConfigDirectory                                   SDLibraryFolder(SDConfigFolderName)

/**
 *  归档文件存储文件夹路径
 */
#define SDArchiverDirectory                                 SDConfigFolder(SDArchiverFolderName)

#endif /* EXConstantMacors_h */
