//
//  YKLNetworkingPrizes.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/13.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLNetworkingPrizes.h"

@implementation YKLNetworkingPrizes
+ (void)releasePrizesWithData:(NSString *)data
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"edit_Redenvelope" forKey:@"act"];
    [parameters setObject:data forKey:@"data"];
    
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)releasePublicRedWithRID:(NSString *)RID
                        Success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"public_red" forKey:@"act"];
    [parameters setObject:RID forKey:@"rid"];
    
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getRedListWithUserID:(NSString *)userID
                      Status:(NSString *)status
                     Success:(void (^)(NSArray *activityList))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"red_list" forKey:@"act"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:status forKey:@"status"];
    
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!([responseObject isEqual:@""])) {
            success([self constructModelsForClass:[YKLRedActivityListModel class] withData: responseObject]);
        }else{
            success([self constructModelsForClass:[YKLRedActivityListModel class] withData: NULL]);
        }

//        success([self constructModelsForClass:[YKLRedActivityListModel class] withData: responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)deleteRedWithRedID:(NSString *)redID
                   Success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"delete_red" forKey:@"act"];
    [parameters setObject:redID forKey:@"rid"];
    
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)readRedWithRID:(NSString *)RID
               Success:(void (^)(NSDictionary *dict))success
               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"read_red" forKey:@"act"];
    [parameters setObject:RID forKey:@"rid"];
    
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getRedWinnerWithRID:(NSString *)RID
                     Status:(NSString *)status
                    Success:(void (^)(NSArray *winnerList))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"red_winner" forKey:@"act"];
    [parameters setObject:RID forKey:@"rid"];
    [parameters setObject:status forKey:@"status"];
    
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil||[responseObject isEqual:@"尚无获奖信息产生！"]) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getRedOrderCenterWithUserID:(NSString *)userID
                            Success:(void (^)(NSArray *orderListModel))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_center" forKey:@"act"];
    [parameters setObject:userID forKey:@"shop_id"];
    [self POSTRed:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLHighGoOrderListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLHighGoOrderListModel class] withData: responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
