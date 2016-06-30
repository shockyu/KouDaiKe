//
//  YKLHighGoActivityListDetailTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/4.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivityListDetailTableViewCell.h"

@implementation YKLHighGoActivityListDetailTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = [UIColor flatPinkColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, self.contentView.width, 138)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo"]];
        //        self.titleImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.titleImageView.frame = CGRectMake(10, 10, 60, 60);
        [self.bgView addSubview:self.titleImageView];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleImageView.bottom+20, self.bgView.width, 1)];
        self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView addSubview:self.lineView];
        
        self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImageView.right+10, 10, self.width-self.titleImageView.right-20, 40)];
        self.descLabel.text = @"活动介绍是一个很神奇的label，看着看着你会发现活动原来还是比介绍有意思多了的哦，再凑点字数看看会如何呢？";
        self.descLabel.numberOfLines = 3;
        self.descLabel.font = [UIFont systemFontOfSize:10];
        self.descLabel.textColor = [UIColor blackColor];
        //        self.descLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.descLabel];
        
        self.isSuccessLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.descLabel.left, self.descLabel.bottom, 130, 18)];
        self.isSuccessLabel.text = @"已成功";
        self.isSuccessLabel.textColor = [UIColor flatLightRedColor];
        self.isSuccessLabel.font = [UIFont systemFontOfSize:11];
        //        self.endTimeLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.isSuccessLabel];
        
        self.isExchangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.isSuccessLabel.right, self.isSuccessLabel.top, 50, 19)];
        self.isExchangeLabel.text = @"已/未兑换";
        self.isExchangeLabel.textColor = [UIColor flatLightRedColor];
        self.isExchangeLabel.font = [UIFont systemFontOfSize:11];
        //      self.isExchangeLabel.backgroundColor = [UIColor grayColor];
        [self.bgView addSubview:self.isExchangeLabel];
        
        
        self.winnnerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.descLabel.left, self.isSuccessLabel.bottom, 100, 19)];
        self.winnnerNameLabel.text = @"暂无";
        self.winnnerNameLabel.textColor = [UIColor flatLightRedColor];
        self.winnnerNameLabel.font = [UIFont systemFontOfSize:11];
//      self.winnnerNameLabel.backgroundColor = [UIColor grayColor];
        [self.bgView addSubview:self.winnnerNameLabel];
        
        self.winnnerMobLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.winnnerNameLabel.right, self.isSuccessLabel.bottom, 80, 19)];
        self.winnnerMobLabel.text = @"暂无";
        self.winnnerMobLabel.textColor = [UIColor flatLightRedColor];
        self.winnnerMobLabel.font = [UIFont systemFontOfSize:11];
//      self.winnnerMobLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.winnnerMobLabel];
       
        self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.lineView.bottom+10, 90, 25)];
        self.totalLabel.textAlignment = NSTextAlignmentCenter;
        self.totalLabel.backgroundColor = [UIColor whiteColor];
        self.totalLabel.textColor = [UIColor flatLightRedColor];
       
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共需%@人次",self.totalStr]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:@"共需"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
        NSRange range2=[[hintString string]rangeOfString:@"人次"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2];
        self.totalLabel.attributedText=hintString;
        
        self.totalLabel.font = [UIFont systemFontOfSize:11];
        [self.totalLabel.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247.0/255.0, 81.0/255.0, 81.0/255.0, 0.8 });
       
        [self.totalLabel.layer setBorderColor:colorref];
        self.totalLabel.layer.cornerRadius = 10;
        self.totalLabel.layer.masksToBounds = YES;
        [self.bgView addSubview:self.totalLabel];
        
        self.isUserLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.totalLabel.right+15, self.lineView.bottom+10, 95, 25)];
        self.isUserLabel.textAlignment = NSTextAlignmentCenter;
        self.isUserLabel.backgroundColor = [UIColor whiteColor];
        self.isUserLabel.textColor = [UIColor flatLightRedColor];
        
        NSMutableAttributedString *hintString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已参与%@人次",self.isUserStr]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range2_1=[[hintString2 string]rangeOfString:@"已参与"];
        [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_1];
        NSRange range2_2=[[hintString2 string]rangeOfString:@"人次"];
        [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_2];
        self.isUserLabel.attributedText= hintString2;
        
        self.isUserLabel.font = [UIFont systemFontOfSize:11];
        [self.isUserLabel.layer setBorderWidth:1.0]; //边框宽度
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247.0/255.0, 81.0/255.0, 81.0/255.0, 0.8 });
        
        [self.isUserLabel.layer setBorderColor:colorref];
        self.isUserLabel.layer.cornerRadius = 10;
        self.isUserLabel.layer.masksToBounds = YES;
        [self.bgView addSubview:self.isUserLabel];
        
        self.remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.isUserLabel.right+10, self.lineView.bottom+10, 90, 25)];
        self.remainLabel.textAlignment = NSTextAlignmentCenter;
        self.remainLabel.backgroundColor = [UIColor whiteColor];
        self.remainLabel.textColor = [UIColor flatLightRedColor];
        
        NSMutableAttributedString *hintString3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还剩%@人次",self.remainStr]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range3_1=[[hintString3 string]rangeOfString:@"还剩"];
        [hintString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3_1];
        NSRange range3_2=[[hintString3 string]rangeOfString:@"人次"];
        [hintString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3_2];
        self.remainLabel.attributedText= hintString3;
        
        self.remainLabel.font = [UIFont systemFontOfSize:11];
        [self.remainLabel.layer setBorderWidth:1.0]; //边框宽度
        //        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247.0/255.0, 81.0/255.0, 81.0/255.0, 0.8 });
        
        [self.remainLabel.layer setBorderColor:colorref];
        self.remainLabel.layer.cornerRadius = 10;
        self.remainLabel.layer.masksToBounds = YES;
        [self.bgView addSubview:self.remainLabel];
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
