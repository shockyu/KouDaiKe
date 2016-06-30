//
//  YKLNetWorkingShop.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/12.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseNetworking.h"
#import "YKLShopAdressListModel.h"
#import "YKLPayShopListModel.h"

@interface YKLNetWorkingShop : YKLBaseNetworking

/*!
 * 获取收货地址列表
 */
+ (void)getAddressWithShopID:(NSString *)shopID
                     Success:(void (^)(NSArray *shopList))success
                     failure:(void (^)(NSError *error))failure;
/*!
 * 删除收货地址
 */
+ (void)deleteAddressWithAdressID:(NSString *)adressID
                     Success:(void (^)())success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 设置收货地址
 */
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
                          failure:(void (^)(NSError *error))failure;

/*!
 * 设置默认收货地址
 */
+ (void)saveAddressWithAdressID:(NSString *)adressID
                         ShopID:(NSString *)shopID
                      IsDefault:(NSString *)isDefault
                        Success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure;


/*!
 * 获取商家列表
 */
+ (void)getPayShopWithGoodID:(NSString *)goodID
                     Success:(void (^)(NSArray *shopList))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 获取商家列表
 */
+ (void)getDefaultAddressWithShopID:(NSString *)shopID
                            Success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSError *error))failure;

/*!
 * 获取订单中心订单数
 */
+ (void)getorderCenterNumWithShopID:(NSString *)shopID
                            Success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSError *error))failure;
@end
