//
//  DNWFirstCusomCell.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#define IconView_MarginX 5
#define IconView_MarginY 5
#define IconView_Width_Height   40

#define NameLabel_MarginY 5
#define NameLabel_MarginLeft 5
#define NameLabel_Width  100
#define NameLabel_Height  20

#define TimeLabel_MarginTop 0
#define TimeLabel_MarginLeft 10
#define TimeLabel_Width  100
#define TimeLabel_Height  20

#define collectButton_MarginY 5
#define collectButton_X  255
#define collectButton_Width 40
#define collectButton_Height 45

#define PaperTextLabel_MarginLeft 5
#define PaperTextLabel_MarginTop 5
#define PaperTextLabel_Width  310
#define PaperTextLabel_Height 100

#import "DNWFirstCustomCell.h"
#import "DNWBottomLabelView.h"
#import "DNWPaperData.h"
#import "UIImageView+WebCache.h"

@implementation DNWFirstCustomCell

- (void)dealloc{

    RELEASE_SAFELY(_paperData);
    RELEASE_SAFELY(_animationLabel);
    RELEASE_SAFELY(_collectButton);
    Block_release(_reportBlock);
    Block_release(_collectBlock);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self createCustomCellView];
        //self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

#pragma mark - 初始化View
- (void)createCustomCellView{

    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = [UIImage imageNamed:@"bj"];
    _backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backImageView];
    [_backImageView release];
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IconView_MarginX, IconView_MarginY, IconView_Width_Height, IconView_Width_Height)];
    _profileImageView.layer.cornerRadius = 20.0;
    _profileImageView.clipsToBounds = YES;
     [_backImageView addSubview:_profileImageView];
    [_profileImageView release];
    
    float nx = IconView_MarginX + IconView_Width_Height + NameLabel_MarginLeft;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nx, NameLabel_MarginY, NameLabel_Width, NameLabel_Height)];
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    _nameLabel.textColor = [UIColor brownColor];
    [_backImageView addSubview:_nameLabel];
    [_nameLabel release];
    
    float px = nx;
    float py = NameLabel_MarginY + NameLabel_Height + TimeLabel_MarginTop;
    _passTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(px, py, TimeLabel_Width+50, TimeLabel_Height)];
    _passTimeLabel.font = [UIFont systemFontOfSize:12.0];
    _passTimeLabel.textColor = [UIColor grayColor];
    [_backImageView addSubview:_passTimeLabel];
    [_passTimeLabel release];
    
    #pragma mark 举报Button
    self.reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _reportButton.frame = CGRectMake(200, collectButton_MarginY, collectButton_Width, collectButton_Height);
    [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [_reportButton setTitleColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_reportButton addTarget:self action:@selector(didClickReportButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_reportButton];
    
    #pragma mark 收藏Button
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(collectButton_X, collectButton_MarginY, collectButton_Width, collectButton_Height);
    //[_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
    [_collectButton addTarget:self action:@selector(didClickCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_collectButton];
    
    float ty = py + TimeLabel_Height + PaperTextLabel_MarginTop;
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IconView_MarginX, ty-3, 300, 1)];
    _lineImageView.image = [UIImage imageNamed:@"xian"];
    [_backImageView addSubview:_lineImageView];
    [_lineImageView release];
    
    _paperTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(PaperTextLabel_MarginLeft, ty, PaperTextLabel_Width, PaperTextLabel_Height)];
    _paperTextLabel.font = [UIFont systemFontOfSize:15.0];
    _paperTextLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1.0];
    _paperTextLabel.numberOfLines = 0;
    _paperTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_backImageView addSubview:_paperTextLabel];
    [_paperTextLabel release];

    
    [self createLoveView];
    
    [self createHateView];

    [self createShareView];
    
    [self createDiscussView];

}

#pragma mark - 点击举报按钮
- (void)didClickReportButton:(UIButton *)btn{

    if (_reportBlock) {
        _reportBlock();
    }
    
}

#pragma mark - 点击收藏按钮
- (void)didClickCollectButtonAction:(UIButton *)btn{

    if (_collectBlock) {
        _collectBlock();
    }

}

#pragma mark - 点赞视图
- (void)createLoveView{

    _praiseView = [[DNWBottomLabelView alloc] init];
    _praiseView.labelImageView.image = [UIImage imageNamed:@"love"];
    [_backImageView addSubview:_praiseView];
    [_praiseView release];

}

#pragma mark - 点贬视图
- (void)createHateView{

    _hateView = [[DNWBottomLabelView alloc] init];
    _hateView.labelImageView.image = [UIImage imageNamed:@"hate"];
    [_backImageView addSubview:_hateView];
    [_hateView release];

}

#pragma mark - 分享视图
- (void)createShareView{

    _shareView = [[DNWBottomLabelView alloc] init];
    _shareView.labelImageView.image = [UIImage imageNamed:@"share"];
    [_backImageView addSubview:_shareView];
    [_shareView release];
    
}

#pragma mark - 评论视图
- (void)createDiscussView{

    _discussView = [[DNWBottomLabelView alloc] init];
    _discussView.labelImageView.image = [UIImage imageNamed:@"comment"];
    [_backImageView addSubview:_discussView];
    [_discussView release];

}

#pragma mark - 加1动画效果
- (void)changeCountAnimation:(DNWBottomLabelView *)typeView{
    
    self.animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -20, 40, 40)];
    _animationLabel.textColor = [UIColor redColor];
    _animationLabel.text = @"+1";
    _animationLabel.font = [UIFont systemFontOfSize:20.0];
    _animationLabel.alpha=1.0;
    [typeView addSubview:_animationLabel];
//    [UIView animateWithDuration:2.0 animations:^{
//        _animationLabel.alpha = 0;
//        _paperData.favouriteNumber = [NSString stringWithFormat:@"%i",[_paperData.favouriteNumber intValue] + 1];
//    } completion:^(BOOL finished) {
//        
//        [_animationLabel removeFromSuperview];
//        
//        
//    }];
    [_animationLabel release];
}



#pragma mark - 用传入的数据对象给自定义Cell完成赋值
- (void)setPaperData:(DNWPaperData *)paperData{

    if (_paperData != paperData) {
        
        [_paperData release];
        _paperData = [paperData retain];
        
    }
    
    //  完成赋值
    [_profileImageView setImageWithURL:[NSURL URLWithString:paperData.hostImageUrl] placeholderImage:[UIImage imageNamed:@"head_bj"]];
    _nameLabel.text               = paperData.hostName;
    _passTimeLabel.text           = paperData.passTime;
    _paperTextLabel.text          = paperData.paperText;
    _praiseView.numberLabel.text  = paperData.favouriteNumber;
    _hateView.numberLabel.text    = paperData.hateNumber;
    _shareView.numberLabel.text   = paperData.shareNumber;
    _discussView.numberLabel.text = paperData.discussNumber;
    
    //  自定义Cell高度
    NSDictionary * attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil];
    CGRect newPaperTextRect = [paperData.paperText boundingRectWithSize:CGSizeMake(_paperTextLabel.frame.size.width, 20000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    CGRect oldPaperTextRect = _paperTextLabel.frame;
    oldPaperTextRect.size.height = newPaperTextRect.size.height;
    _paperTextLabel.frame = oldPaperTextRect;
    
    //  调整Text文本下面控件的问题,解决Cell重用问题
    _backImageView.frame = CGRectMake(5, 5, 310, 40*2+15+_paperTextLabel.frame.size.height);
    _praiseView.frame = CGRectMake(0, _paperTextLabel.frame.size.height + 15 + IconView_Width_Height, 80, 40);
    _hateView.frame = CGRectMake(80, _paperTextLabel.frame.size.height + 15 + IconView_Width_Height, 80, 40);
    _shareView.frame = CGRectMake(160,_paperTextLabel.frame.size.height + 15 + IconView_Width_Height, 80, 40);
    _discussView.frame = CGRectMake(240,_paperTextLabel.frame.size.height + 15 + IconView_Width_Height, 80, 40);
}

#pragma mark - 根据具体信息调整Cell实际高度
+(CGFloat)cellHeight:(DNWPaperData *)paperData{
    
    NSDictionary * attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil];
    CGRect newPaperTextRect = [paperData.paperText boundingRectWithSize:CGSizeMake(PaperTextLabel_Width, 20000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    
    return newPaperTextRect.size.height + 15 + IconView_Width_Height + 40;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end