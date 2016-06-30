//
//  SelectorGroup.m
//  etionUI
//
//  Created by wangjian on 9/26/13.
//  Copyright (c) 2013 GuangZhouXuanWu. All rights reserved.
//

#import "SelectorGroup.h"

//#define SELECTOR_ITEM_H 28
//#define SELECTOR_ITEM_FONT_H 14
#define SELECTOR_GROUP_MARGIN_HORIZONTAL 20
#define SELECTOR_GROUP_MARGIN_VERTICAL 10

@implementation CSelectorGroup
{
    NSArray *_selectors;
    ESelectorGroupType _type;
    CSelector *_curSelectedSelector;    //仅用于单选模式
}

@synthesize selectors = _selectors;
@synthesize type = _type;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles type:(ESelectorGroupType)type
{
    return [self initWithFrame:frame titles:titles headImage:nil highlightedImage:nil type:type];
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles headImage:(UIImage *)headImage highlightedImage:(UIImage *)highlightedImage type:(ESelectorGroupType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        _curSelectedSelector = nil;
        self.changeStateAnimated = YES;
        self.autoArrange = YES;
        NSMutableArray *selectors = [NSMutableArray array];
        NSInteger tag = 0;
        for (NSString *title in titles)
        {
            CSelector *selector = nil;
            if (headImage == nil)
            {
                selector = [[CSelector alloc] initWithFrame:CGRectZero title:title type:type==ESelectorGroupTypeUnique ? ESelectorSignTypeRadio : ESelectorSignTypeCheck];
            }
            else
            {
                selector = [[CSelector alloc] initWithFrame:CGRectZero title:title headImage:headImage highlightedImage:highlightedImage];
            }
            selector.changeSelectedStateWhenTouchUpInside = NO;
            selector.tag = tag++;
            [selectors addObject:selector];
            [selector addTarget:self action:@selector(selectorTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:selector];
        }
        _selectors = [selectors copy];
    }
    return self;
}

#pragma mark layout

- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(frame.size, self.frame.size))
    {
        [self setNeedsLayout];
    }
    [super setFrame:frame];
}

- (void)setAlign:(ESelectorAlign)align
{
    for (CSelector *selector in self.selectors)
    {
        [selector setAlign:align];
    }
}

- (void)setDirection:(ESelectorDirection)direction
{
    for (CSelector *selector in self.selectors)
    {
        [selector setDirection:direction];
    }
}

- (void)setTitleLabelFont:(UIFont *)font
{
    for (CSelector *selector in self.selectors)
    {
        [selector setTitleLabelFont:font];
    }
    [self setNeedsLayout];
}

- (CGSize)fitSize
{
    if (self.selectors.count == 0)
    {
        return CGSizeZero;
    }
    
    CGSize fitSize = [self calculateFitItemSize];
    NSInteger itemNumPerLine = self.autoArrange ? [self calculateSuitableItemNumberPerLineWithItemWidth:fitSize.width] : 1;
    NSInteger numberOfLine = (self.selectors.count+itemNumPerLine-1)/itemNumPerLine;
    
    return CGSizeMake(self.width, (numberOfLine*fitSize.height+(numberOfLine-1)*SELECTOR_GROUP_MARGIN_VERTICAL));
}

- (NSInteger)calculateSuitableItemNumberPerLineWithItemWidth:(float)itemWidth
{
    NSInteger numberOfItemPerLine = self.width/(itemWidth+SELECTOR_GROUP_MARGIN_HORIZONTAL);
    numberOfItemPerLine = MAX(numberOfItemPerLine, 1);
    
    NSInteger numberOfLine = (self.selectors.count+numberOfItemPerLine-1)/numberOfItemPerLine;
    
    NSInteger lastLineItemNumber = self.selectors.count % numberOfItemPerLine;
    if (lastLineItemNumber > 0)
    {
        NSInteger adjustNumber = (numberOfItemPerLine-lastLineItemNumber)/numberOfLine;
        numberOfItemPerLine -= adjustNumber;
    }
    
    return numberOfItemPerLine;
}

- (CGSize)calculateFitItemSize
{
    CGSize fitSize = CGSizeZero;
    for (CSelector *selector in self.selectors)
    {
        CGSize curFitSize = [selector fitSize];
        fitSize.width = MAX(fitSize.width, curFitSize.width);
        fitSize.height = MAX(fitSize.height, curFitSize.height);
    }
    return fitSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.selectors.count == 0)
        return;
    
    CGSize fitSize = [self calculateFitItemSize];
    NSInteger itemNumPerLine = self.autoArrange ? [self calculateSuitableItemNumberPerLineWithItemWidth:fitSize.width] : 1;
    NSInteger numberOfLine = (self.selectors.count+itemNumPerLine-1)/itemNumPerLine;
    
    float itemWidth = self.width/itemNumPerLine;
    float itemHeight = self.height/numberOfLine;
    for (int i=0; i<self.selectors.count; i++)
    {
        CSelector *selector = self.selectors[i];
        selector.frame = CGRectMake((i%itemNumPerLine)*itemWidth, (i/itemNumPerLine)*itemHeight, itemWidth, itemHeight);
    }
}

#pragma mark state change

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    for (CSelector *selector in self.selectors)
    {
        selector.enabled = enabled;
    }
}

- (void)setRenderColor:(UIColor *)renderColor
{
    for (CSelector *selector in self.selectors)
    {
        selector.renderColor = renderColor;
    }
}

- (void)selectorTouchUpInside:(CSelector *)selector
{
    if (self.type == ESelectorGroupTypeUnique)
    {
        if (_curSelectedSelector != selector)
        {
            if (_curSelectedSelector != nil)
            {
                [_curSelectedSelector setSelected:NO animated:self.changeStateAnimated];
            }
            _curSelectedSelector = selector;
            [selector setSelected:YES animated:self.changeStateAnimated];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    else
    {
        [selector setSelected:!selector.selected animated:self.changeStateAnimated];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setSelected:(BOOL)selected forSelectorAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (self.type == ESelectorGroupTypeUnique && selected == YES)
    {
        if (_curSelectedSelector != nil)
        {
            [_curSelectedSelector setSelected:NO animated:animated];
        }
        _curSelectedSelector = [self.selectors objectAtIndex:index];
    }
    CSelector *selector = [self.selectors objectAtIndex:index];
    [selector setSelected:selected animated:animated];
}

- (NSIndexSet *)selectedIndexSet
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self.selectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CSelector *item = obj;
        if (item.selected == YES)
        {
            [indexSet addIndex:idx];
        }
    }];
    return indexSet;
}

- (NSUInteger)currentSelectedIndex
{
    return _curSelectedSelector == nil ? NSNotFound : _curSelectedSelector.tag;
}

+ (UIView *)testViewWithFrame:(CGRect)frame
{
    UIScrollView *testView = [[UIScrollView alloc] initWithFrame:frame];
    testView.backgroundColor = [UIColor whiteColor];
    
    NSArray *colors = @[[UIColor colorWithHex:0x16A085], [UIColor colorWithHex:0x27AE60], [UIColor colorWithHex:0x2980B9], [UIColor colorWithHex:0x8E44AD], [UIColor colorWithHex:0x2C3E50], [UIColor colorWithHex:0xF39C12], [UIColor colorWithHex:0xD35400], [UIColor colorWithHex:0xC0392B]];
    
    for (int colorId=0; colorId<3; colorId++)
    {
        for (int i=0; i<2; i++)
        {
            for (int j=0; j<6; j++)
            {
                CSelectorSignView *signView = [[CSelectorSignView alloc] initWithFrame:CGRectMake(20+j*50, 20+i*40+colorId*100, 40, 40) type:i];
                signView.selected = j>=3;
                signView.highlighted = j%3 == 1;
                signView.enabled = !(j%3 == 2);
                signView.renderColor = colors[colorId];
                [testView addSubview:signView];
            }
        }
    }
    
//    CSelector *selector = [[CSelector alloc] initWithFrame:CGRectMake(20, 20, 120, 40) title:@"test1" type:ESelectorSignTypeCheck];
//    [testView addSubview:selector];
//    
//    CSelector *selector1 = [[CSelector alloc] initWithFrame:CGRectMake(20, 20, 120, 40) title:@"test2" type:ESelectorSignTypeRadio];
//    [selector1 setTitleLabelFont:[UIFont systemFontOfSize:14]];
//    [testView addSubview:selector1];
//    
//    CSelectorGroup *selectorGroup = [[CSelectorGroup alloc] initWithFrame:CGRectMake(20, 70, 200, 40) titles:@[@"test group"] type:ESelectorGroupTypeUnique];
//    [selectorGroup setTitleLabelFont:[UIFont systemFontOfSize:16]];
//    [testView addSubview:selectorGroup];
    
    float curStartY = 300;
    
    CSelectorGroup *selectorGroup = [[CSelectorGroup alloc] initWithFrame:CGRectMake(20, curStartY, 300, 40) titles:@[@"test group", @"test group", @"test group", @"test group", @"test group"] headImage:[UIImage imageNamed:@"mobileofficesub"] highlightedImage:[UIImage imageNamed:@"mobileofficesubselected"] type:ESelectorGroupTypeUnique];
    selectorGroup.height = [selectorGroup fitSize].height;
    [testView addSubview:selectorGroup];
    
    CSelectorGroup *selectorGroup1 = [[CSelectorGroup alloc] initWithFrame:CGRectMake(20, selectorGroup.bottom+10, 300, 40) titles:@[@"test group", @"test group", @"test group", @"test group", @"test group"] headImage:[UIImage imageNamed:@"unselect_multiple"] highlightedImage:[UIImage imageNamed:@"select_multiple"] type:ESelectorGroupTypeMultiple];
    selectorGroup1.height = [selectorGroup1 fitSize].height;
    [testView addSubview:selectorGroup1];
    
    curStartY += 200;
    for (int i=0; i<2; i++)
    {
        for (int j=0; j<4; j++)
        {
            CSelector * selector = [[CSelector alloc] initWithFrame:CGRectMake(20 + j*70, curStartY+i*70, 60, 60) title:nil type:i];
            selector.signViewWidth = j*10;
            selector.backgroundColor = [UIColor blueColor];
            selector.align = j;
            [testView addSubview:selector];
        }
    }
//    CSelector * selector1 = [[CSelector alloc] initWithFrame:CGRectMake(180, curStartY, 60, 60) title:nil headImage:[UIImage imageNamed:@"unselect_multiple"] highlightedImage:[UIImage imageNamed:@"select_multiple"]];
//    [testView addSubview:selector1];
    
    curStartY = 900;
    NSArray *arTitles = @[@"标题1", @"标题2", @"标题3", @"标题4", @"标题5", @"标题6", @"标题7", @"标题8", @"标题9", @"标题10", @"标题11"];
    NSArray *arTitles1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
    NSArray *arTitles2 = @[@"这的标题1", @"题1", @"这是很标题1", @"的标题1", @"很长的标题1", @"这是很的标题1", @"标1", @"这长的标题1", @"这是的标题1", @"这是一标题1", @"这是一个很长1"];
    for (int i=0; i<11; i++)
    {
        CSelectorGroup *group = [[CSelectorGroup alloc] initWithFrame:CGRectMake(20, curStartY, testView.width-40, 0) titles:[arTitles1 subarrayWithRange:NSMakeRange(0, i+1)] type:i%2];
        group.renderColor = [UIColor colorWithHex:0x2ECC71];
        group.height = [group fitSize].height;
        group.enabled = i/5 == 0;
        [group setSelected:YES forSelectorAtIndex:0 animated:NO];
        [testView addSubview:group];
        curStartY += group.height+20;
    }
    
    curStartY += 40;
    
    for (int i=0; i<4; i++)
    {
        CSelectorGroup *group = [[CSelectorGroup alloc] initWithFrame:CGRectMake(20, curStartY, testView.width-40, 0) titles:[arTitles subarrayWithRange:NSMakeRange(0, i+1)] type:ESelectorGroupTypeMultiple];
        [group setTitleLabelFont:[UIFont systemFontOfSize:14+3*i]];
        group.align = i;
        group.height = [group fitSize].height;
        [testView addSubview:group];
        curStartY += group.height+20;
    }
    
    curStartY += 40;
    
    for (int i=0; i<2; i++)
    {
        CSelectorGroup *group = [[CSelectorGroup alloc] initWithFrame:CGRectMake(20, curStartY, testView.width-40, 0) titles:[arTitles2 subarrayWithRange:NSMakeRange(0, 6)] type:ESelectorGroupTypeUnique];
        group.direction = i;
        if (i==1)
        {
            group.align = ESelectorAlignRight;
        }
        group.height = [group fitSize].height;
        [testView addSubview:group];
        curStartY += group.height+20;
    }
    
    testView.contentSize = CGSizeMake(testView.width, curStartY);
    return testView;
}

@end
