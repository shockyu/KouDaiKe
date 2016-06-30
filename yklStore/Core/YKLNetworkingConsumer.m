//
//  MPSNetworkingConsumer.m
//  MPStore
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLNetworkingConsumer.h"


@implementation YKLNetworkingConsumer

+ (ViewController *)viewControllerAlloct
{
    static ViewController *playingVC = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        playingVC = [[ViewController alloc] init];
    });
    return playingVC;
}

/// 获取注册验证码
+ (void)getRegistVCodeWithMobile:(NSString *)mobile
                         success:(void (^)(NSString *verificationCode))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:mobile forKey:@"mobile"];
    
    [self POST:@"get_vcode_login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

/// 登陆
+ (void)loginWithMobile:(NSString *)mobile
                  Vcode:(NSString *)vcode
                success:(void (^)(YKLUserModel *userModel))success
                failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:vcode forKey:@"vcode"];
    
//    [self POST:@"shop_login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        
//        success([[YKLUserModel defUserModel] updateWithDictionary:responseObject]);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(error);
//    }];
    
    [[self shareManager] POST:[ROOT_URL stringByAppendingString:@"shop_login"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
        if (responseCode == 1) {
            success([[YKLUserModel defUserModel] updateWithDictionary:[responseObject objectForKey:@"data"]]);
        }
        else {
            success(nil);
            [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
          
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(nil);
        
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(newError);
        
    }];
}

///注册
+ (void)registWithMobile:(NSString *)mobile
                  UserID:(NSString *)UserID
                ShopName:(NSString *)shopName
                 Address:(NSString *)address
                  Street:(NSString *)street
              ServiceTel:(NSString *)serviceTel
               Lianxiren:(NSString *)lianxiren
            IdentityCard:(NSString *)identityCard
                 License:(NSString *)license
               AgentCode:(NSString *)agentCode
              AlipayName:(NSString *)alipayName
           AlipayAccount:(NSString *)alipayAccount
                  QRcode:(NSString *)QRcode
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:UserID forKey:@"shop_id"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:shopName forKey:@"shop_name"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:street forKey:@"street"];
    [parameters setObject:serviceTel forKey:@"service_tel"];
    [parameters setObject:lianxiren forKey:@"lianxiren"];
    [parameters setObject:identityCard forKey:@"identity_card"];
    [parameters setObject:license forKey:@"license"];
    [parameters setObject:agentCode forKey:@"agent_code"];
    [parameters setObject:alipayName forKey:@"alipay_name"];
    [parameters setObject:alipayAccount forKey:@"alipay_account"];
    [parameters setObject:QRcode forKey:@"qr_code"];
    
    
    [self POST:@"save_shopInfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getSynchronizationWithUserID:(NSString *)UserID
                               Success:(void (^)(YKLUserSynchronizationModel *userSynchronizationModel))success
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:UserID forKey:@"shop_id"];
    
    //synchronization
    //synchronization_1
    [self POST:@"synchronization_1" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[YKLUserSynchronizationModel defUserModel] updateWithDictionary:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

+ (void)getTemplateWithType:(NSString *)type
                   TempCode:(NSString *)tempCode
                     cateID:(NSString *)cateIDStr
                    Success:(void (^)(NSArray *templateModel))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:tempCode forKey:@"temp_code"];
    [parameters setObject:cateIDStr forKey:@"category_id"];

    [self POST:@"get_template" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLTemplateModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLTemplateModel class] withData:responseObject]);
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)releaseActWithUserID:(NSString *)userID
               ActivityID:(NSString *)activityID
                    Title:(NSString *)title
                     Desc:(NSString *)desc
            OriginalPrice:(NSString *)originalPrice
                BasePrice:(NSString *)basePrice
               ProductNum:(NSString *)productNum
             StartBargain:(NSString *)startBargain
//               EndBargain:(NSString *)endBargain
          ActivityEndTime:(NSString *)activityEndTime
               RewardCode:(NSString *)rewardCode
               TemplateID:(NSString *)templateID
                   Status:(NSString *)status
                      Img:(NSString *)img
                     Type:(NSString *)type
                IsOverSms:(NSString *)isOverSms
            ShowBasePrice:(NSString *)showBasePrice
       OnlinePayPrivilege:(NSString *)onlinePayPrivilege
                  Success:(void (^)(NSDictionary *templateModel))success
                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:activityID forKey:@"activity_id"];
    [parameters setObject:title forKey:@"title"];
    [parameters setObject:desc forKey:@"desc"];
    [parameters setObject:originalPrice forKey:@"original_price"];
    [parameters setObject:basePrice forKey:@"base_price"];
    [parameters setObject:productNum forKey:@"product_num"];
    [parameters setObject:startBargain forKey:@"player_num"];
//    [parameters setObject:endBargain forKey:@"end_bargain"];
    [parameters setObject:activityEndTime forKey:@"activity_end_time"];
    [parameters setObject:rewardCode forKey:@"reward_code"];
    [parameters setObject:templateID forKey:@"template_id"];
    [parameters setObject:status forKey:@"status"];
    [parameters setObject:img forKey:@"img"];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:isOverSms forKey:@"is_over_sms"];
    [parameters setObject:showBasePrice forKey:@"show_base_price"];
    [parameters setObject:onlinePayPrivilege forKey:@"online_pay_privilege"];
    
    NSLog(@"%@",parameters);
    [self POST:@"release_activity" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)releaseBargainWithUserID:(NSString *)userID
                      ActivityID:(NSString *)activityID
                    StartBargain:(NSString *)startBargain
                      EndBargain:(NSString *)endBargain
                         Success:(void (^)(NSDictionary *templateModel))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:activityID forKey:@"activity_id"];
    [parameters setObject:startBargain forKey:@"start_bargain"];
    [parameters setObject:endBargain forKey:@"end_bargain"];
    [parameters setObject:@"interval" forKey:@"action"];//修改砍价区间时标识
    
    [self POST:@"release_activity" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)releaseActAndShareWithUserID:(NSString *)userID
                          ActivityID:(NSString *)activityID
                              Status:(NSString *)status
                             Success:(void (^)(NSDictionary *templateModel))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:activityID forKey:@"activity_id"];
    [parameters setObject:status forKey:@"status"];
    
    [self POST:@"release_activity" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)releaseWithUserID:(NSString *)userID
                   Status:(NSString *)status
                  Success:(void (^)(NSArray *activityListSummaryModel))success
                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:status forKey:@"status"];
    
    [self POST:@"get_ActivityList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSDictionary *dic = [responseObject objectForKey:@"rows"];
        if (!([dic isEqual:@""])) {
             success([self constructModelsForClass:[YKLActivityListSummaryModel class] withData: [responseObject objectForKey:@"rows"]]);
        }else{
            success([self constructModelsForClass:[YKLActivityListSummaryModel class] withData: NULL]);
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)delActivityWithActivityID:(NSString *)activityID
                          Success:(void (^)())success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:activityID forKey:@"activity_id"];
    
    [self POST:@"del_Activity" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)getActivityInfoWithActivityID:(NSString *)activityID
                              Success:(void (^)(NSDictionary *templateModel))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:activityID forKey:@"activity_id"];
    
    [self POST:@"get_ActivityInfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}


+ (void)requestFansListWithShopID:(NSString *)shopID
                          success:(void (^)(NSArray *fans))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:shopID forKey:@"shop_id"];
    
    [self POST:@"get_players" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLFanModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLFanModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getAuthorPriceSuccess:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    
    [self POST:@"get_author_price" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

//    [[self shareManager] POST:[ROOT_URL stringByAppendingString:@"get_author_price"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        success(responseObject);
//    
//        NSLog(@"JSON: %@", responseObject);
//        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
//        if (responseCode == 1) {
//            NSString *authorPrice = [responseObject objectForKey:@"author_price"];
//            success(authorPrice);
//        }
//        else {
//
//        }
    
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@", error);
//
//    }];
}

+ (void)addOrderWithGoodsName:(NSString *)goodsName
                    GoodsType:(NSString *)goodsType
                  OrderAmount:(NSString *)orderAmount
                      PayType:(NSString *)payType
                      BuyerID:(NSString *)buyerID
                    BuyerName:(NSString *)buyerName
                   ActivityID:(NSString *)activityID
                      GoodsID:(NSString *)goodsID
                      Success:(void (^)(NSDictionary *orderDic))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:goodsName forKey:@"goods_name"];
    [parameters setObject:goodsType forKey:@"goods_type"];
    [parameters setObject:orderAmount forKey:@"order_amount"];
    [parameters setObject:payType forKey:@"pay_type"];
    [parameters setObject:buyerID forKey:@"buyer_id"];
    [parameters setObject:buyerName forKey:@"buyer_name"];
    [parameters setObject:activityID forKey:@"activity_id"];
    [parameters setObject:goodsID forKey:@"goods_id"];
    
    [self POST:@"add_order" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"order"];
        success(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

+ (void)getOrderListWithOrderState:(NSString *)orderState
                           PayType:(NSString *)payType
                           Success:(void (^)(NSArray *orderModel))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKeyedSubscript:@"shop_id"];
    [parameters setObject:orderState forKey:@"order_state"];
    [parameters setObject:payType forKey:@"pay_type"];
    
    [self POST:@"get_OrderList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLOrderListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLOrderListModel class] withData:responseObject]);
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

+ (void)getShopInfoWithShopID:(NSString *)shopID
                      Success:(void (^)(YKLShopInfoModel *shopInfoDic))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:shopID forKeyedSubscript:@"shop_id"];

    [self POST:@"get_shopInfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[YKLShopInfoModel defShopInfoModel] updateWithDictionary:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getExposureWithUserID:(NSString *)userID
                    StartTime:(NSString *)startTime
                      EndTime:(NSString *)endTime
                      Success:(void (^)(NSArray *exposureModel))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:userID forKeyedSubscript:@"shop_id"];
    [parameters setObject:startTime forKeyedSubscript:@"start_time"];
    [parameters setObject:endTime forKeyedSubscript:@"end_time"];
    
    [self POST:@"get_exposure" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([self constructModelsForClass:[YKLExposureModel class] withData:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getActivityPlayerWithActivityID:(NSString *)activityID
                               IsExpiry:(NSString *)isExpiry
                                PayType:(NSString *)payType
                                Success:(void (^)(NSArray *fansModel))success
                                failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:activityID forKey:@"activity_id"];
    [parameters setObject:isExpiry forKey:@"is_expiry"];
    [parameters setObject:payType forKey:@"is_pay"];
    
    [self POST:@"activity_order" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLFanModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLFanModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getActivityPlayerWithActivityID:(NSString *)activityID
                                 IsOver:(NSString *)isOver
                                Success:(void (^)(NSArray *fansModel))success
                                failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:activityID forKey:@"activity_id"];
    [parameters setObject:isOver forKey:@"is_over"];
    
    [self POST:@"activity_player" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLFanModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLFanModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)getADWithName:(NSString *)name
                 Type:(NSString *)type
              Success:(void (^)(NSArray *fansModel))success
              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:type forKey:@"type"];
    
    [self POST:@"get_ad" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         success([self constructModelsForClass:[YKLGetADModel class] withData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)shareActWithActArray:(NSString *)actArray
                     Success:(void (^)(NSDictionary *shareDic))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:actArray forKey:@"id"];

    
    [self POST:@"merger_activity" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)shopRecommendWithShopID:(NSString *)ShopID
                        Success:(void (^)(YKLShopRecommendModel *shopModel))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:ShopID forKey:@"shop_id"];
    
    
    [self POST:@"shop_Recommend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([[YKLShopRecommendModel defShopRecommendModel] updateWithDictionary:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)setBankAccountWithShopID:(NSString *)shopID             //商户id
                        BankName:(NSString *)bankName           //银行名称
                   AccountHolder:(NSString *)accountHolder      //开户人姓名
                     BankAccount:(NSString *)bankAccount        //银行账号
                            Type:(NSString *)type               //1 alipay  2 银行卡
                       IsDefault:(NSString *)isDefault          //1. 默认提现账户  2 非默认账户
                           Vcode:(NSString *)vcode              //验证码
                   BankAccountID:(NSString *)bankAccountID      //提现账户ID
                         Success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:shopID forKey:@"shop_id"];
    [parameters setObject:bankName forKey:@"bank_name"];
    [parameters setObject:accountHolder forKey:@"account_holder"];
    [parameters setObject:bankAccount forKey:@"bank_account"];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:isDefault forKey:@"is_default"];
    [parameters setObject:vcode forKey:@"vcode"];
    [parameters setObject:bankAccountID forKey:@"id"];
    
    [self POST:@"setBankAccount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)accountPayWithOrderSN:(NSString *)orderSN
                   TotalMoney:(NSString *)totalMoney
                      Success:(void (^)(NSDictionary *responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:orderSN forKey:@"order_sn"];
    [parameters setObject:totalMoney forKey:@"total_money"];
    
    [[self shareManager] POST:[ROOT_URL stringByAppendingString:@"account_pay"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(newError);
        
    }];
    
    
}

+ (void)shopRecommendListWithShopID:(NSString *)shopID
                           IsAuthor:(NSString *)isAuthor
                            Success:(void (^)(NSArray *fans))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    [parameters setObject:isAuthor forKey:@"is_author"];
    
    [self POST:@"shop_Recommend_list" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([self constructModelsForClass:[YKLAuthorFansModel class] withData:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

+ (void)accountCashWithShopID:(NSString *)shopID
                    Success:(void (^)(YKLAccountCashModel *cashModel))success
                    failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    
    [self POST:@"accountCash" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[YKLAccountCashModel defAccountCashModel] updateWithDictionary:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getBankAccountWithShopID:(NSString *)shopID
                         Success:(void (^)(NSArray *bankAccount))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    
    [self POST:@"getBankAccount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success([self constructModelsForClass:[YKLAccountCashModel class] withData:responseObject]);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}
+ (void)withdrawCashWithShopID:(NSString *)shopID
                         Money:(NSString *)money
                   BankAccount:(NSString *)bankAccount
                 AccountHolder:(NSString *)accountHolder
                      BankName:(NSString *)bankName
                       Success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    [parameters setObject:money forKey:@"money"];
    [parameters setObject:bankAccount forKey:@"bank_account"];
    [parameters setObject:accountHolder forKey:@"account_holder"];
    [parameters setObject:bankName forKey:@"bank_name"];
    
    [[self shareManager] POST:[ROOT_URL stringByAppendingString:@"withdrawCash"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(newError);
        
    }];
}

+ (void)getWithdrawCashWithShopID:(NSString *)shopID
                          success:(void (^)(NSArray *list))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:shopID forKey:@"shop_id"];
    
    [self POST:@"get_withdrawCash" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLWithDrawCashModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLWithDrawCashModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getTransactionDetailWithShopID:(NSString *)shopID
                                  Type:(NSString *)type
                               success:(void (^)(NSArray *list))success
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:shopID forKey:@"shop_id"];
    [parameters setObject:type forKey:@"pay_type"];
    
    [self POST:@"get_transaction_detail" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLWithDrawCashModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLWithDrawCashModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getCommentWithActID:(NSString *)actID
                    success:(void (^)(NSArray *list))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:actID forKey:@"activity_id"];
    
    [self POST:@"comment_lsit" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLCommentListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLCommentListModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)deleteCommentWithCommentID:(NSString *)commentID
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:commentID forKey:@"comment_id"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    
    [self POST:@"del_comment" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getVersionWithType:(NSString *)type
                VersionNum:(NSString *)versionNum
                   success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:versionNum forKey:@"version_num"];
    [parameters setObject:type forKey:@"type"];
    
    [self POST:@"get_version" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)saveHeadImgWithImageURL:(NSString *)imageUR
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:imageUR forKey:@"head_img"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    
    [self POST:@"save_headImg" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getChildAccountPriceSuccess:(void (^)(NSArray *list))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    
    [self POST:@"get_ChildAccountPrice" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([self constructModelsForClass:[YKLChildAccountPriceModel class] withData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

///添加子账号
+ (void)registWithMobile:(NSString *)mobile
                  UserID:(NSString *)UserID
                ShopName:(NSString *)shopName
                 Address:(NSString *)address
                  Street:(NSString *)street
              ServiceTel:(NSString *)serviceTel
               Lianxiren:(NSString *)lianxiren
            IdentityCard:(NSString *)identityCard
                 License:(NSString *)license
               AgentCode:(NSString *)agentCode
              AlipayName:(NSString *)alipayName
           AlipayAccount:(NSString *)alipayAccount
                  QRcode:(NSString *)QRcode
                   Vcode:(NSString *)vcode
                     Pid:(NSString *)pid
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:UserID forKey:@"shop_id"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:shopName forKey:@"shop_name"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:street forKey:@"street"];
    [parameters setObject:serviceTel forKey:@"service_tel"];
    [parameters setObject:lianxiren forKey:@"lianxiren"];
    [parameters setObject:identityCard forKey:@"identity_card"];
    [parameters setObject:license forKey:@"license"];
    [parameters setObject:agentCode forKey:@"agent_code"];
    [parameters setObject:alipayName forKey:@"alipay_name"];
    [parameters setObject:alipayAccount forKey:@"alipay_account"];
    [parameters setObject:QRcode forKey:@"qr_code"];
    [parameters setObject:pid forKey:@"pid"];
    [parameters setObject:vcode forKey:@"vcode"];
    
    [self POST:@"save_subshop" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getChildAccountWithPid:(NSString *)pid
                           Act:(NSString *)act
                        IsShow:(NSString *)isShow
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:pid forKey:@"pid"];
    [parameters setObject:act forKey:@"act"];
    [parameters setObject:isShow forKey:@"isshow"];
    
    [self POST:@"get_ChildAccount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}
@end
