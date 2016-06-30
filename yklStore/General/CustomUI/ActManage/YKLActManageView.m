//
//  YKLActManageView.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/24.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLActManageView.h"

@implementation YKLActManageView
{
    UIView      *_bottomView;
    
}

- (void)createView:(NSDictionary *)imageDict
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 7, ScreenWidth-20, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    titleLabel.centerX = ScreenWidth/2;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"活动管理";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    NSArray *imgArr = imageDict[@"img"];
    NSInteger num = imgArr.count;
    
    if (num > 4) {
        
        for (int i = 0; i < 4; i++) {
            
            float viewWidth = ScreenWidth / 4;
            
            UIView *imageBgView = [[UIView alloc]initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, _bottomView.height)];
            imageBgView.backgroundColor = [UIColor clearColor];
            [_bottomView addSubview:imageBgView];
            
            if (i == 3) {
                
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 40, 40)];
                iconImageView.centerX = imageBgView.width/2;
                iconImageView.image = [UIImage imageNamed:@"act_detail_more"];
                [imageBgView addSubview:iconImageView];
                
                UILabel *detaliLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+7, imageBgView.width, 12)];
                detaliLabel.textAlignment = NSTextAlignmentCenter;
                detaliLabel.font = [UIFont systemFontOfSize:8];
                detaliLabel.text = @"更多";
                [imageBgView addSubview:detaliLabel];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = imageBgView.frame;
                button.tag = 0;
                [button addTarget:self action:@selector(buttonClickded:) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:button];
                
            }
            else{
                
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 40, 40)];
                iconImageView.centerX = imageBgView.width/2;
                iconImageView.image = [UIImage imageNamed:imgArr[i][@"fileName"]];
                [imageBgView addSubview:iconImageView];
                
                UILabel *detaliLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+7, imageBgView.width, 12)];
                detaliLabel.textAlignment = NSTextAlignmentCenter;
                detaliLabel.font = [UIFont systemFontOfSize:8];
                detaliLabel.text = imgArr[i][@"title"];
                [imageBgView addSubview:detaliLabel];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = imageBgView.frame;
                button.tag = [imgArr[i][@"tag"]intValue];
                [button addTarget:self action:@selector(buttonClickded:) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:button];
            }
            
        }
    }
    else{
        
        for (int i = 0; i < num; i++) {
            
            float viewWidth = ScreenWidth / num;
            
            UIView *imageBgView = [[UIView alloc]initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, _bottomView.height)];
            imageBgView.backgroundColor = [UIColor clearColor];
            [_bottomView addSubview:imageBgView];
            
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 40, 40)];
            iconImageView.centerX = imageBgView.width/2;
            iconImageView.image = [UIImage imageNamed:imgArr[i][@"fileName"]];
            [imageBgView addSubview:iconImageView];
            
            UILabel *detaliLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+7, imageBgView.width, 12)];
            detaliLabel.textAlignment = NSTextAlignmentCenter;
            detaliLabel.font = [UIFont systemFontOfSize:8];
            detaliLabel.text = imgArr[i][@"title"];
            [imageBgView addSubview:detaliLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageBgView.frame;
            button.tag = [imgArr[i][@"tag"]intValue];
            [button addTarget:self action:@selector(buttonClickded:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
            
        }
    }
    
    
}

- (void)buttonClickded:(UIButton *)sender{
    
    NSLog(@"tag:%ld",(long)sender.tag);
    
    [self.delegate didClickedWithTag:sender.tag];
    
}

@end
