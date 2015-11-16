//
//  SecondPictureView.m
//  DouNiWan
//
//  Created by apple on 14-5-17.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "SecondPictureView.h"
#import "DNWSecondViewTableViewCell.h"
#import "DNWOneCellDataForSecondView.h"
#import "MJRefreshBaseView.h"
#import "DNWAllDataHandle.h"
#import "HMTMyCustomNetRequest.h"
#import "DNWCollectDataHandle.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "DXAlertView.h"
#import "CustomAlertView.h"

@interface SecondPictureView (){

    NSInteger page;

}

@property (nonatomic,retain)Reachability * reach;

@end

@implementation SecondPictureView
-(void)dealloc
{
    RELEASE_SAFELY(_reach);
    RELEASE_SAFELY(_dataArray);
    RELEASE_SAFELY(_receiveData);
    RELEASE_SAFELY(_receiveArray);
    RELEASE_SAFELY(_urlStr);
    RELEASE_SAFELY(_frontString);
    RELEASE_SAFELY(_backString);
    Block_release(_pushedBlock);
    RELEASE_SAFELY(_cellData);
    RELEASE_SAFELY(_HUD);
    [_header free];
    [_footer free];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark - 实现一个tableView多用的初始化方法
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style urlString:(NSString *)urlString{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.dataArray = [NSMutableArray array];
        self.receiveArray = [NSMutableArray array];
        page = 1;
        // 通过数据操作类,解析JSON数据,返回数组
        [[DNWAllDataHandle sharedInstance] getAllImageDataWithUrl:urlString];
        __block SecondPictureView * otherSelf = self;
        [[DNWAllDataHandle sharedInstance] setReposeImageDataBlock:^(NSMutableArray * dataArray){
            otherSelf.dataArray = dataArray;
            // 请求到数据后,一定要刷新tableView,因为空白的Cell出现在你请求数据之前,要手动刷新
            [otherSelf reloadData];
            
        }];
        //  cell之间分割线样式
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self refreshFromHeadViewOfBlock];
        [self refreshFromFootViewOfBlock];
    }
    return self;
}

#pragma mark - 下拉刷新
- (void)refreshFromHeadViewOfBlock{
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self;
    __block SecondPictureView * otherSelf = self;
    [_header setBeginRefreshingBlock:^(MJRefreshBaseView * refreshView){
        
        NSString * urlString = [[otherSelf.frontString stringByAppendingString:[NSString stringWithFormat:@"%i",page]] stringByAppendingString:otherSelf.backString];
       
        [[DNWAllDataHandle sharedInstance] getAllImageDataWithUrl:urlString];
        [[DNWAllDataHandle sharedInstance]setReposeImageDataBlock:^(NSMutableArray * dataArray){
            otherSelf.receiveArray = dataArray;
            otherSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
            [otherSelf reloadData];
            // 结束刷新
            [refreshView endRefreshing];
        
        }];
        
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
    [_header setEndStateChangeBlock:^(MJRefreshBaseView * refreshView){
        self.receiveArray = [NSMutableArray array];
        page = 1;
    }];
}
#pragma mark - 上拉加载
- (void)refreshFromFootViewOfBlock{
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self;
    __block SecondPictureView * otherSelf = self;
    [_footer setBeginRefreshingBlock:^(MJRefreshBaseView * refreshView){
        
    
        NSString * urlString = [[otherSelf.frontString stringByAppendingString:[NSString stringWithFormat:@"%i",page]] stringByAppendingString:otherSelf.backString];
        
        [[DNWAllDataHandle sharedInstance] getAllImageDataWithUrl:urlString];
        [[DNWAllDataHandle sharedInstance] setReposeImageDataBlock:^(NSMutableArray * dataArray){
            
            otherSelf.receiveArray = dataArray;
            
            for (int i = 0; i < [otherSelf.receiveArray count]; i++) {
                
                DNWOneCellDataForSecondView * lastPaper = [otherSelf.receiveArray objectAtIndex:i];
                DNWOneCellDataForSecondView * nowPaper = [otherSelf.dataArray objectAtIndex:i];
                
                if ([lastPaper.hostId doubleValue] != [nowPaper.hostId doubleValue]) {
                    
                    [otherSelf.dataArray addObject:lastPaper];
                }
            }

            [otherSelf reloadData];
            // 结束刷新
            [refreshView endRefreshing];
            
        }];
        
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
    [_footer setEndStateChangeBlock:^(MJRefreshBaseView * refreshView){
        self.receiveArray = [NSMutableArray array];
        page++;
        
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
  DNWSecondViewTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
    cell = [[[DNWSecondViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    DNWOneCellDataForSecondView * data1 = [self.dataArray objectAtIndex:indexPath.row];
    self.cellData = data1;
    
    if ([data1.discussCount intValue] <= 5) {
        data1.discussCount = @"0";
    }
    [cell initWith:data1];
    cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    
    [cell setAgreeBlock:^(){
        //设置喜欢Block
        
        if (data1.k == YES) {
            
            [cell changeCountAnimation:cell.agreeButton];
            [UIView animateWithDuration:0.5 animations:^{
                
                cell.animationLabel.transform = CGAffineTransformTranslate(cell.animationLabel.transform, 20, -20);
                cell.animationLabel.alpha = 0.0;
                    int number1 = [[NSString stringWithFormat:@"%@",data1.agreeCount]intValue];
                    number1 = number1+1;
                    data1.agreeCount = [NSString stringWithFormat:@"%d",number1];
                
                data1.k = NO;

            } completion:^(BOOL finished) {
                
                [cell.animationLabel removeFromSuperview];
                [self reloadData];
                
            }];
        }
        
        
    }];
    [cell setDisAgreeBlock:^(){
//        设置不喜欢Block
        if (data1.k == YES) {
            
            [cell changeCountAnimation:cell.disagreeButton];
            [UIView animateWithDuration:0.5 animations:^{
                cell.animationLabel.transform = CGAffineTransformTranslate(cell.animationLabel.transform, 20, -20);
                cell.animationLabel.alpha = 0.0;
                
                    int number = [[NSString stringWithFormat:@"%@",data1.disagreeCount]intValue];
                    number = number+1;
                    data1.disagreeCount = [NSString stringWithFormat:@"%d",number];
                
                data1.k = NO;
            } completion:^(BOOL finished) {
                
                [cell.animationLabel removeFromSuperview];
                                [self reloadData];
                
            }];
        }
        
    }];
    [cell setShareBlock:^(){
        NSString * content = self.cellData.shareUrl;
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
                                       self.cellData.shareCount = [NSString stringWithFormat:@"%i",[data1.shareCount intValue] + 1];
                                        
                                        //  切记,tableView上数据要主动刷新,只要希望更改后能显示新数据的地方都要刷新
                                        [self reloadData];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        //NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                    }];
    }];
    [cell setDiscusseBlock:^(){
//        设置评论block
        if ([data1.discussCount isEqualToString:@"0"]) {
            
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
            if (_pushedBlock) {
                _pushedBlock(data1.shareUrl);
            }
        }
    }];
    
    __block SecondPictureView * otherSelf = self;
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
    if ([[DNWCollectDataHandle shareInstance] selectImageDataWithId:data1.hostId] == YES) {
         [cell.collectionButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    }else{
         [cell.collectionButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
    }
    [cell setCollectionBlock:^(){
        
        // 设置收藏block

        
            if ([[DNWCollectDataHandle shareInstance] selectImageDataWithId:data1.hostId]== NO) {
                
                [self createBaseMBProgressHUDWithText:@"收藏成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [_HUD release];
                    _HUD = nil;
                    [[DNWCollectDataHandle  shareInstance] insertIntoImageDataWithUserInfoId:data1];
                    [cell.collectionButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                    
                }];
                
            } else {
                
                [self createBaseMBProgressHUDWithText:@"取消成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [_HUD release];
                    _HUD = nil;
                    [[DNWCollectDataHandle shareInstance] deleteImageDataFromDataBase:data1];
                    [cell.collectionButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
                }];

            }
        }];

    return cell;
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DNWSecondViewTableViewCell *cell = [[[DNWSecondViewTableViewCell alloc]init]autorelease];
    DNWOneCellDataForSecondView *cellData = [self.dataArray objectAtIndex:indexPath.row];
    return  [DNWSecondViewTableViewCell returnRowHighWith:cellData];
}

@end
