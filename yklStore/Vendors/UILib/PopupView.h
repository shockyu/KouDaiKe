//
//  PopupView.h
//  etionUI
//
//  Created by wangjian on 11/29/13.
//  Copyright (c) 2013 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,EPopupViewArrorDir)
{
    EPopupViewArrorDirTop,
    EPopupViewArrorDirBottom
};

@class CPopupView;

@protocol CPopupViewDelegate<NSObject>

@optional

-(void)clickMaskPopupViewWillClose:(CPopupView*)popupView;

@end

@interface CPopupView : UIView
{
    UIView *_contentView;
    UIView *_anchorView;
    EPopupViewArrorDir _arrorDirection;
}

@property (nonatomic, readonly) EPopupViewArrorDir arrorDirection;
@property (nonatomic, assign) CGPoint anchorOffSet;
@property (nonatomic, strong) UIColor *viewBackgroundColor;
@property (nonatomic, strong) UIColor *borderColor; //default is black
@property (nonatomic, weak) id<CPopupViewDelegate> delegate;

- (void)setAnchorView:(UIView *)view;

- (void)setView:(UIView *)view;

- (void)show;

- (void)dismiss;

@end
