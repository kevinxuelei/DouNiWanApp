//
//  DNWCollectDataHandle.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-20.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWCollectDataHandle.h"
#import "FMDB.h"
#import "DNWPaperData.h"
#import "DNWThirdData.h"

#import "DNWOneCellDataForSecondView.h"

@implementation DNWCollectDataHandle

- (void)dealloc{

    RELEASE_SAFELY(_database);
    [super dealloc];
}

static DNWCollectDataHandle * _dbHandle = nil;
+ (DNWCollectDataHandle *)shareInstance{
    
    @synchronized(self){
        
        if (!_dbHandle) {
            
            _dbHandle = [[DNWCollectDataHandle alloc]init];
            
            [_dbHandle openDataBase];
            
            [_dbHandle createPaperTable];
            [_dbHandle createImageTable];
            [_dbHandle createVideo];
        }
    }
    
    return _dbHandle;
}


#pragma mark - 获得沙盒文件下Documents路径
- (NSString *)getDocumentsPath{
    
    NSString * documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return documents;
}


#pragma mark - 打开数据库操作------ databaseWithPath   open
- (void)openDataBase{
    
    if (_database) {
        return;
    }
    
    NSString * DataBasePath = [[self getDocumentsPath] stringByAppendingPathComponent:@"doulewan.sqlite"];
    
    self.database = [FMDatabase databaseWithPath:DataBasePath];
    if (![_database open]) {
        
        //NSLog(@"打开数据库失败");
    }
    
    // 为数据库设置缓存,提高查询效率
    _database.shouldCacheStatements = YES;
    
    //NSLog(@"打开数据库成功");
}

#pragma mark - 关闭数据库操作
- (void)closeDataBase{
    
    if (![_database close]) {
        //NSLog(@"关闭数据库失败");
        return;
    }
    
    _database = nil;
    //NSLog(@"关闭数据库成功");
    
}

/******************************************段子***********************************************************************/
 #pragma mark - 管理创建表的操作
- (void)createPaperTable{
    
    [self openDataBase];
    
    // 判断表是否存在,不存在就创建------ tableExists
    if (![_database tableExists:@"Paper"]) {
        
        [_database executeUpdate:@"CREATE TABLE Paper(id TEXT PRIMARY KEY, imageUrl TEXT,name TEXT, time TEXT,paperText TEXT,loveNumber TEXT,hateNumber TEXT,shareNumber TEXT,discussNumber TEXT,comment TEXT,isLoveOrHate INTEGER)"];
        
        //NSLog(@"创建表成功");
    }
    
    [self closeDataBase];
}

#pragma mark - 增加数据操作----- executeUpdate
- (void)insertIntoPaperDataWithUserInfoId:(DNWPaperData *)paper{
    
    [self openDataBase];
    
    [_database executeUpdate:@" INSERT INTO Paper (id,imageUrl,name,time,paperText,loveNumber,hateNumber,shareNumber,discussNumber,comment,isLoveOrHate) VALUES (?,?,?,?,?,?,?,?,?,?,?)",paper.hostId,paper.hostImageUrl,paper.hostName,paper.passTime,paper.paperText,paper.favouriteNumber,paper.hateNumber,paper.shareNumber,paper.discussNumber,paper.commentUrl,[NSString stringWithFormat:@"%i",paper.isLoveOrHate]];
    [self closeDataBase];
}

#pragma mark - 删除数据操作----- executeUpdate
- (void)deletePaperDataFromDataBase:(DNWPaperData *)paper{
    
    [self openDataBase];
    
    [_database executeUpdate:@" DELETE FROM Paper WHERE id = ?",paper.hostId];
    
    [self closeDataBase];
}


#pragma mark - 查询数据操作(与其他的都不一样,查询是调用executeQuery,切记切记!!!!!!)
- (NSMutableArray *)selectAllPaperDataFromDataBase{
    
    [self openDataBase];
    
    NSMutableArray * allDataArray = [NSMutableArray array];
    
    FMResultSet * resultSet = [_database executeQuery:@" SELECT * FROM Paper"];
    while ([resultSet next]) {
        
        DNWPaperData * paperData    = [[DNWPaperData alloc] init];
        paperData.hostId            = [resultSet stringForColumn:@"id"];
        paperData.hostImageUrl      = [resultSet stringForColumn:@"imageUrl"];
        paperData.hostName          = [resultSet stringForColumn:@"name"];
        paperData.passTime          = [resultSet stringForColumn:@"time"];
        paperData.paperText         = [resultSet stringForColumn:@"paperText"];
        paperData.favouriteNumber   = [resultSet stringForColumn:@"loveNumber"];
        paperData.hateNumber        = [resultSet stringForColumn:@"hateNumber"];
        paperData.shareNumber       = [resultSet stringForColumn:@"shareNumber"];
        paperData.discussNumber     = [resultSet stringForColumn:@"discussNumber"];
        paperData.commentUrl        = [resultSet stringForColumn:@"comment"];
        paperData.isLoveOrHate      = [resultSet intForColumn:@"isLoveOrHate"];

        [allDataArray addObject:paperData];
        [paperData release];
    }
    
    [self closeDataBase];
    return allDataArray;
}

#pragma mark - 根据单个条件查询数据
- (BOOL)selectPaperDataWithId:(NSString *)ID{

    [self openDataBase];
    FMResultSet * resultSet = [_database executeQuery:@"SELECT * FROM Paper Where id = ?",ID];
    
    while ([resultSet next]) {
        
        //  在返回数据前先关闭数据库
        [self closeDataBase];
        return YES;
    }
    
    [self closeDataBase];
    return NO;
}
/******************************************图片****************************************************/
#pragma mark - 管理创建表的操作
- (void)createImageTable{
    
    [self openDataBase];
    
    // 判断表是否存在,不存在就创建------ tableExists
    if (![_database tableExists:@"Image"]) {
        
        [_database executeUpdate:@"CREATE TABLE Image(id TEXT PRIMARY KEY, imageUrl TEXT,name TEXT, time TEXT,titleText TEXT,mainImage TEXT,mainImageWidth TEXT,mainImageHigh TEXT,loveNumber TEXT,hateNumber TEXT,shareNumber TEXT,discussNumber TEXT,comment TEXT,isLoveOrHate INTEGER)"];

        //NSLog(@"创建表成功");
    }
    
    
    [self closeDataBase];
}

#pragma mark - 增加数据操作----- executeUpdate
- (void)insertIntoImageDataWithUserInfoId:(DNWOneCellDataForSecondView *)image{
    
    [self openDataBase];
    
    [_database executeUpdate:@" INSERT INTO Image (id,imageUrl,name,time,titleText,mainImage,mainImageWidth,mainImageHigh,loveNumber,hateNumber,shareNumber,discussNumber,comment,isLoveOrHate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",image.hostId,image.iconImageUrl,image.nameString,image.timeString,image.titleString,image.mainImageUrl,image.mainImageWidth,image.mainImageHigh,image.agreeCount,image.disagreeCount,image.shareCount,image.discussCount,image.shareUrl,[NSString stringWithFormat:@"%i",image.k]];
    
    [self closeDataBase];
}

#pragma mark - 删除数据操作----- executeUpdate
- (void)deleteImageDataFromDataBase:(DNWOneCellDataForSecondView *)image{
    
    [self openDataBase];
    
    [_database executeUpdate:@" DELETE FROM Image WHERE id = ?",image.hostId];
    
    [self closeDataBase];
}


#pragma mark - 查询数据操作(与其他的都不一样,查询是调用executeQuery,切记切记!!!!!!)
- (NSMutableArray *)selectAllImageDataFromDataBase{
    
    [self openDataBase];
    
    NSMutableArray * allDataArray = [NSMutableArray array];
    
    FMResultSet * resultSet = [_database executeQuery:@" SELECT * FROM Image"];
    while ([resultSet next]) {
        
        DNWOneCellDataForSecondView * imageData  = [[DNWOneCellDataForSecondView alloc] init];
        imageData.hostId            = [resultSet stringForColumn:@"id"];
        imageData.iconImageUrl      = [resultSet stringForColumn:@"imageUrl"];
        imageData.nameString        = [resultSet stringForColumn:@"name"];
        imageData.timeString        = [resultSet stringForColumn:@"time"];
        imageData.titleString       = [resultSet stringForColumn:@"titleText"];
        imageData.mainImageUrl      = [resultSet stringForColumn:@"mainImage"];
//        添加图片高度和宽度
        imageData.mainImageWidth    = [resultSet stringForColumn:@"mainImageWidth"];
        imageData.mainImageHigh     = [resultSet stringForColumn:@"mainImageHigh"];
        
        imageData.agreeCount        = [resultSet stringForColumn:@"loveNumber"];
        imageData.disagreeCount     = [resultSet stringForColumn:@"hateNumber"];
        imageData.shareCount        = [resultSet stringForColumn:@"shareNumber"];
        imageData.discussCount      = [resultSet stringForColumn:@"discussNumber"];
        imageData.shareUrl          = [resultSet stringForColumn:@"comment"];
        imageData.k                 = [resultSet intForColumn:@"isLoveOrHate"];
        
        [allDataArray addObject:imageData];
        [imageData release];
    }
    
    [self closeDataBase];
    return allDataArray;
}

#pragma mark - 根据单个条件查询数据
- (BOOL)selectImageDataWithId:(NSString *)ID{
    
    [self openDataBase];
    FMResultSet * resultSet = [_database executeQuery:@"SELECT * FROM Image Where id = ?",ID];
    
    while ([resultSet next]) {
        
        //  在返回数据前先关闭数据库
        [self closeDataBase];
        return YES;
    }
    
    [self closeDataBase];
    return NO;
}





/******************************************视频***********************************************************************/
- (void)createVideo
{
    [self openDataBase];
    
    if (![_database tableExists:@"Video"]) {
        
        [_database executeUpdate:@"CREATE TABLE Video(Id TEXT PRIMARY KEY, mp4_url TEXT,pic TEXT, title TEXT,web_url TEXT,timeStr TEXT)"];
        
        NSLog(@"创建表成功");
    }
    
    [self closeDataBase];
    
}

#pragma mark ----添加数据操作-----
- (void)insertNewDNWThirdData:(DNWThirdData *)DNWThirdData
{
    [self openDataBase];
    
    [_database executeUpdate:@" INSERT INTO Video (Id,mp4_url,pic,title,web_url,timeStr) VALUES (?,?,?,?,?,?)",DNWThirdData.Id,DNWThirdData.mp4_url,DNWThirdData.pic,DNWThirdData.title,DNWThirdData.web_url,DNWThirdData.timeStr];
    
    [self closeDataBase];
    
}
#pragma mark----删除数据操作----
- (void)deleteDNWThirdData:(DNWThirdData *)DNWThirdData
{
    [self openDataBase];
    
    [_database executeUpdate:@" DELETE FROM Video WHERE Id = ?",DNWThirdData.Id];
    
    [self closeDataBase];
}
#pragma mark-----查找数据----
- (NSMutableArray *)selectAllDNWThirdData
{
    [self openDataBase];
    self.allThirdDataArray = [NSMutableArray array];
    FMResultSet * resultSet = [_database executeQuery:@" SELECT * FROM Video"];
    while ([resultSet next]) {
        
        DNWThirdData *VideoData = [[DNWThirdData alloc]init];
        VideoData.Id = [resultSet stringForColumn:@"Id"];
        VideoData.mp4_url = [resultSet stringForColumn:@"mp4_url"];
        VideoData.pic = [resultSet stringForColumn:@"pic"];
        VideoData.timeStr = [resultSet stringForColumn:@"timeStr"];
        VideoData.title = [resultSet stringForColumn:@"title"];
        VideoData.web_url = [resultSet stringForColumn:@"web_url"];
        [_allThirdDataArray addObject:VideoData];
        [VideoData release];
    }
    
    [self closeDataBase];
    return _allThirdDataArray;
}

#pragma mark-----根据Id查看对象是否已经存在----
- (BOOL)electThirdDataWithId:(NSString *)Id
{
    [self openDataBase];
    FMResultSet * resultSet = [_database executeQuery:@"SELECT * FROM Video Where Id = ?",Id];
    
    while ([resultSet next]) {
        
        [self closeDataBase];
        return YES;
    }
    
    [self closeDataBase];
    return NO;
    
}

@end





























