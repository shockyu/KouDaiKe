//
//  MPSNetworkingConsumer.h
//  MPStore
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLBaseNetworking.h"
#import "YKLUserModel.h"
#import "YKLUserSynchronizationModel.h"
#import "YKLTemplateModel.h"
#import "YKLActivityListSummaryModel.h"
#import "YKLFanModel.h"
#import "YKLShopInfoModel.h"
#import "YKLOrderListModel.h"
#import "YKLExposureModel.h"
#import "YKLGetADModel.h"
#import "YKLShopRecommendModel.h"
#import "YKLAccountCashModel.h"
#import "YKLAuthorFansModel.h"
#import "YKLWithDrawCashModel.h"
#import "YKLCommentListModel.h"
#import "YKLChildAccountPriceModel.h"

#import "ViewController.h"


@interface YKLNetworkingConsumer : YKLBaseNetworking


+ (ViewController *)viewControllerAlloct;

/*!
 * 全民砍价模板接口
 */
+ (void)getTemplateWithType:(NSString *)type
                   TempCode:(NSString *)tempCode
                     cateID:(NSString *)cateIDStr
                    Success:(void (^)(NSArray *templateModel))success
                    failure:(void (^)(NSError *error))failure;



/*!
 * 获取验证码
 */
+ (void)getRegistVCodeWithMobile:(NSString *)mobile
                         success:(void (^)(NSString *verificationCode))success
                         failure:(void (^)(NSError *error))failure;

/*!
 * 登陆
 */
+ (void)loginWithMobile:(NSString *)mobile
                  Vcode:(NSString *)vcode
                success:(void (^)(YKLUserModel *userModel))success
                failure:(void (^)(NSError *error))failure;

/*!
 * 注册
 */
+ (void)registWithMobile:(NSString *)mobile
                  UserID:(NSString *)UserID
                ShopName:(NSString *)shopName
                 Address:(NSString *)address
                  Street:(NSString *)street
              ServiceTel:(NSString *)serviceTel
               Lianxiren:(NSString *)lianxiren
            IdentityCard:(NSString *)identityCard
                 License:(NSString *)license
               AgentCode:(NSString *)agentCode
              AlipayName:(NSString *)alipayName
           AlipayAccount:(NSString *)alipayAccount
                  QRcode:(NSString *)QRcode
                 success:(void (^)(NSString *success))success
                 failure:(void (^)(NSError *error))failure;

/*!
 * 同步接口
 */
+ (void)getSynchronizationWithUserID:(NSString *)UserID
                             Success:(void (^)(YKLUserSynchronizationModel *userSynchronizationModel))success
                             failure:(void (^)(NSError *error))failure;



/*！
 * 发布活动
 */
+ (void)releaseActWithUserID:(NSString *)userID
               ActivityID:(NSString *)activityID
                    Title:(NSString *)title
                     Desc:(NSString *)desc
            OriginalPrice:(NSString *)originalPrice
                BasePrice:(NSString *)basePrice
               ProductNum:(NSString *)productNum
             StartBargain:(NSString *)startBargain
//               EndBargain:(NSString *)endBargain
          ActivityEndTime:(NSString *)activityEndTime
               RewardCode:(NSString *)rewardCode
               TemplateID:(NSString *)templateID
                   Status:(NSString *)status
                      Img:(NSString *)img
                     Type:(NSString *)type
                IsOverSms:(NSString *)isOverSms
               ShowBasePrice:(NSString *)showBasePrice
          OnlinePayPrivilege:(NSString *)onlinePayPrivilege
                    Success:(void (^)(NSDictionary *templateModel))success
                   failure:(void (^)(NSError *error))failure;

/*！
 * 修改砍价区间
 */
+ (void)releaseBargainWithUserID:(NSString *)userID
                  ActivityID:(NSString *)activityID
                StartBargain:(NSString *)startBargain
                  EndBargain:(NSString *)endBargain
                     Success:(void (^)(NSDictionary *templateModel))success
                     failure:(void (^)(NSError *error))failure;


/*!
 * 发布并分享活动
 */
+ (void)releaseActAndShareWithUserID:(NSString *)userID
               ActivityID:(NSString *)activityID
                   Status:(NSString *)status
                  Success:(void (^)(NSDictionary *templateModel))success
                  failure:(void (^)(NSError *error))failure;

/*!
 * 活动列表
 */
+ (void)releaseWithUserID:(NSString *)userID
                   Status:(NSString *)status
                  Success:(void (^)(NSArray *activityListSummaryModel))success
                  failure:(void (^)(NSError *error))failure;

/*!
 * 删除待发布活动
 */
+ (void)delActivityWithActivityID:(NSString *)activityID
                      Success:(void (^)())success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 活动详情
 */
+ (void)getActivityInfoWithActivityID:(NSString *)activityID
                              Success:(void (^)(NSDictionary *templateModel))success
                              failure:(void (^)(NSError *error))failure;

/*!
 *  获取关注我的人的列表(粉丝列表)
 */
+ (void)requestFansListWithShopID:(NSString *)shopID
                          success:(void (^)(NSArray *fans))success
                          failure:(void (^)(NSError *error))failure;

/*!
 * 获取授权接口返回
 */
+ (void)getAuthorPriceSuccess:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 添加订单信息
 */
+ (void)addOrderWithGoodsName:(NSString *)goodsName
                    GoodsType:(NSString *)goodsType
                  OrderAmount:(NSString *)orderAmount
                      PayType:(NSString *)payType
                      BuyerID:(NSString *)buyerID
                    BuyerName:(NSString *)buyerName
                   ActivityID:(NSString *)activityID
                      GoodsID:(NSString *)goodsID
                      Success:(void (^)(NSDictionary *orderDic))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 获取订单中心列表
 */
+ (void)getOrderListWithOrderState:(NSString *)orderState
                           PayType:(NSString *)payType
                           Success:(void (^)(NSArray *orderModel))success
                           failure:(void (^)(NSError *error))failure;

/*!
 * 获取商户详情接口
 */
+ (void)getShopInfoWithShopID:(NSString *)shopID
                      Success:(void (^)(YKLShopInfoModel *shopInfoDic))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 获取曝光详情接口
 */
+ (void)getExposureWithUserID:(NSString *)userID
                    StartTime:(NSString *)startTime
                      EndTime:(NSString *)endTime
                  Success:(void (^)(NSArray *activityListSummaryModel))success
                  failure:(void (^)(NSError *error))failure;

/*!
 * 获取活动订单记录
 */
+ (void)getActivityPlayerWithActivityID:(NSString *)activityID
                               IsExpiry:(NSString *)isExpiry
                                PayType:(NSString *)payType
                                Success:(void (^)(NSArray *fansModel))success
                                failure:(void (^)(NSError *error))failure;

/*!
 * 获取进行中活动粉丝列表
 */
+ (void)getActivityPlayerWithActivityID:(NSString *)activityID
                                 IsOver:(NSString *)isOver
                                Success:(void (^)(NSArray *fansModel))success
                                failure:(void (^)(NSError *error))failure;

/*!
 * 获取AD 获取闪屏：ios_shanping
 */
+ (void)getADWithName:(NSString *)name
                 Type:(NSString *)type
              Success:(void (^)(NSArray *fansModel))success
              failure:(void (^)(NSError *error))failure;

/*!
 * 合并分享
 */
+ (void)shareActWithActArray:(NSString *)actArray
                     Success:(void (^)(NSDictionary *shareDic))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 店家推荐
 */
+ (void)shopRecommendWithShopID:(NSString *)ShopID
                     Success:(void (^)(YKLShopRecommendModel *shopModel))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * 设置提现账户
 */
+ (void)setBankAccountWithShopID:(NSString *)ShopID
                        BankName:(NSString *)bankName
                   AccountHolder:(NSString *)accountHolder
                     BankAccount:(NSString *)bankAccount
                            Type:(NSString *)type
                       IsDefault:(NSString *)isDefault
                           Vcode:(NSString *)vcode
                   BankAccountID:(NSString *)bankAccountID
                         Success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSError *error))failure;

/*!
 * 余额支付
 */
+ (void)accountPayWithOrderSN:(NSString *)orderSN
                   TotalMoney:(NSString *)totalMoney
                      Success:(void (^)(NSDictionary *responseObject))success
                      failure:(void (^)(NSError *error))failure;


/*!
 * 店家推荐列表
 */
+ (void)shopRecommendListWithShopID:(NSString *)shopID
                           IsAuthor:(NSString *)isAuthor
                      Success:(void (^)(NSArray *fans))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 口袋钱包
 */
+ (void)accountCashWithShopID:(NSString *)shopID
                      Success:(void (^)(YKLAccountCashModel *cashModel))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 获取提现账户信息
 */
+ (void)getBankAccountWithShopID:(NSString *)shopID
                         Success:(void (^)(NSArray *bankAccount))success
                         failure:(void (^)(NSError *error))failure;

/*!
 * 余额提现
 */
+ (void)withdrawCashWithShopID:(NSString *)shopID
                         Money:(NSString *)money
                   BankAccount:(NSString *)bankAccount
                 AccountHolder:(NSString *)accountHolder
                      BankName:(NSString *)bankName
                      Success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * 提现记录列表
 */
+ (void)getWithdrawCashWithShopID:(NSString *)shopID
                          success:(void (^)(NSArray *list))success
                          failure:(void (^)(NSError *error))failure;

/*!
 * 收支明细列表
 */
+ (void)getTransactionDetailWithShopID:(NSString *)shopID
                                  Type:(NSString *)type
                               success:(void (^)(NSArray *list))success
                               failure:(void (^)(NSError *error))failure;

/*!
 * 评论列表
 */
+ (void)getCommentWithActID:(NSString *)actID
                    success:(void (^)(NSArray *list))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * 删除评论列表
 */
+ (void)deleteCommentWithCommentID:(NSString *)commentID
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSError *error))failure;

/*!
 * 版本控制更新
 */
+ (void)getVersionWithType:(NSString *)type
                VersionNum:(NSString *)versionNum
                   success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSError *error))failure;

/*!
 * 上传头像
 */
+ (void)saveHeadImgWithImageURL:(NSString *)imageUR
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *error))failure;

/*!
 * 获取子账号购买价格
 */
+ (void)getChildAccountPriceSuccess:(void (^)(NSArray *list))success
                            failure:(void (^)(NSError *error))failure;


/*!
 * 添加子账号
 */
+ (void)registWithMobile:(NSString *)mobile
                  UserID:(NSString *)UserID
                ShopName:(NSString *)shopName
                 Address:(NSString *)address
                  Street:(NSString *)street
              ServiceTel:(NSString *)serviceTel
               Lianxiren:(NSString *)lianxiren
            IdentityCard:(NSString *)identityCard
                 License:(NSString *)license
               AgentCode:(NSString *)agentCode
              AlipayName:(NSString *)alipayName
           AlipayAccount:(NSString *)alipayAccount
                  QRcode:(NSString *)QRcode
                   Vcode:(NSString *)vcode
                     Pid:(NSString *)pid
                 success:(void (^)(NSString *success))success
                 failure:(void (^)(NSError *error))failure;

/*!
 * 获取子账号列表
 */
+ (void)getChildAccountWithPid:(NSString *)pid
                           Act:(NSString *)act
                        IsShow:(NSString *)isShow
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSError *error))failure;

@end
