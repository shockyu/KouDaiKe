//
//  TJRequestManager.m
//  TuJing
//
//  Created by willbin on 14-7-27.
//  Copyright (c) 2014年 willbin. All rights reserved.
//

#import "TJRequestManager.h"

@implementation TJRequestManager

+ (instancetype)sharedManagerWithToken
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //超时设置 统一入口
    manager.requestSerializer.timeoutInterval = 15;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    
//    // 添加id openidfa
//    NSString *openIDFAStr = [QTXUserDataModel objectForDestKey:OpenIDFAKey];
//    if (!openIDFAStr.length)
//    {
//        openIDFAStr = [OpenIDFA sameDayOpenIDFA];
//        if (openIDFAStr.length)
//        {
//            [QTXUserDataModel setObject:openIDFAStr forDestKey:OpenIDFAKey];
//        }
//    }
//    if (openIDFAStr.length)
//    {
//        [manager.requestSerializer setValue:openIDFAStr forHTTPHeaderField:@"device_id"];
//    }
//    
//    // 添加devicetoken
//    NSString *dTokenStr = [QTXUserDataModel objectForDestKey:DeviceTokenKey];
//    if (dTokenStr.length)
//    {
//        [manager.requestSerializer setValue:dTokenStr forHTTPHeaderField:@"device_token"];
//    }
//
//    // 添加token信息 uid信息
//    NSString *tokenStr  = [QTXUserManager userTokenString];
//    NSString *uidStr  = [QTXUserManager userIDString];
//    if (tokenStr && uidStr)
//    {        
//        [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"user_token"];
//        [manager.requestSerializer setValue:uidStr forHTTPHeaderField:@"user_id"];
//    }

 
 

    return (TJRequestManager *)manager;
}

@end
