//
//  YKLNetWorkingSuDing.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/6.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseNetworking.h"

@interface YKLNetWorkingSuDing : YKLBaseNetworking

/*!
 * 速定模板接口
 */
+ (void)getSuDingTemplateWithTempCode:(NSString *)tempCode
                                cateID:(NSString *)cateIDStr
                               Success:(void (^)(NSArray *templateModel))success
                               failure:(void (^)(NSError *error))failure;

/*！
 * 速定发布活动
 */
+ (void)releaseActWithData:(NSString *)data
                   Success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure;

/*！
 * 速定待发布列表发布活动
 */
+ (void)releaseActWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 速定活动列表
 */
+ (void)getActListWithUserID:(NSString *)userID
                      Status:(NSString *)status
                     Success:(void (^)(NSArray *activityListSummaryModel))success
                     failure:(void (^)(NSError *error))failure;

/*！
 * 速定待发布列表删除活动
 */
+ (void)delActWithActID:(NSString *)actID
                Success:(void (^)())success
                failure:(void (^)(NSError *error))failure;

/*!
 * 速定活动详情
 */
+ (void)getActListWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 速定订单列表
 */
+ (void)getOrderListWithUserID:(NSString *)userID
                        Status:(NSString *)status
                       Success:(void (^)(NSArray *orderListModel))success
                       failure:(void (^)(NSError *error))failure;

/*！
 * 速定成功秒杀人
 */
+ (void)getGoodsWinnerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSArray *userList))success
                          failure:(void (^)(NSError *error))failure;

/*！
 * 速定报名管理
 */
+ (void)getGoodsJoinerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSArray *userList))success
                          failure:(void (^)(NSError *error))failure;

/*!
 * 速定评论列表
 */
+ (void)getCommentWithActID:(NSString *)actID
                    success:(void (^)(NSArray *list))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 速定删除评论列表
 */
+ (void)deleteCommentWithCommentID:(NSString *)commentID
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSError *error))failure;

/*!
 * 合并分享
 */
+ (void)shareActWithActArray:(NSString *)actArray
                     Success:(void (^)(NSDictionary *shareDic))success
                     failure:(void (^)(NSError *error))failure;

@end
