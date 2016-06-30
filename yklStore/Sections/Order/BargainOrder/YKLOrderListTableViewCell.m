//
//  YKLOderListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLOrderListTableViewCell.h"

@implementation YKLOrderListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        //self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //self.selectedBackgroundView.backgroundColor = [UIColor flatPinkColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 145)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo"]];
//                self.avatarImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.avatarImageView.frame = CGRectMake(10, 10, 60, 60);
        [self.bgView addSubview:self.avatarImageView];
        
        self.typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"到店"]];
//        self.typeImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.typeImageView.frame = CGRectMake(self.width-10-30, 0, 30, 30);
        [self.bgView addSubview:self.typeImageView];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.avatarImageView.bottom+10, self.bgView.width, 1)];
        self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView addSubview:self.lineView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.right+10, 10, self.width-self.avatarImageView.right-55, 18)];
        NSString *name = @"隔壁小王";
        self.nameLabel.text = [NSString stringWithFormat:@"昵称：%@",name];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = [UIColor lightGrayColor];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.nameLabel];
        
        self.mobleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.origin.x, self.nameLabel.bottom+5, self.width-self.avatarImageView.right-10, 18)];
        NSString *moble = @"暂无";
        self.mobleLabel.text = [NSString stringWithFormat:@"联系方式：%@",moble];
        self.mobleLabel.textColor = [UIColor lightGrayColor];
        self.mobleLabel.font = [UIFont systemFontOfSize:13];
        self.mobleLabel.textColor = [UIColor lightGrayColor];
//        self.mobleLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.mobleLabel];
        
        self.actTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.origin.x, self.mobleLabel.bottom+5, self.width-self.avatarImageView.right-10, 18)];
        self.actTitleLabel.text = @"双11居家用品全面促销活动";
        self.actTitleLabel.textColor = [UIColor blackColor];
        self.actTitleLabel.font = [UIFont systemFontOfSize:14];
//        self.actTitleLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.actTitleLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.lineView.bottom+11,80,22)];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        NSString *price = @"398";
        self.priceLabel.text = [NSString stringWithFormat:@"原价¥%@",price];
        self.priceLabel.textColor = [UIColor flatLightRedColor];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.layer.borderColor = [UIColor flatLightRedColor].CGColor;
        self.priceLabel.layer.borderWidth = 1;
        self.priceLabel.layer.cornerRadius = 3;
//      self.priceLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.priceLabel];
        
        self.lowestPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right+10,self.lineView.bottom+11,105,22)];
        self.lowestPriceLabel.textAlignment = NSTextAlignmentCenter;
        NSString *lowestPrice = @"198";
        self.lowestPriceLabel.text = [NSString stringWithFormat:@"最低砍到¥%@",lowestPrice];
        self.lowestPriceLabel.textColor = [UIColor flatLightRedColor];
        self.lowestPriceLabel.font = [UIFont systemFontOfSize:14];
        self.lowestPriceLabel.layer.borderColor = [UIColor flatLightRedColor].CGColor;
        self.lowestPriceLabel.layer.borderWidth = 1;
        self.lowestPriceLabel.layer.cornerRadius = 3;
//      self.lowestPriceLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.lowestPriceLabel];
        
        self.peducePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.lowestPriceLabel.right+10,self.lineView.bottom+11,90,22)];
        self.peducePriceLabel.textAlignment = NSTextAlignmentCenter;
        NSString *peducePrice = @"198";
        self.peducePriceLabel.text = [NSString stringWithFormat:@"成交价¥%@",peducePrice];
        self.peducePriceLabel.textColor = [UIColor flatLightRedColor];
        self.peducePriceLabel.font = [UIFont systemFontOfSize:14];
        self.peducePriceLabel.layer.borderColor = [UIColor flatLightRedColor].CGColor;
        self.peducePriceLabel.layer.borderWidth = 1;
        self.peducePriceLabel.layer.cornerRadius = 3;
//      self.peducePriceLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.peducePriceLabel];
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
