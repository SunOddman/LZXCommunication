# LZXCommunication
快速实现 发短信，发邮件，打电话 功能，无需更多代码，一行足矣！

- v1.0
  1. 需要在调用的控制器内遵守协议：<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
  2. 需要实现协议方法：
    - (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // 只需实现代理方法，不用写具体操作
    }

    - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    // 只需实现代理方法，不用写具体实现
    }
  3. 一行调用（目前打电话的第三种方式功能尚不完善）
    如：[LZXCommunication messageToReceivers:@[@"10010", @"10086"] content:@"查询话费" delegateVc:self];
