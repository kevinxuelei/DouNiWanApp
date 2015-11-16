//
//  DNWSwitchTableViewCell.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-17.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShakeToChangeModal)(void);
typedef void(^CancelToChangeModal)(void);

@interface DNWSettingTableViewCell : UITableViewCell

@property (nonatomic,retain,readonly) UIImageView * backImageView;
@property (nonatomic,retain,readonly) UIImageView * iconImageView;
@property (nonatomic,retain,readonly) UILabel     * contentLabel;
@property (nonatomic,retain)UISwitch * switchButton;

@property (nonatomic,copy)ShakeToChangeModal shakeToChangeModal;
@property (nonatomic,copy)CancelToChangeModal cancelToChangeModal;


@end
