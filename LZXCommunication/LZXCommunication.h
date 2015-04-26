//
//  LZXCommunication.h
//  网易彩票
//
//  Created by 刘泽祥 on 15/4/24.
//  Copyright (c) 2015年 刘泽祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD+MJ.h"

@interface LZXCommunication : NSObject

#pragma mark - 发短信

/**
 *  简单的打开短信应用，给指定号码发送邮件（不会返回原应用）
 *
 *  @param receiver 电话号码
 */
+ (void)messageToReceiver:(NSString *)receiver;

/**
 *  设置短信的具体内容（可返回原应用）
 *      依赖于<MessageUI/MessageUI.h>
 *      项目需要导入框架：MessageUI.framework
 *      依赖第三方框架：MBProgressHUD+MJ
 *
 *  @param receivers  收件人列表
 *  @param content    短信内容
 *  @param delegateVc 要发送短信的控制器，需要遵守协议：<MFMessageComposeViewControllerDelegate>
 *
 *  @return 短信是否发送成功
 */
+ (BOOL)messageToReceivers:(NSArray *)receivers content:(NSString *)content delegateVc:(UIViewController<MFMessageComposeViewControllerDelegate> *)delegateVc;


#pragma mark - 发邮件

/**
 *  简单的打开邮件应用，给指定地址发送邮件（不会返回原应用）
 *
 *  @param mailAddress 收件人
 */
+ (void)mailToReceiver:(NSString *)mailAddress;

/**
 *  可以设置邮件的主题等具体内容（可以返回原应用）
 *      依赖于<MessageUI/MessageUI.h>,
 *      项目需要导入框架：MessageUI.framework
 *      依赖第三方框架：MBProgressHUD+MJ
 *
 *  @param receivers      收件人列表
 *  @param copyers        抄送人列表
 *  @param secretors      密送人列表
 *  @param theme          主题
 *  @param content        邮件内容
 *  @param contentIsHTML  内容是否是HTML
 *  @param attachment     附件数据
 *  @param attachmentName 附件名称
 *  @param attachmentType 附件MIME类型（如：image/jpeg）
 *  @param delegateVc     要发送邮件的控制器,需要遵守协议：<MFMailComposeViewControllerDelegate>
 *
 *  @return 是否发送成功
 */
+ (BOOL)mailToReceivers:(NSArray *)receivers copyers:(NSArray *)copyers secretors:(NSArray *)secretors theme:(NSString *)theme content:(NSString *)content contentIsHTML:(BOOL)contentIsHTML attachment:(NSData *)attachment attachmentName:(NSString *)attachmentName attachmentType:(NSString *)attachmentType showInViewController:(UIViewController<MFMailComposeViewControllerDelegate> *)delegateVc;
#warning 需要导入框架：MessageUI.framework?

#pragma mark - 打电话

/**
 *  利用 tel 协议打电话（返回原应用：iOS8可用）
 *  在 iOS7 之前的系统中，通话结束后会停留在通话记录界面，iOS8 之后会返回当前应用
 *
 *  缺点：
        在 iOS7 之前系统中打完电话后不会自动返回到原应用，而是停留在通话记录界面
 *
 *  @param tel 电话号码
 */
+ (void)callToTel:(NSString *)tel;

/**
 *  利用 telprompt 协议打电话（返回原应用：越狱可用）
 *  通话结束后会返回当前应用
 *  使用了苹果的私有协议，审核可能不通过
 *  针对越狱的手机开发的 APP 可以使用此协议
 *
 *  缺点：
 *      由于该协议属于苹果的私有协议，所以审核可能不通过。
 *  @param tel 电话号码
 */
+ (void)callToTelUseCallprompt:(NSString *)tel;

/**
 
 */

/**
 *  利用 WebView 控件实现打电话功能（返回原应用：适用所有）
 *  通话结束后会返回当前应用,解决了iOS7以前的系统使用 tel 协议无法返回当前应用的问题
 *
 *  注意：
 *      要防止这个 WebView控件在添加到页面中后覆盖了页面的内容
 *
 *  @param tel 电话号码
 */
+ (void)callToTelUseWebView:(NSString *)tel;

@end
