//
//  HMTMyCustomNetRequest.m
//  网络封装
//
//  Created by lanou3g on 14-4-23.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "HMTMyCustomNetRequest.h"

@interface HMTMyCustomNetRequest ()

@end

@implementation HMTMyCustomNetRequest

- (void)dealloc{
    
    Block_release(_finishLoadBlock);
    [super dealloc];
    
}

- (void)requestForGETWithUrl:(NSString *)urlString{
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (_finishLoadBlock) {
            
            _finishLoadBlock(data);
        }
        
        
    }];
    
}

- (void)requestForPOSTWithUrl:(NSString *)urlString postData:(NSData *)data{
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (_finishLoadBlock) {
            
            _finishLoadBlock(data);
        }
        
    }];

    
}


@end
