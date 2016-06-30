//
//  YKLChildActManageViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/6/20.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@protocol YKLChildActManageViewControllerDelegate <NSObject>

- (void)cancerBtnChange;

- (void)allSelectdIs:(BOOL)all;

@end

@interface YKLChildActManageViewController : YKLUserBaseViewController

@property (nonatomic, assign) id<YKLChildActManageViewControllerDelegate> childDelegate;

/**
 0.进行中 1.待发布 2.已完成
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger shouldShowIndex;

- (instancetype)initWithShouldShowIndex:(NSInteger)shouldShowIndex type:(NSInteger)type shopDict:(NSDictionary *)shopDict;

//全民砍价
- (void)show_QMKJ_Ctl:(BOOL)showHBFB;

- (void)show_YYMS_Ctl:(BOOL)showHBFB;

- (void)show_YYSD_Ctl:(BOOL)showHBFB;

@end
