//
//  DNWPersonCenterViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-15.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#define HeadViewHeight  200

#import "DNWAppDelegate.h"
#import "DNWPersonCenterViewController.h"
#import "DNWHeadView.h"
#import "DNWLoginViewController.h"
#import "DNWSettingTableViewCell.h"
#import "CUSFlashLabel.h"
#import "UIImageView+WebCache.h"
#import "DXAlertView.h"
#import "DNWUserDeatilInfoViewController.h"
#import "DNWMyCollectViewController.h"
#import "DNWAboutOursViewController.h"
#import "UIView+Shake.h"
#import "SDImageCache.h"
#import <MessageUI/MessageUI.h>
#import "DNWCollectDataHandle.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface DNWPersonCenterViewController (){

    UITableView * _personCenterTableView;
    NSString * _clearCacheName;            //  清除缓存大小
    UIView * _shadowView;                  //  夜间模式一,一个View遮挡
    MBProgressHUD *_HUD;                    //  第三方提示框
    BOOL   isShadow;
    BOOL   isOpen;

}

@property (nonatomic, copy) NSString * clearCacheName;
@property (nonatomic, retain) DNWHeadView * headView;
@property (nonatomic, retain) NSArray     * dataArray;
@property (nonatomic, retain) Reachability * reach;

@end

@implementation DNWPersonCenterViewController

- (void)dealloc{

    RELEASE_SAFELY(_reach);
    RELEASE_SAFELY(_clearCacheName);
    RELEASE_SAFELY(_dataArray);
    RELEASE_SAFELY(_headView);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    
    [self createTableView];
    
    [self createHeadInfoView];
    

    self.dataArray = @[@"个人资料",@"我的收藏",@"夜间模式(开启后摇一摇)",@"推荐逗乐玩给小伙伴们",@"清理缓存",@"检查版本更新",@"意见反馈",@"关于我们"];
    
}



#pragma mark - 登录成功后信息回调,传递一个平台用户协议对象过来,就可以获得用户的很多信息
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //  监测网络是否可用
    self.reach = [Reachability reachabilityWithHostName:HostName];
    if ([_reach currentReachabilityStatus] == NotReachable) {
    }else{
        __block DNWPersonCenterViewController * otherSelf = self;
        if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] == YES) {
            
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                              authOptions:nil
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                       
                                       otherSelf.userInfo = userInfo;
                                       _headView.loginLabel.text = [_userInfo nickname];
                                       [_headView.avatarView setImageWithURL:[NSURL URLWithString:[_userInfo profileImage]] placeholderImage:nil];
                                       
                                   }
             ];
            [self refreshCacheData];
            return;
        }else if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace] == YES) {
            
            [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                              authOptions:nil
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                       
                                       otherSelf.userInfo = userInfo;
                                       _headView.loginLabel.text = [_userInfo nickname];
                                       [_headView.avatarView setImageWithURL:[NSURL URLWithString:[_userInfo profileImage]] placeholderImage:nil];
                                       
                                   }
             ];
            [self refreshCacheData];
            return;
        }else{
            
            [self refreshCacheData];
            //  取消授权后,恢复未登录状态
            _headView.loginLabel.text = @"点击头像登录";
            _headView.avatarView.image = [UIImage imageNamed:@"head_bj"];
            
        }
    }
}


#pragma mark - 创建tableView
- (void)createTableView{
    
    _personCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    _personCenterTableView.delegate = self;
    _personCenterTableView.dataSource = self;
    _personCenterTableView.showsVerticalScrollIndicator = YES;
    _personCenterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_personCenterTableView];
    [_personCenterTableView release];

}

#pragma mark - 创建head视图
- (void)createHeadInfoView{

    self.headView = [[DNWHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeadViewHeight)];
    _personCenterTableView.tableHeaderView  = _headView;
    [_headView release];
    
    #pragma mark 水滴效果
    //  预防Block中的内存泄露
    __block DNWPersonCenterViewController * otherSelf = self;
    [_headView setHandleRefreshEvent:^{
        
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [otherSelf.headView stopRefresh];
        });
    }];
    

#pragma mark 响应点击手势方法
        [_headView setHandleTapGesture:^(){
            
            //  监测网络是否可用
            otherSelf.reach = [Reachability reachabilityWithHostName:HostName];
            if ([_reach currentReachabilityStatus] == NotReachable) {
                
                DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
                [alert show];
                alert.rightBlock = ^() {
                };
                [alert release];
                
            }else{
            
                //  判断是否已经授权登录,没登录就去登录界面进行第三方账号登录
                if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] == YES || [ShareSDK hasAuthorizedWithType:ShareTypeQQSpace] == YES) {
                }else{
                    
                    [otherSelf jumpToLoginViewController];
                    
                }
            }
        }];
}

#pragma mark - 跳转登录界面
- (void)jumpToLoginViewController{

    self.reach = [Reachability reachabilityWithHostName:HostName];
    if ([_reach currentReachabilityStatus] == NotReachable) {
        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
        };
        [alert release];

    }else{
        DNWLoginViewController * loginVC = [[DNWLoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController * loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNC animated:YES completion:nil];
        
        [loginVC release];
        [loginNC release];
        
    }
}

#pragma mark - 跳转用户详情资料界面
- (void)jumpToUserDeatilInfoViewController{

    DNWUserDeatilInfoViewController * userDeatilVC = [[DNWUserDeatilInfoViewController alloc] init];
    userDeatilVC.userInfo = self.userInfo;
    userDeatilVC.modalPresentationStyle = UIModalPresentationFullScreen;
    userDeatilVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController * userDeatilNC = [[UINavigationController alloc] initWithRootViewController:userDeatilVC];
    [self presentViewController:userDeatilNC animated:YES completion:nil];
    
    [userDeatilVC release];
    [userDeatilNC release];

}

#pragma mark - 跳转用户收藏界面
- (void)jumpToMyCollectViewController{

    DNWMyCollectViewController * myCollectVC = [[DNWMyCollectViewController alloc] init];
    myCollectVC.paperArray = [[DNWCollectDataHandle shareInstance] selectAllPaperDataFromDataBase];
    myCollectVC.imageArray = [[DNWCollectDataHandle shareInstance] selectAllImageDataFromDataBase];
    myCollectVC.allThirdDataArray = [[DNWCollectDataHandle shareInstance] selectAllDNWThirdData];
    myCollectVC.modalPresentationStyle = UIModalPresentationFullScreen;
    myCollectVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController * myCollectNC = [[UINavigationController alloc] initWithRootViewController:myCollectVC];
    [self presentViewController:myCollectNC animated:YES completion:nil];
    
    [myCollectVC release];
    [myCollectNC release];

}

#pragma mark - 跳转推荐分享界面
- (void)jumpToShareApplicationView{

    NSString * content = @"欢迎关注我的技术博客http://blog.csdn.net/hmt20130412";
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"这个人比较懒,目前什么都木有写"
                                                image:nil
                                                title:@"逗乐玩"
                                                  url:@"http://blog.csdn.net/hmt20130412"
                                          description:@"欢迎关注我的技术博客http://blog.csdn.net/hmt20130412"
                                            mediaType:SSPublishContentMediaTypeText];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess){
                                }
                                else if (state == SSResponseStateFail){
                                }
                            }];
}

#pragma mark - 跳转清除缓存界面
- (void)jumpToClearCashsData{

    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在清除";
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        // 清除缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
    } completionBlock:^{
        
        [_HUD removeFromSuperview];
        [_HUD release];
        _HUD = nil;
        
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.dimBackground = YES;
        _HUD.labelText = @"清除成功";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] autorelease];
        [_personCenterTableView reloadData];
        [_HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            
            [_HUD removeFromSuperview];
            [_HUD release];
            _HUD = nil;
        }];
    }];
}

#pragma mark - 跳转检查版本更新界面
- (void)jumpToCheckEditionView{

    DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"逗乐玩1.0" contentText:@"现在已经是最新版本" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alert show];
    alert.rightBlock = ^() {
    };
    [alert release];

}

#pragma mark - 跳转意见反馈界面
- (void)jumpToIdeaFeedBackView{

    [self sendIdeaWithEmail];
}

#pragma mark  邮箱方式
- (void)sendIdeaWithEmail{

    BOOL judge = [MFMailComposeViewController canSendMail];
    if (judge) {
        MFMailComposeViewController * mail = [[MFMailComposeViewController alloc] init];
        NSArray * sendToOpposite = [NSArray arrayWithObject:@"humingtao2014@gmail.com"];
        [mail setToRecipients:sendToOpposite];
        mail.mailComposeDelegate = self;
        [mail setMessageBody:@"我有不爽,我要吐槽!!!" isHTML:NO];
        [self presentViewController:mail animated:YES completion:nil];
        [mail release];
    }
}

//  邮箱代理方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:

            break;
        case MFMailComposeResultFailed:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:{
            
            [self createBaseMBProgressHUDWithText:@"发送成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
        }
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - 跳转关于我们界面
- (void)jumpToAboutOursViewController{

    DNWAboutOursViewController * aboutOursVC = [[DNWAboutOursViewController alloc] init];
    aboutOursVC.modalPresentationStyle = UIModalPresentationFullScreen;
    aboutOursVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController * aboutOursNC = [[UINavigationController alloc] initWithRootViewController:aboutOursVC];
    [self presentViewController:aboutOursNC animated:YES completion:nil];
    
    [aboutOursVC release];
    [aboutOursNC release];

}


#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40.0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 2) {
        
        static NSString *CellIdentifier = @"cellWithSwitch";
        DNWSettingTableViewCell *cell = [[[DNWSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.iconImageView.image = [UIImage imageNamed:@"night"];
        cell.contentLabel.text = [self.dataArray objectAtIndex:2];
        cell.switchButton.alpha = 1.0;
        //  摇一摇效果
        [cell setShakeToChangeModal:^(){
            
            isOpen = YES;
        }];
        [cell setCancelToChangeModal:^(){
            isOpen = NO;
        }];
        cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    DNWSettingTableViewCell * cell = [[[DNWSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    
    switch (indexPath.row) {
        case 0:{
            cell.iconImageView.image = [UIImage imageNamed:@"me"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1:{
            cell.iconImageView.image = [UIImage imageNamed:@"mycollect"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:{
            cell.iconImageView.image = [UIImage imageNamed:@"shareToOther"];
            break;
        }
        case 4:{
            cell.iconImageView.image = [UIImage imageNamed:@"clear"];
            break;
        }
        case 5:{
            cell.iconImageView.image = [UIImage imageNamed:@"update"];
            break;
        }
   
        case 6:{
            cell.iconImageView.image = [UIImage imageNamed:@"sendidea"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 7:{
            cell.iconImageView.image = [UIImage imageNamed:@"aboutMe"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    
    cell.contentLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 4) {
        
        float tmpSize = [[SDImageCache sharedImageCache] getSize]/3000000.0;
        self.clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        cell.contentLabel.text = _clearCacheName;
    }
    cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    #pragma mark  个人资料
    if (indexPath.row == 0) {
        
        self.reach = [Reachability reachabilityWithHostName:HostName];
        if ([_reach currentReachabilityStatus] == NotReachable) {
            
            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^() {
            };
            [alert release];

        }else{
            __block DNWPersonCenterViewController * otherSelf = self;
            if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace] == NO){
                if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] == NO) {
                    
                    DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"您还没有登录" contentText:@"是否现在去登录" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                    [alert show];
                    alert.rightBlock = ^() {
                        
                        [otherSelf jumpToLoginViewController];
                        
                    };
                    [alert release];
                    [self shake];
                }else{
                    
                    [self jumpToUserDeatilInfoViewController];
                }
                
            } else {
                
                [self jumpToUserDeatilInfoViewController];
                
            }
        }
    }
    
    #pragma mark  我的收藏
    if (indexPath.row == 1) {
        
        __block DNWPersonCenterViewController * otherSelf = self;
        if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace] == NO) {
            if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] == NO) {
                
                DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"您还没有登录" contentText:@"是否现在去登录" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [alert show];
                alert.rightBlock = ^() {
                    
                    [otherSelf jumpToLoginViewController];
                    
                };
                [alert release];
                [self shake];
            }else{
                
                [self jumpToMyCollectViewController];
            }
            
        } else {
            
            [self jumpToMyCollectViewController];
            
        }
        
    }

    #pragma mark  推荐逗乐玩给小伙伴们
    if (indexPath.row == 3) {
        
        [self jumpToShareApplicationView];
        
    }
    
    #pragma mark  清除缓存
    if (indexPath.row == 4) {
    
        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"清除缓存" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
        
            [self jumpToClearCashsData];
        };
        [alert release];
    }
    
    #pragma mark  检查版本更新
    if (indexPath.row == 5) {
        
        [self jumpToCheckEditionView];
    }

    #pragma mark  意见反馈
    if (indexPath.row == 6) {
        
        [self jumpToIdeaFeedBackView];
        
    }
    
    #pragma mark  关于我们
    if (indexPath.row == 7) {
     
        [self jumpToAboutOursViewController];
        
    }
    

}

#pragma mark - @响应输入密码错误出现视图晃动效果
- (void)shake
{
	[self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		[obj shake:10
		 withDelta:10
		  andSpeed:0.05
	shakeDirection:ShakeDirectionHorizontal];
	}];
}


#pragma mark - scroll delegate 头部视图效果方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.headView.offsetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _headView.touching = NO;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==NO)
    {
        _headView.touching = NO;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _headView.touching = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 手机摇一摇方法
- (void)createShadowView{
    
    _shadowView = [[UIView alloc] initWithFrame:[self.view bounds]];
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.0;
    _shadowView.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
    [_shadowView release];

}

//检测到摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
}

//摇动取消
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent*)event{
}

// 摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event{
    
    if (isOpen) {
        if (event.subtype == UIEventSubtypeMotionShake) {
            if (isShadow) {
                
                [self createShadowView];
                _shadowView.alpha = 0.8;
                isShadow = NO;
            }else{
            
                [_shadowView removeFromSuperview];
                isShadow = YES;
            }
        }
        
    } else {
        
    }
}

#pragma mark - 即时刷新缓存大小数据
- (void)refreshCacheData{

    float tmpSize = [[SDImageCache sharedImageCache] getSize]/3000000.0;
    self.clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    [_personCenterTableView reloadData];

}

#pragma mark - 创建Base提示框
- (void)createBaseMBProgressHUDWithText:(NSString *)text withMode:(MBProgressHUDMode)mode withImageName:(NSString *)imageName{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    //  如果设置此属性则当前的view置于后台
    _HUD.dimBackground = YES;
    //  提示文字
    _HUD.labelText = text;
    //  提示框类型
    _HUD.mode = mode;
    _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        [_HUD release];
        _HUD = nil;
    }];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
