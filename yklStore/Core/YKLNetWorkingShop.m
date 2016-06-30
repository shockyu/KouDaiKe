//
//  YKLNetWorkingShop.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/12.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLNetWorkingShop.h"

@implementation YKLNetWorkingShop

+ (void)getAddressWithShopID:(NSString *)shopID
                     Success:(void (^)(NSArray *shopList))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"get_address" forKey:@"act"];
    [parameters setObject:shopID forKey:@"shop_id"];
    
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLShopAdressListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLShopAdressListModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)deleteAddressWithAdressID:(NSString *)adressID
                          Success:(void (^)())success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"del_address" forKey:@"act"];
    [parameters setObject:adressID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)saveAddressWithAdressID:(NSString *)adressID
                         ShopID:(NSString *)shopID
                       Province:(NSString *)province
                           City:(NSString *)city
                           Area:(NSString *)area
                        Address:(NSString *)address
                  ConsigneeName:(NSString *)consigneeName
                ConsigneeMobile:(NSString *)consigneeMobile
                      IsDefault:(NSString *)isDefault
                        Success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"save_address" forKey:@"act"];
    [parameters setObject:shopID forKey:@"shop_id"];
    [parameters setObject:province forKey:@"province"];
    [parameters setObject:city forKey:@"city"];
    [parameters setObject:area forKey:@"area"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:consigneeName forKey:@"consignee_name"];
    [parameters setObject:consigneeMobile forKey:@"consignee_mobile"];
    [parameters setObject:isDefault forKey:@"is_default"];
    
    //adressID为空不传
    if (![adressID isEqual:@""]) {
        [parameters setObject:adressID forKey:@"id"];
    }
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)saveAddressWithAdressID:(NSString *)adressID
                         ShopID:(NSString *)shopID
                      IsDefault:(NSString *)isDefault
                        Success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"save_address" forKey:@"act"];
    [parameters setObject:shopID forKey:@"shop_id"];
    [parameters setObject:isDefault forKey:@"is_default"];
    [parameters setObject:adressID forKey:@"id"];
    
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

+ (void)getPayShopWithGoodID:(NSString *)goodID
                     Success:(void (^)(NSArray *shopList))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"get_pay_shop" forKey:@"act"];
    [parameters setObject:goodID forKey:@"goods_id"];
    
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isEqual:[NSNull null]]||[responseObject isKindOfClass:[NSNull class]]||responseObject==nil) {
            success([self constructModelsForClass:[YKLPayShopListModel class] withData:NULL]);
        }else{
            success([self constructModelsForClass:[YKLPayShopListModel class] withData:responseObject]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getDefaultAddressWithShopID:(NSString *)shopID
                            Success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"get_default_addr" forKey:@"act"];
    [parameters setObject:shopID forKey:@"shop_id"];
    
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getorderCenterNumWithShopID:(NSString *)shopID
                            Success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:API_Token forKey:@"API_Token"];
    [parameters setObject:@"orderCenter" forKey:@"act"];
    [parameters setObject:shopID forKey:@"shop_id"];
    
    [self POSTOnlyApi:ROOTShop_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
