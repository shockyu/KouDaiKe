//
//  YKLAuthorListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLAuthorListTableViewCell.h"

@implementation YKLAuthorListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 100)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        
        self.shopNameImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"授权店铺"]];
        self.shopNameImageView.frame = CGRectMake(10, 10, 10, 10);
        [self.bgView addSubview:self.shopNameImageView];
        
        self.shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.shopNameImageView.right+10, 0, self.contentView.width-self.shopNameImageView.right-20, 20)];
        self.shopNameLabel.centerY = self.shopNameImageView.centerY;
        self.shopNameLabel.font = [UIFont systemFontOfSize:16];
//        self.shopNameLabel.textColor = [UIColor blackColor];
        [self.bgView addSubview:self.shopNameLabel];
        
        self.nickNameImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"授权姓名"]];
        self.nickNameImageView.frame = CGRectMake(10, self.shopNameImageView.bottom+10, 10, 10);
        [self.bgView addSubview:self.nickNameImageView];
        
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nickNameImageView.right+10, 0, self.contentView.width/2-self.nickNameImageView.right, 20)];
//        self.nickNameLabel.backgroundColor = [UIColor grayColor];
        self.nickNameLabel.centerY = self.nickNameImageView.centerY;
        self.nickNameLabel.font = [UIFont systemFontOfSize:12];
//        self.nickNameLabel.textColor = [UIColor blackColor];
        [self.bgView addSubview:self.nickNameLabel];
        
        self.mobileImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"授权电话"]];
        self.mobileImageView.frame = CGRectMake(self.nickNameLabel.right+5, self.shopNameImageView.bottom+10, 10, 10);
        [self.bgView addSubview:self.mobileImageView];
        
        self.mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.mobileImageView.right+5, 0, self.contentView.width-self.mobileImageView.right-15, 20)];
//        self.mobileLabel.backgroundColor = [UIColor grayColor];
        self.mobileLabel.centerY = self.mobileImageView.centerY;
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor flatLightBlueColor];
        [self.bgView addSubview:self.mobileLabel];
        
        self.addressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"授权地址"]];
        self.addressImageView.frame = CGRectMake(10, self.nickNameImageView.bottom+10, 10, 15);
        [self.bgView addSubview:self.addressImageView];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addressImageView.right+10, self.mobileLabel.bottom, 250, 30)];
//        self.addressLabel.backgroundColor = [UIColor redColor];
        self.addressLabel.numberOfLines = 2;
//        self.addressLabel.centerY = self.addressImageView.centerY;
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.addressLabel];
        
        self.authorizationTimeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"授权时间"]];
        self.authorizationTimeImageView.frame = CGRectMake(10, self.addressLabel.bottom+10, 10, 10);
        [self.bgView addSubview:self.authorizationTimeImageView];
        
        self.authorizationTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.authorizationTimeImageView.right+10, 0, 250, 20)];
//        self.authorizationTimeLabel.backgroundColor = [UIColor redColor];
        self.authorizationTimeLabel.centerY = self.authorizationTimeImageView.centerY;
        self.authorizationTimeLabel.font = [UIFont systemFontOfSize:12];
        self.authorizationTimeLabel.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.authorizationTimeLabel];
        
    }
    return self;
}

- (void)updateWithFanModel:(YKLAuthorFansModel *)model {
    
    if ([model.shopName isBlankString]) {
        self.shopNameLabel.text = @"暂无";
    }else{
        self.shopNameLabel.text = model.shopName;
    }
    
    if ([model.nickName isBlankString]) {
        self.nickNameLabel.text = @"暂无";
    }else{
        self.nickNameLabel.text = model.nickName;
    }
    
    if ([model.mobile isBlankString]) {
        self.mobileLabel.text = @"暂无";
    }else{
        self.mobileLabel.text = model.mobile;
    }
    
    if ([model.address isBlankString]) {
        self.addressLabel.text = @"暂无";
    }else{
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",model.address,model.street];
    }

    if ([model.authorizationTime isBlankString]) {
        self.authorizationTimeLabel.text = @"暂无";
    }else{
        self.authorizationTimeLabel.text = model.authorizationTime;
    }
    
}

@end
