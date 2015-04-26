# LZXCommunication
快速实现 发短信，发邮件，打电话 功能，无需更多代码，一行足矣！

- v1.2
  完善了v1.0版本中打电话功能第三种方法（利用webView拨打电话）的缺陷------具体功能有待测试
  v1.*版本在此趋于稳定，v1.*版本不会大改

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
    如：[LZXCommunication messageToReceivers:@[@"10010", @"10086"] content:@"查询话费" delegateVc:self];
