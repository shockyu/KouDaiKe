//
//  TWTFansViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTFansViewController : UIViewController

@property (nonatomic, strong) UIButton *bargainBtn;
@property (nonatomic, strong) UIImageView *bargainImageView;
@property (nonatomic, strong) UIButton *highShopBtn;
@property (nonatomic, strong) UIImageView *highShopImageView;
@property (nonatomic, strong) UIImageView *selectedImage;

@property (nonatomic, strong) YKLActivityListSummaryModel *detailModel;

- (void)changeButtonPressed;
@end
