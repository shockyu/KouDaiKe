//
//  MUILoadMoreTableView.h
//  etionUI
//
//  Created by WangJian on 14-9-23.
//  Copyright (c) 2014年 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MUILoadMoreTableView;
@protocol MUILoadMoreTableViewDelegate <NSObject, UITableViewDelegate>

@optional
// 当loadMoreEnable == YES，并且有必要加载更多数据的时候，则会调用该委托
- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView;

@end

@interface MUILoadMoreTableView : UITableView

@property (nonatomic, weak) id<MUILoadMoreTableViewDelegate> delegate;
@property (nonatomic, assign) BOOL loadMoreEnable;
//@property (nonatomic, strong) NSString *loadMoreText;

// 显示动画，并调整ContentViewSize
- (void)startLoad;
- (void)endLoad;

@end
