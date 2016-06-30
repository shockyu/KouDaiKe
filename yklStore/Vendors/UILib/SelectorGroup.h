//
//  SelectorGroup.h
//  etionUI
//
//  Created by wangjian on 9/26/13.
//  Copyright (c) 2013 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Selector.h"

typedef NS_ENUM(NSInteger, ESelectorGroupType)
{
    ESelectorGroupTypeUnique,       //单选
    ESelectorGroupTypeMultiple      //多选
};

@interface CSelectorGroup : UIControl

@property (nonatomic, readonly) NSArray *selectors;
@property (nonatomic, readonly) ESelectorGroupType type;
@property (nonatomic, assign) ESelectorAlign align;    //default is ESelectorGroupAlignLeft
@property (nonatomic, assign) ESelectorDirection direction; //default is ESelectorDirectionForward
@property (nonatomic, assign) BOOL autoArrange;     //default is YES
@property (nonatomic, assign) BOOL changeStateAnimated;     //default is YES
@property (nonatomic, assign) UIColor *renderColor;         //default is [UIColor colorWithHex:0x3498DB]

//返回最适合的尺寸，宽度为用户设置的frame的宽度，高度由程序计算得出
- (CGSize)fitSize;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles type:(ESelectorGroupType)type;
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles headImage:(UIImage *)headImage highlightedImage:(UIImage *)highlightedImage type:(ESelectorGroupType)type;
- (void)setTitleLabelFont:(UIFont *)font;       //标题默认字体是[UIFont systemFontOfSize:14]，要设置字体请使用该函数，设置后会自动调整显示大小位置等
- (void)setSelected:(BOOL)selected forSelectorAtIndex:(NSInteger)index animated:(BOOL)animated;

- (NSIndexSet *)selectedIndexSet;
- (NSUInteger)currentSelectedIndex; //当type == ESelectorSignTypeRadio时，可使用该方法

//用于测试
+ (UIView *)testViewWithFrame:(CGRect)frame;

@end

