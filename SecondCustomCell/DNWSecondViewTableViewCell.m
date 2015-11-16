//
//  DNWSecondViewTableViewCell.m
//  DouNiWan
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWSecondViewTableViewCell.h"
#import "CustomButton.h"

#import "UIImageView+WebCache.h"

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

#define kMaskViewTag 100
#define kImageViewTag 101


@implementation DNWSecondViewTableViewCell
-(void)dealloc
{
    RELEASE_SAFELY(_reportButton);
    Block_release(_reportBlock);
    RELEASE_SAFELY(_lineImageView);
    RELEASE_SAFELY(_backImageView);
    RELEASE_SAFELY(_iconView);
    RELEASE_SAFELY(_timeLabel);
    RELEASE_SAFELY(_titleLabel);
    RELEASE_SAFELY(_nameLabel);
    RELEASE_SAFELY(_mainImageView);
    RELEASE_SAFELY(_agreeButton);
    RELEASE_SAFELY(_disagreeButton);
    RELEASE_SAFELY(_shareButton);
    RELEASE_SAFELY(_discussButton);
    RELEASE_SAFELY(_collectionButton);
    Block_release(_agreeBlock);
    Block_release(_disAgreeBlock);
    Block_release(_shareBlock);
    Block_release(_discusseBlock);
    RELEASE_SAFELY(_animationLabel);
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"bj"];
        _backImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_backImageView];
        [_backImageView release];

        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(IconView_MarginX, IconView_MarginY, IconView_Width_Height, IconView_Width_Height)];
        _iconView.layer.cornerRadius = 20;
        _iconView.clipsToBounds = YES;
        [_backImageView addSubview:_iconView];
        [_iconView release];
        
        float nx = IconView_MarginX + IconView_Width_Height + NameLabel_MarginLeft;
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nx, NameLabel_MarginY, NameLabel_Width, NameLabel_Height)];
        _nameLabel.font = [UIFont systemFontOfSize:12.0];
        _nameLabel.textColor = [UIColor brownColor];
        [_backImageView addSubview:_nameLabel];
        [_nameLabel release];
        
        float px = nx;
        float py = NameLabel_MarginY + NameLabel_Height + TimeLabel_MarginTop;
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(px, py, TimeLabel_Width+50, TimeLabel_Height)];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor grayColor];
        [_backImageView addSubview:_timeLabel];
        [_timeLabel release];
        
#pragma mark 举报Button
        self.reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _reportButton.frame = CGRectMake(200, collectButton_MarginY, collectButton_Width, collectButton_Height);
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(didClickReportButton:) forControlEvents:UIControlEventTouchUpInside];
        [_backImageView addSubview:_reportButton];

        
        self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.frame = CGRectMake(collectButton_X, collectButton_MarginY, collectButton_Width, collectButton_Height);
        [_collectionButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
        [_collectionButton addTarget:self action:@selector(didClickCollectionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backImageView addSubview:_collectionButton];

        float ty = py + TimeLabel_Height + PaperTextLabel_MarginTop;
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IconView_MarginX, ty-3, 300, 1)];
        _lineImageView.image = [UIImage imageNamed:@"xian"];
        [_backImageView addSubview:_lineImageView];
        [_lineImageView release];

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PaperTextLabel_MarginLeft, ty, 300, PaperTextLabel_Height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1.0];
        _titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
        _titleLabel.numberOfLines = 0;
        [_backImageView addSubview:_titleLabel];
        [_titleLabel release];
        
        self.mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PaperTextLabel_MarginLeft, ty, 300, PaperTextLabel_Height)];
        _mainImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageWithFullScreen:)];
        [_mainImageView addGestureRecognizer:tap];
        [tap release];
        [_backImageView addSubview:_mainImageView];
        [_mainImageView release];
        
        self.agreeButton = [[CustomButton alloc]init];
        [self.agreeButton.button addTarget:self action:@selector(didClickAgreebutton) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton.button setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
        [_backImageView addSubview:_agreeButton];
        [_agreeButton release];
        
        self.disagreeButton = [[CustomButton alloc]init];
        [self.disagreeButton.button addTarget:self action:@selector(didClickDisagreeButton) forControlEvents:UIControlEventTouchUpInside];
        [_disagreeButton.button setImage:[UIImage imageNamed:@"hate"] forState:UIControlStateNormal];
        [_backImageView addSubview:_disagreeButton];
        [_disagreeButton release];
        
        self.shareButton = [[CustomButton alloc]init];
        [self.shareButton.button addTarget:self action:@selector(didClickShareButton) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton.button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_backImageView addSubview:_shareButton];
        [_shareButton release];
        
        self.discussButton = [[CustomButton alloc] init];
        [self.discussButton.button addTarget:self action:@selector(didClickDiscussButton) forControlEvents:UIControlEventTouchUpInside];
        [_discussButton.button setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_backImageView addSubview:_discussButton];
        [_discussButton release];
    }
    return self;
}


#pragma mark - 点击举报按钮
- (void)didClickReportButton:(UIButton *)btn{
    
    if (_reportBlock) {
        _reportBlock();
    }
    
}

-(void)didClickCollectionButtonAction
{
    if (_collectionBlock) {
        _collectionBlock();
    }
}
-(void)didClickAgreebutton
{
        if (_agreeBlock)
        {
            _agreeBlock();
        }
}
-(void)didClickDisagreeButton
{
        if (_disAgreeBlock) {
            _disAgreeBlock();
        }
}
-(void)didClickShareButton
{
    if (_shareBlock) {
        _shareBlock();
    }
}
-(void)didClickDiscussButton
{
    if (_discusseBlock) {
        _discusseBlock();
    }
}
-(void)initWith:(DNWOneCellDataForSecondView*)celldata
{
    self.nameLabel.text = celldata.nameString;
    self.timeLabel.text = celldata.timeString;
    
    
    
    self.titleLabel.text = celldata.titleString;
    self.titleLabel.numberOfLines =0;
    UIFont * tfont = [UIFont systemFontOfSize:14];
    self.titleLabel.font = tfont;
    self.titleLabel.lineBreakMode =NSLineBreakByCharWrapping ;
    //给一个比较大的高度，宽度不变
    CGSize size =CGSizeMake(200,1000);
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[celldata.titleString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    //   更新label的frame
    CGRect rect = self.titleLabel.frame;
    rect.size.height = actualsize.height;
    self.titleLabel.frame = rect;
    
    self.agreeButton.countNumberLabel.text = celldata.agreeCount;
    
    self.disagreeButton.countNumberLabel.text = celldata.disagreeCount;
    
    self.shareButton.countNumberLabel.text = celldata.shareCount;
    
    self.discussButton.countNumberLabel.text = celldata.discussCount;
    

    [self.iconView setImageWithURL:[NSURL URLWithString:celldata.iconImageUrl] placeholderImage:[UIImage imageNamed:@"head_bj"]];
    //修改主图片的y的起始位置
    CGRect mainImageRect = self.mainImageView.frame;
    mainImageRect.origin.y = self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5;
    //修改图片的高度
   CGFloat imgeScale = [[[NSDecimalNumber alloc] initWithString:celldata.mainImageWidth]doubleValue]/(self.bounds.size.width-20);
    mainImageRect.size.width = [[[NSDecimalNumber alloc] initWithString:celldata.mainImageWidth]doubleValue]/imgeScale;
    mainImageRect.size.height =[[[NSDecimalNumber alloc] initWithString:celldata.mainImageHigh ]doubleValue]/imgeScale;
    float finaHeight = mainImageRect.size.height + rect.size.height;
    self.mainImageView.frame = CGRectMake(PaperTextLabel_MarginLeft, rect.origin.y+rect.size.height, 300, mainImageRect.size.height);
    [self.mainImageView setImageWithURL:[NSURL URLWithString:celldata.mainImageUrl]];
    
    self.backImageView.frame = CGRectMake(5, 5, 310, 95+finaHeight+10);
    //修改最下边一排按钮的坐标
    self.agreeButton.frame = CGRectMake(0,finaHeight +15 +IconView_Width_Height , 80, 40);

    self.disagreeButton.frame = CGRectMake(80,finaHeight +15 +IconView_Width_Height , 80, 40);
    self.shareButton.frame =  CGRectMake(160,finaHeight+15 +IconView_Width_Height , 80, 40);

    self.discussButton.frame =  CGRectMake(230,finaHeight+15 +IconView_Width_Height , 80, 40);
   
}
+ (CGFloat)returnRowHighWith:(DNWOneCellDataForSecondView*)celldata
{
    
    //    self.titleLabel.text = text ;
    //给一个比较大的高度，宽度不变
    //CGSize size =CGSizeMake(310,100000);
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[celldata.titleString boundingRectWithSize:CGSizeMake(300, 20000) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
   
    CGFloat imgeScale = [[[NSDecimalNumber alloc] initWithString:celldata.mainImageWidth]doubleValue]/300;
   
    float finaHeight = [(celldata.mainImageHigh) floatValue]/imgeScale + actualsize.height;
   
    return finaHeight + IconView_Width_Height + 15 +40+10;

}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 加1动画效果
- (void)changeCountAnimation:(CustomButton *)typeView{
    
    self.animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -20, 40, 40)];
    _animationLabel.textColor = [UIColor redColor];
    _animationLabel.text = @"+1";
    _animationLabel.font = [UIFont systemFontOfSize:20.0];
    _animationLabel.alpha=1.0;
    [typeView addSubview:_animationLabel];
    [_animationLabel release];
}

#pragma -设置点击图片效果
- (void)showImageWithFullScreen:(UITapGestureRecognizer *)tap
{
    UIView *maskViw = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskViw.backgroundColor = [UIColor blackColor];
    maskViw.alpha = 0.68f;
    maskViw.tag = kMaskViewTag;
    [[UIApplication sharedApplication].keyWindow addSubview:maskViw];
    
    UIImage *image = [(UIImageView *)tap.view image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:maskViw.bounds];
    imageView.image = image;
    imageView.tag = kImageViewTag;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = maskViw.center;
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMaskView:)];
    [imageView addGestureRecognizer:tapGR];
    [tapGR release];
    [imageView release];
    [maskViw release];
}

- (void)dismissMaskView:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:kMaskViewTag] removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:kImageViewTag] removeFromSuperview];
}

@end
