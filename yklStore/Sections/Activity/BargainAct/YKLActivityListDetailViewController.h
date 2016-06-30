//
//  YKLActivityListDetailViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/28.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLActivityListDetailViewController : YKLUserBaseViewController

@property (nonatomic, strong) YKLActivityListSummaryModel *detailModel;
@property (nonatomic, strong) NSMutableArray *actImageViewArr;
@property (nonatomic, strong) NSArray *imageViewArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;
@property (nonatomic, strong) UIView *bgView4;
@property (nonatomic, strong) UIView *bgView5;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *ewmBtn;

@property (nonatomic, strong) UILabel *actTitleLabel;
@property (nonatomic, strong) UILabel *actTitleNameLabel;

@property (nonatomic, strong) UILabel *actPhotoLabel;
@property (nonatomic, strong) UIImageView *actImageView1;
@property (nonatomic, strong) UIImageView *actImageView2;
@property (nonatomic, strong) UIImageView *actImageView3;
@property (nonatomic, strong) UIImageView *actImageView4;
@property (nonatomic, strong) UIImageView *actImageView5;

@property (nonatomic, strong) UILabel *actDescLabel;        //活动说明
@property (nonatomic, strong) UITextView *actDesctextView;  //活动说明TextView

@property (nonatomic, strong) UILabel *priceNubLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *basePriceNubLabel;
@property (nonatomic, strong) UILabel *basePriceLabel;
@property (nonatomic, strong) UILabel *bargainNubLabel;
@property (nonatomic, strong) UILabel *bargainLabel;

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *numShowLabel;
@property (nonatomic, strong) UILabel *endTimeTitleLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *securityTitleLabel;
@property (nonatomic, strong) UILabel *securityLabel;

//@property (nonatomic, strong) UIImageView *participantImageView;    //成功砍价
@property (nonatomic, strong) UILabel *participantLabel;
@property (nonatomic, strong) UILabel *participantNubLabel;
@property (nonatomic, strong) UIButton *participantBtn;

//@property (nonatomic, strong) UIImageView *successImageView;        //参与砍价
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *successNubLabel;
@property (nonatomic, strong) UIButton *successBtn;

//@property (nonatomic, strong) UIImageView *exposureImageView;       //曝光次数
@property (nonatomic, strong) UILabel *exposureNubLabel;
@property (nonatomic, strong) UILabel *exposureLabel;

- (void)createView;
@end
