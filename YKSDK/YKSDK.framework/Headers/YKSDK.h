//
//  YKSDK.h
//  YKSDK
//
//  Created by Don on 2017/1/12.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YKSDK/YKCenterSDKHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKSDK : NSObject

//! Project version number for YKCenterSDK.
FOUNDATION_EXPORT double YKCenterSDKVersionNumber;

//! Project version string for YKCenterSDK.
FOUNDATION_EXPORT const unsigned char YKCenterSDKVersionString[];

- (instancetype)init NS_UNAVAILABLE;

/*
 获取 YKCenterSDK 单例的实例
 
 @return 返回初始化后 SDK 唯一的实例。SDK 不管有没有初始化，都会返回一个有效的值。
 */
+ (instancetype)sharedInstance;


/**
 注册并初始化 SDK，有注册结果回调方法。
 
 注意：此接口调用成功后，其他接口的功能才可以正常使用。
 
 @param appId 应用 ID 是在遥看开发者中心注册。
 @param completion 注册成功回调。
 */
+ (void)registApp:(NSString *)appId completion:(void (^ __nullable)(NSError *error))completion;

/**
 获取遥控码的设备类型

 @param ykcId       遥控中心 id
 @param completion  返回遥控码的设备类型列表
 */
+ (void)fetchRemoteDeviceTypeWithYKCId:(NSString *)ykcId
                            completion:(void (^__nullable)(NSArray<YKRemoteDeviceType *> *types, NSError *error))completion;


/**
 获取遥控码的设备品牌

 @param ykcId       遥控中心 id
 @param typeId      遥控码的设备类型 id
 @param completion  返回遥控码的设备品牌列表
 */
+ (void)fetchRemoteDeviceBrandWithYKCId:(NSString *)ykcId
                     remoteDeviceTypeId:(NSUInteger)typeId
                             completion:(void (^__nullable)(NSArray<YKRemoteDeviceBrand*> *brands, NSError *error))completion;


/**
 获取遥控码的匹配设备列表，每个遥控码设备只返回几个匹配用的按键（遥控码）

 @param ykcId 遥控中心 id
 @param typeId 遥控码的设备类型 id
 @param brandId 遥控码的品牌 id
 @param completion 返回遥控码的匹配设备列表
 */
+ (void)fetchMatchRemoteDeviceWithYKCId:(NSString *)ykcId
                     remoteDeviceTypeId:(NSUInteger)typeId
                    remoteDeviceBrandId:(NSUInteger)brandId
                             completion:(void (^__nullable)(NSArray<YKRemoteMatchDevice*> *mathes, NSError *error))completion;

/**
 获取遥控器设备，此方法会保存遥控器

 @param ykcId           遥控中心 id
 @param remoteDeviceId  遥控器设备 id
 @param completion      回调返回遥控器
 */
+ (void)fetchRemoteDeivceWithYKCId:(NSString *)ykcId
                    remoteDeviceId:(NSString *)remoteDeviceId
                        completion:(void (^__nullable)(YKRemoteDevice *remote, NSError *error))completion;

/**
 获取 SDK 版本号

 @return SDK 版本号
 */
+ (NSString *)sdkVersion;


/**
 关闭 SDK 日志

 @param disable YES 为关闭 SDK 日志，NO 为打开日志，默认为打开
 */
+ (void)disableSDKLog:(BOOL)disable;

@end

NS_ASSUME_NONNULL_END
