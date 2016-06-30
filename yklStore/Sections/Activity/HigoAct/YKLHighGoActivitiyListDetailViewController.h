//
//  YKLHighGoActivitiyListDetailViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/3.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
//#import "YKLHighGoActivityListView.h"
#import "YKLHighGoActivityListDetailTableView.h"
#import "QRCodeGenerator.h"

@interface YKLHighGoActivitiyListDetailViewController : YKLUserBaseViewController
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *actTitleLabel;
@property (nonatomic, strong) UILabel *actTitleNameLabel;
@property (nonatomic, strong) UITextView *actDesctextView;          //活动说明TextView
//@property (nonatomic, strong) UIImageView *successImageView;        //参与砍价
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *successNubLabel;
//@property (nonatomic, strong) UIImageView *exposureImageView;       //曝光次数
@property (nonatomic, strong) UILabel *exposureNubLabel;
@property (nonatomic, strong) UILabel *exposureLabel;
@property (nonatomic, strong) UILabel *actTypeLabel;                //活动类型
@property (nonatomic, strong) UILabel *actTypeNameLabel;            //活动类型显示
@property (nonatomic, strong) UILabel *successGoodsLabel;           //成功产品数
@property (nonatomic, strong) UILabel *successGoodsNumLabel;        //成功产品数显示
@property (nonatomic, strong) UILabel *endTimeLabel;                //活动截止时间
@property (nonatomic, strong) UILabel *endTimeShowLabel;            //活动截止时间显示
@property (nonatomic, strong) UILabel *securityLabel;               //兑奖码
@property (nonatomic, strong) UILabel *securityShowLabel;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *ewmBtn;
@property (nonatomic, strong) CustomIOSAlertView *rechargeAlertView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *qRBgView;
@property (nonatomic, strong) UILabel *rechargeAlertTitleLabel;
@property (nonatomic, strong) UIImageView *qRImageView;
@property (nonatomic, strong) UIButton *savaBtn;

@property (nonatomic, strong) YKLHighGoActivityListModel *detailModel;
@property (nonatomic, strong) NSMutableArray *actGoodsArr;
@property int type;
- (void)createView;

@end
