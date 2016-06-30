//
//  TWTOrderViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/18.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTOrderViewController : UIViewController

@property (nonatomic, strong) UIButton *bargainBtn;
@property (nonatomic, strong) UIImageView *bargainImageView;
@property (nonatomic, strong) UIButton *highShopBtn;
@property (nonatomic, strong) UIImageView *highShopImageView;
@property (nonatomic, strong) UIButton *prizesBtn;
@property (nonatomic, strong) UIImageView *prizesImageView;
@property (nonatomic, strong) UIButton *duoBaoBtn;
@property (nonatomic, strong) UIImageView *duoBaoImageView;
@property (nonatomic, strong) UIImageView *selectedImage;

- (void)changeButtonPressed;
@end
