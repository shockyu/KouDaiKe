//
//  YKLMiaoShaActivityUserListTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/27.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMiaoShaActivityUserListTableViewCell.h"

@implementation YKLMiaoShaActivityUserListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 50)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.nickNameTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, 25)];
        self.nickNameTitle.font = [UIFont systemFontOfSize:12];
        self.nickNameTitle.text = @"昵称：";
        [self addSubview:self.nickNameTitle];
        
        self.mobileTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, self.nickNameTitle.bottom, 60, 25)];
        self.mobileTitle.font = [UIFont systemFontOfSize:12];
        self.mobileTitle.text = @"联系方式：";
        [self addSubview:self.mobileTitle];
        
        self.nickName = [[UILabel alloc]initWithFrame:CGRectMake(self.nickNameTitle.right, 0, self.width-self.nickName.right-10,25)];
        self.nickName.textColor = [UIColor lightGrayColor];
        self.nickName.font = [UIFont systemFontOfSize:12];
        self.nickName.text = @"大大大大大大瞎";
        [self addSubview:self.nickName];
        
        self.mobile = [[UILabel alloc]initWithFrame:CGRectMake(self.mobileTitle.right, self.mobileTitle.top, self.nickName.width, 25)];
        self.mobile.textColor = [UIColor lightGrayColor];
        self.mobile.font = [UIFont systemFontOfSize:12];
        self.mobile.text = @"13155556666";
        [self addSubview:self.mobile];
        
        
    }
    return self;
}

@end
