//
//  DNWSwitchTableViewCell.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-17.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWSettingTableViewCell.h"

@implementation DNWSettingTableViewCell

- (void)dealloc{

    RELEASE_SAFELY(_switchButton);
    Block_release(_shakeToChangeModal);
    Block_release(_cancelToChangeModal);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self createCustomSettingsTabelViewCell];
        
    }
    return self;
}

- (void)createCustomSettingsTabelViewCell{

    _backImageView =[[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 310, 38)];
    _backImageView.image = [UIImage imageNamed:@"bj"];
    _backImageView.layer.cornerRadius = 5;
    _backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backImageView];
    [_backImageView release];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 30, 32)];
    _iconImageView.userInteractionEnabled = YES;
    [_backImageView addSubview:_iconImageView];
    [_iconImageView release];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 250, 36)];
    [_backImageView addSubview:_contentLabel];
    [_contentLabel release];
    
    self.switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(255, 4, 20, 10)];
    [_switchButton setOn:NO];
    _switchButton.alpha = 0.0;
    [_switchButton addTarget:self action:@selector(changeValueOfswitchAction:) forControlEvents:UIControlEventValueChanged];
    [_backImageView addSubview:_switchButton];
    [_switchButton release];

}

-(void)changeValueOfswitchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = switchButton.isOn;
    if (isButtonOn) {
        
        if (_shakeToChangeModal) {
            _shakeToChangeModal();
        }
        
    }else {
        
        if (_cancelToChangeModal) {
            _cancelToChangeModal();
        }
    }
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
