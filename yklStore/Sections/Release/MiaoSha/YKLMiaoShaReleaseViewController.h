//
//  YKLMiaoShaReleaseViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/20.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLMiaoShaReleaseViewController : YKLUserBaseViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;

/** 产品名 */
@property (nonatomic, strong) UITextField *goodNameField;
/** 秒杀数量 */
@property (nonatomic, strong) UITextField *goodsNunField;
/** 原价 */
@property (nonatomic, strong) UITextField *priceField;
/** 秒杀价 */
@property (nonatomic, strong) UITextField *miaoShaField;
/** 详情页描述 */
@property (nonatomic, strong) UITextView *goodsDesc;
@property (nonatomic, strong) UILabel *goodsDescLabel;
/** 模板选择按钮 */
@property (nonatomic, strong) UIButton *actTemplateChangeBtn;
/** 模板ID */
@property (strong, nonatomic) NSString *templateNub;
/** 模板价格 */
@property (strong, nonatomic) NSString *templatePrice;
/** 开始时间选择按钮 */
@property (nonatomic, strong) UIButton *showStartTimebtn;
/** 单个用户购上限 */
@property (nonatomic, strong) UITextField *payNunField;
/** 10分钟选择按钮 */
@property (nonatomic, strong) UIButton *Min10Btn;
/** 20分钟选择按钮 */
@property (nonatomic, strong) UIButton *Min20Btn;
/** 30分钟选择按钮 */
@property (nonatomic, strong) UIButton *Min30Btn;
/** 活动规则 */
@property (nonatomic, strong) UITextView *ruleDesc;

/** 首页图片数组 */
@property (strong, nonatomic) NSMutableArray *indexImageArr;
/** 添加首页图片 */
@property (nonatomic, strong) UIButton *addIndexImageBtn;
/** 首页图片背景视图 */
@property (nonatomic, strong) UIView *indexImageBgView;

/** 详情页图片数组 */
@property (strong, nonatomic) NSMutableArray *detailImageArr;
/** 添加详情页图片 */
@property (nonatomic, strong) UIButton *addDetailmageBtn;
/** 详情图片背景视图 */
@property (nonatomic, strong) UIView *detailImageBgView;

/** 照相判断 1：首页图，2：详情图，0：不添加 */
@property int photoNub;

/** 兑换码选择器 */
@property (strong, nonatomic) NSArray *nubArray;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIPickerView *myPicker;

@property (nonatomic, strong) UILabel *securityLabel;
@property (nonatomic, strong) UITextField *securityTextField1;
@property (nonatomic, strong) UITextField *securityTextField2;
@property (nonatomic, strong) UITextField *securityTextField3;
@property (nonatomic, strong) UITextField *securityTextField4;

/** 时间选择器 */
@property (strong, nonatomic) UIView *maskTimeView;
@property (strong, nonatomic) UIView *pickerBgTimeView;
@property (strong, nonatomic) UIDatePicker *myTimePicker;

@property (strong, nonatomic) NSString *activityID;
@property BOOL isAgainRealease;//是否为再次发布
@property BOOL isWaitActivity;//是否为待发布
@property BOOL isFirstIn;//是否为首次进入
@property BOOL isEndActivity;

@property (strong, nonatomic) NSString *shareTitle;     //分享标题
@property (strong, nonatomic) NSString *shareURL;       //分享URL
@property (strong, nonatomic) NSString *shareImage;     //分享图片
@property (strong, nonatomic) NSString *shareDesc;      //分享介绍

@end
