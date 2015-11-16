//
//  DNWHeadImageCell.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-20.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWHeadImageCell.h"

@implementation DNWHeadImageCell

- (void)dealloc{

    RELEASE_SAFELY(_headImageView);
    [super dealloc];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
        _headImageView.userInteractionEnabled = NO;
        [self.contentView addSubview:_headImageView];
        [_headImageView release];
        
    }
    return self;
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

@end
