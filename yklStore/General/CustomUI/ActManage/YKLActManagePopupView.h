//
//  YKLActManagePopupView.h
//  yklStore
//
//  Created by 肖震宇 on 16/6/24.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKLActManagePopupViewDelegate <NSObject>

- (void)actManagePopupViewDidClickedWithTag:(NSInteger)tag;

@end


@interface YKLActManagePopupView : UIView

@property (nonatomic, assign) id<YKLActManagePopupViewDelegate> delegate;

//帮助弹窗
@property (strong, nonatomic) UIView *pickerBgCashView;
@property (strong, nonatomic) UIView *AlertBgView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIButton *closeBtn;
//是否关闭弹出帮助窗口
@property BOOL isClose;

- (void)createView:(NSDictionary *)imageDict;

- (void)hideRechargeAlertBgView;

@end
