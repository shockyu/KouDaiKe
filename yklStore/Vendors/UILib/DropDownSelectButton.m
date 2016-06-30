//
//  DropDownSelectButton.m
//  etionRichText
//
//  Created by WangJian on 14-5-12.
//
//

#import "DropDownSelectButton.h"
#import "PopupMenuView.h"

#define DDSB_INNER_MARGIN 15
#define DDSB_TRIANGLE_W 10
#define DDSB_TRIANGLE_H 6

@interface CDropDownSelectButton() <CPopupMenuViewDelegate>

@property (nonatomic, assign) float borderSize;
@property (nonatomic, assign) float cornerRadius;

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) CPopupMenuView *popupMenu;

@end

@implementation CDropDownSelectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = NO;
        self.renderingColor = [UIColor colorWithHex:0x2083C3];
        self.selectedColor = [UIColor whiteColor];
//        self.seperatorColor = [UIColor lightGrayColor];
        self.borderSize = 1;
        self.cornerRadius = 5;
        self.hasBorder = YES;
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-DDSB_INNER_MARGIN/2-DDSB_TRIANGLE_W, self.height)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont systemFontOfSize:14];
        self.titleLable.textColor = self.renderingColor;
        self.titleLable.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.titleLable];
        
        self.placeHolder = @"--请选择--";
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.borderSize/2, self.borderSize/2) cornerRadius:self.cornerRadius];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.renderingColor set];
    if (self.hasBorder == YES)
    {
        CGContextAddPath(context, borderPath.CGPath);
        CGContextDrawPath(context, self.highlighted ? kCGPathFillStroke : kCGPathStroke);
    }
    
    if (self.highlighted)
    {
        [self.selectedColor set];
    }
    CGContextMoveToPoint(context, self.width-DDSB_TRIANGLE_W, (self.height-DDSB_TRIANGLE_H)/2);
    CGContextAddLineToPoint(context, self.width, (self.height-DDSB_TRIANGLE_H)/2);
    CGContextAddLineToPoint(context, self.width-DDSB_TRIANGLE_W/2, (self.height-DDSB_TRIANGLE_H)/2+DDSB_TRIANGLE_H);
    CGContextAddLineToPoint(context, self.width-DDSB_TRIANGLE_W, (self.height-DDSB_TRIANGLE_H)/2);
    CGContextFillPath(context);
}

- (CPopupMenuView *)popupMenu
{
    if (_popupMenu == nil)
    {
        _popupMenu = [[CPopupMenuView alloc] initWithTitles:self.arTitles anchorView:self];
        _popupMenu.delegate = self;
//        _popupMenu.borderColor = _popupMenu.textColor = self.renderingColor;
//        _popupMenu.separatorColor = self.seperatorColor;
    }
    return _popupMenu;
}

- (void)setRenderingColor:(UIColor *)renderingColor
{
    _renderingColor = renderingColor;
    
    self.titleLable.textColor = renderingColor;
    [self setNeedsDisplay];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    self.titleLable.text = selectedIndex >= 0 && selectedIndex < self.arTitles.count ? [self.arTitles objectAtIndex:selectedIndex] : self.placeHolder;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    self.titleLable.text = placeHolder;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.titleLable.textColor = highlighted ? self.selectedColor : self.renderingColor;
    [self setNeedsDisplay];
}

- (void)touchUpInside:(id)sender
{
    [self.popupMenu show];
}

- (void)invalidOldPopupView
{
    self.popupMenu = nil;
}

#pragma mark - popup menu delegate

- (void)popupMenuView:(CPopupMenuView *)menuView didSelectTitleAtIndex:(NSUInteger)index
{
    [self.popupMenu dismiss];
    
    if (index != self.selectedIndex)
    {
        self.selectedIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
