//
//  DNWThirdCustomCell.m
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWThirdCustomCell.h"

#import "DNWThirdVideoSubclassViewController.h"
#import "DNWThirdVideoViewController.h"
#import "DNWAllDataHandle.h"
#import "DNWThirdData.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "DNWCollectDataHandle.h"


#define backgroundImagesView_x  5
#define backgroundImagesView_Y  5
#define backgroundImagesView_Width 310
#define backgroundImagesView_Hight 400


//#define IntroduceLabel_MarginX 10
#define IntroduceLabel_MarginY 5
#define IntroduceLabel_Width   290
#define IntroduceLabel_Hight   50

#define PicImageView_MarginX   90
#define PicImageView_MarginY   60
#define PicImageView_Width     140
#define PicImageView_Hight     110

#define TimeLabel_MarginLeft   5
#define TimeLabel_MarginY      170
#define TimeLabel_Width        100
#define TimeLabel_Height       30

#define Button_Width           50
#define Button_Height          30


@implementation DNWThirdCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubviews];
       
    }
    return self;
}
#pragma mark-------重写ThirdData的set方法--------
/**
 *  重写set方法实现自适应高度
 *  自适应高度的实现
 *
 *  @param thirdData setThirdData
 *  @param thirdData cellHight
 */
- (void)setThirdData:(DNWThirdData *)thirdData
{
    if (_thirdData!=thirdData) {
        
        [_thirdData release];
        _thirdData = [thirdData retain];
    }
    _introduceLable.text = thirdData.title;
    _timeLabel.text = thirdData.timeStr;
    _thirdData = thirdData;
    [_picImageView setImageWithURL:[NSURL URLWithString:thirdData.pic] placeholderImage:nil];
 
    CGSize size = CGSizeMake(_introduceLable.bounds.size.width, 2000);
    
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] ;
    
    CGRect textRect = [thirdData.title boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    
    CGRect introduceLabelRect = _introduceLable.frame;
    introduceLabelRect.size.height = textRect.size.height;
    
    
   //自定义后得到的frame值
    _introduceLable.frame = introduceLabelRect;
    _backgroundImagesView.frame = CGRectMake(5, 5, 310, _introduceLable.frame.size.height+PicImageView_Hight+TimeLabel_Height+10);
    _imageButton.frame = CGRectMake(PicImageView_MarginX, _introduceLable.frame.size.height+10, PicImageView_Width, PicImageView_Hight);
    
    _picImageView.frame = CGRectMake(0, 0,PicImageView_Width, PicImageView_Hight);
    
    _imageTView.frame = CGRectMake(10, _introduceLable.frame.size.height+PicImageView_Hight+8,290, 2);
    _timeLabel.frame = CGRectMake(10, _introduceLable.frame.size.height+PicImageView_Hight+10, TimeLabel_Width, TimeLabel_Height);
    
    _reportButton.frame = CGRectMake(PicImageView_Hight+15, _introduceLable.frame.size.height+PicImageView_Hight+10+5, 40, 20);
    
    _collectButton.frame = CGRectMake(PicImageView_Hight+15+75, _introduceLable.frame.size.height+PicImageView_Hight+10+5, 20, 20);
    
    _shareButton.frame = CGRectMake(PicImageView_Hight+Button_Width*2+15 + 25, _introduceLable.frame.size.height+PicImageView_Hight+10+5, 20, 20);
    
    
}

#pragma mark-------自定义高度--------
+ (CGFloat)cellHight:(DNWThirdData *)data
{
    
    
    CGSize size = CGSizeMake(IntroduceLabel_Width, 20000);
    
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil];
    
    CGRect textRect = [data.title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    
    return textRect.size.height+PicImageView_Hight+Button_Height+20;
    
}


#pragma mark-------初始化在cell上显示视图--------
- (void)createSubviews
{
    CGFloat px = backgroundImagesView_x;
	CGFloat py = backgroundImagesView_Y;
	CGFloat pw = backgroundImagesView_Width;
    CGFloat ph = backgroundImagesView_Hight;
    
    
    _backgroundImagesView = [[UIImageView alloc] init];
    _backgroundImagesView.image = [UIImage imageNamed:@"bj"];
    _backgroundImagesView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backgroundImagesView];
    [_backgroundImagesView release];
    
    px = px+5;
    py = IntroduceLabel_MarginY;
    pw = IntroduceLabel_Width;
    ph = IntroduceLabel_Hight;
    _introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(px, py, pw, ph)];
    _introduceLable.font = [UIFont systemFontOfSize:15.0];
    _introduceLable.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1.0];
    _introduceLable.textAlignment =   NSTextAlignmentCenter;
    _introduceLable.numberOfLines = 0;
    _introduceLable.lineBreakMode =  NSLineBreakByTruncatingMiddle;
	[_backgroundImagesView addSubview:_introduceLable];
	[_introduceLable release];
    
    px = PicImageView_MarginX;
    py = ph;
    pw = PicImageView_Width;
    ph = PicImageView_Hight;
    
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageButton.frame = CGRectMake(px, py, pw, ph);
    [_imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backgroundImagesView addSubview:_imageButton];
    //_imageButton.backgroundColor = [UIColor purpleColor];
    [_imageButton addTarget:self action:@selector(didClickImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    _picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pw, ph)];
    [_imageButton addSubview:_picImageView];
    [_picImageView release];
    _imageButtonView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"splay"]];
    _imageButtonView.frame =CGRectMake(_picImageView.bounds.size.width/2-20, _picImageView.bounds.size.height/2-20, 40, 40);
    [_picImageView addSubview:_imageButtonView];
    
    [_imageButtonView release];
    
    
    
    px = TimeLabel_MarginLeft;
    py = PicImageView_Hight+IntroduceLabel_Hight;
    pw = TimeLabel_Width;
    ph = TimeLabel_Height;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(px, py, pw, ph)];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    [_backgroundImagesView addSubview:_timeLabel];
    [_timeLabel release];
    
#pragma mark 举报Button
    self.reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [_reportButton setTitleColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_reportButton addTarget:self action:@selector(didClickReportButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImagesView addSubview:_reportButton];

    
    px = px+pw;
    py =py;
    pw = Button_Width;
    ph = Button_Height;
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(px+5, py+5, 20, 20);
    [_collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
    [_backgroundImagesView addSubview:_collectButton];
    [_collectButton addTarget:self action:@selector(didClickCollectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    px = px+Button_Width;
    py = py;
    pw = Button_Width;
    ph = Button_Height;
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(px+5, py+5, 20, 20);
    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_backgroundImagesView addSubview:_shareButton];
    [_shareButton addTarget:self action:@selector(didClickShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - 点击举报按钮
- (void)didClickReportButton:(UIButton *)btn{
    
    if (_reportBlock) {
        _reportBlock();
    }
    
}


#pragma mark-------点击图片实现Block--------
- (void)didClickImageButtonAction
{
    if (_block) {
        _block();
    }
}
#pragma mark-------Block的实现方法--------
- (void)changBackGround:(myBlock)block
{
    self.block = block;
}
/**
 * collectButton 实现方法(收藏)
 */
#pragma mark-------实现收藏的方法--------
- (void)didClickCollectButtonAction
{
    
    if (_passCollectBlock) {
        _passCollectBlock();
    }
}

/**
 *  shareButton 实现方法(分享)
 */
#pragma mark-------实现分享的方法--------
- (void)didClickShareButtonAction
{
    
    //构造分享内容
    NSString * content = [_thirdData.title stringByAppendingString:_thirdData.mp4_url];

    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:_thirdData.title
                                                image:nil
                                                title:@"逗乐玩"
                                                  url:_thirdData.web_url
                                          description:@"分享了一个链接"
                                            mediaType:SSPublishContentMediaTypeText];
                                                    //SSPublishContentMediaTypeNews SSPublishContentMediaTypeVideo
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    //NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //NSLog(@"失败");
                                }
                            }];
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)dealloc{
    
    RELEASE_SAFELY(_reportButton);
    Block_release(_reportBlock);
    RELEASE_SAFELY(_thirdData);
    Block_release(_passCollectBlock);
    Block_release(_block);
    [super dealloc];
    
}


@end
