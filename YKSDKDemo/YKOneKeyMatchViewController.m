//
//  YKOneKeyMatchViewController.m
//  YKSDKDemo
//
//  Created by Don on 2017/10/25.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKOneKeyMatchViewController.h"
#import <YKSDK/YKSDK.h>
#import "YKCommon.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "YKMatchKeyTableViewController.h"

// 测试演示数据：康佳电视机，真实数据请使用SDK返回的
static NSString * const TV_TID = @"2";   // 设备类型
static NSString * const TV_BID = @"426"; // 设备品牌
// 康佳电视机电源键
static NSString * const TV_POWER_CODE = @"iNJ0HC696TupFe+iM1HgaxaILEiGAf3mC0y6wvBcd3BAMmr+WlKguK5eWwJZ9MDyS9k2/5UbB8aLdPNHEkr/65vwwUeFo6VHBThGQG9FZPpOPz2JKrY2F5g/S93Exs5efsqjky/CVG7L9vzapJ55cdH8D0Jm5ZHlc3QYanj9q1EbTSQAv0Wc7VoYvzT1PTIUUDJi4hXTUuPLpvQui7Awvg==";
//康佳电视机信号源键
static NSString * const TV_SIGNAL_CODE = @"GI+tAUXYamhCzXBINv7VFMMPNIHrPVnS+WaQWCuzBrud53M+9u5C5OLNG9f7eMyt1oJIZtOXlpMALD2HPTknIFNPHJgSc1UruY6FREIVjdl0JSMvaRgXBz62LkQYmY8IcVf0yNQdZvWIo1HTwzOlAjo2KgHAg+1axVznMADAhkznHlfTcTb9hmwHpPM0+LtretMhlpX9UzNJ0FNMhn9Q2EpkEnSsDpIsFX7tJz2XxERV6op4c+e2jSVC6OVDl3lGmYl/+sAciMXF+E3U4KP+jioiRwCXPCDpnwOzIT47rO3Ba4y0yuGqTHhRuSXT4bfQ";

@interface YKOneKeyMatchViewController ()
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) UIAlertController *ac;
@property (nonatomic, copy) NSString *matchKey;
@property (nonatomic, strong) NSArray <YKRemoteMatchDevice *> *devices;

@end

@implementation YKOneKeyMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFirstMatchKey];
    [self retryAction:nil];
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[YKMatchKeyTableViewController class]]) {
//        YKMatchKeyTableViewController *vc = segue.destinationViewController;
//        YKRemoteMatchDevice *device = sender;
//
//        vc.matchDevice = device;
//    }
//}

- (void)showMatchKeyTableViewController:(YKRemoteMatchDevice *)device {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Remote" bundle:nil];
    
    YKMatchKeyTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"YKMatchKeyTableViewController"];
    vc.matchDevice = device;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resetFirstMatchKey {
    if (self.deviceType.tid.integerValue == kDeviceACType) {
        self.matchKey = @"on";
    }
    else if (self.deviceType.tid.integerValue == kDeviceCarAudioType) {
        self.matchKey = @"ok";
    }
    else {
        self.matchKey = @"power";
    }
}

- (void)showAlert:(NSString *)message isLoading:(BOOL)loading {
    if (self.ac == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
        self.ac = ac;
    }
    
    self.ac.message = message;
    
    if (self.ac.presentingViewController != self.navigationController) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK"
                                                         style:(UIAlertActionStyleCancel)
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           self.ac = nil;
                                                       }];
        [self.ac addAction:cancel];
        [self presentViewController:self.ac animated:YES completion:nil];
    }
}

- (void)hideAlert {
    [self dismissViewControllerAnimated:YES completion:^{
        self.ac = nil;
    }];
}

- (IBAction)retryAction:(id)sender {
    NSString *ykcId = [[YKCommon sharedInstance] currentYKCId];
    __weak __typeof(self)weakSelf = self;
    
    NSString *message = [NSString stringWithFormat:@"开始匹配，请发送%@", self.matchKey];
    [self showAlert:message isLoading:YES];
    // 以下功能自己实现，注释仅参考
//    [YKSDK learnCodeWithYKCId:ykcId completion:^(BOOL result, NSString * _Nullable code) {
//        NSLog(@"code = %@", code);
//
//        if (code.length == 0) {
//            return;
//        }
//
//        [self showAlert:@"正在匹配" isLoading:YES];
//        [weakSelf requestOnekeyMatchWith:code];
//    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAlert:@"正在匹配" isLoading:YES];
        if ([self.matchKey isEqualToString:@"power"]) {
            [self requestOnekeyMatchWith:TV_POWER_CODE];
        }
        else {
            [self requestOnekeyMatchWith:TV_SIGNAL_CODE];
        }
    });
}

- (void)requestOnekeyMatchWith:(NSString *)cmd {
    if (cmd.length == 0) {
        return;
    }
    
    [YKSDK oneKeyMatchWithYKCId:[[YKCommon sharedInstance] currentYKCId]
                   beRemoteType:self.deviceType.tid.integerValue
                        brandId:self.deviceBrand.bid
                        cmd_key:self.matchKey
                      cmd_value:cmd
                     completion:^(id _Nonnull result, NSError * _Nonnull error)
     {
         NSLog(@"result = %@, error=%@", result, error);
         
         if ([result isKindOfClass:[NSArray class]] && [result count] > 0) {
             [self hideAlert];
             [self showTestView:[self parseResult:result]];
         }
         else if (result[@"errorMsg"]) {
             NSString *errorMsg = result[@"errorMsg"];
             NSLog(@"errorMsg:%@", errorMsg);
             [self resetFirstMatchKey];
             NSString *message = [NSString stringWithFormat:@"匹配结果：%@\nerrorMsg=%@", result, errorMsg];
             [self showAlert:message isLoading:NO];
         } else if (result[@"next_cmp_key"]) {
             self.matchKey = result[@"next_cmp_key"];
             NSString *message = [NSString stringWithFormat:@"请点击右上角按钮，开始匹配下一个键：%@",
                                  self.matchKey];
             [self showAlert:message isLoading:NO];
//             [self retryAction:nil];
//             [self hideAlert];
         } else if (result[@"rs"]) {
             [self hideAlert];
             [self showTestView:[self parseResult:result[@"rs"]]];
         } else {
             [self showAlert:error.localizedDescription isLoading:NO];
         }
         
     }];
}

- (NSArray <YKRemoteMatchDevice *> *)parseResult:(NSArray *)array {
    NSMutableArray <YKRemoteMatchDevice *> *devices = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *deviceDict in array) {
        YKRemoteMatchDevice *device = [[YKRemoteMatchDevice alloc] init];
        device.name = deviceDict[@"name"];
        //    device.model = deviceDict[@"be_rmodel"];
        device.rid = deviceDict[@"rid"];
        device.rmodel = deviceDict[@"rmodel"];
        //    device.typeId = typeId;
        
        NSMutableArray *keys = [NSMutableArray array];
        NSDictionary *keysDict = deviceDict[@"rc_command"];
        for (NSString *key in keysDict.allKeys) {
            NSDictionary *keyDict = keysDict[key];
            YKRemoteMatchDeviceKey *deviceKey = [YKRemoteMatchDeviceKey new];
            //        deviceKey.shortCMD = keyDict[@"short"];
            deviceKey.src = keyDict[@"src"];
            //        deviceKey.tip = keyDict[@"tip"];
            deviceKey.kn = key;
            deviceKey.key = key;
            deviceKey.zip = [deviceDict[@"zip"] integerValue];
            //        deviceKey.order = [deviceDict[@"order"] integerValue];
            [keys addObject:deviceKey];
        }
        
        device.matchKeys = keys;
        [devices addObject:device];
    }
    
    return devices;
}

- (void)showTestView:(NSArray <YKRemoteMatchDevice *> *)devices {
    if (devices.count == 1) {
        [self showMatchKeyTableViewController:devices.firstObject];
    }
    else if (devices.count > 1) {
        self.devices = devices;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneKeyMatchCellIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteMatchDevice *device = self.devices[indexPath.row];
    
    cell.textLabel.text = device.name;//[device.name stringByAppendingFormat:@"-%@", device.rmodel];
    cell.detailTextLabel.text = device.rmodel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YKRemoteMatchDevice *device = self.devices[indexPath.row];
//    [self performSegueWithIdentifier:@"showTestSegue" sender:device];
    [self showMatchKeyTableViewController:device];
}

@end
