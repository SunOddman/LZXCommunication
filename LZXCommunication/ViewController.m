//
//  ViewController.m
//  LZXCommunication
//
//  Created by 刘泽祥 on 15/4/26.
//  Copyright (c) 2015年 刘泽祥. All rights reserved.
//

#import "ViewController.h"

#import "LZXCommunication.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.callIssueWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    UIWebView *aa = self.callIssueWebView;
    NSLog(@"%@", aa);
}

#pragma mark - 调用工具类

// 在触摸事件中调用方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 发短信
//    [self sendEmail1];
//    [self sendEmail2];
    
    // 发邮件
//    [self sendMessage1];
//    [self sendMessage2];
    
    // 打电话
//    [self call1];
//    [self call2];
    [self call3];
    
}

#pragma mark - 调用工具类

// 发短信
- (void)sendMessage1 {
    [LZXCommunication messageToReceiver:@"10010"];
}

- (void)sendMessage2 {
    [LZXCommunication messageToReceivers:@[@"10010", @"10086"] content:@"查询话费" delegateVc:self];
}

// 发邮件
- (void)sendEmail1 {
    [LZXCommunication mailToReceiver:@"hello@icloud.com"];
}

- (void)sendEmail2 {
    NSData *attachmentData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SunOddman" ofType:@"jpg"]];
    
    [LZXCommunication mailToReceivers:@[@"marry@qq.com", @"jack@qq.com"] copyers:@[@"tom@qq.com", @"bob@qq.com"] secretors:@[@"john@qq.com", @"gousheng@qq.com"] theme:@"周末请你吃饭" content:@"周末有空不，请你吃饭" contentIsHTML:NO attachment:attachmentData attachmentName:@"SunOddman" attachmentType:@"image/jpg" showInViewController:self];
}

// 打电话
- (void)call1 {
    // iOS8之后功能正常
    [LZXCommunication callToTel:@"10086"];
}

- (void)call2 {
    // 越狱可用
    [LZXCommunication callToTelUseCallprompt:@"10086" ];
}

- (void)call3 {
    // 这个方法功能需要测试
    [LZXCommunication callToTelUseWebView:@"10086" inViewController:self];
}


@end
