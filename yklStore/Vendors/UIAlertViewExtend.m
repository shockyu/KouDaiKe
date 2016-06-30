//
//  UIAlertView+UIAlertViewExtend.m
//  etionUI
//
//  Created by wu jingxing on 12-11-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIAlertViewExtend.h"

#define ShowErrorAlertView(title,msg,dele) \
{\
UIAlertView* alert=[[UIAlertView alloc]initWithTitle:title message:msg delegate:dele cancelButtonTitle:nil otherButtonTitles:@"确定",nil];\
[alert show];\
}

#define ShowAskAlertView(title,msg,dele) \
{\
UIAlertView* alert=[[UIAlertView alloc]initWithTitle:title message:msg delegate:dele cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];\
[alert show];\
}

@implementation UIAlertView (UIAlertViewExtend)

+(void)showErrorMsg:(NSString*)szMsg
{
    ShowErrorAlertView(@"错误",szMsg,nil);
}

+(void)showInfoMsg:(NSString*)szMsg
{
    ShowErrorAlertView(@"提示",szMsg,nil);
}

+(void)showAskMsg:(NSString*)szMsg delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"询问" message:szMsg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.delegate=delegate;
    [alert show];
}

+(void)showMessageWithTitle:(NSString*)szTitle message:(NSString*)szMsg
{
    ShowErrorAlertView(szTitle,szMsg,nil);
}

@end
