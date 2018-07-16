//
//  YKCommon.m
//  YKSDKDemo
//
//  Created by Don on 2017/1/16.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKCommon.h"

static YKCommon *instance = nil;

@implementation YKCommon

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YKCommon alloc] __init];
    });
    
    return instance;
}

- (id)__init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

@end
