//
//  YKLHigoGoTokenTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/10.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHigoGoTokenTableViewCell.h"

@implementation YKLHigoGoTokenTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.mobleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.mobleLabel.text = @"15117118111";
        self.mobleLabel.font = [UIFont systemFontOfSize:16];
        self.mobleLabel.textColor = [UIColor lightGrayColor];
//        self.mobleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.mobleLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.mobleLabel.right+10, 10, 150, 20)];
        self.nameLabel.text = @"卡卡";
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = [UIColor lightGrayColor];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.nameLabel];
        
        self.monneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-50, 10, 50, 25)];
        self.monneyLabel.textColor = [UIColor flatLightRedColor];
        self.monneyLabel.textAlignment = NSTextAlignmentCenter;
//        self.monneyLabel.backgroundColor = [UIColor yellowColor];
        
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"5¥"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range=[[hintString string]rangeOfString:@"¥"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
        self.monneyLabel.attributedText=hintString;
        
        self.monneyLabel.font = [UIFont systemFontOfSize:16];
       

        [self addSubview:self.monneyLabel];
        
        
        
        
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
