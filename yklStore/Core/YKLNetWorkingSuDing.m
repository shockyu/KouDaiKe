//
//  YKLNetWorkingSuDing.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/6.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLNetWorkingSuDing.h"

@implementation YKLNetWorkingSuDing

+ (void)getSuDingTemplateWithTempCode:(NSString *)tempCode
                                cateID:(NSString *)cateIDStr
                               Success:(void (^)(NSArray *templateModel))success
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"temp_list" forKey:@"act"];
    [parameters setObject:tempCode forKey:@"temp_code"];
    [parameters setObject:cateIDStr forKey:@"category_id"];

    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLTemplateModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLTemplateModel class] withData:responseObject]);
        }
        
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
    [parameters setObject:@"edit_seckill" forKey:@"act"];
    [parameters setObject:data forKey:@"data"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [parameters setObject:@"public_seckill" forKey:@"act"];
    [parameters setObject:actID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
//        if ([responseObject objectForKey:@"content"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[responseObject objectForKey:@"content"] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        }
        
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
    [parameters setObject:@"seckill_list" forKey:@"act"];
    [parameters setObject:userID forKey:@"shop_id"];
    [parameters setObject:status forKey:@"status"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([self constructModelsForClass:[YKLMiaoShaActivityListModel class] withData: responseObject]);
        
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
    [parameters setObject:@"delete_seckill" forKey:@"act"];
    [parameters setObject:actID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
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
    [parameters setObject:@"seckill_info" forKey:@"act"];
    [parameters setObject:actID forKey:@"id"];
    
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}


+ (void)getOrderListWithUserID:(NSString *)userID
                        Status:(NSString *)status
                       Success:(void (^)(NSArray *orderListModel))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_convert" forKey:@"act"];
    [parameters setObject:userID forKey:@"id"];
    [parameters setObject:status forKey:@"status"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: NULL]);
            
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getGoodsWinnerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSArray *userList))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"order_all" forKey:@"act"];
    [parameters setObject:goodsID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil && !([responseObject isEqual:[NSNull null]])) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: NULL]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}


+ (void)getGoodsJoinerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSArray *userList))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"register_manage" forKey:@"act"];
    [parameters setObject:goodsID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil && !([responseObject isEqual:[NSNull null]])) {
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: responseObject]);
        }else{
            success([self constructModelsForClass:[YKLHighGoUserListModel class] withData: NULL]);
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
    [parameters setObject:@"seckill_comment" forKey:@"act"];
    [parameters setObject:actID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    [parameters setObject:@"delete_comment" forKey:@"act"];
    [parameters setObject:commentID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
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
    [parameters setObject:@"merge_seckill" forKey:@"act"];
    [parameters setObject:actArray forKey:@"ids"];
    
    [self POSTOnlyApi:ROOTSuDing_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
