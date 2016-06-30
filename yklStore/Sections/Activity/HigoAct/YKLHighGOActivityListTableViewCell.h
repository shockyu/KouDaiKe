//
//  YKLHighGOActivityListTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLHighGOActivityListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *titleImageView;
//@property (nonatomic, strong) UILabel *titleLabel;          //店铺名
@property (nonatomic, strong) UILabel *actTitleLabel;       //活动名
@property (nonatomic, strong) UILabel *descLabel;           //活动介绍

@property (nonatomic, strong) UILabel *originalLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *bargainLabel;
@property (nonatomic, strong) UILabel *bargainPriceLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *activityLabel;
@property (nonatomic, strong) UILabel *activityNameLabel;

//0.进行中
@property (nonatomic, strong) UILabel *participantLabel;
@property (nonatomic, strong) UILabel *participantNubLabel;
@property (nonatomic, strong) UIView *participantLineView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *successNubLabel;
@property (nonatomic, strong) UIView *successLineView;
@property (nonatomic, strong) UIButton *shareBtn;

//1.待发布
@property (nonatomic, strong) UIButton *shareReleaseBtn;

//2.已完成
@property (nonatomic, strong) UILabel *dealLabel;
@property (nonatomic, strong) UILabel *dealNubLabel;
@property (nonatomic, strong) UILabel *dealMoneyLabel;
@property (nonatomic, strong) UILabel *dealMoneyNubLabel;
@end
