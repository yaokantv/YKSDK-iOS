//
//  YKRemoteACViewController.m
//  YKSDKDemo
//
//  Created by Don on 2017/6/28.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKRemoteACViewController.h"
#import <YKSDK/YKSDK.h>

@interface YKRemoteACViewController ()

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *sweepUDLabel;
@property (weak, nonatomic) IBOutlet UILabel *sweepLRLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (nonatomic, strong) NSArray *modelKeys;
@property (nonatomic, strong) NSArray *modelKeyNames;

@property (nonatomic, copy) NSString *currentModel;
@property (nonatomic, assign) NSUInteger temperature;   // 16~30
@property (nonatomic, assign) NSUInteger currentSpeed;  // 0~9
@property (nonatomic, assign) NSUInteger currentWindU;  // 0~9
@property (nonatomic, assign) NSUInteger currentWindL;  // 0~9

@property (nonatomic, strong) NSArray<YKRemoteDeviceKey *> *asteriskDatas;

@end

@implementation YKRemoteACViewController

- (NSString *)currentModel {
    if (!_currentModel || _currentModel.length == 0) {
        _currentModel = ACModelCool; // cool
    }
    
    return _currentModel;
}

- (NSArray<YKRemoteDeviceKey *> *)asteriskDatas {
    if (_asteriskDatas == nil) {
        _asteriskDatas = [YKRemoteDeviceKey asteriskKeysWithRemote:self.remote];
    }
    
    return _asteriskDatas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.remote.name;
    
    self.modelKeys = @[ACModelAuto, ACModelCool, ACModelDry, ACModelWind, ACModelHot];
    self.modelKeyNames = @[NSLocalizedString(@"自动", @"a"),
                           NSLocalizedString(@"制冷", @"r"),
                           NSLocalizedString(@"抽湿", @"d"),
                           NSLocalizedString(@"送风", @"w"),
                           NSLocalizedString(@"制热", @"h")];
    self.temperature = 23;
    
    _currentWindL = 0;
    _currentWindU = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateStatusView];
}

- (IBAction)modelAction:(id)sender {
    NSInteger modelIndex = [self.modelKeys indexOfObject:_currentModel];
    if (modelIndex + 1 >= self.modelKeys.count) {
        modelIndex = 0;
    } else {
        modelIndex++;
    }
    _currentModel = [self.modelKeys objectAtIndex:modelIndex];
  
    [self remoteControl];
    [self updateStatusView];
}

/**
 风量调整
 
 A 表示自动档
 
 @param sender 消息发送的对象
 */
- (IBAction)windAction:(id)sender {
    if (_currentSpeed < 3) {
        _currentSpeed++;
    } else  {
        _currentSpeed = 0;
    }
    
    if ([_currentModel isEqualToString:ACModelDry]) {
        // 抽湿只有 1档s1
        _currentSpeed = 1;
    }
    if ([_currentModel isEqualToString:ACModelWind] && _currentSpeed == 0) {
        // 送风没有 s0
        _currentSpeed = 1;
    }

    [self remoteControl];
    [self updateStatusView];
}


/**
 切换上下扫风
 
 目前仅支持关和自动

 @param sender 消息发送的对象
 */
- (IBAction)sweepUDAction:(id)sender {
    if (_currentWindU < 1) {
        _currentWindU++;
    } else if (_currentWindU != INT_MAX) {
        _currentWindU = 0;
    }
    
    [self remoteControl];
    [self updateStatusView];
}

/**
 切换左右扫风
 
 目前仅支持关和自动
 
 @param sender 消息发送的对象
 */
- (IBAction)sweepLRAction:(id)sender {
    if (_currentWindL < 1) {
        _currentWindL++;
    } else if (_currentWindU != INT_MAX) {
        _currentWindL = 0;
    }
    
    [self remoteControl];
    [self updateStatusView];
}

- (IBAction)tempAction:(UIStepper *)sender {
    _temperature = sender.value;
    [self remoteControl];
    [self updateStatusView];
}

- (IBAction)powerOnAction:(id)sender {
    [self remoteControl];
    [self updateStatusView];
}

/**
 获取当前的遥控码对象 key 后，发码逻辑请自己实现
 */
- (IBAction)powerOffAction:(id)sender {
//    YKRemoteDeviceKey *key = [YKRemoteDeviceKey remoteDeviceKeyInRemoteDevice:self.remote
//                                                                          key:KeyPowerOff];
    // TODO: 发送 key
}


/**
 获取当前的遥控码对象 key 后，发码逻辑请自己实现
 */
- (void)remoteControl {
//    YKRemoteDeviceKey *key = [YKRemoteDeviceKey remoteDeviceKeyIn:self.remote
//                                                         withMode:self.currentModel
//                                                             temp:self.temperature
//                                                            speed:self.currentSpeed
//                                                            windU:self.currentWindU
//                                                            windL:self.currentWindL
//                                                    asteriskDatas:self.asteriskDatas];
}

- (void)updateStatusView {
    // 空调只有在制冷、制热模式下才显示温度,温度才可调,其它模式,温度不显示
    if (([self.currentModel isEqualToString:@"r"]
         || [self.currentModel isEqualToString:@"h"])
        && _temperature != 0)
    {
        _tempLabel.text = [NSString stringWithFormat:@"%ld", (long)_temperature];
    }
    else {
        _tempLabel.text = @"--";
    }
    
    self.modelLabel.text = [self.modelKeyNames objectAtIndex:[self.modelKeys indexOfObject:self.currentModel]];
    
    if (_currentSpeed != INT_MAX) {
        self.windLabel.text = _currentSpeed==0?@"A":[NSString stringWithFormat:@"%lu", (unsigned long)_currentSpeed];
    }
    else {
        self.windLabel.text = @"";
    }
    
    if (_currentWindU != INT_MAX) {
        if (_currentWindU>1) {
            // +1个区间-(关闭和自动)，(u2是一档)
            self.sweepUDLabel.text = [NSString stringWithFormat:@"%ld 档", _currentWindU-1];
        } else if (_currentWindU == 1) {
            // auto mode
            self.sweepUDLabel.text = @"自动";
        } else {
            self.sweepUDLabel.text = @"--";
        }
    }
    else {
        self.sweepUDLabel.text = @"--";
    }
    
    if (_currentWindL != INT_MAX) {
        if (_currentWindL>1) {
            // +1个区间-(关闭和自动)，(l2是一档)
            self.sweepLRLabel.text = [NSString stringWithFormat:@"%ld 档", _currentWindL-1];
        } else if (_currentWindL == 1) {
            // auto mode
            self.sweepLRLabel.text = @"自动";
        } else {
            self.sweepLRLabel.text = @"--";
        }
    }
    else {
        self.sweepLRLabel.text = @"--";
    }
}

@end
