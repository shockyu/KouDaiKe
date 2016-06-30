//
//  YKLHighGoReleaseTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoReleaseTableViewCell.h"

@implementation YKLHighGoReleaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = [UIColor flatPinkColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 168-35+10)];
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        
        self.goodsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"商品编辑.png"]];
        self.goodsImageView.backgroundColor = [UIColor whiteColor];
        self.goodsImageView.frame = CGRectMake(10, 10, 115, 115);
        [self.bgView addSubview:self.goodsImageView];
        
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsImageView.right+10, 15, self.width-self.goodsImageView.right-20, 18)];
        NSString *title = @"商品名称";
        self.nameLabel.text = [NSString stringWithFormat:@"%@",title];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor flatLightRedColor];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom+10,  self.width-self.goodsImageView.right-20, 18)];
        self.timeLabel.text = @"截止日期：";
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = [UIColor flatLightRedColor];
//        self.timeLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.timeLabel];
        
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.timeLabel.bottom+10,  self.width-self.goodsImageView.right-60, 0)];
        self.progressView.progressViewStyle= UIProgressViewStyleDefault;
        self.progressView.tintColor = [UIColor flatLightRedColor];
        self.progressView.backgroundColor = [UIColor flatLightWhiteColor];
        self.progressView.progress = 0.5;
        [self.bgView addSubview:self.progressView];
        
        self.playerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.progressView.bottom+10, self.progressView.width/2, 18)];
        self.playerLabel.text = @"已参与:";
        self.playerLabel.font = [UIFont systemFontOfSize:11];
        self.playerLabel.textColor = [UIColor flatLightRedColor];
//        self.playerLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.playerLabel];
        
        self.noPlayerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.playerLabel.right+1, self.progressView.bottom+10, self.progressView.width/2, 18)];
        self.noPlayerLabel.text = @"还需:";
        self.noPlayerLabel.font = [UIFont systemFontOfSize:11];
        self.noPlayerLabel.textColor = [UIColor flatLightRedColor];
//        self.noPlayerLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.noPlayerLabel];

                                                            
                                                                
        
        
    }
    return self;
}


@end
