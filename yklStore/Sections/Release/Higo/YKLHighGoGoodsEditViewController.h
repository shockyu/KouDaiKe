//
//  YKLHighGoGoodsEditViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLHighGoGoodsEditViewController : YKLUserBaseViewController

@property (nonatomic, strong) NSMutableDictionary *goodsDictionary;//商品详情字典
@property (nonatomic, strong) NSString *actID;                   //活动ID

@property (nonatomic, assign) NSString *titleText;
@property (nonatomic, assign) NSInteger cellNum;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIButton *saveBtn;//保存

@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UITextField *goodsTitleField;
@property (nonatomic, strong) UILabel *goodsIntroLabel;
@property (nonatomic, strong) UITextView *goodsIntroTextField;

@property (nonatomic, strong) UILabel *actPhotoLabel;
@property (nonatomic, strong) UIImageView *actImageView1;
@property (nonatomic, strong) UIImageView *actImageView2;
@property (nonatomic, strong) UIImageView *actImageView3;
@property (nonatomic, strong) UIImageView *actImageView4;
@property (nonatomic, strong) UIImageView *actImageView5;
@property (nonatomic, strong) UIButton *addImageBtn;

@property (nonatomic, strong) UILabel *goodsTotalPriceLabel;
@property (nonatomic, strong) UITextField *goodsTotalPriceField;
@property (nonatomic, strong) UILabel *goodsOncePriceLabel;
@property (nonatomic, strong) UITextField *goodsOncePriceField;
@property (nonatomic, strong) UILabel *totalNumLabel;
@property (nonatomic, strong) UITextField *totalNumField;

@property (strong, nonatomic) NSArray *actIVs;
@property (strong, nonatomic) NSMutableArray *totle;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *actImageViewArr;
@property (strong, nonatomic) NSString *actImageView1_URL;
@property (strong, nonatomic) NSMutableArray *imagePopArr;      //传递图片数组


@property bool hidAddImageBtn;
@property bool isPhoto;               //是否先读取相册
@property NSInteger selectNub;        //上传图片总数
@property float myPercent;            //进度百分百

@end
