/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@interface UIView (UIViewExtend)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat offsetX;
@property(nonatomic) CGFloat offsetY;

@property(nonatomic) CGSize size;

@property(nonatomic) CGPoint origin;

@property(nonatomic) CGFloat centerX;

@property(nonatomic) CGFloat centerY;

+(UIView*)parentView:(UIView*)view findWithKindOfClass:(Class)cls;

+(UIView*)loadNibNamed:(NSString*)nibName;

@end

@protocol UIViewExtendDelegate <NSObject>

@optional

@property(nonatomic, retain) NSString *szTag;

@end





@interface NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end


