//
//  YKLShopRecommendModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/16.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLShopRecommendModel.h"

@implementation YKLShopRecommendModel

+ (YKLShopRecommendModel *)defShopRecommendModel{
    static YKLShopRecommendModel *shopInfoModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shopInfoModel = [[YKLShopRecommendModel alloc] init];
    });
    return shopInfoModel;
}


- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    
    self.bonus = [dicData objectForKey:@"bonus"];
    self.tjSMSNum = [dicData objectForKey:@"tj_sms_num"];
    self.tjShopTotal = [dicData objectForKey:@"tj_shop_total"];
    self.tjAuthorizationNum = [dicData objectForKey:@"tj_authorization_num"];
    self.URL = [dicData objectForKey:@"url"];
    
    return self;
}
@end
