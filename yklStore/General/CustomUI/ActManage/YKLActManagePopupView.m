//
//  YKLActManagePopupView.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/24.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLActManagePopupView.h"

@implementation YKLActManagePopupView

- (void)createView:(NSDictionary *)imageDict{
    
    self.AlertBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.AlertBgView.backgroundColor = [UIColor blackColor];
    self.AlertBgView.alpha = 0;
    
    [self addSubview:self.AlertBgView];
    [self addSubview:[self createHelpView:imageDict]];
    self.AlertBgView.alpha = 0;
    self.pickerBgCashView.top = self.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AlertBgView.alpha = 0.3;
        self.pickerBgCashView.bottom = self.height;
    }];
    
    _isClose = YES;
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRechargeAlertBgView)];
    gesture.numberOfTapsRequired = 1;
    [self.AlertBgView addGestureRecognizer:gesture];
}

- (UIView *)createHelpView:(NSDictionary *)imageDict{
    
    NSArray *imgArr = imageDict[@"img"];
    
    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,320)];
    self.rechargeAlertBgView.center = CGPointMake(self.width/2, self.height/2);
    self.rechargeAlertBgView.backgroundColor = [UIColor clearColor];
    self.rechargeAlertBgView.layer.cornerRadius = 7;
    self.rechargeAlertBgView.layer.masksToBounds = YES;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 250, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.center = CGPointMake(self.rechargeAlertBgView.width/2, self.rechargeAlertBgView.height/2);
    [self.rechargeAlertBgView addSubview:bgView];
    
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 192, 95)];
    topImageView.image = [UIImage imageNamed:@"act_detail_back"];
    topImageView.centerX = ScreenWidth/2;
    [self.rechargeAlertBgView addSubview:topImageView];
    
    for (int i = 0 ; i < imgArr.count; i++) {
        
        float top = i > 2 ? 94 : 17;
        float right = i > 2 ? 28+(i-3)*77.5: 28+i*77.5;
        
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(right, 100+top, 40, 40)];
        iconImageView.image = [UIImage imageNamed:imgArr[i][@"fileName"]];
        [bgView addSubview:iconImageView];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+10, 70, 10)];
        detailLabel.centerX = iconImageView.centerX;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [UIFont systemFontOfSize:8];
        detailLabel.text = imgArr[i][@"title"];
        [bgView addSubview:detailLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = iconImageView.frame;
        button.tag = [imgArr[i][@"tag"]intValue];
        [button addTarget:self action:@selector(buttonClickded:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
    }

    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"act_detail_close"] forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake(0,bgView.height-10-25,25,25);
    self.closeBtn.centerX = bgView.width/2;
    [self.closeBtn addTarget:self action:@selector(hideRechargeAlertBgView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview: self.closeBtn];
    
    return self.rechargeAlertBgView;
}

- (void)hideRechargeAlertBgView{
    
    _isClose = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AlertBgView.alpha = 0;
        self.rechargeAlertBgView.top = self.height;
        
    } completion:^(BOOL finished) {
        [self.AlertBgView removeFromSuperview];
        [self.pickerBgCashView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)buttonClickded:(UIButton *)sender{
    
    NSLog(@"tag:%ld",(long)sender.tag);
    
    [self hideRechargeAlertBgView];
    
    [self.delegate actManagePopupViewDidClickedWithTag:sender.tag];
    
}

@end
