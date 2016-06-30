//
//  YKLDuoBaoReleaseViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/2/29.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLDuoBaoReleaseViewController : YKLUserBaseViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *shareSaveBtn;//保存并分享到微信

//设置奖品
@property (nonatomic, strong) UILabel *goodsTitle;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UITextField *goodsNameField;

@property (nonatomic, strong) UILabel *goodsPhotoLabel;
@property (nonatomic, strong) UIImageView *goodsImageView1;
@property (nonatomic, strong) UIButton *addImageBtn;

//原价
@property (nonatomic, strong) UILabel *originalPrize;
@property (nonatomic, strong) UITextField *originalPrizeField;
//打劫价
@property (nonatomic, strong) UILabel *discountlPrize;
@property (nonatomic, strong) UITextField *discountlPrizeField;
//线上支付立减
@property (nonatomic, strong) UILabel *onlinePay;
@property (nonatomic, strong) UITextField *onlinePayField;
//设置代金卷
@property (nonatomic, strong) UILabel *couponTitle;
@property (nonatomic, strong) UILabel *couponRangeTitle;
//代金卷适用品牌
@property (nonatomic, strong) UIView *couponBrandBgView;
@property (nonatomic, strong) UILabel *couponBrand;
@property (nonatomic, strong) UITextField *couponBrandField;
@property (nonatomic, strong) UILabel *couponGeneral;
@property (nonatomic, strong) UIButton *selectGeneralBtn;
//代金券区间
@property (nonatomic, strong) UILabel *couponPriceLabel;
@property (nonatomic, strong) UITextField *couponPriceField1;
@property (nonatomic, strong) UITextField *couponPriceField2;
//代金券有效期
@property (nonatomic, strong) UILabel *couponEndTimeLabel;
@property (nonatomic, strong) UIButton *couponEndTimebtn;
//设置奖品数
@property (nonatomic, strong) UILabel *goodsNumTitle;
@property (nonatomic, strong) UITextField *goodsNumField;
//活动有效期
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIButton *endTimebtn;
//判断时间按钮点击情况
@property (nonatomic, strong) NSString *selectedStr;
//时间弹窗
@property (strong, nonatomic) UIView *maskTimeView;
@property (strong, nonatomic) UIView *pickerBgTimeView;
@property (strong, nonatomic) UIDatePicker *myTimePicker;
@property (strong, nonatomic) NSArray *nubArray;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIPickerView *myPicker;
//兑奖码设置
@property (nonatomic, strong) UILabel *rewardCodeLabel;
@property (nonatomic, strong) UITextField *securityTextField1;
@property (nonatomic, strong) UITextField *securityTextField2;
@property (nonatomic, strong) UITextField *securityTextField3;
@property (nonatomic, strong) UITextField *securityTextField4;
@property (nonatomic, strong) UIButton *rewardCodeBtn;
//设置活动规则
@property (nonatomic, strong) UILabel *actRuleTitle;
@property (nonatomic, strong) UITextView *actRuleTextView;

@property (strong, nonatomic) NSArray *actIVs;
@property (strong, nonatomic) NSMutableArray *totle;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *actImageViewArr;
@property (strong, nonatomic) NSString *actImageView1_URL;

@property bool hidAddImageBtn;
@property bool isPhoto;               //是否先读取相册
@property NSInteger selectNub;        //上传图片总数
@property float myPercent;            //进度百分百

@property (strong, nonatomic) NSString *activityID;
@property (nonatomic, strong) YKLDuoBaoActivityListModel *detailModel;
@property BOOL isEndActivity;
@property BOOL isWaitActivity;

@property (strong, nonatomic) NSString *shareTitle;     //分享标题
@property (strong, nonatomic) NSString *shareURL;       //分享URL
@property (strong, nonatomic) NSString *shareImage;     //分享图片
@property (strong, nonatomic) NSString *shareDesc;      //分享介绍

//充值金额
@property (nonatomic, strong) NSString *authorPrice;        //授权金额
@property (nonatomic, strong) NSString *discount;           //折扣率
@property (nonatomic, strong) NSString *balance;            //余额支付余额
@property int moneyNub;                                     //短信充值金额
@property  NSInteger orderStatus;                           //订单状态
@property (nonatomic, strong) NSString *content;            //支付内容
@property (nonatomic, strong) NSString *totleMoney;         //支付共计金额
@property (nonatomic, strong) NSMutableArray *payArray;     //支付返回pay数组

@end
