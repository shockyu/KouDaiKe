//
//  YKLHighGoActivityListDetailTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/4.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLHighGoActivityListDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UILabel *descLabel;           //商品名介绍

@property (nonatomic, strong) UILabel *isSuccessLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *numNameLabel;

@property (nonatomic, strong) UILabel *winnnerNameLabel;
@property (nonatomic, strong) UILabel *winnnerMobLabel;
@property (nonatomic, strong) UILabel *isExchangeLabel;

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) NSString *totalStr;

@property (nonatomic, strong) UILabel *isUserLabel;
@property (nonatomic, strong) NSString *isUserStr;

@property (nonatomic, strong) UILabel *remainLabel;
@property (nonatomic, strong) NSString *remainStr;

////0.进行中
//@property (nonatomic, strong) UILabel *participantLabel;
//@property (nonatomic, strong) UILabel *participantNubLabel;
//@property (nonatomic, strong) UILabel *successLabel;
//@property (nonatomic, strong) UILabel *successNubLabel;
//@property (nonatomic, strong) UIButton *shareBtn;
//
////1.待发布
//@property (nonatomic, strong) UIButton *shareReleaseBtn;
//
////2.已完成
//@property (nonatomic, strong) UILabel *dealLabel;
//@property (nonatomic, strong) UILabel *dealNubLabel;
//@property (nonatomic, strong) UILabel *dealMoneyLabel;
//@property (nonatomic, strong) UILabel *dealMoneyNubLabel;

@end
