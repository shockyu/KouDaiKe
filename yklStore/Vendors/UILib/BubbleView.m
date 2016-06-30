//
//  BubbleView.m
//  etionUI
//
//  Created by WangJian on 14-9-11.
//  Copyright (c) 2014年 GuangZhouXuanWu. All rights reserved.
//

#import "BubbleView.h"

@implementation CBubbleView
{
//    CAShapeLayer *_shadowLayer;
    UIView *_maskView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.3;
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
        [super setBackgroundColor:[UIColor clearColor]];
        
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_maskView];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [_maskView setBackgroundColor:backgroundColor];
}

- (void)setArrorDir:(EBubbleViewArrorDir)arrorDir
{
    _arrorDir = arrorDir;
    [self setNeedsLayout];
}

- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    
    UIView *tmpView = contentView;
    _contentView = tmpView;
    
    [_maskView addSubview:contentView];
    
    [self contentViewSizeHasChange];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsLayout];
}

- (void)contentViewSizeHasChange
{
    self.frame = CGRectMake(self.left, self.top, self.contentView.width+self.contentEdgeInsets.left+self.contentEdgeInsets.right, self.contentView.height+BUBBLE_ARROR_SIZE+self.contentEdgeInsets.top+self.contentEdgeInsets.bottom);
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.contentView != nil)
    {
        self.contentView.frame = CGRectMake(self.contentEdgeInsets.left,
                                            (self.arrorDir == EBubbleViewArrorDirTop ? BUBBLE_ARROR_SIZE : 0)+self.contentEdgeInsets.top,
                                            self.contentView.width,
                                            self.contentView.height);
    }
    [self setMaskPath:[self bezierPathWithContentSize:self.size arrorDir:self.arrorDir arrorLocX:self.size.width/2]];
}

- (void)setMaskPath:(UIBezierPath *)maskPath
{
    _maskView.frame = self.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    _maskView.layer.mask = maskLayer;
}

- (UIBezierPath *)bezierPathWithContentSize:(CGSize)contentSize arrorDir:(EBubbleViewArrorDir)arrorDir arrorLocX:(float)x
{
    const float radius = BUBBLE_RADIUS;
    const int arrawSize = BUBBLE_ARROR_SIZE;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (arrorDir == EBubbleViewArrorDirTop)
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


@end
