//
//  MPSConsumerOrderSummaryModel.h
//  MPStore
//
//  Created by apple on 14/12/6.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLBaseModel.h"

// 活动类型
typedef NS_ENUM(NSInteger, YKLActivityListType) {
    //进行中
    YKLActivityListTypeIng = 0,
    //待付款
    YKLActivityListTypeWait = 1,
    //已完成
    YKLActivityListTypeDone = 2
    
};

@interface YKLActivityListSummaryModel : YKLBaseModel


@property (nonatomic, assign) YKLActivityListType orderType;

@property (nonatomic, copy) NSString *activityID;               //活动ID
@property (nonatomic, copy) NSString *title;                    //活动标题
@property (nonatomic, copy) NSString *desc;                     //说明
@property (nonatomic, copy) NSString *originalPrice;            //原价
@property (nonatomic, copy) NSString *basePrice;                //底价
@property (nonatomic, copy) NSString *productNum;               //产品数量
@property (nonatomic, copy) NSString *startBargain;             //砍价起价
@property (nonatomic, copy) NSString *endBargain;               //砍价最高价
@property (nonatomic, copy) NSString *playerNum;                //完成砍价所需人数
@property (nonatomic, copy) NSString *activityNum;              //活动个数
@property (nonatomic, copy) NSString *activityEndTime;          //结束时间
@property (nonatomic, copy) NSString *coverImg;                 //活动图片
@property (nonatomic, copy) NSString *templateID;               //模板ID
@property (nonatomic, copy) NSString *rewardCode;               //现场兑奖码

@property (nonatomic, copy) NSString *status;                   //状态        1进行中 2 待发布 3 已完成
@property (nonatomic, copy) NSString *type;                     //活动类型     1拓客 2动销

@property (nonatomic, copy) NSString *playersNum;               //参于人数
@property (nonatomic, copy) NSString *playersOverNum;           //完成砍价人数
@property (nonatomic, copy) NSString *exposureNum;              //曝光次数

@property (nonatomic, copy) NSString *shareUrl;                 //分享链接
@property (nonatomic, copy) NSString *shareImage;               //分享图片
@property (nonatomic, copy) NSString *shareDesc;                //分享详情


@property (nonatomic, copy) NSString *orderVol;                 //成交量
@property (nonatomic, copy) NSString *orderSale;                //成交额
@property (nonatomic, copy) NSString *templatePrice;            //模板价格

@property (nonatomic, copy) NSString *createTime;               //创建时间
@property (nonatomic, copy) NSString *tmallPrice;               //天猫商城
@property (nonatomic, copy) NSString *onlinePayPrivilege;       //在线支付


@end
