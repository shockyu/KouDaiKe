//
//  YKLActManageView.h
//  yklStore
//
//  Created by 肖震宇 on 16/6/24.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKLActManageViewDelegate <NSObject>

- (void)didClickedWithTag:(NSInteger)tag;

@end


@interface YKLActManageView : UIView

@property (nonatomic, assign) id<YKLActManageViewDelegate> delegate;

- (void)createView:(NSDictionary *)imageDict;


@end
