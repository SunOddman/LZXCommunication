//
//  LZXCommunication.m
//  网易彩票
//
//  Created by 刘泽祥 on 15/4/24.
//  Copyright (c) 2015年 刘泽祥. All rights reserved.
//

#import "LZXCommunication.h"

#import <objc/runtime.h>

@implementation LZXCommunication

#pragma mark - 发短信

+ (void)messageToReceiver:(NSString *)receiver {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", receiver]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)messageToReceivers:(NSArray *)receivers content:(NSString *)content delegateVc:(UIViewController *)delegateVc {
    
    NSAssert(delegateVc, @"必须传入有效的调用该方法的控制器");
    
    // 1. 判断用户设备能否发送短信
    if (![MFMessageComposeViewController canSendText]) {
        // 发送失败 用户设备无法发送短信
        return NO;
    }
    
    // 2. 实例化短信控制器
    MFMessageComposeViewController *messageVc = [MFMessageComposeViewController new];
    
    // 3. 设置短信内容
    
    // 设置收件人
    [messageVc setRecipients:receivers];
    // 设置短信内容
    [messageVc setBody:content];
    
    // 4. 设置代理
    messageVc.messageComposeDelegate = (UIViewController<MFMessageComposeViewControllerDelegate> *)delegateVc;
    
    // 5. 显示短信控制器
    [delegateVc presentViewController:messageVc animated:YES completion:^{
        
        // 设置delegateVc 中短信控制器关闭的代理方法回调
        
        // 代理控制器的回调方法
        Method delegateCallBackMethod = class_getInstanceMethod([delegateVc class], @selector(messageComposeViewController:didFinishWithResult:));
        
        // 工具类中回调方法实现
        Method implementationMethod = class_getInstanceMethod(self, @selector(messageComposeViewController:didFinishWithResult:));
        IMP implementation = method_getImplementation(implementationMethod);
        
        // 设置控制器中的回调方法实现
        
        // 如果没有代理方法，那么就动态添加
        if (!delegateCallBackMethod) {
            class_addMethod([delegateVc class], @selector(messageComposeViewController:didFinishWithResult:), implementation, "v@:@i");
        } else {
        // 如果有代理方法，则替换其实现
            method_setImplementation(delegateCallBackMethod, implementation);
        }
        
    }];
    
    return YES;
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    /**
     MessageComposeResultCancelled,     取消
     MessageComposeResultSent,          发送
     MessageComposeResultFailed         失败
     */
    
    NSString *resultAlert; // 操作结果提示
    switch (result) {
        case MessageComposeResultCancelled:
            // 取消
            resultAlert = @"取消发送";
            break;
        case MessageComposeResultSent:
            // 已经发送
            resultAlert = @"发送成功";
            break;
        case MessageComposeResultFailed:
            // 已经失败
            resultAlert = @"发送失败";
            break;
            
        default:
            break;
    }
    
    // 提示操作结果
    MBProgressHUD *alert = [MBProgressHUD showMessage:resultAlert];
    // 0.5m后移除提示
    [alert hide:YES afterDelay:1.0];
    
    
    // 关闭窗口
    //[self performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:@(YES) withObject:nil]; // 这种做法不可行，YES包装成对象后会变成一个很大的数字
    //    [self dismissViewControllerAnimated:YES completion:nil]; // 在当前工具类中无法调用无法调用（如果下面的方法不可行，那么可以尝试在工具类中声明一个这个方法，不用写实现。因为这里写的 mailComposeController:didFinishWithResult: 方法的实现将来会复制到delegateVc中，调用的实际上会是delegateVc的 mailComposeController:didFinishWithResult: 方法）
    [controller dismissViewControllerAnimated:YES completion:nil]; // 这种方法也是可以的，因为系统会将关闭消息发送回给self
}

#pragma mark - 发邮件

+ (void)mailToReceiver:(NSString *)mailAddress {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", mailAddress]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)mailToReceivers:(NSArray *)receivers copyers:(NSArray *)copyers secretors:(NSArray *)secretors theme:(NSString *)theme content:(NSString *)content contentIsHTML:(BOOL)contentIsHTML attachment:(NSData *)attachment attachmentName:(NSString *)attachmentName attachmentType:(NSString *)attachmentType showInViewController:(UIViewController *)delegateVc {
    
    NSAssert(delegateVc, @"必须传入有效的调用该方法的控制器！");
    
    // 1. 判断是否能发邮件
    if (![MFMailComposeViewController canSendMail]) {
        // 发送失败  提示用户检查邮箱设置
        return NO;
    }
    
    // 2. 实例化邮件控制器
    MFMailComposeViewController *mailVc = [MFMailComposeViewController new];
    
    // 3. 设置邮件内容
    
    // 设置收件人列表
    [mailVc setToRecipients:receivers];
    // 设置抄送人列表
    [mailVc setCcRecipients:copyers];
    // 设置密送人列表
    [mailVc setBccRecipients:secretors];
    
    // 设置邮件主题
    [mailVc setSubject:theme];
    // 设置邮件内容
    [mailVc setMessageBody:content isHTML:contentIsHTML];
    // 设置邮件附件
    [mailVc addAttachmentData:attachment mimeType:attachmentType fileName:attachmentName];
    
    
    
    // 4. 设置代理
    
    mailVc.mailComposeDelegate  = (UIViewController<MFMailComposeViewControllerDelegate> *)delegateVc;
    
    // 5. 显示邮件控制器
    [delegateVc presentViewController:mailVc animated:YES completion:^{
        
        
        // 设置delegateVc中邮件控制器关闭的代理方法回调
        
        
        // 代理控制器的回调方法
        Method delegateCallBackMethod = class_getInstanceMethod([delegateVc class], @selector(mailComposeController:didFinishWithResult:error:));
        
        // 工具类中的回调方法实现
        Method implementationMethod = class_getInstanceMethod(self, @selector(mailComposeController:didFinishWithResult:error:));
        IMP implementation = method_getImplementation(implementationMethod);
        
        // 设置代理控制器中回调方法的实现
        
        // 如果没有代理方法，那么就动态添加
        if (!delegateCallBackMethod) {
            class_addMethod([delegateVc class], @selector(mailComposeController:didFinishWithResult:error:), implementation, "v@:@i@");
        } else {
        // 如果有代理方法，则替换其实现
            method_setImplementation(delegateCallBackMethod, implementation);
        }
        
    }];
    
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    /**
     MFMailComposeResultCancelled,      取消
     MFMailComposeResultSaved,          保存邮件
     MFMailComposeResultSent,           已经发送
     MFMailComposeResultFailed          发送失败
     */
    NSString *resultAlert; // 操作结果提示
    switch (result) {
        case MFMailComposeResultCancelled:
            // 取消
            resultAlert = @"取消发送";
            break;
        case MFMailComposeResultSaved:
            // 保存邮件
            resultAlert = @"邮件已保存到草稿箱";
            break;
        case MFMailComposeResultSent:
            // 已经发送
            resultAlert = @"邮件已发送";
            break;
        case MFMailComposeResultFailed:
            // 发送失败
            resultAlert = @"邮件发送失败";
            break;
            
        default:
            break;
    }
    
    // 提示操作结果
    MBProgressHUD *alert = [MBProgressHUD showMessage:resultAlert];
    // 1.0m后移除提示
    [alert hide:YES afterDelay:1.0];
    
    // 关闭窗口
    //[self performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:@(YES) withObject:nil]; // 这种做法不可行，YES包装成对象后会变成一个很大的数字
    //    [self dismissViewControllerAnimated:YES completion:nil]; // 在当前工具类中无法调用无法调用（如果下面的方法不可行，那么可以尝试在工具类中声明一个这个方法，不用写实现。因为这里写的 mailComposeController:didFinishWithResult: 方法的实现将来会复制到delegateVc中，调用的实际上会是delegateVc的 mailComposeController:didFinishWithResult: 方法）
    [controller dismissViewControllerAnimated:YES completion:nil]; // 这种方法也是可以的，因为系统会将关闭消息发送回给self
}

#pragma mark - 打电话

+ (void)callToTel:(NSString *)tel {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]];
    
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)callToTelUseCallprompt:(NSString *)tel {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", tel]];
    
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)callToTelUseWebView:(NSString *)tel {
#warning 这里试试是否可以不将webView添加到页面中
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}


@end
