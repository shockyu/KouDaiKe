//
//  YKLActSelectViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/17.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
//#import "YKLActSelectADView.h"


@interface YKLActSelectViewController : YKLUserBaseViewController
@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) NSArray *titles;

@end
