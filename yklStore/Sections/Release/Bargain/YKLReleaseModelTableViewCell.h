//
//  YKLReleaseModelTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YKLReleaseModelTableViewCell : UITableViewCell<YKLBaseModelDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceNubLabel;
@property (nonatomic, strong) UILabel  *explainLabel;
@property (nonatomic, strong) UILabel *explainMoreLabel;

@property (nonatomic, strong) UIImageView *selectImageView;

@end
