//
//  YKLTogetherShareViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/25.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLTogetherShareViewController : YKLUserBaseViewController

@property (strong, nonatomic) UIView *bgView;
//@property (strong, nonatomic) UILabel *shareTitleLabel;
@property (strong, nonatomic) UITextField *shareTitleField;
@property (strong, nonatomic) UITextView *shareDescTextView;
@property (strong, nonatomic) UILabel *actTypeLabel;
@property (strong, nonatomic) UIImageView *shareImageView;

@property (strong, nonatomic) NSString *shareURL;
@property (strong, nonatomic) NSString *actType;    //活动类型
@property (strong, nonatomic) NSString *shareTitle; //分享标题
@property (strong, nonatomic) NSString *shareDesc;  //分享描述
@property (strong, nonatomic) NSString *shareImg;   //分享图片

//是否隐藏BarButtonItem
@property BOOL hidenBar;


+ (void)sharedByWeChatWithText:(NSString *)WeChatMessage sceneType:(int)sceneType;

+ (void)sharedByWeChatWithImage:(UIImage *)image sceneType:(int)sceneType;

@end
