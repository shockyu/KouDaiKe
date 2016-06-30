//
//  MyButton.h
//  Untitled
//
//  Created by  user on 11-2-17.
//  Copyright 2011 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESelectorSignType)
{
    ESelectorSignTypeCheck,
    ESelectorSignTypeRadio,
    ESelectorSignTypeCustomerImage
};

typedef NS_ENUM(NSUInteger, ESelectorAlign)
{
    ESelectorAlignLeft,
    ESelectorAlignMiddle,
    ESelectorAlignRight,
    ESelectorAlignJustified
};

typedef NS_ENUM(NSUInteger, ESelectorDirection)
{
    ESelectorDirectionForward,  //图标在文字前方
    ESelectorDirectionBackward  //图标在文字后方
};

@interface CSelectorSignView : UIView

@property (nonatomic, retain) UIColor *renderColor;     //当类型为Check or Radio时才有效
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) float cornerRadius;

- (id)initWithFrame:(CGRect)frame type:(ESelectorSignType)type;
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;    //此时的类型为ESelectorSignTypeCustomerImage

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;

@end

@interface CSelector : UIControl<UIViewExtendDelegate>

@property (nonatomic, readonly) ESelectorSignType selectorSignType;
@property (nonatomic, assign) ESelectorAlign align;         //default is ESelectorAlignLeft
@property (nonatomic, assign) ESelectorDirection direction; //default is ESelectorDirectionForward
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, assign) UIColor *renderColor;         //default is [UIColor colorWithHex:0x2083C3]

@property (nonatomic, assign) BOOL changeSelectedStateWhenTouchUpInside;    //默认为YES，当用户在该selector的区域内点击后，自动修改当前的selected属性，并发送UIControlEventValueChanged事件；当为NO时，用户点击只会发送UIControlEventTouchUpInside事件。

//默认为0
//如果类型为ESelectorSignTypeCustomerImage，则该属性无效
//否则，如果不为0，则图标的大小由该属性决定；如果等于0则当有标题时，图标大小由标题字体大小决定，否则图标大小与选择器的大小相当
@property (nonatomic, assign) float signViewWidth;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)setEnabled:(BOOL)enable animated:(BOOL)animated;

//返回最适合的尺寸
- (CGSize)fitSize;

- (id)initWithFrame:(CGRect)frame title:(NSString *)szTitle type:(ESelectorSignType)type;
- (id)initWithFrame:(CGRect)frame title:(NSString *)szTitle headImage:(UIImage *)headImage highlightedImage:(UIImage *)highlightedImage;    //自动生成ESelectorSignTypeCustomerImage类型
- (void)setTitleLabelFont:(UIFont *)font;       //标题默认字体是[UIFont systemFontOfSize:14]，要设置字体请使用该函数，设置后会自动调整显示大小位置等

@end
