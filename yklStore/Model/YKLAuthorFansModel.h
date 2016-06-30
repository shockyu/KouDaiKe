//
//  YKLAuthorFansModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLAuthorFansModel : YKLBaseModel

@property (nonatomic, strong) NSString *userId;             //用户ID
@property (nonatomic, strong) NSString *nickName;           //联系人昵称
@property (nonatomic, strong) NSString *mobile;             //手机号码
@property (nonatomic, strong) NSString *shopName;           //店铺名
@property (nonatomic, strong) NSString *address;            //地址
@property (nonatomic, strong) NSString *street;             //街道
@property (nonatomic, strong) NSString *authorizationTime;  //授权时间

@end
