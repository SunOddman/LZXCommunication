# [LZXCommunication](https://github.com/SunOddman/LZXCommunication)
快速实现 发短信，发邮件，打电话 功能，无需更多代码，一行足矣!

## Usage

  ### 注意： 需要导入系统框架：MessageUI.framework
  
  项目中添加工具类： LZXCommunication.h & LZXCommunication
  
  导入 LZXCommunication.h

  调用如下类方法实现响应功能：
  
### 打电话

    #### 拨打电话（通用）
    ``` objc
    /**
    *  利用 WebView 控件实现打电话功能（返回原应用：适用所有）
    *  通话结束后会返回当前应用,解决了iOS7以前的系统使用 tel 协议无法返回当前应用的问题
    *
    *  注意：
    *      要防止这个 WebView控件在添加到页面中后覆盖了页面的内容
    *
    *  @param tel 电话号码
    */
    + (void)callToTelUseWebView:(NSString *)tel inViewController:(UIViewController *)targetVc;
    ```

    #### 拨打电话（仅限iOS8.0之后使用）
    ``` objc
    /**
    *  利用 tel 协议打电话（返回原应用：iOS8可用）
    *  在 iOS7 之前的系统中，通话结束后会停留在通话记录界面，iOS8 之后会返回当前应用
    *
    *  注意：
       在 iOS7 之前系统中打完电话后不会自动返回到原应用，而是停留在通话记录界面
    *
    *  @param tel 电话号码
    */
    + (void)callToTel:(NSString *)tel NS_AVAILABLE_IOS(8_0);
    ```

    #### 拨打电话（仅越狱可用）
    ``` objc
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
    ```

### 发短信

    #### 发短信：仅指定收件人
    ``` objc
    /**
    *  简单的打开短信应用，给指定号码发送邮件（不会返回原应用）
    *
    *  @param receiver 电话号码
    */
    + (void)messageToReceiver:(NSString *)receiver;
    ```

    #### 发短信：设置详细短信内容支持群发功能
    ``` objc
    /**
    *  设置短信的具体内容（可返回原应用）
    *      依赖于<MessageUI/MessageUI.h>
    *      项目需要导入框架：MessageUI.framework
    *      依赖第三方框架：MBProgressHUD+MJ
    *
    *  @param receivers  收件人列表
    *  @param content    短信内容
    *  @param delegateVc 要发送短信的控制器
    *
    *  @return 短信是否发送成功
    */
    + (BOOL)messageToReceivers:(NSArray *)receivers content:(NSString *)content delegateVc:(UIViewController *)delegateVc;
    ```

### 发邮件

    #### 发邮件：仅指定收件人
    ``` objc
    /**
    *  简单的打开邮件应用，给指定地址发送邮件（不会返回原应用）
    *
    *  @param mailAddress 收件人
    */
    + (void)mailToReceiver:(NSString *)mailAddress;
    ```

    #### 发邮件：设置详细邮件内容，支持群发功能
    ``` objc
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
    *  @param delegateVc     要发送邮件的控制器
    *
    *  @return 是否发送成功
    */
    + (BOOL)mailToReceivers:(NSArray *)receivers copyers:(NSArray *)copyers secretors:(NSArray *)secretors theme:(NSString *)theme content:(NSString *)content contentIsHTML:(BOOL)contentIsHTML attachment:(NSData *)attachment attachmentName:(NSString *)attachmentName attachmentType:(NSString *)attachmentType showInViewController:(UIViewController *)delegateVc;
    ```

## Version
- v1.3
  1. 将提示的第三方框架改为SVProgressHUD
  2. 增加了对iOS8.0之前调用callToTel:方法的判断

- v1.2
  完善了v1.0版本中打电话功能第三种方法（利用webView拨打电话）的缺陷
  至此，基本功能全部实现！

- v1.1
  1. 修改了 Communication工具类，现在不要求调用控制器必须遵守协议，以及实现协议内方法了。

- v1.0
  1. (已废弃)需要在调用的控制器内遵守协议：<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
  2. (已废弃)需要实现协议方法：
    - (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // 只需实现代理方法，不用写具体操作
    }

    - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    // 只需实现代理方法，不用写具体实现
    }
  3. 一行调用（目前打电话的第三种方式功能尚不完善）
    如：
    ``` objective-c
    [LZXCommunication messageToReceivers:@[@"10010", @"10086"] content:@"查询话费" delegateVc:self];
    ```
    即可实现给10010和10086发送内容为“查询话费”的短信