//
//  YKMatchKeyTableViewController.m
//  YKSDKDemo
//
//  Created by Don on 2017/1/17.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKMatchKeyTableViewController.h"
#import <YKSDK/YKSDK.h>
#import "YKCommon.h"

@interface YKMatchKeyTableViewController ()

@end

@implementation YKMatchKeyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@-%@",
                  self.matchDevice.name, self.matchDevice.rmodel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchDevice.matchKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKRemoteMatchKeyIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteMatchDeviceKey *key = self.matchDevice.matchKeys[indexPath.row];
    cell.textLabel.text = key.kn;
    cell.detailTextLabel.text = key.shortCMD;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YKRemoteMatchDeviceKey *key = self.matchDevice.matchKeys[indexPath.row];
    NSLog(@"发送%@=%@", key.key, key.src);
}

- (IBAction)save:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [YKSDK fetchRemoteDeivceWithYKCId:[[YKCommon sharedInstance] currentYKCId]
                             remoteDeviceId:self.matchDevice.rid
                                 completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error)
     {
         if (error == nil) {
             [weakSelf.navigationController.presentingViewController
              dismissViewControllerAnimated:YES completion:nil];
         } else {
             NSLog(@"%s error:%@", __PRETTY_FUNCTION__, error.localizedDescription);
         }
     }];
}

@end
