//
//  DNWFirstCusomCell.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RealizeCollectBlock)();
typedef void(^RealizeRepotrBlock)();

@class DNWBottomLabelView;
@class DNWPaperData;
@interface DNWFirstCustomCell : UITableViewCell

/**
 *  profileImageView 发表人头像
 *  nameLabel        姓名
 *  passTimeLabel    发布时间
 *  collectButton    收藏
 *  paperTextLabel   段子文本
 *  praiseView       点赞
 *  hateView         讨厌
 *  shareView        分享
 *  discussView      评论
 *  lineImageView    虚线
 *  backImageView    背景
 *  reportButton     举报
 */
@property (nonatomic,retain,readonly)UIImageView * backImageView;
@property (nonatomic,retain,readonly)UIImageView * profileImageView;
@property (nonatomic,readonly,retain)UILabel     * nameLabel;
@property (nonatomic,retain,readonly)UILabel     * passTimeLabel;
@property (nonatomic,retain)UIButton    * collectButton;
@property (nonatomic,retain,readonly)UILabel     * paperTextLabel;
@property (nonatomic,retain,readonly)DNWBottomLabelView * praiseView;
@property (nonatomic,retain,readonly)DNWBottomLabelView * hateView;
@property (nonatomic,retain,readonly)DNWBottomLabelView * shareView;
@property (nonatomic,retain,readonly)DNWBottomLabelView * discussView;
@property (nonatomic,retain,readonly)UIImageView * lineImageView;
@property (nonatomic,retain)UIButton    * reportButton;

/**
 *  collectBlock   实现点击收藏
 */
@property (nonatomic,copy)RealizeCollectBlock collectBlock;

/**
 *  collectBlock   实现点击举报
 */
@property (nonatomic,copy)RealizeRepotrBlock reportBlock;


/**
 *  animationLabel  动画效果
 */
@property (nonatomic,retain)UILabel * animationLabel;

/**
 * paperData        段子数据对象
 */
@property (nonatomic,retain)DNWPaperData * paperData;

/**
 *  根据text长度自动调整cell高度
 *
 *  @param paperData 文本对象
 *
 *  @return cell新高度
 */
+(CGFloat)cellHeight:(DNWPaperData *)paperData;

/**
 *  赞一个或者贬一个动画
 *
 *  @param typeView 视图类型
 */
- (void)changeCountAnimation:(DNWBottomLabelView *)typeView;


@end













