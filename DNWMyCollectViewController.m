//
//  DNWMyCollectViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-18.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWMyCollectViewController.h"
#import "DNWFirstCustomCell.h"
#import "DNWCollectDataHandle.h"
#import "DNWPaperData.h"
#import "DNWBottomLabelView.h"
#import "DNWCommitViewController.h"
#import "MBProgressHUD.h"
#import "DXAlertView.h"
#import "DNWSecondViewTableViewCell.h"
#import "DNWThirdCustomCell.h"
#import "DNWThirdData.h"
#import "DNWThirdVideoSubclassViewController.h"

@interface DNWMyCollectViewController (){

    UITableView * _collectTableView;
    MBProgressHUD * _HUD;
    

}

@end

@implementation DNWMyCollectViewController

- (void)dealloc{

    RELEASE_SAFELY(_paperArray);
    Block_release(_pushCommitView);
    RELEASE_SAFELY(_imageArray);
    RELEASE_SAFELY(_allThirdDataArray);
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
    
    if (([_paperArray count]== 0) && ([_allThirdDataArray count] == 0) && ([_imageArray count] == 0)) {
        
        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"收藏为空" contentText:@"亲,快去挑选吧!" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
        };
        [alert release];

    }
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收藏";
    #pragma mark 导航栏配色设置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    //  改变导航栏中间标题颜色
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"个人中心" style:UIBarButtonItemStylePlain target:self action:@selector(didLeftBarButtonItemAction:)]autorelease];
    
    [self createCollectTableView];
}

#pragma mark - 创建段子TableView
- (void)createCollectTableView{

    _collectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];;
    _collectTableView.delegate = self;
    _collectTableView.dataSource = self;
    _collectTableView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    _collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_collectTableView];
    [_collectTableView release];

    // 防止循环引用,预防内存泄露
    __block DNWMyCollectViewController * otherSelf = self;
    [otherSelf setPushCommitView:^(NSString * url){
        
        DNWCommitViewController * commitVC = [[DNWCommitViewController alloc] init];
        commitVC.modalPresentationStyle = UIModalPresentationFullScreen;
        commitVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        commitVC.getCommitUrl = url;
        
        UINavigationController * commitNC = [[UINavigationController alloc] initWithRootViewController:commitVC];
        [otherSelf presentViewController:commitNC animated:YES completion:nil];
        
        [commitVC release];
        [commitNC release];
        
    }];

}

- (void)didLeftBarButtonItemAction:(UIBarButtonItem *)leftBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return [[self paperArray] count];
    }
    if (section == 1) {
       
        return [[self imageArray] count];
    }
    
    if (section==2) {
        return [[[DNWCollectDataHandle shareInstance]selectAllDNWThirdData] count];
    }
    
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return [DNWFirstCustomCell cellHeight:((DNWPaperData *)[self.paperArray objectAtIndex:indexPath.row])] + 5;
    }
    if (indexPath.section ==1) {
        
        DNWOneCellDataForSecondView *cellData = [self.imageArray objectAtIndex:indexPath.row];
        
        return  [DNWSecondViewTableViewCell returnRowHighWith:cellData];
    }
    if (indexPath.section==2) {

        return [DNWThirdCustomCell cellHight:((DNWThirdData *)[self.allThirdDataArray objectAtIndex:indexPath.row])];
    }
    
    return 200.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return @"段子";
            break;
        case 1:
            return @"图片";
            break;
        case 2:
            return @"视频";
            break;
        
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

#pragma mark - 收藏的段子区
    if (indexPath.section == 0) {
        
        DNWPaperData * _paperData = [self.paperArray objectAtIndex:indexPath.row];
        
        static NSString * paperCellIdentifier = @"paperCell";
        DNWFirstCustomCell * paperCell = [tableView dequeueReusableCellWithIdentifier:paperCellIdentifier];
        
        // Configure the cell...
        if (!paperCell) {
            
            paperCell = [[[DNWFirstCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paperCellIdentifier]autorelease];
            
        }
        
        paperCell.paperData = [self.paperArray objectAtIndex:indexPath.row];

        
#pragma mark 实现收藏
        if ([[DNWCollectDataHandle shareInstance] selectPaperDataWithId:_paperData.hostId] == YES) {
            
            [paperCell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        
        }else{
            
            [paperCell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
            
        }
        [paperCell setCollectBlock:^(){
            
            if ([[DNWCollectDataHandle shareInstance] selectPaperDataWithId:_paperData.hostId]== NO) {
                
                //  创建提示框
                [self createBaseMBProgressHUDWithText:@"收藏成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [_HUD release];
                    _HUD = nil;
                    [[DNWCollectDataHandle  shareInstance] insertIntoPaperDataWithUserInfoId:_paperData];
                    [paperCell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                    
                }];
                
            } else {
                
                [self createBaseMBProgressHUDWithText:@"取消成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [_HUD release];
                    _HUD = nil;
                    //  不仅从数据库中删除数据,而且还要在显示的数组中删除掉数据,然后刷新列表
                    [[DNWCollectDataHandle shareInstance] deletePaperDataFromDataBase:_paperData];
                    [self.paperArray removeObjectAtIndex:indexPath.row];
                    [_collectTableView reloadData];
                }];
                
            }

        }];
        
#pragma mark 实现love赞一个
        [paperCell.praiseView setPassBlock:^(){
            //  判断是否已经被赞或者贬
            if (_paperData.isLoveOrHate == YES) {
                
                [paperCell changeCountAnimation:paperCell.praiseView];
                [UIView animateWithDuration:0.5 animations:^{
                    
                    paperCell.animationLabel.transform = CGAffineTransformTranslate(paperCell.animationLabel.transform, 20, -20);
                    paperCell.animationLabel.alpha = 0.0;
                    _paperData.favouriteNumber = [NSString stringWithFormat:@"%i",[_paperData.favouriteNumber intValue] + 1];
                    _paperData.isLoveOrHate = NO;
                } completion:^(BOOL finished) {
                    
                    [paperCell.animationLabel removeFromSuperview];
                    //  已赞
                    [_collectTableView reloadData];
                }];
            }
            
        }];
        
#pragma mark 实现hate贬一个
        [paperCell.hateView setPassBlock:^(){
            
            if (_paperData.isLoveOrHate == YES) {
                
                [paperCell changeCountAnimation:paperCell.hateView];
                [UIView animateWithDuration:0.5 animations:^{
                    paperCell.animationLabel.alpha = 0.0;
                    paperCell.animationLabel.transform = CGAffineTransformTranslate(paperCell.animationLabel.transform, 20, -20);
                    _paperData.hateNumber = [NSString stringWithFormat:@"%i",[_paperData.hateNumber intValue] + 1];
                    _paperData.isLoveOrHate = NO;
                } completion:^(BOOL finished) {
                    
                    [paperCell.animationLabel removeFromSuperview];
                    [_collectTableView reloadData];
                }];
            }
            
            
        }];
        
#pragma mark  实现分享
        [paperCell.shareView setPassBlock:^(){
            
            //  拼接段子的内容和网页链接
            NSString * content = [[_paperData.paperText stringByAppendingString:[NSString stringWithFormat:@"[%@",_paperData.commentUrl]] stringByAppendingString:@"]"];
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:@"这个人比较懒,目前什么都木有写"
                                                        image:nil
                                                        title:@"逗乐玩"
                                                          url:_paperData.commentUrl
                                                  description:@"分享了一个链接"
                                                    mediaType:SSPublishContentMediaTypeText];
            
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            
                                            //  假分享计数字(并没有上传到服务器)
                                            _paperData.shareNumber = [NSString stringWithFormat:@"%i",[_paperData.shareNumber intValue] + 1];
                                            
                                            //  切记,tableView上数据要主动刷新,只要希望更改后能显示新数据的地方都要刷新
                                            [_collectTableView reloadData];
                                            
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            //NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }];
        
#pragma mark 评论
        [paperCell.discussView setPassBlock:^(){
            
            if (_pushCommitView) {
                
                _pushCommitView(_paperData.commentUrl);
                
            }
        }];
        
        paperCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return paperCell;
    }
    
#pragma mark - 收藏视频
    if(indexPath.section == 2){
        
        DNWThirdData * _thirdDatas = [_allThirdDataArray objectAtIndex:indexPath.row];
        
        static NSString * videoCellIdentifier = @"VideoCell";
        DNWThirdCustomCell *VCell = [tableView dequeueReusableCellWithIdentifier:videoCellIdentifier];
        
        if (!VCell) {
            
            VCell = [[[DNWThirdCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellIdentifier]autorelease];
        }
        VCell.thirdData = _thirdDatas;
        VCell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
        if ([[DNWCollectDataHandle shareInstance] electThirdDataWithId:_thirdDatas.Id]== YES) {
            
            [VCell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            
        } else {
            [VCell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
        }
        [VCell setPassCollectBlock:^(){
            
            if ([[DNWCollectDataHandle shareInstance] electThirdDataWithId:_thirdDatas.Id]== NO) {
                
                [VCell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
               
            } else {
                
                [[DNWCollectDataHandle shareInstance] deleteDNWThirdData:_thirdDatas];
                [self.allThirdDataArray removeObjectAtIndex:indexPath.row];
                [VCell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
                [_collectTableView reloadData];
            }
            
        }];

       
        /**
         *  Block的回调实现push出DNWThirdVideoSubclassViewController类
         */
        __block DNWMyCollectViewController *myVC = self;
        [VCell changBackGround:^{
            
            [myVC pushDNWThirdVideoSubclassViewController:indexPath];
            
        }];

        return VCell;
        
    }
    
//    ***********************************图片********************************************
    
    if (indexPath.section == 1) {
        
        static NSString *imageCellIdentifier = @"imageCell";
        DNWSecondViewTableViewCell *imageCell =[tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
        if (!imageCell) {
            imageCell = [[[DNWSecondViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIdentifier]autorelease];
        }
        DNWOneCellDataForSecondView * imageData = [self.imageArray objectAtIndex:indexPath.row];
       
        [imageCell initWith:imageData];
        
        [imageCell setAgreeBlock:^(){
            //设置喜欢Block
            if (imageData.k == YES) {
            
                [imageCell changeCountAnimation:imageCell.agreeButton];
                [UIView animateWithDuration:0.5 animations:^{
                    imageCell.animationLabel.transform = CGAffineTransformTranslate(imageCell.animationLabel.transform, 20, -20);
                    imageCell.animationLabel.alpha = 0.0;
                    
                    int number1 = [[NSString stringWithFormat:@"%@",imageData.agreeCount]intValue];
                    number1 = number1+1;
                    imageData.agreeCount = [NSString stringWithFormat:@"%d",number1];
                    imageData.k = NO;
                    
                    
                } completion:^(BOOL finished) {
                    [imageCell.animationLabel removeFromSuperview];
                    //  已赞
                    [_collectTableView reloadData];
                    
                }];
            }
            
            
        }];
        [imageCell setDisAgreeBlock:^(){
            //        设置不喜欢Block
            if (imageData.k == YES) {
                
                [imageCell changeCountAnimation:imageCell.disagreeButton];
                [UIView animateWithDuration:0.5 animations:^{
                    imageCell.animationLabel.transform = CGAffineTransformTranslate(imageCell.animationLabel.transform, 20, -20);
                    imageCell.animationLabel.alpha = 0.0;
                    int number = [[NSString stringWithFormat:@"%@",imageData.disagreeCount]intValue];
                        number = number+1;
                        imageData.disagreeCount = [NSString stringWithFormat:@"%d",number];
                        imageData.k = NO;
                    
                    
                } completion:^(BOOL finished) {
                    [imageCell.animationLabel removeFromSuperview];
                    //  已赞
                    [_collectTableView reloadData];
                    
                }];
            }
            
        }];
        [imageCell setShareBlock:^(){
            NSString * content = imageData.shareUrl;
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
                                        if (state == SSResponseStateSuccess)
                                        {
                                            //  假分享计数字(并没有上传到服务器)
                                            imageData.shareCount = [NSString stringWithFormat:@"%i",[imageData.shareCount intValue] + 1];
                                            
                                            //  切记,tableView上数据要主动刷新,只要希望更改后能显示新数据的地方都要刷新
                                            [_collectTableView reloadData];
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            //NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }];
        [imageCell setDiscusseBlock:^(){
            //        设置评论block
//            DNWOneCellDataForSecondView * data = [self.imageArray objectAtIndex:indexPath.row];
            if (_pushedBlock) {
                _pushedBlock(imageData.shareUrl);
            }
            
        }];
#pragma mark 实现收藏
        if ([[DNWCollectDataHandle shareInstance] selectImageDataWithId:imageData.hostId] == YES) {
            [imageCell.collectionButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        }else{
            [imageCell.collectionButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];;
        }
        [imageCell setCollectionBlock:^(){
            
            // 设置收藏block
            
            if ([[DNWCollectDataHandle shareInstance] selectImageDataWithId:imageData.hostId]== NO) {
                
                [self createBaseMBProgressHUDWithText:@"收藏成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [_HUD release];
                    _HUD = nil;
                    [[DNWCollectDataHandle  shareInstance] insertIntoImageDataWithUserInfoId:imageData];
                    [imageCell.collectionButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                    
                }];
                
            } else {
                
                [self createBaseMBProgressHUDWithText:@"取消成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [_HUD release];
                    _HUD = nil;
                    [[DNWCollectDataHandle shareInstance] deleteImageDataFromDataBase:imageData];
                    [self.imageArray removeObjectAtIndex:indexPath.row];
                    [_collectTableView reloadData];
                }];
                
            }
            
            
        }];
        
        return imageCell;
        
    }
//    ********************************************************************************

    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        
    }

    return cell;
}


#pragma mark - 创建Base提示框
- (void)createBaseMBProgressHUDWithText:(NSString *)text withMode:(MBProgressHUDMode)mode withImageName:(NSString *)imageName{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    _HUD.dimBackground = YES;
    //  提示文字
    _HUD.labelText = text;
    //  提示框类型
    _HUD.mode = mode;
    _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
}

#pragma mark-----(在收藏中实现)推出DNWThirdVideoSubclassViewController实现过程----
- (void)pushDNWThirdVideoSubclassViewController:(NSIndexPath *)indesPath
{
        
    if (self.interfaceOrientation==UIDeviceOrientationPortrait) {
        
        DNWThirdVideoSubclassViewController *ThirdVideoSubclassVC = [[DNWThirdVideoSubclassViewController alloc]init];
        
        DNWThirdData * _thirdDatas = [_allThirdDataArray objectAtIndex:indesPath.row];
        
        ThirdVideoSubclassVC.thirdData = _thirdDatas ;
        [self.navigationController pushViewController:ThirdVideoSubclassVC animated:YES];
        [ThirdVideoSubclassVC release];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
