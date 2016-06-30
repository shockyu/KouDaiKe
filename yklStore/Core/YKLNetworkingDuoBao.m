//
//  YKLNetworkingDuoBao.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/4.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLNetworkingDuoBao.h"

@implementation YKLNetworkingDuoBao

+ (void)releasePrizesWithData:(NSString *)data
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"edit_activity" forKey:@"act"];
    [parameters setObject:data forKey:@"data"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)releasePublicIndianaWithIndianaID:(NSString *)indianaID
                                  Success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"public_activity" forKey:@"act"];
    [parameters setObject:indianaID forKey:@"id"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:@"活动截止日期已过，请重新发布！"]) {
        
            return ;
        }
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getIndianaListWithUserID:(NSString *)userID
                          Status:(NSString *)status
                         Success:(void (^)(NSArray *activityList))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"indiana_list" forKey:@"act"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:status forKey:@"status"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil && !([responseObject isEqual:[NSNull null]])) {
            success([self constructModelsForClass:[YKLDuoBaoActivityListModel class] withData: responseObject]);
        }else{
            success([self constructModelsForClass:[YKLDuoBaoActivityListModel class] withData: NULL]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)deleteIndianaWithIndianaID:(NSString *)indianaID
                           Success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"delete_activity" forKey:@"act"];
    [parameters setObject:indianaID forKey:@"id"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)readIndianaInfoWithIndianaID:(NSString *)indianaID
                             Success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"indiana_info" forKey:@"act"];
    [parameters setObject:indianaID forKey:@"id"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


+ (void)getJoinListWithIndianaID:(NSString *)indianaID
                         Success:(void (^)(NSArray *joinList))success
                         failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_all_join" forKey:@"act"];
    [parameters setObject:indianaID forKey:@"id"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil && !([responseObject isEqual:[NSNull null]])) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: NULL]);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getSuccessListWithIndianaID:(NSString *)indianaID
                            Success:(void (^)(NSArray *successList))success
                            failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_all_success" forKey:@"act"];
    [parameters setObject:indianaID forKey:@"id"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil && !([responseObject isEqual:[NSNull null]])) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: NULL]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


+ (void)getIndianaOrderCenterWithUserID:(NSString *)userID
                                Success:(void (^)(NSArray *orderListModel))success
                                failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_center" forKey:@"act"];
    [parameters setObject:userID forKey:@"shop_id"];
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLDuoBaoOrderListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLDuoBaoOrderListModel class] withData: responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getIndianaPlayerListWithIndianaID:(NSString *)indianaID
                                  ActName:(NSString *)actName
                                  Success:(void (^)(NSArray *activityList))success
                                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:indianaID forKey:@"id"];
    [parameters setObject:actName forKey:@"act"];
    
    [self POSTDuoBao:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

@end
