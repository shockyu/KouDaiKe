//
//  YKLUserSynchronizationModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserSynchronizationModel.h"

@implementation YKLUserSynchronizationModel
+ (YKLUserSynchronizationModel *)defUserModel {
    static YKLUserSynchronizationModel *userSynchronizationModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userSynchronizationModel = [[YKLUserSynchronizationModel alloc] init];
    });
    return userSynchronizationModel;
}

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    
    self.todayExposure = [[dicData objectForKey:@"today_exposure"] isEqual:@""]?@"0":[[dicData objectForKey:@"today_exposure"] objectForKey:@"exposure_num"];
    
    self.redFlowDesc = [dicData objectForKey:@"red_flow_desc"];
    
    self.expoArray = [dicData objectForKey:@"month_exposure"];

    if ([[dicData objectForKey:@"agent"] isEqual:@[]]) {
        
        self.registerAgentCode = @"";
        self.agentName = @"";
        self.agentMobile = @"";
        self.agentAddress = @"";
        self.agentHeaderURL = @"";
        
    }else{
        
        self.agentDic = [dicData objectForKey:@"agent"];
        self.registerAgentCode = [self.agentDic objectForKey:@"code"];
        self.agentName = [self.agentDic objectForKey:@"agent_name"];
        self.agentMobile = [self.agentDic objectForKey:@"mobile"];
        self.agentAddress = [self.agentDic objectForKey:@"address"];
        self.agentHeaderURL = [self.agentDic objectForKey:@"head_img"];
    }
    
    self.shopDic = [dicData objectForKey:@"shop"];
    
    self.userID = [self.shopDic objectForKey:@"id"];
    self.userName = [self.shopDic objectForKey:@"username"];
    self.mobile = [self.shopDic objectForKey:@"mobile"];
    self.shopName = [self.shopDic objectForKey:@"shop_name"];
    self.shopQRCode = [self.shopDic objectForKey:@"qr_code"];
    self.address = [self.shopDic objectForKey:@"address"];
    self.street = [self.shopDic objectForKey:@"street"];
    self.servicTel = [self.shopDic objectForKey:@"service_tel"];
    self.lianxiren = [self.shopDic objectForKey:@"lianxiren"];
    self.identityCard = [self.shopDic objectForKey:@"identity_card"];
    self.license = [self.shopDic objectForKey:@"license"];
    self.agentCode = [self.shopDic objectForKey:@"agent_code"];
    self.alipayName = [self.shopDic objectForKey:@"alipay_name"];
    self.alipayAccount = [self.shopDic objectForKey:@"alipay_account"];
    self.status = [self.shopDic objectForKey:@"status"];
    self.activityNum = [self.shopDic objectForKey:@"activity_num"];
    self.unpublishedNum = [self.shopDic objectForKey:@"unpublished_num"];
    self.completeNum = [self.shopDic objectForKey:@"complete_num"];
    self.ongoingNum = [self.shopDic objectForKey:@"ongoing_num"];
    self.smsNum = [self.shopDic objectForKey:@"sms_num"];
    self.shopSale = [self.shopDic objectForKey:@"shop_sale"];
    self.shopVol = [self.shopDic objectForKey:@"shop_vol"];
    self.shopExposureNum = [self.shopDic objectForKey:@"shop_exposure_num"];
    self.isVip = [self.shopDic objectForKey:@"is_vip"];
    self.money = [self.shopDic objectForKey:@"money"];
    self.headImg = [self.shopDic objectForKey:@"head_img"];
    
    self.purview = [self.shopDic objectForKey:@"purview"];
    
    NSString* time = [self.shopDic objectForKey:@"vip_end_time"];
    
    if ([time isEqual:[NSNull null]]||[time isKindOfClass:[NSNull class]]||time==nil) {
        
        self.vipEnd = @"暂未开通";
    }
    else
    {
        self.vipEnd = [time timeNumber];
    
    }
    
    
    return self;
}


@end
