//
//  YKLHighGoRealeaseMainViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/8.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "YKLTemplateModel.h"

@interface YKLHighGoRealeaseMainViewController : YKLUserBaseViewController

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *actDictionary;

@property BOOL isGoodsList;                                             //商品列表时候刷新
@property (nonatomic, assign) NSInteger cellNum;                        //商品列表cell标示
@property (nonatomic, strong) NSMutableDictionary *actDict;             //储存活动字典
@property (nonatomic, strong) NSMutableDictionary *goodsDict;           //储存商品字典

@property (nonatomic, strong) NSString *layout;                         //排序
@property (nonatomic, strong) NSString *goodsNum;                       //商品个数
@property (nonatomic, strong) NSString *imageURL;                       //模板背景图片
//活动规则字段
@property (nonatomic, strong) NSString *actEndTime;                     //活动结束时间
@property (nonatomic, strong) NSString *tempID;                         //模板ID

@property (strong, nonatomic) NSString *activityID;

@property BOOL isAgainRealease;//是否为再次发布
@property BOOL isWaitActivity;//是否为待发布
@property BOOL isFirstIn;//是否为首次进入

//短信充值金额
@property int moneyNub;
@property  NSInteger orderStatus;                           //订单状态
@property (nonatomic, strong) NSString *content;            //支付内容
@property (nonatomic, strong) NSString *totleMoney;         //支付共计金额
@property (nonatomic, strong) NSMutableArray *payArray;     //支付返回pay数组
@property (nonatomic, strong) NSString *authorPrice;        //授权金额
@property (nonatomic, strong) NSString *discount;           //折扣率
@property (nonatomic, strong) NSString *balance;            //余额支付余额

@property (strong, nonatomic) NSString *shareTitle;     //分享标题
@property (strong, nonatomic) NSString *shareURL;       //分享URL
@property (strong, nonatomic) NSString *shareImage;     //分享图片
@property (strong, nonatomic) NSString *shareDesc;      //分享介绍

@property BOOL isReloadActDict;

- (void)refreshList;

@end
