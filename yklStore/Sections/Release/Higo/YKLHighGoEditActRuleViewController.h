//
//  YKLHighGoEditActRuleViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLHighGoEditActRuleViewController : YKLUserBaseViewController

@property (nonatomic, strong) NSMutableDictionary *actDictionary;//活动详情字典
@property (nonatomic, strong) NSString *actID;//活动ID


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIButton *saveBtn;//保存

@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UITextField *goodsTitleField;
@property (nonatomic, strong) UILabel *goodsIntroLabel;
@property (nonatomic, strong) UITextView *goodsIntroTextField;


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

@property (nonatomic, strong) UILabel *couponPriceLabel;             //代金券区间
@property (nonatomic, strong) UITextField *couponPriceField1;
@property (nonatomic, strong) UITextField *couponPriceField2;

@property (nonatomic, strong) UILabel *couponEndTimeLabel;           //代金券有效期
@property (nonatomic, strong) UIButton *couponEndTimebtn;

@property (nonatomic, strong) UILabel *couponExplainLabel;           //代金券使用说明
@property (nonatomic, strong) UITextView *couponExplainField;

//判断时间按钮点击情况
@property (nonatomic, strong) NSString *selectedStr;
@end
