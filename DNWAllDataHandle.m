//
//  DNWAllDataHandle.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-11.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWAllDataHandle.h"
#import "HMTMyCustomNetRequest.h"
#import "DNWPaperData.h"
#import "DNWThirdData.h"
#import "DNWOneCellDataForSecondView.h"
#import "Reachability.h"
#import "DXAlertView.h"
#import "DNWAppDelegate.h"

@interface DNWAllDataHandle (){

    HMTMyCustomNetRequest * _request;

}

@property (nonatomic,retain)Reachability * reach;
@property (nonatomic,retain)Reachability * wifiReach;
@property (nonatomic,retain)Reachability * threeGReach;

@end

@implementation DNWAllDataHandle

- (void)dealloc{

    RELEASE_SAFELY(_wifiReach);
    RELEASE_SAFELY(_threeGReach);
    RELEASE_SAFELY(_reach);
    RELEASE_SAFELY(_request);
    Block_release(_reposeDataBlock);
    Block_release(_reposeImageDataBlock);
    [super dealloc];

}

static  DNWAllDataHandle * shareDataHandle = nil;
+(DNWAllDataHandle *)sharedInstance{
    
    @synchronized(self){
        
        if(shareDataHandle == nil){
            
            shareDataHandle = [[self alloc] init] ;
        }
    }
    
    return shareDataHandle;
}

#pragma mark - 请求段子数据
- (void)getAllPaperDataWithUrl:(NSString *)urlString{

    //  网络监测
    //self.reach = [Reachability reachabilityWithHostName:HostName];
    //self.reach = [Reachability reachabilityForLocalWiFi];
    //DNWAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    //int staus = appDelegate.statusValue;
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    self.threeGReach = [Reachability reachabilityForInternetConnection];
    if (([_wifiReach currentReachabilityStatus] == NotReachable) && ([_threeGReach currentReachabilityStatus] == NotReachable)) {
        
    }else{
   
        NSMutableArray * allPaperArray = [NSMutableArray array];
        
        _request = [[HMTMyCustomNetRequest alloc] init];
        
        [_request setFinishLoadBlock:^(NSData * date){
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * listArray = [dic objectForKey:@"list"];
            
            for (int i = 0; i < [listArray count]; i++) {
                
                DNWPaperData * paper = [[DNWPaperData alloc] initWithDictionary:[listArray objectAtIndex:i]];
                [allPaperArray addObject:paper];
                [paper release];
            }
            // 数据请求完成后,利用一个block返回数据给tableView赋值
            if (_reposeDataBlock) {
                _reposeDataBlock(allPaperArray);
                
            }
        }];
        
        [_request requestForGETWithUrl:urlString];
        
    }
   
    
}
- (void)getAllImageDataWithUrl:(NSString *)urlString{
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    self.threeGReach = [Reachability reachabilityForInternetConnection];
    if (([_wifiReach currentReachabilityStatus] == NotReachable) && ([_threeGReach currentReachabilityStatus] == NotReachable)) {
        
    }else{
        
        NSMutableArray * allImageDataArray = [NSMutableArray array];
        
        _request = [[HMTMyCustomNetRequest alloc] init];
        
        [_request setFinishLoadBlock:^(NSData * date){
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * listArray = [dic objectForKey:@"list"];
            
            for (int i = 0; i < [listArray count]; i++) {
                
                DNWOneCellDataForSecondView * image = [[DNWOneCellDataForSecondView alloc] initWithDictionary:[listArray objectAtIndex:i]];
                [allImageDataArray addObject:image];
                [image release];
            }
            // 数据请求完成后,利用一个block返回数据给tableView赋值
            if (_reposeImageDataBlock) {
                _reposeImageDataBlock(allImageDataArray);
            }
        }];
        
        [_request requestForGETWithUrl:urlString];
    }
}

- (void)getAllThirdDataWithUrl:(NSString *)urlString{
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    self.threeGReach = [Reachability reachabilityForInternetConnection];
    if (([_wifiReach currentReachabilityStatus] == NotReachable) && ([_threeGReach currentReachabilityStatus] == NotReachable)) {
       
    }else{
        
        NSMutableArray *array = [NSMutableArray array];
        
        _request = [[HMTMyCustomNetRequest alloc] init];
        
        [_request requestForGETWithUrl:urlString];
        
        [_request setFinishLoadBlock:^(NSData * data){
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * rowsArray = [dic objectForKey:@"rows"];
            
            for (int i = 0; i<[rowsArray count]; i++) {
                
                DNWThirdData *thirdData = [[DNWThirdData alloc]initWithNSDictionary:[rowsArray objectAtIndex:i]];
                
                [array addObject:thirdData];
                
                [thirdData release];
            }
            
            if (_reposeVideoDataBlock) {
                _reposeVideoDataBlock(array);
            }
            
        }];
    }
   
}

- (void)getallThirdAddDataWithUrl:(NSString *)urlString
{
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    self.threeGReach = [Reachability reachabilityForInternetConnection];
    if (([_wifiReach currentReachabilityStatus] == NotReachable) && ([_threeGReach currentReachabilityStatus] == NotReachable)) {
        
    }else{
        
        NSMutableArray *array = [NSMutableArray array];
        
        _request = [[HMTMyCustomNetRequest alloc] init];
        
        [_request requestForGETWithUrl:urlString];
        
        [_request setFinishLoadBlock:^(NSData * data){
            
            NSArray * rowsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            for (int i = 0; i<[rowsArray count]; i++) {
                
                DNWThirdData *thirdData = [[DNWThirdData alloc]initWithNSDictionary:[rowsArray objectAtIndex:i]];
                
                [array addObject:thirdData];
                
                [thirdData release];
            }
            
            if (_reposeThirdVideoAddDataBlock) {
                _reposeThirdVideoAddDataBlock(array);
            }
            
        }];
    }

}

#pragma mark - 网络检测提醒
- (void)netWorkDetectionAlert{

    DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alert show];
    alert.rightBlock = ^() {
    };
    [alert release];


}



@end
























