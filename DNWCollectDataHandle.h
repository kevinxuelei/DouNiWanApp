//
//  DNWCollectDataHandle.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-20.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DNWPaperData;
@class DNWOneCellDataForSecondView;
@class DNWThirdData;
@class FMDatabase;
@interface DNWCollectDataHandle : NSObject

/**
 *  database 定义一个 FMDatabase 对象
 */
@property (nonatomic,retain)FMDatabase * database;

/**
 *  单例模式
 *
 *  @return DNWCollectDataHandle的单例对象
 */
+ (DNWCollectDataHandle *)shareInstance;


/**
 *  删除段子数据
 *
 *  @param paper 段子对象
 */
- (void)deletePaperDataFromDataBase:(DNWPaperData *)paper;

/**
 *  添加段子数据
 *
 *  @param paper 段子对象
 */
- (void)insertIntoPaperDataWithUserInfoId:(DNWPaperData *)paper;

/**
 *  查询所有段子数据
 *
 *  @return 段子数据所在数组
 */
- (NSMutableArray *)selectAllPaperDataFromDataBase;

/**
 *  根据ID查询段子对象是否已经存在
 *
 *  @param  id
 *
 *  @return 对应的段子对象
 */
- (BOOL)selectPaperDataWithId:(NSString *)ID;


/**
 *  建立数组储存已经收藏的视频
 *
 *  @param  allThirdDataArray
 *
 *  @return 所有的已经储存的对象
 */
@property (nonatomic,retain)NSMutableArray *allThirdDataArray;
/**
 *  添加视频数据
 *
 *  @param DNWThirdData 视频数据
 */
- (void)insertNewDNWThirdData:(DNWThirdData *)DNWThirdData;

/**
 *  删除数据
 *
 *  @param DNWThirdData 删除视频数据
 */
- (void)deleteDNWThirdData:(DNWThirdData *)DNWThirdData;

/**
 *  查询
 *
 *  @return 查询数组查找需要的数据
 */
- (NSMutableArray *)selectAllDNWThirdData;

/**
 *  判断是否已经存在
 *
 *  @param Id Id
 *
 *  @return 对应Id的视频
 */
- (BOOL)electThirdDataWithId:(NSString *)Id;

- (void)insertIntoImageDataWithUserInfoId:(DNWOneCellDataForSecondView *)image;//添加图片数据
- (void)deleteImageDataFromDataBase:(DNWOneCellDataForSecondView *)image;//删除图片数据
- (NSMutableArray *)selectAllImageDataFromDataBase;//查询图片数据
- (BOOL)selectImageDataWithId:(NSString *)ID;//根据条件查询图片数据

@end






