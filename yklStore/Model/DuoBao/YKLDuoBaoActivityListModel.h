//
//  YKLDuoBaoActivityListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/7.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLDuoBaoActivityListModel : YKLBaseModel

@property (nonatomic, copy) NSString *activityID;               //活动ID
@property (nonatomic, copy) NSString *title;                    //活动标题
@property (nonatomic, copy) NSString *shopName;                 //店铺名
@property (nonatomic, copy) NSString *desc;                     //说明
@property (nonatomic, copy) NSString *activityEndTime;          //结束时间
@property (nonatomic, copy) NSString *coverImg;                 //活动图片
@property (nonatomic, copy) NSString *rewardCode;               //现场兑奖码
@property (nonatomic, copy) NSString *status;                   //状态            1进行中 2 待发布 3 已完成
@property (nonatomic, copy) NSString *couponType;               //代金券类型       0全店通用 1可选品牌
@property (nonatomic, copy) NSString *couponBrand;              //代金券适用品牌

@property (nonatomic, copy) NSString *shareUrl;                 //分享链接
@property (nonatomic, copy) NSString *shareImage;               //分享图片
@property (nonatomic, copy) NSString *shareDesc;                //分享详情
@property (nonatomic, copy) NSString *templatePrice;            //模板价格
@property (nonatomic, copy) NSString *createTime;               //创建时间

@property (nonatomic, copy) NSString *successNum;               //获奖人数
@property (nonatomic, copy) NSString *joinNum;                  //参与人数
@property (nonatomic, copy) NSString *redeemed;                 //已兑奖

@end
