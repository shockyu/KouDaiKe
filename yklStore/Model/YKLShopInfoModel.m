//
//  YKLShopInfoModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/10/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLShopInfoModel.h"

@implementation YKLShopInfoModel

+ (YKLShopInfoModel *)defShopInfoModel {
    static YKLShopInfoModel *shopInfoModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shopInfoModel = [[YKLShopInfoModel alloc] init];
    });
    return shopInfoModel;
}

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    
    self.userID = [dicData objectForKey:@"id"];
    self.userName = [dicData objectForKey:@"username"];
    self.mobile = [dicData objectForKey:@"mobile"];
    self.shopName = [dicData objectForKey:@"shop_name"];
    self.address = [dicData objectForKey:@"address"];
    self.street = [dicData objectForKey:@"street"];
    self.servicTel = [dicData objectForKey:@"service_tel"];
    self.lianxiren = [dicData objectForKey:@"lianxiren"];
    self.identityCard = [dicData objectForKey:@"identity_card"];
    self.license = [dicData objectForKey:@"license"];
    self.shopQRCode = [dicData objectForKey:@"qr_code"];
    self.agentCode = [dicData objectForKey:@"agent_code"];
    
    NSDictionary *agentDic = [dicData objectForKey:@"agent"];
    self.agentName = [agentDic objectForKey:@"agent_name"];
    self.agentMobile = [agentDic objectForKey:@"mobile"];
    self.status = [dicData objectForKey:@"status"];
    self.activityNum = [dicData objectForKey:@"activity_num"];
    
    return self;
}

@end
