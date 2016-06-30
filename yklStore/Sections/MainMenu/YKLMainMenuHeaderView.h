//
//  YKLMainMenuHeaderView.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface YKLMainMenuHeaderView : UIView<CPTPlotDataSource>
{
    
    NSMutableArray *dataArray;
    
    int MaxData;
    int arrayCount;
    
}

@property (nonatomic, strong) UIView *corePlotBgView;
@property (nonatomic, strong) UIView *dataBgView;

@property (nonatomic, strong) UILabel *todayNumLabel;   //今日访问量
@property (nonatomic, strong) UILabel *totleNumLabel;   //总访问量

@property (nonatomic, strong) NSMutableArray *expoArray;

//- (instancetype)initWithFrame:(CGRect)frame
//                    expoArray:(NSMutableArray *)expoArray;

- (void)reloadDataWithExpoArray:(NSMutableArray *)expoArray;

- (void)createCorePlotView;

@end
