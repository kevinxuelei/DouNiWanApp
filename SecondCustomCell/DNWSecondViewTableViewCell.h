//
//  DNWSecondViewTableViewCell.h
//  DouNiWan
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "DNWOneCellDataForSecondView.h"

typedef void(^RealizeRepotrBlock)();
typedef void(^PassAgreeBlock)();
typedef void(^PassDisAgreeBlock)();
typedef void(^PassShareBlock)();
typedef void(^PassDiscusseBlock)();
typedef void(^PassCollectionButtonBlock)();

@interface DNWSecondViewTableViewCell : UITableViewCell

@property (nonatomic,retain)UIImageView     *backImageView;
@property(nonatomic,retain)UIImageView  *iconView;
@property(nonatomic,retain)UILabel      *nameLabel;
@property(nonatomic,retain)UILabel      *timeLabel;
@property(nonatomic,retain)UILabel      *titleLabel;
@property (nonatomic,retain)UIButton    *collectionButton;
@property(nonatomic,retain)UIImageView  *mainImageView;
@property (nonatomic,retain)UIImageView *lineImageView;

@property(nonatomic,retain)CustomButton *agreeButton;
@property(nonatomic,retain)CustomButton *disagreeButton;
@property(nonatomic,retain)CustomButton *shareButton;
@property(nonatomic,retain)CustomButton *discussButton;

@property (nonatomic,copy) PassAgreeBlock    agreeBlock;       //  block回调
@property (nonatomic,copy) PassDisAgreeBlock disAgreeBlock;    //  block回调
@property (nonatomic,copy) PassShareBlock    shareBlock;       //  block回调
@property (nonatomic,copy) PassDiscusseBlock discusseBlock;    //  block回调
@property (nonatomic,copy) PassCollectionButtonBlock collectionBlock;//block回调
@property(nonatomic,assign)SEL action;
@property(nonatomic,assign)id target;

@property (nonatomic,retain)UIButton    * reportButton;  // 举报

@property (nonatomic,retain)UILabel * animationLabel;//添加动画

@property (nonatomic,copy)RealizeRepotrBlock reportBlock;


-(void)initWith:(DNWOneCellDataForSecondView*)celldata;
+ (CGFloat)returnRowHighWith:(DNWOneCellDataForSecondView*)celldata;
- (void)changeCountAnimation:(CustomButton *)typeView;//动画方法

//+(CGFloat)DNWSecondViewTableViewCellReturnRowHighWith:(DNWOneCellDataForSecondView*)celldata;

@end
