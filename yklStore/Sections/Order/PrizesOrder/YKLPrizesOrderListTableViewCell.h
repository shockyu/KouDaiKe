//
//  YKLPrizesOrderListTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/16.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLPrizesOrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mobileLabel;

- (void)updateWithFanModel:(YKLHighGoUserListModel *)model;

@end
