//
//  YKLMainMenuView.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/15.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YKLMainMenuType) {
    
    YKLMainMenuTypeActList,       //活动列表
    YKLMainMenuTypeBalance,       //口袋钱包
    YKLMainMenuTypeShop,          //口袋联采
    
//    YKLMainMenuTypeRelease,       //发布活动
//    YKLMainMenuTypeOrder          //订单中心
};

@class YKLMainMenuView;
@protocol YKLMainMenuViewDelegate <NSObject>

- (void)shareViewDidClickItemType:(YKLMainMenuType)type;

@end

@interface YKLMainMenuView : UIView
@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIButton *releaseBtn;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UILabel *orderMarkLabel;
@property (nonatomic, strong) UIImageView *releaseImageView;
@property (nonatomic, strong) UIImageView *orderImageView;
@property (nonatomic, strong) UILabel *releaseLabel;
@property (nonatomic, strong) UILabel *orderLabel;

- (instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types;

@property (nonatomic, weak) id<YKLMainMenuViewDelegate> delegate;

@end


