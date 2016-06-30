//
//  YKLNetworkingPrizes.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/13.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseNetworking.h"
#import "YKLRedActivityListModel.h"

@interface YKLNetworkingPrizes : YKLBaseNetworking
/*！
 * 发布红包奖品
 */
+ (void)releasePrizesWithData:(NSString *)data
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure;
/*！
 * 活动列表发布红包
 */
+ (void)releasePublicRedWithRID:(NSString *)RID
                        Success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure;

/*！
 * 红包活动列表
 */
+ (void)getRedListWithUserID:(NSString *)userID
                      Status:(NSString *)status
                     Success:(void (^)(NSArray *activityList))success
                     failure:(void (^)(NSError *error))failure;
/*！
 * 删除红包活动
 */
+ (void)deleteRedWithRedID:(NSString *)redID
                   Success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure;
/*！
 * 红包详情
 */
+ (void)readRedWithRID:(NSString *)RID
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure;

/*！
 * 参与活动人列表
 */
+ (void)getRedWinnerWithRID:(NSString *)RID
                     Status:(NSString *)status
               Success:(void (^)(NSArray *winnerList))success
               failure:(void (^)(NSError *error))failure;

/*！
 * 红包订单列表
 */
+ (void)getRedOrderCenterWithUserID:(NSString *)userID
                            Success:(void (^)(NSArray *orderListModel))success
                            failure:(void (^)(NSError *error))failure;
@end
