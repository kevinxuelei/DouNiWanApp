//
//  DNWPaperData.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNWPaperData : NSObject

/**
 *  hostId            楼主ID
 *  hostImage         楼主头像图片对象
 *  hostImageUrl      楼主头像
 *  hostName          楼主姓名
 *  passTime          发布时间
 *  paperText         发布的内容
 *  favouriteNumber   点赞次数
 *  hateNumber        讨厌次数
 *  shareNumber       分享次数
 *  discussNumber     评论次数
 *  commentUrl        内容和评论链接
 */
@property (nonatomic,copy)    NSString * hostId;
@property (nonatomic ,retain) UIImage  * hostImage;
@property (nonatomic,copy)    NSString * hostImageUrl;
@property (nonatomic,copy)    NSString * hostName;
@property (nonatomic,copy)    NSString * passTime;
@property (nonatomic,copy)    NSString * paperText;
@property (nonatomic,copy)    NSString * favouriteNumber;
@property (nonatomic,copy)    NSString * hateNumber;
@property (nonatomic,copy)    NSString * shareNumber;
@property (nonatomic,copy)    NSString * discussNumber;
@property (nonatomic,copy)    NSString * commentUrl;
@property (nonatomic,assign)  BOOL       isLoveOrHate;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
