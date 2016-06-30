//
//  MyButton.m
//  Untitled
//
//  Created by  user on 11-2-17.
//  Copyright 2011 GuangZhouXuanWu. All rights reserved.
//

#import "Selector.h"

#define SELECTOR_SIGN_BORDER_W 0.5
#define SELECTOR_CHECK_RADIUS 3
#define SELECTOR_SIGN_BORDER_COLOR [UIColor lightGrayColor]
#define SELECTOR_MIN_SPACE 10

@interface CTickLayer : CALayer

@property (nonatomic, assign) float lineWidth;
@property (nonatomic, retain) UIColor *renderColor;

@end

@implementation CTickLayer

- (id)init
{
    self = [super init];
    if (self)
    {
        self.lineWidth = 2;
        self.renderColor = [UIColor whiteColor];
        self.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        self.lineWidth = ((CTickLayer *)layer).lineWidth;
        self.renderColor = ((CTickLayer *)layer).renderColor;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"lineWidth"])
    {
        return YES;
    }
    else
    {
        return [super needsDisplayForKey:key];
    }
}

- (void)setLineWidth:(float)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setRenderColor:(UIColor *)renderColor
{
    _renderColor = renderColor;
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextMoveToPoint(ctx, self.bounds.size.width*(4.0/14.0), self.bounds.size.height*(7.0/14.0));
    CGContextAddLineToPoint(ctx, self.bounds.size.width*(6.0/14.0), self.bounds.size.height*(10.0/14.0));
    CGContextAddLineToPoint(ctx, self.bounds.size.width*(11.0/14.0), self.bounds.size.height*(4.0/14.0));
    
    CGContextSetStrokeColorWithColor(ctx, self.renderColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    CGContextStrokePath(ctx);
}

@end

@interface CSelectorSignView ()

@property (nonatomic, retain) UIColor *highlightForegroundColor;
@property (nonatomic, retain) UIColor *highlightBackgroundColor;

@end

@implementation CSelectorSignView
{
    ESelectorSignType _type;
    UIView *_backroundView;
    UIView *_radioCircleView;   //用于ESelectorSignTypeRadio模式
    CTickLayer *_tickLayer;     //仅用于ESelectorSignTypeCheck模式
    UIImageView *_imageView;    //用于ESelectorSignTypeCustomerImage模式
}

- (id)initWithFrame:(CGRect)frame type:(ESelectorSignType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        _enabled = YES;
        self.cornerRadius = SELECTOR_CHECK_RADIUS;
        self.userInteractionEnabled = NO;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _backroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backroundView.backgroundColor = SELECTOR_SIGN_BORDER_COLOR;
        [self addSubview:_backroundView];

        if (type == ESelectorSignTypeCheck)
        {
            _tickLayer = [CTickLayer layer];
            _tickLayer.masksToBounds = YES;
            _tickLayer.frame = CGRectInset(self.bounds, SELECTOR_SIGN_BORDER_W, SELECTOR_SIGN_BORDER_W);
            [self.layer addSublayer:_tickLayer];
        }
        else
        {
            _radioCircleView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, SELECTOR_SIGN_BORDER_W, SELECTOR_SIGN_BORDER_W)];
            [self addSubview:_radioCircleView];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.renderColor = [UIColor colorWithHex:0x3498DB];
        
        [self viewSizeChanged];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = ESelectorSignTypeCustomerImage;
        _enabled = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
        [self addSubview:_imageView];
        
        [self viewSizeChanged];
    }
    return self;
}

- (UIColor *)brighterColorWithColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    CGFloat baseValue = MAX(r, MAX(g, b));
    CGFloat brightRate = (1.0-baseValue)*0.5/baseValue;
    r += r*brightRate;
    g += g*brightRate;
    b += b*brightRate;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (UIColor *)lighterColorWithColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    CGFloat lightRate = 0.85;
    r += (1.0-r)*lightRate;
    g += (1.0-g)*lightRate;
    b += (1.0-b)*lightRate;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (void)setFrame:(CGRect)frame
{
    BOOL needUpdateView = NO;
    if (!CGSizeEqualToSize(frame.size, self.frame.size))
    {
        needUpdateView = YES;
    }
    
    [super setFrame:frame];
    
    if (needUpdateView)
    {
        [self viewSizeChanged];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_type == ESelectorSignTypeCustomerImage)
    {
        [super setBackgroundColor:backgroundColor];
    }
    else
    {
        _radioCircleView.backgroundColor = backgroundColor;
    }
}

- (void)setRenderColor:(UIColor *)renderColor
{
    if (_type == ESelectorSignTypeCustomerImage)
    {
        return;
    }
    
    _renderColor = renderColor;

    self.highlightBackgroundColor = [self brighterColorWithColor:renderColor];
    self.highlightForegroundColor = [self lighterColorWithColor:self.highlightBackgroundColor];
    
    [self updateDisplayColor];
}

-(void)setCornerRadius:(float)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    _tickLayer.cornerRadius = cornerRadius;
}

- (void)viewSizeChanged
{
    if (_type == ESelectorSignTypeCustomerImage)
    {
        _imageView.frame = self.bounds;
    }
    else
    {
        self.layer.cornerRadius = _type == ESelectorSignTypeCheck ? self.cornerRadius : self.width/2;
        
        _backroundView.frame = self.bounds;
        CGRect foregroundFrame = CGRectInset(self.bounds, SELECTOR_SIGN_BORDER_W, SELECTOR_SIGN_BORDER_W);
        if (self.bounds.size.width <= 2*SELECTOR_SIGN_BORDER_W || self.bounds.size.height <= 2*SELECTOR_SIGN_BORDER_W) {
            foregroundFrame = CGRectZero;
        }
        if (_type == ESelectorSignTypeCheck)
        {
            _tickLayer.frame = foregroundFrame;
            _tickLayer.cornerRadius = self.cornerRadius;
            _tickLayer.lineWidth = [self lineWidthOfTickLayer];
        }
        else
        {
            _radioCircleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _radioCircleView.frame = foregroundFrame;
            _radioCircleView.layer.cornerRadius = _radioCircleView.width/2;
            _radioCircleView.transform = [self transformOfRadioView];
        }
    }
}

- (void)setLineWidthAnimated
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.fromValue = [NSNumber numberWithFloat:_tickLayer.lineWidth];
    animation.toValue = [NSNumber numberWithFloat:[self lineWidthOfTickLayer]];
    animation.duration = .25;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_tickLayer addAnimation:animation forKey:@"lineWidth"];
    _tickLayer.lineWidth = [self lineWidthOfTickLayer];
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _selected = selected;
    
    if (_type == ESelectorSignTypeCustomerImage)
    {
        _imageView.highlighted = selected;
    }
    else
    {
        if (animated == NO)
        {
            [self updateDisplayColor];
            if (_type == ESelectorSignTypeCheck)
            {
                _tickLayer.lineWidth = [self lineWidthOfTickLayer];
            }
            else if (_type == ESelectorSignTypeRadio)
            {
                _radioCircleView.transform = [self transformOfRadioView];
            }
        }
        else
        {
            [UIView animateWithDuration:.25 animations:^
            {
                [self updateDisplayColor];
                if (_type == ESelectorSignTypeRadio)
                {
                    _radioCircleView.transform = [self transformOfRadioView];
                }
            }];
            if (_type == ESelectorSignTypeCheck)
            {
                [self setLineWidthAnimated];
            }
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self updateDisplayColor];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (animated == NO)
    {
        self.highlighted = highlighted;
    }
    else
    {
        [UIView animateWithDuration:.15 animations:^
        {
            self.highlighted = highlighted;
        }];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self updateDisplayColor];
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:.15 animations:^{
            self.enabled = enabled;
        }];
    }
    else
    {
        self.enabled = enabled;
    }
}

- (CGAffineTransform)transformOfRadioView
{
    return self.selected ? CGAffineTransformMakeScale(0.375, 0.375) : CGAffineTransformMakeScale(1.0, 1.0);
}

- (float)lineWidthOfTickLayer
{
    return self.selected ? self.width*0.13 : self.width*1.2;
}

- (void)updateDisplayColor
{
    if (_type == ESelectorSignTypeCustomerImage)
    {
        return;
    }
    
    _backroundView.backgroundColor = [self backgroundColorWithCurState];
    if (_type == ESelectorSignTypeCheck)
    {
        _tickLayer.renderColor = [self foregroundColorWithCurState];
    }
    else
    {
        _radioCircleView.backgroundColor = [self foregroundColorWithCurState];
    }
}

- (UIColor *)backgroundColorWithCurState
{
    if (self.highlighted == NO)
    {
        if (self.enabled == YES)
        {
            return self.selected ? self.renderColor : SELECTOR_SIGN_BORDER_COLOR;
        }
        else
        {
            return self.selected ? [UIColor colorWithHex:0xECF0F1] : SELECTOR_SIGN_BORDER_COLOR;
        }
    }
    else
    {
        return self.selected ? self.highlightBackgroundColor : SELECTOR_SIGN_BORDER_COLOR;
    }
}

- (UIColor *)foregroundColorWithCurState
{
    if (self.highlighted == NO)
    {
        if (self.enabled == YES)
        {
            return [UIColor whiteColor];
        }
        else
        {
            return self.selected ? [UIColor colorWithHex:0x95A5A6] : [UIColor colorWithHex:0xECF0F1];
        }
    }
    else
    {
        return self.highlightForegroundColor;
    }
}

@end

@implementation CSelector
{
    BOOL _check;
    
    ESelectorSignType _selectorSignType;
    CSelectorSignView *_signView;
    UILabel *_titleLabel;
}

@synthesize selectorSignType = _selectorSignType;
@synthesize titleLabel = _titleLabel;
@synthesize szTag;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self setupWithFrame:self.frame title:szTag headImage:nil highlightedImage:nil type:ESelectorSignTypeCheck];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame title:nil type:ESelectorSignTypeCheck];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)szTitle type:(ESelectorSignType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupWithFrame:frame title:szTitle headImage:nil highlightedImage:nil type:type];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)szTitle headImage:(UIImage *)headImage highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupWithFrame:frame title:szTitle headImage:headImage highlightedImage:highlightedImage type:ESelectorSignTypeCustomerImage];
    }
    return self;
}

-(void)setupWithFrame:(CGRect)frame title:(NSString *)szTitle headImage:(UIImage *)headImage highlightedImage:(UIImage *)highlightedImage type:(ESelectorSignType)type
{
    self.changeSelectedStateWhenTouchUpInside = YES;
    _selectorSignType = type;
    
    if (type == ESelectorSignTypeCustomerImage)
    {
        _signView = [[CSelectorSignView alloc] initWithFrame:CGRectMake(0, 0, headImage.size.width, headImage.size.height) image:headImage highlightedImage:highlightedImage];
    }
    else
    {
        _signView = [[CSelectorSignView alloc] initWithFrame:CGRectZero type:type];
    }
    [self addSubview:_signView];
    
    if (szTitle != nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = szTitle;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }

    self.align = ESelectorAlignLeft;
    self.direction = ESelectorDirectionForward;
}


#pragma mark update subviews layout

- (CGSize)calculateSignSize
{
    if (_selectorSignType == ESelectorSignTypeCustomerImage)
    {
        return _signView.size;
    }
    else
    {
        float signWidth = self.signViewWidth;
        if (signWidth == 0)
        {
            if (self.titleLabel == nil)
            {
                signWidth = MIN(self.width, self.height);
            }
            else
            {
                signWidth = self.titleLabel.font.lineHeight * (self.selectorSignType == ESelectorSignTypeCheck ? 0.95 : 1.0);
            }
        }
        return CGSizeMake(signWidth, signWidth);
    }
}

- (CGSize)fitSize
{
    CGSize textAreaSize = [self.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.titleLabel.font forKey:NSFontAttributeName]];
    if (self.titleLabel != nil)
    {
        textAreaSize.width += SELECTOR_MIN_SPACE;
    }
    else
    {
        textAreaSize = CGSizeZero;
    }
    if (self.selectorSignType == ESelectorSignTypeCustomerImage)
    {
        return CGSizeMake(_signView.width+textAreaSize.width, MAX(textAreaSize.height, _signView.height));
    }
    else
    {
        float signWidth = [self calculateSignSize].width;
        return CGSizeMake(signWidth+textAreaSize.width, MAX(textAreaSize.height, signWidth));
    }
}

- (void)setTitleLabelFont:(UIFont *)font
{
    self.titleLabel.font = font;
    [self setNeedsLayout];
}

- (void)setAlign:(ESelectorAlign)align
{
    _align = align;
    [self setNeedsLayout];
}

- (void)setDirection:(ESelectorDirection)direction
{
    _direction = direction;
    [self setNeedsLayout];
}

- (void)setSignViewWidth:(float)signViewWidth
{
    _signViewWidth = signViewWidth;
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    if (!CGSizeEqualToSize(frame.size, self.frame.size))
    {
        [self setNeedsLayout];
    }
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize signSize = [self calculateSignSize];
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.titleLabel.font forKey:NSFontAttributeName]];
    if (textSize.width+signSize.width+SELECTOR_MIN_SPACE > self.width)
    {
        textSize.width = self.width - (signSize.width+SELECTOR_MIN_SPACE);
    }
    
    float startX = 0;
    float margin = SELECTOR_MIN_SPACE;  //图标和文字之间的距离
    if (self.titleLabel == nil)
    {
        textSize = CGSizeZero;
        margin = 0;
        switch (self.align)
        {
            case ESelectorAlignRight:
                startX = self.width-signSize.width;
                break;
            case ESelectorAlignMiddle:
            case ESelectorAlignJustified:
                startX = (self.width-signSize.width)/2;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (self.align)
        {
            case ESelectorAlignRight:
                startX = self.width-textSize.width-signSize.width-SELECTOR_MIN_SPACE;
                break;
            case ESelectorAlignMiddle:
                startX = (self.width-textSize.width-signSize.width-SELECTOR_MIN_SPACE)/2;
                break;
            case ESelectorAlignJustified:
            {
                float spaceWidth = self.width-textSize.width-signSize.width;
                if (spaceWidth > 3*SELECTOR_MIN_SPACE)
                {
                    startX = spaceWidth/3;
                    margin = spaceWidth/3;
                }
                else
                {
                    startX = (spaceWidth-SELECTOR_MIN_SPACE)/2;
                }
            }
            default:
                break;
        }
    }
    
    if (self.direction == ESelectorDirectionForward)
    {
        _signView.frame = CGRectMake(startX, (self.height-signSize.height)/2, signSize.width, signSize.height);
        _titleLabel.frame = CGRectMake(_signView.right+margin, (self.height-textSize.height)/2, textSize.width, textSize.height);
    }
    else
    {
        _titleLabel.frame = CGRectMake(startX, (self.height-textSize.height)/2, textSize.width, textSize.height);
        _signView.frame = CGRectMake(_titleLabel.right+margin, (self.height-signSize.height)/2, signSize.width, signSize.height);
    }
}

#pragma mark state change

- (void)setRenderColor:(UIColor *)renderColor
{
    [_signView setRenderColor:renderColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [self setHighlighted:highlighted animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.highlighted == highlighted)
    {
        return;
    }
    [super setHighlighted:highlighted];
    [_signView setHighlighted:highlighted animated:animated];
}

- (void)setEnabled:(BOOL)enabled
{
    [self setEnabled:enabled animated:NO];
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated
{
    if (self.enabled == enabled)
    {
        return;
    }
    [super setEnabled:enabled];
    [_signView setEnabled:enabled animated:animated];
    self.titleLabel.enabled = enabled;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    [super setSelected:selected];
    [_signView setSelected:selected animated:animated];
}

#pragma mark touch event

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self setHighlighted:YES animated:YES];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, point) == NO)
    {
        [self setHighlighted:NO animated:YES];
    }
    else
    {
        [self setHighlighted:YES animated:YES];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self setHighlighted:NO animated:YES];
    if (self.changeSelectedStateWhenTouchUpInside == YES)
    {
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(self.bounds, point) == YES)
        {
            [self setSelected:!self.selected animated:YES];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self setHighlighted:NO animated:YES];
}

@end
