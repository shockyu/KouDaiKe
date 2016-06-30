//
//  BubbleView.h
//  etionUI
//
//  Created by WangJian on 14-9-11.
//  Copyright (c) 2014年 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUBBLE_RADIUS 5
#define BUBBLE_ARROR_SIZE 7

typedef NS_ENUM(NSInteger,EBubbleViewArrorDir)
{
    EBubbleViewArrorDirTop,
    EBubbleViewArrorDirBottom
};

/*
 气泡框
 */
@interface CBubbleView : UIView

@property (nonatomic, assign) EBubbleViewArrorDir arrorDir;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;   //内容四周的边距，默认为（5, 15, 5, 15）

// 当contentView的尺寸发生变化时，调用该函数调整bubble view的尺寸
- (void)contentViewSizeHasChange;

@end
