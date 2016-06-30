//
//  YKLNewYearPosterPreviewViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/22.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLNewYearPosterPreviewViewController : YKLUserBaseViewController

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *upImageView;
@property (nonatomic,strong) UIImageView *labelImageView;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UILabel *shopLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIImageView *addressImageView;

@property (nonatomic,strong) NSString *weString;

- (void)createBgView;
- (void)createContent;
@end
