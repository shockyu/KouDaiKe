//
//  MPBaseNetworking.h
//  MPStore
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//正式接口
#define ROOT_URL @"http://ykl.meipa.net/admin.php/Api/"

#define API_Token @"EPveMP8T-dJ_NGsoNN7VNZAX"
//测试接口
//#define ROOT_URL @"http://ykl.meipa.net/admin.php/TestApi/"

//口袋红包接口
#define ROOTRED_URL @"http://ykl.meipa.net/admin.php/RedApi"

//一元抽奖接口
#define ROOTWX_URL @"http://ykl.meipa.net/weixin.php/Api"

//口袋夺宝接口
#define ROOTDUOBAO_URL @"http://ykl.meipa.net/indiana.php/Api"

//全民秒杀接口
#define ROOTMiaoSha_URL @"http://ykl.meipa.net/indiana.php/SeckillApi"

//一元速定接口
#define ROOTSuDing_URL @"http://ykl.meipa.net/indiana.php/SecSetApi"


#pragma mark -  口袋说

// 基础地址
#define ROOTZZS_URL @"http://ykl.meipa.net/admin.php/ZzsApi"
// 列表
#define KDS_LIST_ACT            @"get_fileList"
// 收藏
#define KDS_FAVOURITE_ACT       @"get_file_collection"
// 详情(视频)
#define KDS_DETAIL_ACT          @"get_file_info"
// 评论列表
#define KDS_COMMENT_ACT         @"get_comment"
// 添加评论
#define KDS_ADD_COMMENT_ACT     @"add_comment"
// 添加收藏
#define KDS_ADD_COLLECTION_ACT  @"add_collection"

#pragma mark -  口袋联采

// 基础地址
#define ROOTShop_URL @"http://ykl.meipa.net/admin.php/UnionPurchase"
// 订单管理
#define ORDER_LIST_ACT            @"get_orderList"

#define ORDER_QRSH_ACT            @"receiving_goods"

#define ORDER_QRZF_ACT            @"add_order"





typedef enum {
    EMPSNetworkingErrorTypeAccountInvalid,
    EMPSNetworkingErrorTypeNetConnectFail,
    EMPSNetworkingErrorTypeServiceFail,
} EMPSNetworkingErrorType;

@interface YKLBaseNetworking : NSObject

+ (AFHTTPRequestOperationManager *)shareManager;

+ (void)cancelAllRequest;

+ (void)POSTOnlyApi:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)POST:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)POSTWX:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)POSTRed:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)POSTDuoBao:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)POSTMiaoSha:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//+ (void)POSTZZS:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSArray *)constructModelsForClass:(Class)aClass withData:(NSArray *)data;

+ (NSString *)appVersion;

@end
