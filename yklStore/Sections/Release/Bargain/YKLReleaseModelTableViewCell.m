//
//  YKLReleaseModelTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLReleaseModelTableViewCell.h"

@implementation YKLReleaseModelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = [UIColor flatPinkColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 168-35+10)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo"]];
        self.avatarImageView.backgroundColor = [UIColor flatLightYellowColor];
        self.avatarImageView.frame = CGRectMake(10, 10, 115, 115);
        [self.bgView addSubview:self.avatarImageView];
        
        self.imageBtn = [[UIButton alloc]initWithFrame: CGRectMake(10, 50, 115, 75)];
        [self.imageBtn setImage:[UIImage imageNamed:@"预览"] forState:UIControlStateNormal];
        self.imageBtn.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:self.imageBtn];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.right+10, 10, self.width-self.avatarImageView.right-20, 18)];
        NSString *title = @"大刀向鬼子头上砍去";
        self.titleLabel.text = [NSString stringWithFormat:@"标题：%@",title];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor lightGrayColor];
//        self.tileLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.right+10, self.titleLabel.bottom+5, 40, 18)];
        self.priceLabel.text = @"价格：";
        self.priceLabel.font = [UIFont systemFontOfSize:13];
        self.priceLabel.textColor = [UIColor lightGrayColor];
//        self.priceLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.priceLabel];
        
        self.priceNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right, self.titleLabel.bottom+5, self.width-self.priceLabel.right-10, 18)];
        self.priceNubLabel.text = @"¥20";
        self.priceNubLabel.font = [UIFont systemFontOfSize:13];
        self.priceNubLabel.textColor = [UIColor flatLightRedColor];
//        self.priceNubLabel.backgroundColor = [UIColor blueColor];
        [self.bgView addSubview:self.priceNubLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.left, self.priceLabel.bottom+5, 55, 20)];
        label.text = @"黄钻免费";
        label.textColor = [UIColor colorWithHexString:@"ffcc00"];
        label.font = [UIFont systemFontOfSize:13];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right, 0, 25, 25)];
        imageView.centerY = label.centerY;
        imageView.image = [UIImage imageNamed:@"黄钻2"];
        
        if (![[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
           
            [self.bgView addSubview:label];
            [self.bgView addSubview:imageView];
            
        }

        
    
        self.explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.right+10, label.bottom+5, 40, 18)];
        self.explainLabel.text = @"说明：";
        self.explainLabel.font = [UIFont systemFontOfSize:13];
        self.explainLabel.textColor = [UIColor lightGrayColor];
//                self.explainLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.explainLabel];
        
        self.explainMoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.right+10, self.explainLabel.bottom, self.width-self.avatarImageView.right-20, 35)];
        self.explainMoreLabel.numberOfLines = 0;
        self.explainMoreLabel.text = @"有客来特别推出有客来特别推出有客来特别推出有客来特别推出有客来特别推出";
        self.explainMoreLabel.font = [UIFont systemFontOfSize:13];
        self.explainMoreLabel.textColor = [UIColor lightGrayColor];
//        self.explainMoreLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.explainMoreLabel];
        
//        self.selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选中"]];
//        self.selectImageView.frame = CGRectMake(self.explainMoreLabel.right-26,self.explainMoreLabel.bottom+5,26,26);
//        [self.bgView addSubview:self.selectImageView];
    }
    return self;
}


@end
