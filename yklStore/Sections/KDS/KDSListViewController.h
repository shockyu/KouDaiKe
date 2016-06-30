//
//  KDSListViewController.h
//  yklStore
//
//  Created by 王硕 on 16/4/25.
//  Copyright © 2016年 wangshuo. All rights reserved.
//

#import "KDSListViewController.h"

//    http://api.meipa.net/index.php?act=api&tag=3#info_api_a87ff679a2f3e71d9181a67b7542122c
/*
 
 KDS
 正常帐号：15116103323
 验证码：0000
 
 黄钻帐号：18670377152
 验证码：0000
 
 上架帐号：13787416332
 @“29”
 验证码：0000
 
 
 ok2.	收藏列表没有滑动删除功能。
 3.	wifi,3G情况下的功能。
 4.	缺少直接到最上的功能。
ok 5.	播放完之后 把进度条拉倒 任何位置  不自动播放  （如果是这样设置的，那暂停按钮应该改成播放按钮）
 
 口袋说bug
 1.视频播放的时候，点击播放屏幕--播放的状态标识发生改变
 2.口袋说---进入其中一期，刷新页面的时候，视频不动
 4.视频播放中点击home键让程序进入后台---再次进入视频中实际上在播放，界面和时间不动了几秒，随后正常
 
 
 1.口袋说--视频页面刷新的时候--视频不动
ok 2.口袋说--在视频界面加一个蒙层---放播放的标识和进度条
 3.口袋说--视频页面向下滑动的时候--播放量评论分享那个模块不动
ok 4.口袋说--视频播放的时候--全屏的时候把苹果手机状态栏隐藏
 */


typedef enum : NSUInteger {
    KDSListTypeNormal       = 0,
    KDSListTypeFavorites    = 1,
    KDSListTypeSearch       = 2,
} KDSListType;

#pragma mark - KDSListCell

@interface KDSListCell : UITableViewCell

@property (nonatomic, strong) UILabel *kdsTitleLabel;//标题
@property (nonatomic, strong) UILabel *kdsInfoLabel;//详情
@property (nonatomic, strong) UILabel *timeNumLabel;//时长
@property (nonatomic, strong) UILabel *playNumLabel;//播放数
@property (nonatomic, strong) UILabel *discussNumLabel;//评论数
@property (nonatomic, strong) UIImageView *contentImage;//图片
//@property (nonatomic, strong) UIView *lineView;//分隔线

@end

@interface KDSListViewController : YKLUserBaseViewController<UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView     *_kDSTableView;
    
    NSMutableArray              *_kDSDicArr;
    
    NSDictionary                *_kDSDic;
    
    NSInteger                   _pageInt;
}

@property (nonatomic, assign) KDSListType listType;
@property (nonatomic, strong) NSString *userIDStr;

@end
