//
//  YKLHighGoReleaseCollectionViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/8.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoReleaseCollectionViewCell.h"

@implementation YKLHighGoReleaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        
        self.goodsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加商品"]];
        self.goodsImageView.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.goodsImageView];
        
        self.nameTitle = [[UILabel alloc]init];
        self.nameTitle.text = @"商品名：";
        self.nameTitle.font = [UIFont systemFontOfSize:11];
        self.nameTitle.textColor = [UIColor blackColor];
//        self.nameTitle.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.nameTitle];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.text = @"点击编辑";
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        self.nameLabel.font = [UIFont systemFontOfSize:11];
        self.nameLabel.textColor = [UIColor lightGrayColor];
//        self.nameLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.nameLabel];
        
        self.timeTitle = [[UILabel alloc]init];
        self.timeTitle.text = @"截止日期：";
        self.timeTitle.font = [UIFont systemFontOfSize:9];
        self.timeTitle.textColor = [UIColor blackColor];
//        self.timeTitle.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.timeTitle];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.text = @"点击编辑";
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont systemFontOfSize:9];
        self.timeLabel.textColor = [UIColor lightGrayColor];
//        self.timeLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.timeLabel];
        
        self.progressView = [[UIImageView alloc]init];
        [self.bgView addSubview:self.progressView];
        
        self.playerLabel = [[UILabel alloc]init];
        self.playerLabel.textColor = [UIColor blackColor];
        self.playerLabel.font = [UIFont systemFontOfSize:9];
        self.playerLabel.text = @"xx人次已参与";
        [self.bgView addSubview:self.playerLabel];
        
        self.noPlayerLabel = [[UILabel alloc]init];
        self.noPlayerLabel.textColor = [UIColor blackColor];
        self.noPlayerLabel.font = [UIFont systemFontOfSize:9];
        self.noPlayerLabel.text = @"还需xx人次";
        [self.bgView addSubview:self.noPlayerLabel];
        
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.layoutNum isEqualToString:@"1"]) {
       
        self.bgView.frame = CGRectMake(0, 0, self.contentView.width, 190);
        
        self.progressView.image = [UIImage imageNamed:@"progress_cross"];
        self.goodsImageView.frame = CGRectMake(10+10, 10, 90, 90);
        
        self.nameTitle.frame = CGRectMake(10+10, self.goodsImageView.bottom+10,45, 18);
        self.nameLabel.frame = CGRectMake(self.nameTitle.right, self.goodsImageView.bottom+10,75, 18);
        
        self.timeTitle.frame = CGRectMake(self.nameTitle.left, self.nameTitle.bottom, 45, 18);
        self.timeLabel.frame = CGRectMake(self.nameLabel.left, self.nameTitle.bottom, 75, 18);
        
        
        self.progressView.frame = CGRectMake(self.nameTitle.left, self.timeLabel.bottom+10, 120, 5);
        self.playerLabel.frame = CGRectMake(self.nameTitle.left, self.progressView.bottom+10, 120/2, 10);
        self.noPlayerLabel.frame = CGRectMake(self.playerLabel.right, self.progressView.bottom+10, 120/2, 10);
        
        self.goodsImageView.centerX = self.progressView.centerX;
        
    }else{
        self.noPlayerLabel.textAlignment = NSTextAlignmentRight;
        
        self.bgView.frame = CGRectMake(0, 0, self.contentView.width, 115);
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10+10, self.bgView.bottom, self.bgView.width-20, 1)];
        lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView addSubview:lineView];
        
        self.goodsImageView.frame = CGRectMake(10+10, 10, 90, 90);        
        self.progressView.image = [UIImage imageNamed:@"progress_vertical"];

        self.nameTitle.frame = CGRectMake(self.goodsImageView.right+10, 15, 45, 18);
        self.nameLabel.frame = CGRectMake(self.nameTitle.right, 15, self.width-self.goodsImageView.right-30-45, 18);
        
        self.timeTitle.frame = CGRectMake(self.nameTitle.left, self.nameTitle.bottom+10, 45, 18);
        self.timeLabel.frame = CGRectMake(self.timeTitle.right, self.nameTitle.bottom+10, self.width-self.goodsImageView.right-30-45, 18);
        
        
        self.progressView.frame = CGRectMake(self.nameTitle.left, self.timeLabel.bottom+10,  self.width-self.goodsImageView.right-30, 5);
        
        self.playerLabel.frame = CGRectMake(self.nameTitle.left, self.progressView.bottom+10, self.progressView.width/2, 10);
        self.noPlayerLabel.frame = CGRectMake(self.playerLabel.right, self.progressView.bottom+10, self.progressView.width/2, 10);

        
    }
   
}

@end
