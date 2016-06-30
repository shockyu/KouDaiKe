//
//  PopupView.m
//  etionUI
//
//  Created by wangjian on 11/29/13.
//  Copyright (c) 2013 GuangZhouXuanWu. All rights reserved.
//

#import "PopupView.h"


#define MARGIN 15
#define RADIUS 5
#define ARROR_SIZE 7

@implementation CPopupView
{
    UIView *_shadowView;
    UIView *_maskView;
}

- (id)initWithFrame:(CGRect)frame
{
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:shareWindow.bounds];
    if (self)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:bgView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        
        _shadowView = [[UIView alloc] initWithFrame:_contentView.bounds];
        _shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_contentView addSubview:_shadowView];
        
        _maskView = [[UIView alloc] initWithFrame:_contentView.bounds];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_contentView addSubview:_maskView];
        
        _viewBackgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
        [bgView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (UIBezierPath *)bezierPathWithContentSize:(CGSize)contentSize arrorDir:(EPopupViewArrorDir)arrorDir arrorLocX:(float)x
{
    const float radius = RADIUS;
    const int arrawSize = ARROR_SIZE;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (arrorDir == EPopupViewArrorDirTop)
    {
        [bezierPath moveToPoint: CGPointMake(0, arrawSize+radius)];
        [bezierPath addArcWithCenter:CGPointMake(radius, arrawSize+radius) radius:radius startAngle:M_PI endAngle:M_PI*3/2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(x-arrawSize, arrawSize)];
        [bezierPath addLineToPoint:CGPointMake(x, 0)];
        [bezierPath addLineToPoint:CGPointMake(x+arrawSize, arrawSize)];
        [bezierPath addLineToPoint:CGPointMake(contentSize.width-radius, arrawSize)];
        [bezierPath addArcWithCenter:CGPointMake(contentSize.width-radius, arrawSize+radius) radius:radius startAngle:M_PI*3/2 endAngle:0 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(contentSize.width, contentSize.height-radius)];
        [bezierPath addArcWithCenter:CGPointMake(contentSize.width-radius, contentSize.height-radius) radius:radius startAngle:0 endAngle:M_PI/2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(radius, contentSize.height)];
        [bezierPath addArcWithCenter:CGPointMake(radius, contentSize.height-radius) radius:radius startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(0, arrawSize+radius)];
    }
    else
    {
        [bezierPath moveToPoint: CGPointMake(0, radius)];
        [bezierPath addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI*3/2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(contentSize.width-radius, 0)];
        [bezierPath addArcWithCenter:CGPointMake(contentSize.width-radius, radius) radius:radius startAngle:M_PI*3/2 endAngle:0 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(contentSize.width, contentSize.height-arrawSize-radius)];
        [bezierPath addArcWithCenter:CGPointMake(contentSize.width-radius, contentSize.height-arrawSize-radius) radius:radius startAngle:0 endAngle:M_PI/2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(x+arrawSize, contentSize.height-arrawSize)];
        [bezierPath addLineToPoint:CGPointMake(x, contentSize.height)];
        [bezierPath addLineToPoint:CGPointMake(x-arrawSize, contentSize.height-arrawSize)];
        [bezierPath addLineToPoint:CGPointMake(radius, contentSize.height-arrawSize)];
        [bezierPath addArcWithCenter:CGPointMake(radius, contentSize.height-arrawSize-radius) radius:radius startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(0, radius)];
    }
    
    [bezierPath closePath];
    return bezierPath;
}

-(void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    _viewBackgroundColor = viewBackgroundColor;
    [_maskView viewWithTag:12985476].backgroundColor = _viewBackgroundColor;
}

- (void)_setView:(UIView *)view
{
    _contentView.frame = CGRectMake((self.width-view.width)/2, (self.height-view.height)/2, view.width, view.height);
    [_maskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_maskView addSubview:view];
    view.tag=12985476;
    view.backgroundColor = _viewBackgroundColor;
}

-(void)setView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect bounds = _anchorView.bounds;
    bounds.origin.x += _anchorOffSet.x;
    bounds.origin.y += _anchorOffSet.y;
    CGRect anchorFrame = [window convertRect:bounds fromView:_anchorView];
    
    CGPoint targetCenter = CGPointMake(CGRectGetMidX(anchorFrame), CGRectGetMidY(anchorFrame));
    _arrorDirection = targetCenter.y < CGRectGetMidY(self.frame) ? EPopupViewArrorDirTop : EPopupViewArrorDirBottom;
    
    [self _setView:view];
    
    int startX = targetCenter.x - _contentView.width/2;
    if (startX < MARGIN)
    {
        startX = MARGIN;
    }
    else if (startX > self.width-MARGIN-_contentView.width)
    {
        startX = self.width-MARGIN-_contentView.width;
    }
    
    int startY = 0;
    if (_arrorDirection == EPopupViewArrorDirTop)
    {
        startY = CGRectGetMaxY(anchorFrame);
    }
    else
    {
        startY = CGRectGetMinY(anchorFrame)-_contentView.height;
    }
    if (startY < MARGIN)
    {
        startY = MARGIN;
    }
    else if (startY > self.height - MARGIN - _contentView.height)
    {
        startY = self.height - MARGIN - _contentView.height;
    }
    
    _contentView.frame = CGRectMake(startX, startY, _contentView.width, _contentView.height);
    UIBezierPath *path = [self bezierPathWithContentSize:_contentView.size arrorDir:_arrorDirection arrorLocX:targetCenter.x - startX];
    self.maskPath = path;
}

- (void)setAnchorView:(UIView *)view
{
    _anchorView = view;
}

- (void)setMaskPath:(UIBezierPath *)maskPath
{
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:self.bounds];
    [shadowLayer setMasksToBounds:NO];
    [shadowLayer setShadowPath:maskPath.CGPath];
    [shadowLayer setShadowOpacity:.3];
    [shadowLayer setShadowOffset:CGSizeMake(0, 0)];
    [shadowLayer setShadowRadius:3];
    [shadowLayer setShadowColor:self.borderColor.CGColor];
    [_shadowView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_shadowView.layer addSublayer:shadowLayer];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    _maskView.layer.mask = maskLayer;
}

- (void)tapBgView:(UIGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self];
    if (CGRectContainsPoint(_contentView.frame, tapPoint) == NO)
    {
        if([_delegate respondsToSelector:@selector(clickMaskPopupViewWillClose:)])
           [_delegate clickMaskPopupViewWillClose:self];
        [self dismiss];
    }
}

- (void)show
{
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    [shareWindow addSubview:self];
    _contentView.alpha = 0.0;
    self.userInteractionEnabled = NO;
    _contentView.frame = CGRectMake((self.width-_contentView.width)/2, (self.height-_contentView.height)/2, _contentView.width, _contentView.height);
    [UIView animateWithDuration:.25 animations:^{
        _contentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)dismiss
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25 animations:^{
        _contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
}

@end
