//
//  DNWEssenceTableView.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//


#import "DNWFirstPagesTableView.h"
#import "DNWFirstCustomCell.h"
#import "DNWAllDataHandle.h"
#import "DNWPaperData.h"
#import "DNWBottomLabelView.h"
#import "MJRefresh.h"
#import "HMTMyCustomNetRequest.h"
#import "DNWCollectDataHandle.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "DXAlertView.h"
#import "CustomAlertView.h"

@interface DNWFirstPagesTableView (){

    NSInteger page;  //  请求的当前页码
    
    MJRefreshHeaderView   * _header;
    MJRefreshFooterView   * _footer;
    HMTMyCustomNetRequest * _request;
 
    MBProgressHUD * _HUD;  // 提示框
}

@property (nonatomic,retain)Reachability * reach;

@end

@implementation DNWFirstPagesTableView

- (void)dealloc{

    RELEASE_SAFELY(_reach);
    RELEASE_SAFELY(_allDataArray);
    RELEASE_SAFELY(_momentDataArray);
    Block_release(_pushCommitView);
    RELEASE_SAFELY(_frontString);
    RELEASE_SAFELY(_backString);
    
    [_header free];
    [_footer free];
    
    RELEASE_SAFELY(_request);
    
    [super dealloc];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}

#pragma mark - 实现一个tableView多用的初始化方法
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style urlString:(NSString *)urlString{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.allDataArray = [NSMutableArray array];
        self.momentDataArray = [NSMutableArray array];
        
        // 通过数据操作类,解析JSON数据,返回数组
        [[DNWAllDataHandle sharedInstance] getAllPaperDataWithUrl:urlString];
        __block DNWFirstPagesTableView * otherSelf = self;
        [[DNWAllDataHandle sharedInstance] setReposeDataBlock:^(NSMutableArray * dataArray){
        
            otherSelf.allDataArray = dataArray;
            
            // 请求到数据后,一定要刷新tableView,因为空白的Cell出现在你请求数据之前,要手动刷新
            [otherSelf reloadData];
            
        }];
        
        //  cell之间分割线样式
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        page = 1;
        [self refreshFromHeadViewOfBlock];
        [self refreshFromFootViewOfBlock];
    }
    
    return self;
    
}

#pragma mark - 下拉刷新
- (void)refreshFromHeadViewOfBlock{

    _header = [MJRefreshHeaderView header];
    _header.scrollView = self;

    __block DNWFirstPagesTableView * otherSelf = self;
    [_header setBeginRefreshingBlock:^(MJRefreshBaseView * refreshView){
    
        NSString * urlString = [[otherSelf.frontString stringByAppendingString:[NSString stringWithFormat:@"%i",page]] stringByAppendingString:otherSelf.backString];
        
        [[DNWAllDataHandle sharedInstance] getAllPaperDataWithUrl:urlString];
        [[DNWAllDataHandle sharedInstance]setReposeDataBlock:^(NSMutableArray * dataArray){
            
            otherSelf.momentDataArray = dataArray;
            
            otherSelf.allDataArray = [NSMutableArray arrayWithArray:dataArray];
            
            [otherSelf reloadData];
            // 结束刷新
            [refreshView endRefreshing];
            
        }];
        
        otherSelf.reach = [Reachability reachabilityWithHostName:HostName];
        if ([_reach currentReachabilityStatus] == NotReachable) {
            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^() {
            };
            [alert release];
            [refreshView endRefreshing];
        }
        
    }];
    
    [_header setEndStateChangeBlock:^(MJRefreshBaseView * refreshView){
        
        self.momentDataArray = [NSMutableArray array];
        page = 1;
        
    }];
    

}

#pragma mark - 上拉加载
- (void)refreshFromFootViewOfBlock{

    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self;
    
    __block DNWFirstPagesTableView * otherSelf = self;
    [_footer setBeginRefreshingBlock:^(MJRefreshBaseView * refreshView){
        
        NSString * urlString = [[otherSelf.frontString stringByAppendingString:[NSString stringWithFormat:@"%i",page]] stringByAppendingString:otherSelf.backString];
        
        [[DNWAllDataHandle sharedInstance] getAllPaperDataWithUrl:urlString];
        [[DNWAllDataHandle sharedInstance] setReposeDataBlock:^(NSMutableArray * dataArray){
        
            otherSelf.momentDataArray = dataArray;
            
            for (int i = 0; i < [otherSelf.momentDataArray count]; i++) {
                
                DNWPaperData * lastPaper = [otherSelf.momentDataArray objectAtIndex:i];
                DNWPaperData * nowPaper = [otherSelf.allDataArray objectAtIndex:i];
    
                if ([lastPaper.hostId doubleValue] != [nowPaper.hostId doubleValue]) {
                    
                    [otherSelf.allDataArray addObject:lastPaper];
                }
            }
                        
            [otherSelf reloadData];
            // 结束刷新
            [refreshView endRefreshing];
            
            self.reach = [Reachability reachabilityWithHostName:HostName];
            if ([_reach currentReachabilityStatus] == NotReachable) {
                DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
                [alert show];
                alert.rightBlock = ^() {
                };
                [alert release];
                [refreshView endRefreshing];
            }
            
        }];
    }];
    
    [_footer setEndStateChangeBlock:^(MJRefreshBaseView * refreshView){
        
        self.momentDataArray = [NSMutableArray array];
        page ++;
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.allDataArray count];
}

#pragma mark cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  因为不确定文本高度,因此要自动调整文本高度
    return [DNWFirstCustomCell cellHeight:((DNWPaperData *)[self.allDataArray objectAtIndex:indexPath.row])] + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DNWFirstCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        
        cell = [[[DNWFirstCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        
    }
    
    cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    //cell.backgroundColor = [UIColor brownColor];
    DNWPaperData * paperData = [self.allDataArray objectAtIndex:indexPath.row];
    if ([paperData.discussNumber intValue] <= 5) {
        paperData.discussNumber = @"0";
    }
    //  在自定义Cell内部完成赋值
    cell.paperData = paperData;
    
    __block DNWFirstPagesTableView * otherSelf = self;
    #pragma mark 实现举报
    [cell setReportBlock:^(){
    
        otherSelf.reach = [Reachability reachabilityWithHostName:HostName];
        if ([_reach currentReachabilityStatus] == NotReachable) {

            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络未连接" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^() {
            };
            [alert release];

        }else{
            
            CustomAlertView * alert = [[CustomAlertView alloc] initWithTitle:@"我要举报" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
            [alert setOtherBlcok:^(){
            
                [otherSelf reportAlertView];
                
            }];
            [alert setCancelBlock:^(){
            }];
            [alert release];
        }
    }];
    
    #pragma mark 实现收藏
    if ([[DNWCollectDataHandle shareInstance] selectPaperDataWithId:paperData.hostId] == YES) {
        
        [cell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    }else{
        
        [cell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
    }
    [cell setCollectBlock:^(){
    
        if ([[DNWCollectDataHandle shareInstance] selectPaperDataWithId:paperData.hostId]== NO) {
            
            [otherSelf createBaseMBProgressHUDWithText:@"收藏成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
            [_HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_HUD removeFromSuperview];
                [_HUD release];
                _HUD = nil;
                [[DNWCollectDataHandle  shareInstance] insertIntoPaperDataWithUserInfoId:paperData];
                
                [cell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            }];

        } else {
            
            [otherSelf createBaseMBProgressHUDWithText:@"取消成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
            [_HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_HUD removeFromSuperview];
                [_HUD release];
                _HUD = nil;
                [[DNWCollectDataHandle shareInstance] deletePaperDataFromDataBase:paperData];
                
                [cell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
            }];

        }
        
        
    }];
    
    #pragma mark 实现love赞一个
    [cell.praiseView setPassBlock:^(){
        //  判断是否已经被赞或者贬
        if (paperData.isLoveOrHate == YES) {
            
            [cell changeCountAnimation:cell.praiseView];
            [UIView animateWithDuration:0.5 animations:^{
                
                cell.animationLabel.transform = CGAffineTransformTranslate(cell.animationLabel.transform, 20, -20);
                cell.animationLabel.alpha = 0.0;
                paperData.favouriteNumber = [NSString stringWithFormat:@"%i",[paperData.favouriteNumber intValue] + 1];
                paperData.isLoveOrHate = NO;
            } completion:^(BOOL finished) {
                
                [cell.animationLabel removeFromSuperview];
                //  已赞
                [self reloadData];
            }];
        }
        
    }];
    
    #pragma mark 实现hate贬一个
    [cell.hateView setPassBlock:^(){
    
        if (paperData.isLoveOrHate == YES) {
            
            [cell changeCountAnimation:cell.hateView];
            [UIView animateWithDuration:0.5 animations:^{
                cell.animationLabel.alpha = 0.0;
                cell.animationLabel.transform = CGAffineTransformTranslate(cell.animationLabel.transform, 20, -20);
                paperData.hateNumber = [NSString stringWithFormat:@"%i",[paperData.hateNumber intValue] + 1];
                paperData.isLoveOrHate = NO;
            } completion:^(BOOL finished) {
                
                [cell.animationLabel removeFromSuperview];
                [otherSelf reloadData];
            }];
        }

        
    }];
    
    #pragma mark  实现分享
    [cell.shareView setPassBlock:^(){
        
        /**
         *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
         *
         *	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
         *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
         *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝）
         *	@param 	title 	标题（QQ空间、人人、微信、QQ）
         *	@param 	url 	链接（QQ空间、人人、instapaper、微信、QQ）
         *	@param 	description 	主体内容（人人）
         *	@param 	mediaType 	分享类型（QQ、微信）
         *
         *	@return	分享内容对象
         */
        //  拼接段子的内容和网页链接
        NSString * content = [[paperData.paperText stringByAppendingString:[NSString stringWithFormat:@"[%@",paperData.commentUrl]] stringByAppendingString:@"]"];
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@"这个人比较懒,目前什么都木有写"
                                                    image:nil
                                                    title:@"逗乐玩"
                                                      url:paperData.commentUrl
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
                                        paperData.shareNumber = [NSString stringWithFormat:@"%i",[paperData.shareNumber intValue] + 1];
                                        
                                        //  切记,tableView上数据要主动刷新,只要希望更改后能显示新数据的地方都要刷新
                                        [self reloadData];
                                        
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        //NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
                
    }];
    
    #pragma mark 评论
    [cell.discussView setPassBlock:^(){
    
        if ([paperData.discussNumber isEqualToString:@"0"]) {
            
            _HUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:_HUD];
            _HUD.dimBackground = YES;
            _HUD.labelText = @"暂无评论";
            [_HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1.0);
            } completionBlock:^{
                [_HUD removeFromSuperview];
                [_HUD release];
                _HUD = nil;

            }];
        } else {
            
            if (_pushCommitView) {
                
                _pushCommitView(paperData.commentUrl);
                
            }
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - 创建Base提示框
- (void)createBaseMBProgressHUDWithText:(NSString *)text withMode:(MBProgressHUDMode)mode withImageName:(NSString *)imageName{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    _HUD.dimBackground = YES;
    //  提示文字
    _HUD.labelText = text;
    //  提示框类型
    _HUD.mode = mode;
    _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
}

#pragma mark - 本地举报提示
- (void)reportAlertView{

    _HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在举报";
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        // 清除缓存
       
        
    } completionBlock:^{
        
        [_HUD removeFromSuperview];
        [_HUD release];
        _HUD = nil;
        
        _HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:_HUD];
        _HUD.dimBackground = YES;
        _HUD.labelText = @"举报成功,谢谢您的参与";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] autorelease];
        [_HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            
            [_HUD removeFromSuperview];
            [_HUD release];
            _HUD = nil;
        }];
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
