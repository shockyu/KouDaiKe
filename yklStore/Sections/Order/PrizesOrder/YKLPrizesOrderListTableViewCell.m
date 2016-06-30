//
//  YKLPrizesOrderListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/16.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPrizesOrderListTableViewCell.h"

@implementation YKLPrizesOrderListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor lightGrayColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor flatLightRedColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        
        self.mobileLabel = [[UILabel alloc] init];
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor lightGrayColor];
        self.mobileLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.mobileLabel];
        
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateWithFanModel:(YKLHighGoUserListModel *)model {
    
    self.textLabel.text = [NSString stringWithFormat:@"%@",model.nickName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.indianaName];
    self.mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 5, 100, 20);
    
    self.mobileLabel.frame = CGRectMake(self.textLabel.right, 5, self.textLabel.width, 20);
    
    self.detailTextLabel.frame = CGRectMake(self.mobileLabel.right, 5, self.textLabel.width, 20);
    
    //    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8, self.textLabel.width, 18);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
