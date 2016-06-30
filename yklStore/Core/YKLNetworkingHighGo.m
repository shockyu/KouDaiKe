//
//  YKLNetworkingHighGo.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/2.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLNetworkingHighGo.h"

@implementation YKLNetworkingHighGo

+ (void)getHighGoTemplateWithTempCode:(NSString *)tempCode
                               cateID:(NSString *)cateIDStr
                              Success:(void (^)(NSArray *templateModel))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"temp_list" forKey:@"act"];
    [parameters setObject:tempCode forKey:@"temp_code"];
    [parameters setObject:cateIDStr forKey:@"category_id"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLTemplateModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLTemplateModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)addOrderWithOrderJsonArray:(NSString *)orderJsonArray
                           Success:(void (^)(NSDictionary *orderDict))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:orderJsonArray forKey:@"order"];
    
    //用回砍价接口主链接
    [self POST:@"add_order" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)releaseActWithData:(NSString *)data
                  Success:(void (^)(NSDictionary *dict))success
                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"edit_tog" forKey:@"act"];
    [parameters setObject:data forKey:@"data"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)releaseActWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"public_tog" forKey:@"act"];
    [parameters setObject:actID forKey:@"tid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
        if ([responseObject objectForKey:@"content"]) {
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[responseObject objectForKey:@"content"] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)delActWithActID:(NSString *)actID
                Success:(void (^)())success
                failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"delete_tog" forKey:@"act"];
    [parameters setObject:actID forKey:@"tid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}
+ (void)getActWinnerWithActID:(NSString *)actID
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"tog_winner" forKey:@"act"];
    [parameters setObject:actID forKey:@"tid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)getGoodsWinnerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"goods_winner" forKey:@"act"];
    [parameters setObject:goodsID forKey:@"gid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}


+ (void)getActListWithUserID:(NSString *)userID
                      Status:(NSString *)status
                     Success:(void (^)(NSArray *activityListSummaryModel))success
                     failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"tog_list" forKey:@"act"];
    [parameters setObject:userID forKey:@"sid"];
    [parameters setObject:status forKey:@"status"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([self constructModelsForClass:[YKLHighGoActivityListModel class] withData: responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getActListWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"read_tog" forKey:@"act"];
    [parameters setObject:actID forKey:@"tid"];

    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        YKLShopInfoModel *shopInfoDic
//        [YKLShopInfoModel defShopInfoModel] updateWithDictionary:responseObject]
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}


+ (void)getOrderListWithUserID:(NSString *)userID
                       Success:(void (^)(NSArray *orderListModel))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_center" forKey:@"act"];
    [parameters setObject:userID forKey:@"sid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([self constructModelsForClass:[YKLHighGoOrderListModel class] withData: responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getOrderDetailWithActID:(NSString *)actID
                        Success:(void (^)(NSDictionary *orderDict))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_detail" forKey:@"act"];
    [parameters setObject:actID forKey:@"tid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getGoodsRewardWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSDictionary *orderDict))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"goods_reward" forKey:@"act"];
    [parameters setObject:goodsID forKey:@"gid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getUserListWithGoodsID:(NSString *)goodsID
                       Success:(void (^)(NSArray *userList))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"user_list" forKey:@"act"];
    [parameters setObject:goodsID forKey:@"gid"];
    
    [self POSTWX:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
