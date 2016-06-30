//
//  YKLNetworkingDuoBao.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/4.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseNetworking.h"
#import "YKLDuoBaoActivityListModel.h"
#import "YKLDuoBaoOrderListModel.h"

@interface YKLNetworkingDuoBao : YKLBaseNetworking
/*！
 * 夺宝发布奖品
 */
+ (void)releasePrizesWithData:(NSString *)data
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure;

/*！
 * 活动列表发布
 */
+ (void)releasePublicIndianaWithIndianaID:(NSString *)indianaID
                                  Success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSError *error))failure;

/*！
 * 夺宝活动列表
 */
+ (void)getIndianaListWithUserID:(NSString *)userID
                          Status:(NSString *)status
                         Success:(void (^)(NSArray *activityList))success
                         failure:(void (^)(NSError *error))failure;
/*！
 * 夺宝删除活动
 */
+ (void)deleteIndianaWithIndianaID:(NSString *)indianaID
                           Success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSError *error))failure;

/*！
 * 夺宝详情
 */
+ (void)readIndianaInfoWithIndianaID:(NSString *)indianaID
                             Success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSError *error))failure;

/*！
 * 夺宝参与活动人列表
 */
+ (void)getJoinListWithIndianaID:(NSString *)indianaID
                         Success:(void (^)(NSArray *joinList))success
                         failure:(void (^)(NSError *error))failure;

/*！
 * 夺宝获奖人列表
 */
+ (void)getSuccessListWithIndianaID:(NSString *)indianaID
                            Success:(void (^)(NSArray *successList))success
                            failure:(void (^)(NSError *error))failure;


/*！
 * 夺宝订单中心列表
 */
+ (void)getIndianaOrderCenterWithUserID:(NSString *)userID
                                Success:(void (^)(NSArray *orderListModel))success
                                failure:(void (^)(NSError *error))failure;

/*！
 * 夺宝订单参与人列表
 */
+ (void)getIndianaPlayerListWithIndianaID:(NSString *)indianaID
                                  ActName:(NSString *)actName
                                  Success:(void (^)(NSArray *activityList))success
                                  failure:(void (^)(NSError *error))failure;




@end
