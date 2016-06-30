//
//  PopupMenuView.h
//  etionUI
//
//  Created by wangjian on 11/29/13.
//  Copyright (c) 2013 GuangZhouXuanWu. All rights reserved.
//

#import "PopupView.h"

@class CPopupMenuView;

@class CPopupMenuCell;

@protocol CPopupMenuViewDelegate <CPopupViewDelegate>

@optional

- (void)popupMenuView:(CPopupMenuView *)menuView didSelectTitleAtIndex:(NSUInteger)index;

- (CGFloat)popupMenuView:(CPopupMenuView *)menuView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popupMenuView:(CPopupMenuView *)menuView numberOfRowsInSection:(NSInteger)section;

- (NSString*)popupMenuView:(CPopupMenuView *)menuView textForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CPopupMenuCell *)popupMenuView:(CPopupMenuView *)menuView dequeueReusableCell:(CPopupMenuCell*)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)popupMenuView:(CPopupMenuView *)menuView modifyCell:(CPopupMenuCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CPopupMenuCell : UITableViewCell

@property (nonatomic, retain) UIColor *separatorColor;

@end

@interface CPopupMenuView : CPopupView

@property (nonatomic, assign) id<CPopupMenuViewDelegate> delegate;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) UIColor *textColor;           //default is 0x494e56
@property (nonatomic, retain) UIColor *separatorColor;      //default is lightGray

- (id)initWithTitles:(NSArray *)arTitles anchorView:(UIView *)anchorView;

- (id)initWithDelegate:(id<CPopupMenuViewDelegate>)delegate anchorView:(UIView *)anchorView;

- (void)setTitles:(NSArray *)arTitles anchorView:(UIView *)anchorView;

@end
