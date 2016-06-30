//
//  YKLSuDingActivityListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/5.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLSuDingActivityListTableViewCell.h"

@implementation YKLSuDingActivityListTableViewCell

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
        
        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"红包Demo.png"]];
        //        self.titleImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.titleImageView.frame = CGRectMake(10, 10, 75, 75);
        [self.bgView addSubview:self.titleImageView];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleImageView.bottom+5, self.bgView.width, 1)];
        self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView addSubview:self.lineView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImageView.right+10, 10, self.width-self.titleImageView.right-20, 18)];
        self.titleLabel.text = @"XX奖品";
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        //        self.titleLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.titleLabel];
        
        //        self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.titleLabel.bottom, self.width-self.titleImageView.right-20, 18*2)];
        //        self.descLabel.numberOfLines = 2;
        //        self.descLabel.text = @"活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍";
        //        self.descLabel.textColor = [UIColor lightGrayColor];
        //        self.descLabel.font = [UIFont systemFontOfSize:10];
        //        //        self.endTimeLabel.backgroundColor = [UIColor redColor];
        //        [self.bgView addSubview:self.descLabel];
        
        UILabel *miaoShaMoneyTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.titleLabel.bottom, 50, 18)];
        miaoShaMoneyTitle.text = @"速定价：";
        miaoShaMoneyTitle.textColor = [UIColor lightGrayColor];
        miaoShaMoneyTitle.font = [UIFont systemFontOfSize:10];
        //        miaoShaMoneyTitle.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:miaoShaMoneyTitle];
        
        
        self.miaoShaMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(miaoShaMoneyTitle.right, self.titleLabel.bottom, self.width-self.titleImageView.right-20, 18)];
        self.miaoShaMoneyLabel.text = @"12元";
        self.miaoShaMoneyLabel.textColor = [UIColor flatLightRedColor];
        self.miaoShaMoneyLabel.font = [UIFont systemFontOfSize:10];
        //        self.miaoShaMoneyLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.miaoShaMoneyLabel];
        
        self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.miaoShaMoneyLabel.bottom, self.width-self.titleImageView.right-20, 18)];
//        self.startTimeLabel.text = @"开始时间：2015-10-23 20:00";
        self.startTimeLabel.textColor = [UIColor lightGrayColor];
        self.startTimeLabel.font = [UIFont systemFontOfSize:10];
        //        self.startTimeLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.startTimeLabel];
        
        
        self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.origin.x, self.startTimeLabel.bottom, self.width-self.titleImageView.right-70-20, 18)];
        self.endTimeLabel.text = @"结束时间：2015-10-05";
        self.endTimeLabel.textColor = [UIColor lightGrayColor];
        self.endTimeLabel.font = [UIFont systemFontOfSize:10];
        //        self.endTimeLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.endTimeLabel];
        
        self.activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, 50, 18)];
        self.activityLabel.text = @"活动类型：";
        self.activityLabel.textColor = [UIColor lightGrayColor];
        self.activityLabel.font = [UIFont systemFontOfSize:10];
        //        self.activityLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.activityLabel];
        
        self.activityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.activityLabel.right, self.endTimeLabel.top, 20, 18)];
        self.activityNameLabel.text = @"速定";
        self.activityNameLabel.textColor = [UIColor flatLightRedColor];
        self.activityNameLabel.font = [UIFont systemFontOfSize:10];
        //                self.activityNameLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.activityNameLabel];
        
        //0,进行中,分享
        self.participantNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.lineView.bottom+10,106,18)];
        self.participantNubLabel.textAlignment = NSTextAlignmentCenter;
        self.participantNubLabel.text = @"0";
        self.participantNubLabel.textColor = [UIColor flatLightRedColor];
        self.participantNubLabel.font = [UIFont systemFontOfSize:14];
        //        self.participantNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.participantNubLabel];
        
        self.participantLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.participantNubLabel.bottom,106,18)];
        self.participantLabel.textAlignment = NSTextAlignmentCenter;
        self.participantLabel.text = @"访问量";
        self.participantLabel.textColor = [UIColor lightGrayColor];
        self.participantLabel.font = [UIFont systemFontOfSize:12];
        //        self.participantLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.participantLabel];
        
        self.participantLineView = [[UIView alloc]initWithFrame:CGRectMake(self.participantLabel.right, self.lineView.bottom+15, 0.5, 30)];
        self.participantLineView .backgroundColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.participantLineView ];
        
        self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.lineView.bottom+10,106,18)];
        self.successNubLabel.textAlignment = NSTextAlignmentCenter;
        self.successNubLabel.text = @"0个";
        self.successNubLabel.textColor = [UIColor flatLightRedColor];
        self.successNubLabel.font = [UIFont systemFontOfSize:14];
        //        self.successNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.successNubLabel];
        
        self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.participantNubLabel.bottom,106,18)];
        self.successLabel.textAlignment = NSTextAlignmentCenter;
        self.successLabel.text = @"速定人数";
        self.successLabel.textColor = [UIColor lightGrayColor];
        self.successLabel.font = [UIFont systemFontOfSize:12];
        //        self.successLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.successLabel];
        
        self.successLineView = [[UIView alloc]initWithFrame:CGRectMake(self.successLabel.right, self.lineView.bottom+15, 0.5, 30)];
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
        
        //        self.againReleaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        self.backgroundColor = [UIColor redColor];
        //        self.againReleaseBtn.frame = CGRectMake(212,self.lineView.bottom,106,60);
        //        //        [self.againReleaseBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.bgView addSubview: self.againReleaseBtn];
        //
        //        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发布"]];
        //        imageView.frame = CGRectMake(0, 15, 14, 12);
        //        imageView.centerX = self.shareBtn.width/2;
        //        [self.againReleaseBtn addSubview:imageView];
        //
        //        shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,imageView.bottom+1,self.shareBtn.width,18)];
        //        shareLabel.textAlignment = NSTextAlignmentCenter;
        //        shareLabel.text = @"再次发布";
        //        shareLabel.textColor = [UIColor lightGrayColor];
        //        shareLabel.font = [UIFont systemFontOfSize:12];
        //        shareLabel.backgroundColor = [UIColor clearColor];
        //        [self.againReleaseBtn addSubview:shareLabel];
        
        
        self.successedNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successLabel.right,self.lineView.bottom+10,106,18)];
        self.successedNubLabel.textAlignment = NSTextAlignmentCenter;
        self.successedNubLabel.text = @"0个";
        self.successedNubLabel.textColor = [UIColor flatLightRedColor];
        self.successedNubLabel.font = [UIFont systemFontOfSize:14];
        //        self.successedNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.successedNubLabel];
        
        self.successedLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successLabel.right,self.successedNubLabel.bottom,106,18)];
        self.successedLabel.textAlignment = NSTextAlignmentCenter;
        self.successedLabel.text = @"已兑换";
        self.successedLabel.textColor = [UIColor lightGrayColor];
        self.successedLabel.font = [UIFont systemFontOfSize:12];
        //        self.successedLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.successedLabel];
        
        
    }
    return self;
}


@end
