//
//  YKLSuDingActivityListDetailViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/5.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLSuDingActivityListDetailViewController : YKLUserBaseViewController

@property (nonatomic, strong) YKLMiaoShaActivityListModel *detailModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *goodsNameTitle;
@property (nonatomic, strong) UILabel *goodsName;

@property (nonatomic, strong) UILabel *goodsImageTitle;
@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextView *descTextView;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceShowLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *discounthowLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *startTimeShowLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *endTimeShowLabel;
@property (nonatomic, strong) UILabel *securityLabel;
@property (nonatomic, strong) UILabel *securityShowLabel;
//报名人数
@property (nonatomic, strong) UIImageView *participantImageView;
@property (nonatomic, strong) UILabel *participantLabel;
@property (nonatomic, strong) UILabel *participantNubLabel;
@property (nonatomic, strong) UIButton *participantBtn;
//成功秒杀人数
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *successNubLabel;
@property (nonatomic, strong) UIButton *successBtn;
//剩余数量
@property (nonatomic, strong) UILabel *remainNubLabel;
@property (nonatomic, strong) UILabel *remainLabel;
//访问人数
@property (nonatomic, strong) UIImageView *exposureImageView;
@property (nonatomic, strong) UILabel *exposureNubLabel;
@property (nonatomic, strong) UILabel *exposureLabel;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *ewmBtn;
@property (nonatomic, strong) CustomIOSAlertView *rechargeAlertView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *qRBgView;
@property (nonatomic, strong) UILabel *rechargeAlertTitleLabel;
@property (nonatomic, strong) UIImageView *qRImageView;
@property (nonatomic, strong) UIButton *savaBtn;

- (void)createView;

@end
