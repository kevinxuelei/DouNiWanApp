//
//  DNWThirdCustomCell.h
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class DNWThirdData;

typedef void(^RealizeRepotrBlock)();
typedef void(^PassCollectBlock)();

typedef void(^myBlock)(void);


@interface DNWThirdCustomCell : UITableViewCell

@property (nonatomic,retain,readonly)UIImageView *backgroundImagesView;

@property (nonatomic,retain,readonly) UILabel * introduceLable;//介绍

@property (nonatomic,retain,readonly) UIImageView * picImageView;//图片

@property(nonatomic,retain,readonly) UIImageView *imageButtonView;//图片上按钮的图片按钮

@property (nonatomic,retain,readonly) UIButton *imageButton;//图片按钮

@property (nonatomic,retain,readonly)UIImageView *imageTView;

@property (nonatomic,retain,readonly) UILabel * timeLabel;//时间显示

@property (nonatomic,retain,readonly) UIButton * collectButton;//收藏按钮


@property (nonatomic,retain,readonly) UIButton * shareButton;//分享按钮


@property (nonatomic,retain)DNWThirdData *thirdData;
@property (nonatomic,copy)PassCollectBlock passCollectBlock;


//自适应高度
+ (CGFloat)cellHight:(DNWThirdData *)data;

@property (nonatomic,copy) myBlock block;

//block的实现
- (void)changBackGround:(myBlock)block;

@property (nonatomic,retain)UIButton    * reportButton;

/**
 *  collectBlock   实现点击举报
 */
@property (nonatomic,copy)RealizeRepotrBlock reportBlock;



@end
