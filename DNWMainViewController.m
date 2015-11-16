//
//  DNWMainViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#define tabitem_width 80
#define tabitem_hight 44
#define tab_hight 49
#define tab_width 320
#define other_offtop 3

#define img_hight 30
#define img_width 30
#define img_x 23
#define img_y 1

#define TAG 0

#import "DNWAppDelegate.h"
#import "DNWMainViewController.h"
#import "DNWFirstPaperViewController.h"
#import "DNWSecondViewController.h"
#import "DNWThirdVideoViewController.h"
#import "DNWPersonCenterViewController.h"
#import "DNWThirdVideoSubclassViewController.h"


@interface DNWMainViewController (){

    UIImageView * _backGroundImageView;  //  tabbar背景View
    UIImageView * _selectImageView;  //  滑动View
    UIImageView * _buttonImageView;  //  按钮Image
    UILabel     * _nameLabel;
    
    UIButton * _firstButton;
    UIButton * _secondButton;
    UIButton * _thirdButton;
    UIButton * _fourthButton;
    
    DNWFirstPaperViewController    * _firstPaperVC;
    DNWSecondViewController        * _secondPictureVC;
    DNWThirdVideoViewController    * _thirdVideoVC;
    DNWPersonCenterViewController  * _personCenterVC;
    
}

@end

@implementation DNWMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createCustomTabBarView];
    
    [self createFourViewControllerToTabBarView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

#pragma mark - 关联各自视图
- (void)createFourViewControllerToTabBarView{

    #pragma mark firstViewController
    _firstPaperVC = [[DNWFirstPaperViewController alloc] init];
    _firstPaperVC.bottomImageView = _backGroundImageView;
    UINavigationController * firstPaperNC = [[UINavigationController alloc] initWithRootViewController:_firstPaperVC];
    
    #pragma mark secondViewController
    _secondPictureVC = [[DNWSecondViewController alloc]init];
    _secondPictureVC.bottomImageView = _backGroundImageView;
    UINavigationController * secondPictureNC = [[UINavigationController alloc] initWithRootViewController:_secondPictureVC];
    
    #pragma mark thirdViewController
    _thirdVideoVC = [[DNWThirdVideoViewController alloc] init];
    _thirdVideoVC.bottomImageView = _backGroundImageView;
    UINavigationController *thirdVideoNC = [[UINavigationController alloc]initWithRootViewController:_thirdVideoVC];
    
    #pragma mark fourthViewController
    _personCenterVC = [[DNWPersonCenterViewController alloc] init];
    
    self.viewControllers = @[firstPaperNC,secondPictureNC,thirdVideoNC,_personCenterVC];
    
    
    [_firstPaperVC release];
    [firstPaperNC release];
    [_secondPictureVC release];
    [secondPictureNC release];
    [_thirdVideoVC release];
    [thirdVideoNC release];
    [_personCenterVC release];
    
}

#pragma mark - 自定义UITabBar
- (void)createCustomTabBarView{
    
    _backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - tab_hight, ScreenWidth, tab_hight)];
    _backGroundImageView.image = [UIImage imageNamed:@"nav"];
    _backGroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:_backGroundImageView];
    [_backGroundImageView release];
    
    _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, tabitem_width , tab_hight+5)];
    _selectImageView.image = [UIImage imageNamed:@"nav_btn"];
    [_backGroundImageView addSubview:_selectImageView];
    [_selectImageView release];
    
   #pragma mark first标签
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 21, img_width, img_hight)];
    _nameLabel.text = @"段子";
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    _nameLabel.textColor = [UIColor whiteColor];
    _buttonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper"] highlightedImage:[UIImage imageNamed:@"paperH"]];
    _buttonImageView.highlighted = YES;
    _buttonImageView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
    _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstButton.frame = CGRectMake(tabitem_width * 0, other_offtop, tabitem_width, tabitem_hight);
    _firstButton.tag = 0 + TAG;
    [_firstButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_firstButton addSubview:_buttonImageView];
    [_firstButton addSubview:_nameLabel];
    [_buttonImageView release];
    [_nameLabel release];
    
    #pragma mark second标签
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 21, img_width, img_hight)];
    _nameLabel.text = @"图片";
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    _nameLabel.textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    _buttonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2image"] highlightedImage:[UIImage imageNamed:@"2imageH"]];
    _buttonImageView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
    _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondButton.frame = CGRectMake(tabitem_width * 1, other_offtop, tabitem_width, tabitem_hight);
    _secondButton.tag = 1 + TAG;
    [_secondButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_secondButton addSubview:_buttonImageView];
    [_secondButton addSubview:_nameLabel];
    [_buttonImageView release];
    [_nameLabel release];
    
    #pragma mark third标签
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 21, img_width, img_hight)];
    _nameLabel.text = @"视频";
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    _nameLabel.textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    _buttonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video"] highlightedImage:[UIImage imageNamed:@"videoH"]];
    _buttonImageView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
    _thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdButton.frame = CGRectMake(tabitem_width * 2, other_offtop, tabitem_width, tabitem_hight);
    _thirdButton.tag = 2 + TAG;
    [_thirdButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdButton addSubview:_buttonImageView];
    [_thirdButton addSubview:_nameLabel];
    [_buttonImageView release];
    [_nameLabel release];
    
    #pragma mark fourth标签
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 21, 50, img_hight)];
    _nameLabel.text = @"个人中心";
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    _nameLabel.textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    _buttonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"] highlightedImage:[UIImage imageNamed:@"personH"]];
    _buttonImageView.frame = CGRectMake(img_x, img_y, img_width, img_hight);
    _fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fourthButton.frame = CGRectMake(tabitem_width * 3, other_offtop, tabitem_width, tabitem_hight);
    _fourthButton.tag = 3 + TAG;
    [_fourthButton addTarget:self action:@selector(didClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fourthButton addSubview:_buttonImageView];
    [_fourthButton addSubview:_nameLabel];
    [_buttonImageView release];
    [_nameLabel release];
    
    [_backGroundImageView addSubview:_firstButton];
    [_backGroundImageView addSubview:_secondButton];
    [_backGroundImageView addSubview:_thirdButton];
    [_backGroundImageView addSubview:_fourthButton];
    
}

- (BOOL)shouldAutorotate
{
    BOOL shouldAutorotate = ((DNWAppDelegate *)[UIApplication sharedApplication].delegate).shouldAutorotate;
    shouldAutorotate=NO;
    return shouldAutorotate;
}

#pragma mark - 点击按钮响应方法
- (void)didClickButtonAction:(id)sender{
    
    UIButton * button = (UIButton *)sender;
    self.selectedIndex = button.tag;
    
    [self moveSelectImageView:button];
    [self imgAnimate:button];
    
    if (_firstButton.tag != button.tag) {
        
        ((UIImageView *)_firstButton.subviews[0]).highlighted = NO;
        ((UILabel *)_firstButton.subviews[1]).textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    }
    
    if (_secondButton.tag != button.tag) {
        
        ((UIImageView *)_secondButton.subviews[0]).highlighted = NO;
        ((UILabel *)_secondButton.subviews[1]).textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    }
    
    if (_thirdButton.tag != button.tag) {
        
        ((UIImageView *)_thirdButton.subviews[0]).highlighted = NO;
        ((UILabel *)_thirdButton.subviews[1]).textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    }
    
    if (_fourthButton.tag != button.tag) {
        
        ((UIImageView *)_fourthButton.subviews[0]).highlighted = NO;
        ((UILabel *)_fourthButton.subviews[1]).textColor = [UIColor colorWithRed:201/255.0 green:187/255.0 blue:182/255.0 alpha:1.0];
    }
    
    
    ((UIImageView *)button.subviews[0]).highlighted = YES;
    ((UILabel *)button.subviews[1]).textColor = [UIColor whiteColor];
    
}

#pragma mark - 图片滑动动画
- (void)moveSelectImageView:(UIButton*)btn{
    
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         
         CGRect frame = _selectImageView.frame;
         frame.origin.x = btn.frame.origin.x;
         _selectImageView.frame = frame;
         
     } completion:^(BOOL finished){
     }];
    
}

#pragma mark - 按钮图片动画
- (void)imgAnimate:(UIButton*)btn{
    
    UIView *view=btn.subviews[0];
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
         
         
     } completion:^(BOOL finished){
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
              
          } completion:^(BOOL finished){
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
                   
                   
               } completion:^(BOOL finished){
               }];
          }];
     }];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
