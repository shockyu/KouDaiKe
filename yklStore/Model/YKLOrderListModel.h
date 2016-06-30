//
//  YKLOrderListModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLOrderListModel : YKLBaseModel


// 订单类型
typedef NS_ENUM(NSInteger, YKLOrderListType) {
    
//    //到店付
//    YKLOrderListTypeFace = 0,
//    //线上付
//    YKLOrderListTypeLine = 1,
    
    //待兑换
    YKLFaceExchangeStatusWait = 0,
    //已兑换
    YKLFaceExchangeStatusDone = 1,
    
    //待发货
    YKLLineReceiveStatusNotReceive = 2,
    //待收货
    YKLLineReceiveStatusWaitReceived = 3,
    //已完成
    YKLLineReceiveStatusDone = 4
};

//// 到店付类型
//typedef NS_ENUM(NSInteger, YKLFaceExchangeStatus) {
//    //待兑换
//    YKLFaceExchangeStatusWait = 0,
//    //已兑换
//    YKLFaceExchangeStatusDone = 1
//};
//
//// 线上付类型
//typedef NS_ENUM(NSInteger, YKLLineReceiveStatus) {
//    //待兑换
//    YKLLineReceiveStatusNotReceive = 0,
//    //已兑换
//    YKLLineReceiveStatusReceived = 1,
//    //已完成
//    YKLLineReceiveStatusDone = 2
//};
//

@property (nonatomic, copy) NSString *activityID;               //活动ID
@property (nonatomic, copy) NSString *buyerID;                  //买家ID
@property (nonatomic, copy) NSString *mobile;                   //买家电话
@property (nonatomic, copy) NSString *buyerName;                //买家姓名
@property (nonatomic, copy) NSString *coverImg;                 //头像
@property (nonatomic, copy) NSString *goodsID;                  //商品ID
@property (nonatomic, copy) NSString *goodsName;                //商品名称
@property (nonatomic, copy) NSString *goodsBasePrice;           //商品底价
@property (nonatomic, copy) NSString *goodsOriginalPrice;       //商品原价
@property (nonatomic, copy) NSString *orderAmount;              //商品成交价
@property (nonatomic, copy) NSString *addTime;                  //添加时间
@property (nonatomic, copy) NSString *orderType;                //订单类型 1.到店模式 2.线上模式


@end
