/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "UIViewExtend.h"

@implementation UIView (UIViewExtend)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOffsetX:(CGFloat)offsetX
{
    self.frame = CGRectOffset(self.frame, offsetX, 0);
}

- (CGFloat)offsetX
{
    return 0;
}

- (void)setOffsetY:(CGFloat)offsetY
{
    self.frame = CGRectOffset(self.frame, 0, offsetY);
}

- (CGFloat)offsetY
{
    return 0;
}

- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

-(CGFloat) centerX
{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX
{
    self.center=CGPointMake(centerX, self.centerY);
}

-(CGFloat) centerY
{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY
{
    self.center=CGPointMake(self.centerX,centerY);
}

+(UIView*)parentView:(UIView*)view findWithKindOfClass:(Class)cls
{
    @autoreleasepool
    {
        UIView *findview=nil;
        NSArray *ar=view.subviews;
        for(id v in ar)
        {
            if([v isKindOfClass:cls])
                return v;
            else
            {
                findview=[UIView parentView:v findWithKindOfClass:cls];
                if(findview!=nil)
                    return findview;
            }
        }
        return findview;
    }
}

+(UIView*)loadNibNamed:(NSString*)nibName
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

@end










@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
//    block = [[block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
    
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end
