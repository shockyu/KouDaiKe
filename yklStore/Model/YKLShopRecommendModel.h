//
//  YKLShopRecommendModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/16.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLShopRecommendModel : YKLBaseModel

@property (nonatomic, copy) NSString *bonus;                //奖金总额
@property (nonatomic, copy) NSString *tjSMSNum;             //推荐奖励短信条数
@property (nonatomic, copy) NSString *tjShopTotal;          //推荐商户总数
@property (nonatomic, copy) NSString *tjAuthorizationNum;   //推荐授权数量
@property (nonatomic, copy) NSString *URL;                  //分享页面链接


+ (YKLShopRecommendModel *)defShopRecommendModel;
@end
