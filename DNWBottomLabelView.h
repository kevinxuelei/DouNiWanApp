//
//  DNWBottomLabelView.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassValueBlock)();

@interface DNWBottomLabelView : UIView

@property (nonatomic,retain,readonly) UIImageView * labelImageView;  //  赞,贬,分享,评论图标
@property (nonatomic,readonly,retain) UILabel     * numberLabel;     //  ID
@property (nonatomic,retain)          UIButton    * clearButton;     //  按钮,响应点击
@property (nonatomic,copy) PassValueBlock passBlock;       //  block回调


@end
