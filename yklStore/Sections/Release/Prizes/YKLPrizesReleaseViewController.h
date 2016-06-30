//
//  YKLPrizesReleaseViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/13.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "YKLTogetherShareViewController.h"

@interface YKLPrizesReleaseViewController : YKLUserBaseViewController

@property (strong, nonatomic) NSString *activityID;
@property (nonatomic, strong) YKLRedActivityListModel *detailModel;
@property BOOL isEndActivity;
@property BOOL isWaitActivity;

@property (strong, nonatomic) NSString *shareTitle;     //分享标题
@property (strong, nonatomic) NSString *shareURL;       //分享URL
@property (strong, nonatomic) NSString *shareImage;     //分享图片
@property (strong, nonatomic) NSString *shareDesc;      //分享介绍

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;
@property (nonatomic, strong) UIView *bgView4;
@property (nonatomic, strong) UIView *bgView5;
@property (nonatomic, strong) UIButton *shareSaveBtn;//保存并分享到微信

@property (nonatomic, strong) UILabel *prizesTypeLabel;
@property (nonatomic, strong) UILabel *prizeLabel;
@property (nonatomic, strong) UIButton *prizeBtn;
@property (nonatomic, strong) UILabel *flowLabel;
@property (nonatomic, strong) UIButton *flowBtn;

@property (nonatomic, strong) UILabel *prizesSetLabel;
@property (nonatomic, strong) UIView *goodsBgView;
@property (nonatomic, strong) UIButton *addGoodsBtn;
//1号奖品
@property (nonatomic, strong) UIView *goodsView1;
@property (nonatomic, strong) UILabel *goodsNameLabel1;
@property (nonatomic, strong) UITextField *goodsNameField1;
@property (nonatomic, strong) UILabel *goodsNumLabel1;
@property (nonatomic, strong) UITextField *goodsNumField1;
@property (nonatomic, strong) UIButton *goodsDeleteBtn1;

//2号奖品
@property (nonatomic, strong) UIView *goodsView2;
@property (nonatomic, strong) UILabel *goodsNameLabel2;
@property (nonatomic, strong) UITextField *goodsNameField2;
@property (nonatomic, strong) UILabel *goodsNumLabel2;
@property (nonatomic, strong) UITextField *goodsNumField2;
@property (nonatomic, strong) UIButton *goodsDeleteBtn2;

//3号奖品
@property (nonatomic, strong) UIView *goodsView3;
@property (nonatomic, strong) UILabel *goodsNameLabel3;
@property (nonatomic, strong) UITextField *goodsNameField3;
@property (nonatomic, strong) UILabel *goodsNumLabel3;
@property (nonatomic, strong) UITextField *goodsNumField3;
@property (nonatomic, strong) UIButton *goodsDeleteBtn3;

@property (nonatomic, strong) UILabel *useDescLabel;
@property (nonatomic, strong) UITextView *useDescTextView;

@property (nonatomic, strong) UILabel *flowSetLabel;
@property (nonatomic, strong) UILabel *flowNumLabel;
@property (nonatomic, strong) UITextField *flowNumField;
@property (nonatomic, strong) UILabel *flowMoneyLabel;
@property (nonatomic, strong) UILabel *getFlowNumLabel;
@property (nonatomic, strong) UITextField *getFlowNumField;

@property (nonatomic, strong) UILabel *wishLabel;
@property (nonatomic, strong) UITextField *wishField;

@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIButton *showEndTimebtn;
@property (nonatomic, strong) UILabel *rewardCodeLabel; //兑奖码设置
@property (nonatomic, strong) UITextField *securityTextField1;
@property (nonatomic, strong) UITextField *securityTextField2;
@property (nonatomic, strong) UITextField *securityTextField3;
@property (nonatomic, strong) UITextField *securityTextField4;
@property (nonatomic, strong) UIButton *rewardCodeBtn;

@property (strong, nonatomic) UIView *maskTimeView;
@property (strong, nonatomic) UIView *pickerBgTimeView;
@property (strong, nonatomic) UIDatePicker *myTimePicker;
@property (strong, nonatomic) NSArray *nubArray;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIPickerView *myPicker;


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
