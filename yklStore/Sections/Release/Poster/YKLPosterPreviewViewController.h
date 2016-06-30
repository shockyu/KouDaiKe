//
//  YKLPosterPreviewViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLPosterPreviewViewController : YKLUserBaseViewController

@property (nonatomic,strong) UIView *bgView;
@property int colorStatus;  //1.红 2.橙 3.黄 4.绿 5.青 6.蓝 7.紫

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *upImageView;
@property (nonatomic,strong) UIImageView *swearImageView;

@property (nonatomic,strong) UIView *roundView;//大圆球
@property (nonatomic,strong) UILabel *weLabel;
@property (nonatomic,strong) NSString *weString;
@property (nonatomic,strong) UIImageView *witnessImageView;
@property (nonatomic,strong) UILabel *shopLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIImageView *addressImageView;

- (void)createBgView;
- (void)createContent;
@end
