//
//  YKLHighGOActivityListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGOActivityListTableViewCell.h"

@implementation YKLHighGOActivityListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = [UIColor flatPinkColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 150)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo"]];
        //        self.titleImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.titleImageView.frame = CGRectMake(10, 10, 75, 75);
        [self.bgView addSubview:self.titleImageView];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleImageView.bottom+5, self.bgView.width, 1)];
        self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView addSubview:self.lineView];
        
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImageView.right+10, 10, (self.width-self.titleImageView.right-20)/3, 18)];
//        self.titleLabel.text = @"XX店铺";
//        self.titleLabel.font = [UIFont systemFontOfSize:16];
//        self.titleLabel.backgroundColor = [UIColor redColor];
//        [self.bgView addSubview:self.titleLabel];
        
        self.actTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImageView.right+10, 10, self.width-self.titleImageView.right-20, 18)];
        self.actTitleLabel.text = @"";
        self.actTitleLabel.font = [UIFont systemFontOfSize:16];
//        self.actTitleLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.actTitleLabel];
        
        self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImageView.right+10, self.actTitleLabel.bottom, self.width-self.titleImageView.right-20, 32)];
        self.descLabel.text = @"";
        self.descLabel.numberOfLines = 2;
        self.descLabel.font = [UIFont systemFontOfSize:11];
        self.descLabel.textColor = [UIColor lightGrayColor];
//        self.descLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.descLabel];
        
        self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.actTitleLabel.origin.x, self.descLabel.bottom, 130, 13)];
        self.endTimeLabel.text = @"结束时间：2015-10-05";
        self.endTimeLabel.textColor = [UIColor lightGrayColor];
        self.endTimeLabel.font = [UIFont systemFontOfSize:11];
        //        self.endTimeLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.endTimeLabel];
        
        self.activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.actTitleLabel.origin.x, self.endTimeLabel.bottom, 55, 13)];
        self.activityLabel.text = @"活动类型：";
        self.activityLabel.textColor = [UIColor lightGrayColor];
        self.activityLabel.font = [UIFont systemFontOfSize:11];
        //        self.activityLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.activityLabel];
        
        self.activityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.activityLabel.right, self.endTimeLabel.bottom, 50, 13)];
        self.activityNameLabel.text = @"一元抽奖";
        self.activityNameLabel.textColor = [UIColor flatLightRedColor];
        self.activityNameLabel.font = [UIFont systemFontOfSize:11];
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
        self.participantLabel.text = @"参与人数";
        self.participantLabel.textColor = [UIColor lightGrayColor];
        self.participantLabel.font = [UIFont systemFontOfSize:12];
        //        self.participantLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.participantLabel];
        
        self.participantLineView = [[UIView alloc]initWithFrame:CGRectMake(self.participantLabel.right, self.lineView.bottom+15, 0.5, 30)];
        self.participantLineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.participantLineView];
        
        
        self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.lineView.bottom+10,106,18)];
        self.successNubLabel.textAlignment = NSTextAlignmentCenter;
        self.successNubLabel.text = @"0";
        self.successNubLabel.textColor = [UIColor flatLightRedColor];
        self.successNubLabel.font = [UIFont systemFontOfSize:14];
        //        self.successNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.successNubLabel];
        
        self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.participantNubLabel.bottom,106,18)];
        self.successLabel.textAlignment = NSTextAlignmentCenter;
        self.successLabel.text = @"活动成功";
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

        

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
