//
//  YKLHighGoOrderListTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLHighGoOrderListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobleLabel;
@property (nonatomic, strong) UILabel *actTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;         //原价
@property (nonatomic, strong) UILabel *lowestPriceLabel;   //最低看到多少
@property (nonatomic, strong) UILabel *peducePriceLabel;   //成交价
@property (nonatomic, strong) UIButton *sendBtn;           //发给员工处理
@end
