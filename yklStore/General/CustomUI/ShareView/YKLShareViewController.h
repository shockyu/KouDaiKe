//
//  MPSShareViewController.h
//  MPStore
//
//  Created by apple on 14/9/19.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKLShareContentModel.h"

@interface YKLShareViewController : UIViewController

@property (nonatomic, readonly) YKLShareContentModel *shareContent;

+ (YKLShareViewController *)shareViewController;
+ (YKLShareViewController *)shareDetailViewController; //用于在详情里面使用，没有查看这一选项

- (void)showInView:(UIView *)View;

- (void)showViewController;
- (void)showView;

@end
