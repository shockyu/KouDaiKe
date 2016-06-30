//
//  YKLNetworkingMiaoSha.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseNetworking.h"
#import "YKLMiaoShaActivityListModel.h"

@interface YKLNetworkingMiaoSha : YKLBaseNetworking

/*!
 * 秒杀模板接口
 */
+ (void)getMiaoShaTemplateWithTempCode:(NSString *)tempCode
                                cateID:(NSString *)cateIDStr
                               Success:(void (^)(NSArray *templateModel))success
                               failure:(void (^)(NSError *error))failure;

/*！
 * 秒杀发布活动
 */
+ (void)releaseActWithData:(NSString *)data
                   Success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure;

/*！
 * 秒杀待发布列表发布活动
 */
+ (void)releaseActWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 秒杀活动列表
 */
+ (void)getActListWithUserID:(NSString *)userID
                      Status:(NSString *)status
                     Success:(void (^)(NSArray *activityListSummaryModel))success
                     failure:(void (^)(NSError *error))failure;

/*！
 * 秒杀待发布列表删除活动
 */
+ (void)delActWithActID:(NSString *)actID
                Success:(void (^)())success
                failure:(void (^)(NSError *error))failure;

/*!
 * 秒杀活动详情
 */
+ (void)getActListWithActID:(NSString *)actID
                    Success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 秒杀订单列表
 */
+ (void)getOrderListWithUserID:(NSString *)userID
                        Status:(NSString *)status
                       Success:(void (^)(NSArray *orderListModel))success
                       failure:(void (^)(NSError *error))failure;

/*！
 * 秒杀成功秒杀人
 */
+ (void)getGoodsWinnerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSArray *userList))success
                          failure:(void (^)(NSError *error))failure;

/*！
 * 秒杀报名管理
 */
+ (void)getGoodsJoinerWithGoodsID:(NSString *)goodsID
                          Success:(void (^)(NSArray *userList))success
                          failure:(void (^)(NSError *error))failure;

/*!
 * 秒杀评论列表
 */
+ (void)getCommentWithActID:(NSString *)actID
                    success:(void (^)(NSArray *list))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 秒杀删除评论列表
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
