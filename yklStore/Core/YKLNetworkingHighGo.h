//
//  YKLNetworkingHighGo.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/2.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseNetworking.h"
#import "YKLTemplateModel.h"
#import "YKLHighGoActivityListModel.h"
#import "YKLHighGoOrderListModel.h"
#import "YKLHighGoUserListModel.h"

@interface YKLNetworkingHighGo : YKLBaseNetworking
/*!
 * 嗨购模板接口
 */
+ (void)getHighGoTemplateWithTempCode:(NSString *)tempCode
                               cateID:(NSString *)cateIDStr
                              Success:(void (^)(NSArray *templateModel))success
                              failure:(void (^)(NSError *error))failure;
/*!
 * 嗨购付款订单信息
 */
+ (void)addOrderWithOrderJsonArray:(NSString *)orderJsonArray
                           Success:(void (^)(NSDictionary *orderDict))success
                           failure:(void (^)(NSError *error))failure;

/*！
 * 嗨购发布活动
 */
+ (void)releaseActWithData:(NSString *)data
                   Success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure;

/*！
 * 嗨购待发布列表发布活动
 */
+ (void)releaseActWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure;

/*！
 * 嗨购待发布列表删除活动
 */
+ (void)delActWithActID:(NSString *)actID
                Success:(void (^)())success
                failure:(void (^)(NSError *error))failure;

/*！
 * 嗨购活动中奖信息
 */
+ (void)getActWinnerWithActID:(NSString *)actID
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure;

/*！
 * 嗨购产品中奖信息
 */
+ (void)getGoodsWinnerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSError *error))failure;

/*!
 * 嗨购活动列表
 */
+ (void)getActListWithUserID:(NSString *)userID
                      Status:(NSString *)status
                     Success:(void (^)(NSArray *activityListSummaryModel))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 嗨购活动详情
 */
+ (void)getActListWithActID:(NSString *)actID
                     Success:(void (^)(NSDictionary *dict))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 嗨购订单中心
 */
+ (void)getOrderListWithUserID:(NSString *)userID
                     Success:(void (^)(NSArray *orderListModel))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 嗨购订单详情
 */
+ (void)getOrderDetailWithActID:(NSString *)actID
                        Success:(void (^)(NSDictionary *orderDict))success
                        failure:(void (^)(NSError *error))failure;

/*!
 * 嗨购订单中代金券列表
 */
+ (void)getGoodsRewardWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSDictionary *orderDict))success
                          failure:(void (^)(NSError *error))failure;

/*!
 * 嗨购活动详情参与者列表
 */
+ (void)getUserListWithGoodsID:(NSString *)goodsID
                       Success:(void (^)(NSArray *userList))success
                       failure:(void (^)(NSError *error))failure;
@end
