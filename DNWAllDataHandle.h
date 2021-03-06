//
//  DNWAllDataHandle.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-11.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReposePaperArrayBlock)(NSMutableArray *);

typedef void(^ReposeVideoArrayBlock)(NSMutableArray *);

typedef void(^ReposeThirdVideoAddArrayBlock)(NSMutableArray *);

typedef void (^ReposeImageArrayBlock)(NSMutableArray*);

@interface DNWAllDataHandle : NSObject

@property (nonatomic,copy) ReposePaperArrayBlock reposeDataBlock;
//第二页（图片页面）的属性
@property(nonatomic,retain)NSURLConnection *connection;

@property (nonatomic,copy) ReposeImageArrayBlock reposeImageDataBlock;


@property (nonatomic,copy) ReposeVideoArrayBlock reposeVideoDataBlock;

@property (nonatomic,copy) ReposeThirdVideoAddArrayBlock reposeThirdVideoAddDataBlock;

//@property (nonatomic,copy) NSMutableArray * allVideoDataArray;
/**
 *  创建一个数据操作的单例对象
 *
 *  @return 单例对象
 */
+(DNWAllDataHandle *)sharedInstance;

/**
 *  获得所有段子对象的数组
 *
 *  @param urlString 数据接口网址
 */
- (void)getAllPaperDataWithUrl:(NSString *)urlString;
/**
 *  获得所有图片对象的数组
 *
 *  @param urlString 数据接口网址
 */
- (void)getAllImageDataWithUrl:(NSString *)urlString;
/**
 *  获取所有视频对象的数组
 *
 *  @param urlString 数据接口网址
 */
- (void)getAllThirdDataWithUrl:(NSString *)urlString;

/**
 *  获取加载所有对象数组
 *
 *  @param urlString 数据接口网址
 */
- (void)getallThirdAddDataWithUrl:(NSString *)urlString;




@end
