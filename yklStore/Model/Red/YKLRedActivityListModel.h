//
//  YKLRedActivityListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/21.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLRedActivityListModel : YKLBaseModel

@property (nonatomic, copy) NSString *activityID;               //活动ID
@property (nonatomic, copy) NSString *title;                    //活动标题
@property (nonatomic, copy) NSString *shopName;                 //店铺名
@property (nonatomic, copy) NSString *desc;                     //说明
@property (nonatomic, copy) NSString *activityEndTime;          //结束时间
@property (nonatomic, copy) NSString *coverImg;                 //活动图片
@property (nonatomic, copy) NSString *templateID;               //模板ID
@property (nonatomic, copy) NSString *rewardCode;               //现场兑奖码
@property (nonatomic, copy) NSString *status;                   //状态        1进行中 2 待发布 3 已完成
@property (nonatomic, copy) NSString *type;                     //活动类型     1拓客 2动销
@property (nonatomic, copy) NSString *shareUrl;                 //分享链接
@property (nonatomic, copy) NSString *shareImage;               //分享图片
@property (nonatomic, copy) NSString *shareDesc;                //分享详情
@property (nonatomic, copy) NSString *templatePrice;            //模板价格
@property (nonatomic, copy) NSString *createTime;               //创建时间

@property (nonatomic, copy) NSString *prizesCount;              //奖品中奖人数
@property (nonatomic, copy) NSString *flowCount;                //流量中奖人数
@property (nonatomic, copy) NSString *surplusFlowNum;           //流量剩余
@property (nonatomic, copy) NSString *surplusPrizesNum;         //奖品剩余
@property (nonatomic, copy) NSString *playerNum;                //参与人数

@end
