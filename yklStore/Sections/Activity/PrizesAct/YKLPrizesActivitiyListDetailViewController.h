//
//  YKLPrizesActivitiyListDetailViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/15.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "QRCodeGenerator.h"

@interface YKLPrizesActivitiyListDetailViewController : YKLUserBaseViewController

@property (nonatomic, strong) YKLRedActivityListModel *detailModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *prizesBgView;
@property (nonatomic, strong) UILabel *prizesTitleLabel;
@property (nonatomic, strong) UILabel *prizesTotleNumLabel;
@property (nonatomic, strong) UILabel *prizesWinNumLabel;

@property (nonatomic, strong) UILabel *prizesNameLabel1;
@property (nonatomic, strong) UILabel *prizesNameLabel2;
@property (nonatomic, strong) UILabel *prizesNameLabel3;
@property (nonatomic, strong) UILabel *prizesTotleNumLabel1;
@property (nonatomic, strong) UILabel *prizesTotleNumLabel2;
@property (nonatomic, strong) UILabel *prizesTotleNumLabel3;
@property (nonatomic, strong) UILabel *prizesWinNumLabel1;
@property (nonatomic, strong) UILabel *prizesWinNumLabel2;
@property (nonatomic, strong) UILabel *prizesWinNumLabel3;

@property (nonatomic, strong) UIView *flowBgView;
@property (nonatomic, strong) UILabel *flowTitleLabel;
@property (nonatomic, strong) UILabel *flowTotleNumLabel;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextView *descTextView;

@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *endTimeShowLabel;
@property (nonatomic, strong) UILabel *securityLabel;
@property (nonatomic, strong) UILabel *securityShowLabel;

@property (nonatomic, strong) UIImageView *successImageView;        //获奖人数
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *successNubLabel;
@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) UIImageView *exposureImageView;       //访问量
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
