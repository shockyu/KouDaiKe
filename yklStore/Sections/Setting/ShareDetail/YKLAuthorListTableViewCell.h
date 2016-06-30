//
//  YKLAuthorListTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLAuthorListTableViewCell : UITableViewCell

@property (nonatomic, strong) YKLAuthorFansModel *fanModel;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *shopNameImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *nickNameImageView;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UIImageView *mobileImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *authorizationTimeLabel;
@property (nonatomic, strong) UIImageView *authorizationTimeImageView;

- (void)updateWithFanModel:(YKLAuthorFansModel *)model;
@end
