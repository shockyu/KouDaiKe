//
//  YKLUserModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/21.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserModel.h"

@implementation YKLUserModel

+ (YKLUserModel *)defUserModel {
    static YKLUserModel *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[YKLUserModel alloc] init];
    });
    return userModel;
}

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    
   
    self.userID = [dicData objectForKey:@"id"];
    self.userName = [dicData objectForKey:@"username"];
    self.mobile = [dicData objectForKey:@"mobile"];
    self.shopName = [dicData objectForKey:@"shop_name"];
    self.address = [dicData objectForKey:@"address"];
    self.street = [dicData objectForKey:@"street"];
    self.servicTel = [dicData objectForKey:@"servic_tel"];
    self.lianxiren = [dicData objectForKey:@"lianxiren"];
    self.identityCard = [dicData objectForKey:@"identity_card"];
    self.license = [dicData objectForKey:@"license"];
    self.agentCode = [dicData objectForKey:@"agent_code"];
    self.alipayName = [dicData objectForKey:@"alipay_name"];
    self.alipayAccount = [dicData objectForKey:@"alipay_account"];
    self.status = [dicData objectForKey:@"status"];
    self.activityNum = [dicData objectForKey:@"activity_num"];

    return self;
}
@end
