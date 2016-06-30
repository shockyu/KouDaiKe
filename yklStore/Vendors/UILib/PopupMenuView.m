//
//  PopupMenuView.m
//  etionUI
//
//  Created by wangjian on 11/29/13.
//  Copyright (c) 2013 GuangZhouXuanWu. All rights reserved.
//

#import "PopupMenuView.h"

#define MARGIN 15
#define RADIUS 5
#define ARROR_SIZE 7

#define MENU_TITLE_H 40
#define MENU_TITLE_FONT [UIFont systemFontOfSize:14]

@interface CPopupMenuCell ()

@property (nonatomic, assign) BOOL showSepLine;

@end

@implementation CPopupMenuCell
{
    UIView *_sepLineView;
}

@synthesize showSepLine = _showSepLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = nil;
    
    return self;
}

- (void)setShowSepLine:(BOOL)showSepLine
{
    _showSepLine = showSepLine;
    if (_showSepLine == YES)
    {
        if (_sepLineView == nil)
        {
            _sepLineView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, 0, 0, .5)];
            _sepLineView.backgroundColor = self.separatorColor;
            [self.contentView addSubview:_sepLineView];
        }
        _sepLineView.hidden = NO;
    }
    else
    {
        _sepLineView.hidden = YES;
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    _sepLineView.frame = CGRectMake(MARGIN, self.height-.5, self.width-2*MARGIN, .5);
}

@end

@interface CPopupMenuView () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, assign) CGRect anchorFrame;

@end

@implementation CPopupMenuView
{
    UITableView *_tableView;
    BOOL _needRefresh;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _needRefresh = YES;
        self.textColor = [UIColor colorWithHex:0x494e56];
        self.separatorColor = [UIColor lightGrayColor];
    }
    return self;
}

- (id)initWithTitles:(NSArray *)arTitles anchorView:(UIView *)anchorView
{
    self = [self initWithFrame:CGRectZero];
    
    [self setTitles:arTitles anchorView:anchorView];
    
    return self;
}

- (id)initWithDelegate:(id<CPopupMenuViewDelegate>)delegate anchorView:(UIView *)anchorView
{
    self = [self initWithTitles:nil anchorView:anchorView];
    
    self.delegate=delegate;
    
    return self;
}

//- (id)initWithTitles:(NSArray *)arTitles anchorFrame:(CGRect)anchorFrame
//{
//    self = [self initWithFrame:CGRectZero];
//    if (self)
//    {
//        [self setTitles:arTitles anchorFrame:anchorFrame];
//    }
//    return self;
//}

-(id<CPopupMenuViewDelegate>)delegate
{
    return (id<CPopupMenuViewDelegate>)super.delegate;
}

- (void)setTitles:(NSArray *)arTitles anchorView:(UIView *)anchorView
{
    _needRefresh = YES;
    self.anchorView = anchorView;
    self.titles = arTitles;
//    [self setTitles:arTitles anchorFrame:anchorFrame];
}

//- (void)setTitles:(NSArray *)arTitles anchorFrame:(CGRect)anchorFrame
//{
//    _needRefresh = YES;
//    self.titles = arTitles;
//    self.anchorFrame = anchorFrame;
//}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}

- (CGSize)menuSizeWithTitles:(NSArray *)arTitles maxRows:(int)maxRows
{
    CGSize menuSize;
    
    int maxW = self.width-2*MARGIN;
    int minW = self.width/2;
    
    if (arTitles.count == 0)
    {
        return CGSizeMake(minW, MENU_TITLE_H);
    }
    
    NSString *longestTitle = [arTitles objectAtIndex:0];
    for (int i=1; i<arTitles.count; i++)
    {
        if ([[arTitles objectAtIndex:i] length] > longestTitle.length)
        {
            longestTitle = [arTitles objectAtIndex:i];
        }
    }
    CGSize longestTitleSize = [longestTitle sizeWithAttributes:@{NSFontAttributeName:MENU_TITLE_FONT}];
    if (longestTitleSize.width + 2*MARGIN < minW)
    {
        menuSize.width = minW;
    }
    else if (longestTitleSize.width + 2*MARGIN > maxW)
    {
        menuSize.width = maxW;
    }
    else
    {
        menuSize.width = longestTitleSize.width + 2*MARGIN;
    }
    
    if (arTitles.count < maxRows)
    {
        menuSize.height = arTitles.count * MENU_TITLE_H;
    }
    else
    {
        menuSize.height = maxRows * MENU_TITLE_H + MENU_TITLE_H/2;
    }
    
    return menuSize;
}

- (void)setTitles:(NSArray *)titles
{
    _needRefresh = YES;
    _titles = titles;
}

- (void)setAnchorView:(UIView *)anchorView
{
    [super setAnchorView:anchorView];
    
    _needRefresh = YES;
}

//- (void)setAnchorFrame:(CGRect)anchorFrame
//{
//    _anchorFrame = anchorFrame;
//}

- (void)initialize
{
    int maxRows = ((self.height-80)/2) / MENU_TITLE_H;
    NSArray *arItem = nil;
    if([self.delegate respondsToSelector:@selector(popupMenuView:numberOfRowsInSection:)]&&[self.delegate respondsToSelector:@selector(popupMenuView:textForRowAtIndexPath:)])
    {
        arItem = [NSMutableArray new];
        NSUInteger n = [self.delegate popupMenuView:self numberOfRowsInSection:0];
        for(int i=0;i<n;i++)
            [(NSMutableArray*)arItem addObject:@""];
    }
    else
        arItem = self.titles;
    CGSize menuSize = [self menuSizeWithTitles:arItem maxRows:maxRows];
    
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, menuSize.width, menuSize.height+ARROR_SIZE)];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.backgroundView=nil;
//        _tableView.contentInset = _arrorDirection == EPopupViewArrorDirTop ? UIEdgeInsetsMake(ARROR_SIZE, 0, 0, 0) : UIEdgeInsetsMake(0, 0, ARROR_SIZE, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        _tableView.frame = CGRectMake(0, 0, menuSize.width, menuSize.height+ARROR_SIZE);
        [_tableView reloadData];
    }
    if (maxRows >= self.titles.count)
    {
        _tableView.scrollEnabled = NO;
    }
    [self setView:_tableView];
    _tableView.contentInset = _arrorDirection == EPopupViewArrorDirTop ? UIEdgeInsetsMake(ARROR_SIZE, 0, 0, 0) : UIEdgeInsetsMake(0, 0, ARROR_SIZE, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(popupMenuView:heightForRowAtIndexPath:)])
        return [self.delegate popupMenuView:self heightForRowAtIndexPath:indexPath];
    
    return MENU_TITLE_H;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(popupMenuView:numberOfRowsInSection:)])
        return [self.delegate popupMenuView:self numberOfRowsInSection:section];
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(popupMenuView:dequeueReusableCell:cellForRowAtIndexPath:)])
    {
        CPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return [self.delegate popupMenuView:self dequeueReusableCell:cell cellForRowAtIndexPath:indexPath];
    }
    
    CPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[CPopupMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = MENU_TITLE_FONT;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = self.textColor;
        cell.separatorColor = self.separatorColor;
    }
    
    if([self.delegate respondsToSelector:@selector(popupMenuView:numberOfRowsInSection:)])
        cell.showSepLine = indexPath.row < [self.delegate popupMenuView:self numberOfRowsInSection:indexPath.section]-1 ? YES : NO;
    else
        cell.showSepLine = indexPath.row < self.titles.count-1 ? YES : NO;
    
    if([self.delegate respondsToSelector:@selector(popupMenuView:textForRowAtIndexPath:)])
        cell.textLabel.text = [self.delegate popupMenuView:self textForRowAtIndexPath:indexPath];
    else
        cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    
    if([self.delegate respondsToSelector:@selector(popupMenuView:modifyCell:forRowAtIndexPath:)])
       [self.delegate popupMenuView:self modifyCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(popupMenuView:didSelectTitleAtIndex:)])
        [self.delegate popupMenuView:self didSelectTitleAtIndex:indexPath.row];
}

- (void)show
{
    if (_needRefresh == YES)
    {
        [self initialize];
        _needRefresh = NO;
    }
    
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    [shareWindow addSubview:self];
    _contentView.alpha = 0.0;
    
    [_tableView reloadData];
    
    self.userInteractionEnabled = NO;
    _contentView.frame = CGRectOffset(_contentView.frame, 0, _arrorDirection == EPopupViewArrorDirTop ? -MARGIN : MARGIN);
    [UIView animateWithDuration:.25 animations:^
    {
        _contentView.alpha = 1.0;
        _contentView.frame = CGRectOffset(_contentView.frame, 0, _arrorDirection == EPopupViewArrorDirTop ? MARGIN : -MARGIN);
    } completion:^(BOOL finished)
    {
        self.userInteractionEnabled = YES;
    }];
}

- (void)dismiss
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25 animations:^{
        _contentView.alpha = 0.0;
        _contentView.frame = CGRectOffset(_contentView.frame, 0, _arrorDirection == EPopupViewArrorDirTop ? -MARGIN : MARGIN);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        _contentView.frame = CGRectOffset(_contentView.frame, 0, _arrorDirection == EPopupViewArrorDirTop ? MARGIN : -MARGIN);
        [self removeFromSuperview];
    }];
}

@end
