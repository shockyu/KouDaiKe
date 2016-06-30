//
//  SegmentedControl.m
//  etionUI
//
//  Created by WangJian on 14-5-7.
//  Copyright (c) 2014年 GuangZhouXuanWu. All rights reserved.
//

#import "SegmentedControl.h"

#define SEGMENT_DEF_H 30
#define SEGMENT_DEF_W 40
#define SEGMENT_DEF_FONT [UIFont systemFontOfSize:14]

typedef enum
{
    ESegmentedControlItemStateNormal,
    ESegmentedControlItemStateTouched,
    ESegmentedControlItemStateSelected
} ESegmentedControlItemState;

@interface CSegmentedControlItem : UIView

@property (nonatomic, assign) ESegmentedControlItemState state;

@property (nonatomic, retain) UIColor *renderColor;
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, assign) UIFont *font;           // default is 14

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (id)initWithFrame:(CGRect)frame text:(NSString *)text;

@end

@implementation CSegmentedControlItem
{
    UIColor *_touchedBackgroundColor;
    UIImageView *_imageView;
    UILabel *_textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectedColor = [UIColor whiteColor];
        self.renderColor = [UIColor colorWithHex:0x2083C3];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _imageView.image = [UIImage imageFromImage:image renderWithColor:self.renderColor];
        _imageView.highlightedImage = [UIImage imageFromImage:image renderWithColor:self.selectedColor];
        [self addSubview:_imageView];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];

        NSDictionary *variables = NSDictionaryOfVariableBindings(_imageView, self);
        NSArray *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=1)-[_imageView]"
                                                options: NSLayoutFormatAlignAllCenterX
                                                metrics:nil
                                                  views:variables];
        [self addConstraints:constraints];
        
        constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=1)-[_imageView]"
                                                options: NSLayoutFormatAlignAllCenterY
                                                metrics:nil
                                                  views:variables];
        [self addConstraints:constraints];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.textColor = self.renderColor;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = text;
        [self addSubview:_textLabel];
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.font = SEGMENT_DEF_FONT;
        
        NSDictionary *variables = NSDictionaryOfVariableBindings(_textLabel, self);
        NSArray *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=1)-[_textLabel(==self)]"
                                                options: NSLayoutFormatAlignAllCenterX
                                                metrics:nil
                                                  views:variables];
        [self addConstraints:constraints];
        
        constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=1)-[_textLabel(==self)]"
                                                options: NSLayoutFormatAlignAllCenterY
                                                metrics:nil
                                                  views:variables];
        [self addConstraints:constraints];
    }
    return self;
}

- (void)setRenderColor:(UIColor *)renderColor
{
    _renderColor = renderColor;
    
    _touchedBackgroundColor = [renderColor colorWithAlphaComponent:0.2];
    if (_imageView)
    {
        _imageView.image = [UIImage imageFromImage:_imageView.image renderWithColor:self.renderColor];
    }
    
    self.state = self.state;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    if (_imageView)
    {
        _imageView.highlightedImage = [UIImage imageFromImage:_imageView.image renderWithColor:self.selectedColor];
    }
    
    self.state = self.state;
}

- (void)setFont:(UIFont *)font
{
    _textLabel.font = font;
}

- (void)setState:(ESegmentedControlItemState)state
{
    _state = state;
    switch (state)
    {
        case ESegmentedControlItemStateNormal:
            self.backgroundColor = [UIColor clearColor];
            _imageView.highlighted = NO;
            _textLabel.textColor = self.renderColor;
            break;
        case ESegmentedControlItemStateSelected:
            self.backgroundColor = self.renderColor;
            _imageView.highlighted = YES;
            _textLabel.textColor = self.selectedColor;
            break;
        case ESegmentedControlItemStateTouched:
            self.backgroundColor = _touchedBackgroundColor;
            _imageView.highlighted = NO;
            _textLabel.textColor = self.renderColor;
            break;
    }
}

@end

@interface CSegmentedControl()

@property (nonatomic, assign) float segmentW;
@property (nonatomic, assign) NSInteger touchedSegmentIndex;
@property (nonatomic, retain) NSMutableArray *items;

@end

@implementation CSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.renderColor = [UIColor colorWithHex:0x2083C3];
        self.selectedColor = [UIColor whiteColor];
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.boarderSize = 1;
        self.cornerRadius = 3;
        self.segmentW = SEGMENT_DEF_W;
        self.font = SEGMENT_DEF_FONT;
        _momentary = NO;
        
        self.layer.masksToBounds = YES;
        self.items = [NSMutableArray array];
        
        _selectedSegmentIndex = -1;
        _touchedSegmentIndex = -1;
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles
{
    if (self = [self initWithFrame:CGRectMake(0, 0, SEGMENT_DEF_W*titles.count, SEGMENT_DEF_H)])
    {
        float maxTextWidth = 0;
        for (NSString *title in titles)
        {
            CSegmentedControlItem *item = [[CSegmentedControlItem alloc] initWithFrame:CGRectZero text:title];
            [self addSubview:item];
            [self.items addObject:item];
//            float curTextWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
            float curTextWidth = [title sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]].width;
            if (curTextWidth > maxTextWidth)
            {
                maxTextWidth = curTextWidth;
            }
        }

        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        NSMutableString *constraintFormatH = [NSMutableString string];
        for (int i=0; i<self.items.count; i++)
        {
            [itemDict setObject:self.items[i] forKey:[NSString stringWithFormat:@"item%d", i]];
            if (i==0)
            {
                [constraintFormatH appendFormat:@"|[item0]"];
            }
            else
            {
                [constraintFormatH appendFormat:@"[item%d(==item0)]", i];
            }
            if (i==self.items.count-1)
            {
                [constraintFormatH appendFormat:@"|"];
            }
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.items[i] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.items[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormatH options:0 metrics:nil views:itemDict]];

        self.width = (maxTextWidth+20)*titles.count;
    }
    return self;
}

- (id)initWithImages:(NSArray *)images
{
    if (self = [self initWithFrame:CGRectMake(0, 0, SEGMENT_DEF_W*images.count, SEGMENT_DEF_H)])
    {
        for (UIImage *image in images)
        {
            CSegmentedControlItem *item = [[CSegmentedControlItem alloc] initWithFrame:CGRectZero image:image];
            [self addSubview:item];
            [self.items addObject:item];
        }
    
        for (int i=0; i<self.items.count; i++)
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.items[i] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            float rate = (float)(i*2+1)/(self.items.count*2.0)*2.0;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.items[i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:rate constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.items[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/self.items.count constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.items[i] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        }
    }
    return self;
}

- (void)didMoveToSuperview
{
    if (self.superview != nil)
    {
        if (self.selectedSegmentIndex == -1 && self.momentary == NO)
        {
            self.selectedSegmentIndex = 0;
        }
    }
}

- (NSUInteger)numberOfSegments
{
    return self.items.count;
}

- (float)segmentW
{
    return [self.items[0] width];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (self.momentary == YES)
    {
        CSegmentedControlItem *selItem = self.items[selectedSegmentIndex];
        [UIView animateWithDuration:0.15 animations:^
        {
            selItem.state = ESegmentedControlItemStateSelected;
        } completion:^(BOOL finished)
        {
            [UIView animateWithDuration:0.15 animations:^
            {
                selItem.state = ESegmentedControlItemStateNormal;
            } completion:^(BOOL finished) {}];
        }];
    }
    else if (selectedSegmentIndex != _selectedSegmentIndex)
    {
        [UIView animateWithDuration:0.15 animations:^
        {
            if (_selectedSegmentIndex >= 0)
            {
                CSegmentedControlItem *oldSelItem = self.items[_selectedSegmentIndex];
                oldSelItem.state = ESegmentedControlItemStateNormal;
            }
            if (selectedSegmentIndex >= 0)
            {
                CSegmentedControlItem *selItem = self.items[selectedSegmentIndex];
                selItem.state = ESegmentedControlItemStateSelected;
            }
        }];
    }

    NSUInteger oldSelectedSegmentIndex = _selectedSegmentIndex;
    _selectedSegmentIndex = selectedSegmentIndex;
    [self setNeedsDisplay];
    
    if (self.momentary == YES || oldSelectedSegmentIndex != self.selectedSegmentIndex)
    {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setTouchedSegmentIndex:(NSInteger)touchedSegmentIndex
{
    if (_touchedSegmentIndex == touchedSegmentIndex || self.items.count == 0)
    {
        return;
    }
    
    if (_touchedSegmentIndex >= 0)
    {
        CSegmentedControlItem *oldTouchItem = self.items[_touchedSegmentIndex];
        if (oldTouchItem.state != ESegmentedControlItemStateSelected)
        {
            oldTouchItem.state = ESegmentedControlItemStateNormal;
        }
    }
    if (touchedSegmentIndex >= 0)
    {
        CSegmentedControlItem *touchItem = self.items[touchedSegmentIndex];
        if (touchItem.state != ESegmentedControlItemStateSelected)
        {
            touchItem.state = ESegmentedControlItemStateTouched;
        }
    }
    
    _touchedSegmentIndex = touchedSegmentIndex;
}

- (void)setRenderColor:(UIColor *)renderColor
{
    _renderColor = renderColor;
    
    self.layer.borderColor = renderColor.CGColor;
    for (CSegmentedControlItem *item in self.items)
    {
        item.renderColor = renderColor;
    }
    
    [self setNeedsDisplay];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    
    for (CSegmentedControlItem *item in self.items)
    {
        item.selectedColor = selectedColor;
    }
    
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(float)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setBoarderSize:(float)boarderSize
{
    _boarderSize = boarderSize;
    self.layer.borderWidth = boarderSize;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    
    for (CSegmentedControlItem *item in self.items)
    {
        item.font = _font;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.boarderSize);
    CGContextSetStrokeColorWithColor(context, self.renderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.renderColor.CGColor);
    
    for (int i=1; i<self.numberOfSegments; i++)
    {
        if (self.momentary == NO && (i==self.selectedSegmentIndex || i==self.selectedSegmentIndex+1))
        {
            continue;
        }
        CGContextMoveToPoint(context, i*self.segmentW, 0);
        CGContextAddLineToPoint(context, i*self.segmentW, self.height);
        CGContextStrokePath(context);
    }
}

#pragma mark - touch event

- (NSInteger)tpuchPointToIndex:(CGPoint)point
{
    NSInteger index = point.x/self.segmentW;
    if (index >= self.items.count)
    {
        index = self.items.count-1;
    }
    return index;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (self.momentary == YES)
        self.selectedSegmentIndex = [self tpuchPointToIndex:point];
    else
        self.touchedSegmentIndex = [self tpuchPointToIndex:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.momentary == YES)
        return;

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.touchedSegmentIndex = [self tpuchPointToIndex:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.momentary == YES)
        return;

    self.touchedSegmentIndex = -1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.momentary == YES)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.selectedSegmentIndex = [self tpuchPointToIndex:point];
    self.touchedSegmentIndex = -1;
}

@end


@implementation CStaticSegmentedControl
{
    float separateLineH;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.momentary = YES;
        self.boarderSize = 0.0;
        self.cornerRadius = 0.0;
    }
    return self;
}

- (id)initWithImages:(NSArray *)images
{
    self = [super initWithImages:images];
    if (self)
    {
        if (images.count > 0)
        {
            UIImage *image = [images objectAtIndex:0];
            separateLineH = image.size.height;
        }
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles
{
    self = [super initWithTitles:titles];
    if (self)
    {
        separateLineH = self.font.lineHeight;
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    separateLineH = font.lineHeight;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, self.renderColor.CGColor);
    
    for (int i=1; i<self.numberOfSegments; i++)
    {
        CGContextMoveToPoint(context, i*self.segmentW, (self.height-separateLineH)/2);
        CGContextAddLineToPoint(context, i*self.segmentW, (self.height-separateLineH)/2 + separateLineH);
        CGContextStrokePath(context);
    }
}

@end
