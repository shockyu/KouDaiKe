//
//  YKLDuoBaoActivityListTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/1.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLDuoBaoActivityListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *activityLabel;
@property (nonatomic, strong) UILabel *activityNameLabel;

//0.进行中
@property (nonatomic, strong) UILabel *participantLabel;//参与人数
@property (nonatomic, strong) UILabel *participantNubLabel;
@property (nonatomic, strong) UIView *participantLineView;
@property (nonatomic, strong) UILabel *successLabel;//获奖人数
@property (nonatomic, strong) UILabel *successNubLabel;
@property (nonatomic, strong) UIView *successLineView;

@property (nonatomic, strong) UIButton *shareBtn;

//1.待发布
@property (nonatomic, strong) UIButton *shareReleaseBtn;
//2.已完成
@property (nonatomic, strong) UILabel *successedLabel;//已兑奖
@property (nonatomic, strong) UILabel *successedNubLabel;

//@property (nonatomic, strong) UIButton *againReleaseBtn;

@end
