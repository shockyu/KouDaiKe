//
//  YKLActivityListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/16.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLActivityListTableViewCell.h"

@implementation YKLActivityListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
       
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 150)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];

        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo"]];
//        self.titleImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.titleImageView.frame = CGRectMake(10, 10, 75, 75);
        [self.bgView addSubview:self.titleImageView];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleImageView.bottom+5, self.bgView.width, 0.5)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.lineView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImageView.right+5, 10, self.width-self.titleImageView.right-20, 18)];
        self.titleLabel.text = @"双11居家用品全面促销活动";
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        //        self.titleLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.titleLabel];
        
        self.originalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.titleLabel.bottom+5, 36, 13)];
        self.originalLabel.text = @"原价：";
        self.originalLabel.textColor = [UIColor lightGrayColor];
        self.originalLabel.font = [UIFont systemFontOfSize:12];
//        self.originalLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.originalLabel];
        
        self.originalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.originalLabel.right, self.titleLabel.bottom+5, 55, 13)];
        self.originalPriceLabel.text = @"¥1222223";
        //删除线
        NSUInteger length = [self.originalPriceLabel.text length];
        self.originalPriceLabel.size = CGSizeMake(length*8, 13);
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.originalPriceLabel.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
        [self.originalPriceLabel setAttributedText:attri];
        
        self.originalPriceLabel.textColor = [UIColor lightGrayColor];
        self.originalPriceLabel.font = [UIFont systemFontOfSize:12];
//        self.originalPriceLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.originalPriceLabel];
        
        self.bargainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.originalLabel.bottom+5, 60, 13)];
        self.bargainLabel.text = @"最低砍到：";
        self.bargainLabel.textColor = [UIColor lightGrayColor];
        self.bargainLabel.font = [UIFont systemFontOfSize:12];
//        self.bargainLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.bargainLabel];
        
        self.bargainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bargainLabel.right, self.bargainLabel.top, 70, 13)];
        self.bargainLabel.text = @"¥122";
        self.bargainLabel.textColor = [UIColor flatLightRedColor];
        self.bargainLabel.font = [UIFont systemFontOfSize:12];
//        self.bargainLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.bargainLabel];
        
        self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.bargainLabel.bottom+5, 130, 13)];
        self.endTimeLabel.text = @"结束时间：2015-10-05";
        self.endTimeLabel.textColor = [UIColor lightGrayColor];
        self.endTimeLabel.font = [UIFont systemFontOfSize:12];
//        self.endTimeLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.endTimeLabel];
        
        self.activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeLabel.right+5, self.bargainLabel.bottom+5, 60, 13)];
        self.activityLabel.text = @"活动类型：";
        self.activityLabel.textColor = [UIColor lightGrayColor];
        self.activityLabel.font = [UIFont systemFontOfSize:12];
//        self.activityLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.activityLabel];
        
        self.activityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.activityLabel.right, self.bargainLabel.bottom+5, 30, 13)];
        self.activityNameLabel.text = @"到店";
        self.activityNameLabel.textColor = [UIColor flatLightRedColor];
        self.activityNameLabel.font = [UIFont systemFontOfSize:12];
//                self.activityNameLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.activityNameLabel];
        
        
        //0,进行中,分享
        self.participantNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.lineView.bottom+10,80,18)];
        self.participantNubLabel.textAlignment = NSTextAlignmentCenter;
        self.participantNubLabel.text = @"0";
        self.participantNubLabel.textColor = [UIColor flatLightRedColor];
        self.participantNubLabel.font = [UIFont systemFontOfSize:14];
//        self.participantNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.participantNubLabel];
        
        self.participantLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.participantNubLabel.bottom,80,18)];
        self.participantLabel.textAlignment = NSTextAlignmentCenter;
        self.participantLabel.text = @"参与人数";
        self.participantLabel.textColor = [UIColor lightGrayColor];
        self.participantLabel.font = [UIFont systemFontOfSize:12];
//        self.participantLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.participantLabel];
        
        self.participantLineView = [[UIView alloc]initWithFrame:CGRectMake(self.participantLabel.right, self.lineView.bottom+15, 0.5, 30)];
        self.participantLineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.participantLineView];
        
        
        self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.lineView.bottom+10,80,18)];
        self.successNubLabel.textAlignment = NSTextAlignmentCenter;
        self.successNubLabel.text = @"0";
        self.successNubLabel.textColor = [UIColor flatLightRedColor];
        self.successNubLabel.font = [UIFont systemFontOfSize:14];
//        self.successNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.successNubLabel];
        
        self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.participantNubLabel.bottom,80,18)];
        self.successLabel.textAlignment = NSTextAlignmentCenter;
        self.successLabel.text = @"成功砍价";
        self.successLabel.textColor = [UIColor lightGrayColor];
        self.successLabel.font = [UIFont systemFontOfSize:12];
//        self.successLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.successLabel];
        
        self.successLineView = [[UIView alloc]initWithFrame:CGRectMake(self.successNubLabel.right, self.lineView.bottom+15, 0.5, 30)];
        self.successLineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.successLineView];
        

        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundColor = [UIColor redColor];
        self.shareBtn.frame = CGRectMake(212,self.lineView.bottom,106,60);
        //        [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview: self.shareBtn];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分享"]];
        imageView.frame = CGRectMake(0, 15, 14, 12);
        imageView.centerX = self.shareBtn.width/2;
        [self.shareBtn addSubview:imageView];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,imageView.bottom+1,self.shareBtn.width,18)];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.text = @"分享";
        shareLabel.textColor = [UIColor lightGrayColor];
        shareLabel.font = [UIFont systemFontOfSize:12];
        shareLabel.backgroundColor = [UIColor clearColor];
        [self.shareBtn addSubview:shareLabel];

        //1,待发布,分享并发布到微信
        self.shareReleaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundColor = [UIColor redColor];
        self.shareReleaseBtn.frame = CGRectMake(212,self.lineView.bottom,106,60);
        //        [self.shareReleaseBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview: self.shareReleaseBtn];
        
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发布"]];
        imageView.frame = CGRectMake(0, 15, 14, 12);
        imageView.centerX = self.shareBtn.width/2;
        [self.shareReleaseBtn addSubview:imageView];
        
        shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,imageView.bottom+1,self.shareBtn.width,18)];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.text = @"保存并发布";
        shareLabel.textColor = [UIColor lightGrayColor];
        shareLabel.font = [UIFont systemFontOfSize:12];
        shareLabel.backgroundColor = [UIColor clearColor];
        [self.shareReleaseBtn addSubview:shareLabel];
        
        
        
        //2,已完成
        self.dealNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right,self.lineView.bottom+10,80,18)];
        self.dealNubLabel.textAlignment = NSTextAlignmentCenter;
        self.dealNubLabel.text = @"0";
        self.dealNubLabel.textColor = [UIColor flatLightRedColor];
        self.dealNubLabel.font = [UIFont systemFontOfSize:14];
//        self.dealNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.dealNubLabel];
        
        self.dealLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right,self.dealNubLabel.bottom,80,18)];
        self.dealLabel.textAlignment = NSTextAlignmentCenter;
        self.dealLabel.text = @"成交量";
        self.dealLabel.textColor = [UIColor lightGrayColor];
        self.dealLabel.font = [UIFont systemFontOfSize:12];
//        self.dealLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.dealLabel];
        
        self.dealLineView = [[UIView alloc]initWithFrame:CGRectMake(self.dealNubLabel.right, self.lineView.bottom+15, 0.5, 30)];
        self.dealLineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.dealLineView];
        
        self.dealMoneyNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.dealLabel.right,self.lineView.bottom+10,80,18)];
        self.dealMoneyNubLabel.textAlignment = NSTextAlignmentCenter;
        self.dealMoneyNubLabel.text = @"0";
        self.dealMoneyNubLabel.textColor = [UIColor flatLightRedColor];
        self.dealMoneyNubLabel.font = [UIFont systemFontOfSize:14];
//        self.dealNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.dealMoneyNubLabel];
        
        self.dealMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.dealLabel.right,self.dealNubLabel.bottom,80,18)];
        self.dealMoneyLabel.textAlignment = NSTextAlignmentCenter;
        self.dealMoneyLabel.text = @"成交额";
        self.dealMoneyLabel.textColor = [UIColor lightGrayColor];
        self.dealMoneyLabel.font = [UIFont systemFontOfSize:12];
//        self.dealLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.dealMoneyLabel];
        
        
    }
    return self;
}


@end
