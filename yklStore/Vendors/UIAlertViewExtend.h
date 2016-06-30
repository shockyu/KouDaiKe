//
//  UIAlertView+UIAlertViewExtend.h
//  etionUI
//
//  Created by wu jingxing on 12-11-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (UIAlertViewExtend)

+(void)showErrorMsg:(NSString*)szMsg;

+(void)showInfoMsg:(NSString*)szMsg;

+(void)showAskMsg:(NSString*)szMsg delegate:(id<UIAlertViewDelegate>)delegate;

+(void)showMessageWithTitle:(NSString*)szTitle message:(NSString*)szMsg;

@end
