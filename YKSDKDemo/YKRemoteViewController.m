//
//  YKRemoteViewController.m
//  YKSDKDemo
//
//  Created by Don on 2017/1/19.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKRemoteViewController.h"
#import <YKSDK/YKSDK.h>

@interface YKRemoteViewController ()

@end

@implementation YKRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.remote.name;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remote.keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKRemoteCellIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteDeviceKey *key = self.remote.keys[indexPath.row];
    cell.textLabel.text = key.key;
    cell.detailTextLabel.text = key.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YKRemoteDeviceKey *key = self.remote.keys[indexPath.row];
    NSLog(@"%@ = %@, zip=%d", key.name, key.src, key.zip);
}

- (IBAction)showActions:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择"
                                                                message:nil
                                                         preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *exportJson = [UIAlertAction actionWithTitle:@"导出json"
                                                         style:(UIAlertActionStyleDefault)
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     __weak __typeof(weakSelf)strongSelf = weakSelf;
                                     NSDictionary *dict = [strongSelf.remote toJsonObject];
                                     [strongSelf showJson:dict];
                                 }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:(UIAlertActionStyleCancel)
                                                   handler:nil];
    [ac addAction:exportJson];
    [ac addAction:cancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showJson:(NSDictionary *)dict{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Json"
                                                                message:dict.description
                                                         preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭"
                                                     style:(UIAlertActionStyleCancel)
                                                   handler:nil];
    
    UIAlertAction *import = [UIAlertAction actionWithTitle:@"导入"
                                                     style:(UIAlertActionStyleDefault)
                                                   handler:^(UIAlertAction * _Nonnull action)
                             {
                                 
                                 [YKRemoteDevice saveRemoteDeviceWithDictionary:dict];
                                 
                             }];
    
    [ac addAction:cancel];
    [ac addAction:import];
    [self presentViewController:ac animated:YES completion:nil];
}


@end
