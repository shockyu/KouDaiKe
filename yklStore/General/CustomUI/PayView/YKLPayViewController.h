//
//  YKLPayViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLPayViewController : YKLUserBaseViewController

@property (nonatomic, strong) NSString *payType;


//充值金额
@property (nonatomic, strong) NSString *authorPrice;        //授权金额
@property float discount;                                   //折扣率
@property (nonatomic, strong) NSString *balance;            //余额支付余额
@property float vipPrice;                                   //VIP价格

@property int moneyNub;                                     //短信充值金额

@property  NSInteger orderStatus;                           //订单状态

@property (nonatomic, strong) NSString *content;            //支付内容
@property (nonatomic, strong) NSString *totleMoney;         //支付共计金额
@property (nonatomic, strong) NSMutableArray *payArray;     //支付返回pay数组
@property (nonatomic, strong) NSDictionary *templateModel;  //订单数据

@property float templateMoneyNum;                           //模板：金额
@property float SMSMoneyNum;                                //短信：金额
@property float authorMoneyNum;                             //授权：金额
@property float flowMoneyNum;                               //流量：金额
@property float totleMoneyNum;                              //总计：金额

@property int childNum;                                     //购买子账号个数

@property (nonatomic, strong) NSString *activityID;         //活动ID
@property (nonatomic, strong) NSString *orderType;          //订单类型 1.大砍价 2.一元抽奖 3.口袋红包 4.口袋夺宝 5.秒杀
@property BOOL isListPop;                                   //YES:活动列表pop
@property BOOL isListDetailPop;                             //YES:大砍价或一起嗨待发布活动详情pop

//黄钻选择按钮
@property BOOL authorVIP;

@end
