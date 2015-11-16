//
//  DNWPersonCenterViewController.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-15.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DNWPersonCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

/**
 *   userInfo   平台用户协议对象
 *   shareType  登录的平台类型
 */
@property(nonatomic,assign) id<ISSPlatformUser> userInfo;
@property(nonatomic,assign) ShareType shareType;

@end
