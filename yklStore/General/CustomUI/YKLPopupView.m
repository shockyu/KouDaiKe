//
//  YKLPopupView.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/3.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLPopupView.h"

@implementation YKLPopupView

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
    
    NSArray *imgFram = imageDict[@"imgFram"];
    
    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320,[imgFram[3] floatValue]+20)];
    self.rechargeAlertBgView.center = CGPointMake(self.width/2, self.height/2);
    self.rechargeAlertBgView.backgroundColor = [UIColor clearColor];
    self.rechargeAlertBgView.layer.cornerRadius = 7;
    self.rechargeAlertBgView.layer.masksToBounds = YES;

    
    UIImageView *helpImage = [[UIImageView alloc]initWithFrame:CGRectMake([imgFram[0] floatValue],[imgFram[1] floatValue],[imgFram[2] floatValue],[imgFram[3] floatValue])];
    helpImage.image = [UIImage imageNamed:imageDict[@"imgName"]];
    [self.rechargeAlertBgView addSubview:helpImage];
    
    NSArray *btnFram = imageDict[@"btnFram"];
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:imageDict[@"closeBtn"]] forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake([btnFram[0]floatValue],[btnFram[1]floatValue],[btnFram[2]floatValue],[btnFram[3]floatValue]);
    [self.closeBtn addTarget:self action:@selector(hideRechargeAlertBgView) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.closeBtn];
    
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


@end
