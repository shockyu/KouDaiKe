//
//  YKLActSelectADView.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/17.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLActSelectADView : UIView<UIScrollViewDelegate>{
    
    NSTimer *_timer;
}

//广告栏
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UILabel *imageNum;
@property (nonatomic) NSInteger totalNum;

- (void)setArray:(NSMutableArray *)imgArray;

- (void)openTimer;
- (void)closeTimer;

@end


