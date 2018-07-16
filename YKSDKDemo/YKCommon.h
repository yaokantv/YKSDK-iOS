//
//  YKCommon.h
//  YKSDKDemo
//
//  Created by Don on 2017/1/16.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCommon : NSObject


/**
 遥控器ID，唯一ID，建议使用设备的MAC地址
 */
@property (nonatomic, copy) NSString *currentYKCId;

+ (instancetype)sharedInstance;

- (id)init NS_UNAVAILABLE;

@end
