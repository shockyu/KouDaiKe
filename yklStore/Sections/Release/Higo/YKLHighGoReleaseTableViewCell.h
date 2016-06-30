//
//  YKLHighGoReleaseTableViewCell.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLHighGoReleaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIProgressView *progressView; //进度条
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *playerLabel;         //参与人数
@property (nonatomic, strong) UILabel *noPlayerLabel;       //未参与人数

//@property (strong, nonatomic) NSMutableArray *imageArr;     //图片存储数组

@end
