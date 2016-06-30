//
//  YKLEwmPosterViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/21.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLEwmPosterViewController : YKLUserBaseViewController

@property int type;//1.大砍价 2.一元抽奖 3.全民秒杀 4.一元速定

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *LabelImageView;
@property (nonatomic,strong) UIImageView *robLabelImageView;
@property (nonatomic,strong) UIImageView *robImageView;

@property (nonatomic,strong) UIImageView *tempImageView;
@property (nonatomic,strong) UIImageView *tempImage;
@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UIImageView *goodsImage;
@property (nonatomic,strong) UIImageView *ewmImageView;

- (void)createBgView;

@end
