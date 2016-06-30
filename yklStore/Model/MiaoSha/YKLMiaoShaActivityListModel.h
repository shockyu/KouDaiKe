//
//  YKLMiaoShaActivityListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLMiaoShaActivityListModel : YKLBaseModel

@property (nonatomic, copy) NSString *activityID;               //活动ID
@property (nonatomic, copy) NSString *title;                    //活动标题
@property (nonatomic, copy) NSString *seckillPrice;             //秒杀价格
@property (nonatomic, copy) NSString *goodsPrice;               //产品原价

@property (nonatomic, copy) NSString *coverImg;                 //活动图片
@property (nonatomic, copy) NSString *createTime;               //创建时间
@property (nonatomic, copy) NSString *startTime;                //活动开始时间
@property (nonatomic, copy) NSString *endTime;                  //活动结束时间
@property (nonatomic, copy) NSString *sortTime;                 //排序时间
@property (nonatomic, copy) NSString *continueTime;             //持续时间

@property (nonatomic, copy) NSString *joinNum;                  //参与人数
@property (nonatomic, copy) NSString *successNum;               //成功秒杀人数
@property (nonatomic, copy) NSString *redeemed;                 //已兑换人数
@property (nonatomic, copy) NSString *exposureNum;              //曝光率


@property (nonatomic, copy) NSString *shareUrl;                 //分享链接
@property (nonatomic, copy) NSString *shareImage;               //分享图片
@property (nonatomic, copy) NSString *shareDesc;                //分享详情

@property (nonatomic, copy) NSString *templateID;               //模板ID

@end
