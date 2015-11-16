//
//  HMTMyCustomNetRequest.h
//  网络封装
//
//  Created by lanou3g on 14-4-23.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MyBlock)(NSData *);

@interface HMTMyCustomNetRequest : NSObject

@property (nonatomic,copy)MyBlock finishLoadBlock;


// GET请求方式
- (void)requestForGETWithUrl:(NSString *)urlString;

// POST请求方式
- (void)requestForPOSTWithUrl:(NSString *)urlString postData:(NSData *)data;




@end
