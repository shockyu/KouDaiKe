//
//  YKLActListTabBarViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/8.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLActListTabBarViewController.h"
#import "YKLChildActManageViewController.h"
#import "YKLChildNameListViewController.h"

@interface YKLActListTabBarViewController ()<UITabBarControllerDelegate,YKLChildActManageViewControllerDelegate>
{
    YKLChildActManageViewController         *_JXZ_ActView;
    YKLChildActManageViewController         *_DFB_ActView;
    YKLChildActManageViewController         *_YWC_ActView;
    
    NSArray                                 *_tempVcArr;
    
    UIView                                  *_arrowBgView;          // arrow button
    UIImageView                             *_arrowButton;          // arrow button
    
    BOOL                                    _showArrowButton;       // is showed arrow button
    BOOL                                    _popItemMenu;           // is needed pop item menu
    
    UIView                                  *_moreView;
    UIImageView                             *_gouImageView;
    
    UIButton                                *_settingBtn;
    UIView                                  *_settingBgView;
    UIView                                  *_settingView;
    
    BOOL                                    _showHBFB;              //是否显示合并发布
    BOOL                                    _isAllSelected;         //是否全选
}

@property (nonatomic, strong) UIBarButtonItem *backBarItem;

@end

@implementation YKLActListTabBarViewController

- (instancetype)init{
    if (self = [super init]) {
        
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.selected = YES;
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"Add"]forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(showMoreView)
         forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.frame = CGRectMake(0, 0, 16, 16);
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:_settingBtn];
        self.navigationItem.rightBarButtonItem = menuButton;

        //默认显示合并发布
        _showHBFB = YES;
        
        self.delegate = self;
        
        self.backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
        [self.navigationItem setBackBarButtonItem:self.backBarItem];

    }
    return self;
}

//创建设置视图
- (void)createSettingViewWithCellNum:(int)cellNum Height:(float)cellHeight{
    
    //设置页面下拉时的蒙版阴影图片
    _settingBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)];
    _settingBgView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.5];
    _settingBgView.hidden = YES;
    [self.view addSubview:_settingBgView];
    
    //添加手势setBgView隐藏设置页面
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMoreView)];
    gesture.numberOfTapsRequired = 1;
    [_settingBgView addGestureRecognizer:gesture];
    
    //设置页面创建
    _settingView = [[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, self.view.width, cellHeight*cellNum)];
    _settingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_settingView];
    
    UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guideBtn.frame = CGRectMake(0, 0, self.view.width, cellHeight);
    guideBtn.backgroundColor = [UIColor whiteColor];
    [guideBtn addTarget:self action:@selector(ckfdClicked) forControlEvents:UIControlEventTouchUpInside];
    [_settingView addSubview:guideBtn];
    
    UILabel *guideLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 0, 70, cellHeight)];
    guideLabel.font = [UIFont systemFontOfSize:14];
    guideLabel.text = @"查看分店";
    [guideBtn addSubview:guideLabel];
    
    UIImageView *guideImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 0, 17, 17)];
    guideImageView.image = [UIImage imageNamed:@"act_setting_look_icon"];
    guideImageView.centerY = guideBtn.height/2;
    //    guideImageView.backgroundColor = [UIColor flatLightRedColor];
    [guideBtn addSubview:guideImageView];
    
    
    if (cellNum==2) {
        
        UIButton *aboutUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aboutUsBtn.frame = CGRectMake(0, 50, self.view.width, cellHeight);
        aboutUsBtn.backgroundColor = [UIColor whiteColor];
        [aboutUsBtn addTarget:self action:@selector(hbfbClicked) forControlEvents:UIControlEventTouchUpInside];
        [_settingView addSubview:aboutUsBtn];
        
        UILabel *aboutUsLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 0, 70, cellHeight)];
        aboutUsLabel.font = [UIFont systemFontOfSize:14];
        aboutUsLabel.text = @"合并发布";
        [aboutUsBtn addSubview:aboutUsLabel];
        
        UIImageView *aboutUsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 0, 17, 17)];
        aboutUsImageView.image = [UIImage imageNamed:@"act_setting_merge_icon"];
        aboutUsImageView.centerY = aboutUsBtn.height/2;
        //    aboutUsImageView.backgroundColor = [UIColor flatLightRedColor];
        [aboutUsBtn addSubview:aboutUsImageView];
    }
    
}

//显示更多
- (void)showMoreView{
    
    if(_settingBtn.selected)
    {
        
        [self showSettingView:YES];
        
        [_settingBtn.layer addAnimation:[self rotation:0.5 degree:(M_PI*(45)/180.0) direction:1 repeatCount:1] forKey:nil];
  
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"title_right_add"]forState:UIControlStateNormal];
        
    }else{
        
        [self hidenSettingView:YES];
        
        [_settingBtn.layer addAnimation:[self rotation:0.5 degree:(M_PI*(-45)/180.0) direction:1 repeatCount:1] forKey:nil];
        
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"Add"]forState:UIControlStateNormal];
    }
}

//全选按钮方法
- (void)quanxuanDidClicked{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if(_isAllSelected)
    {
        [dict setObject:@"NO" forKey:@"isSelected"];
        
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"bankBtn2"]forState:UIControlStateNormal];
        
        _isAllSelected = NO;
        
    }else{
        
        [dict setObject:@"YES" forKey:@"isSelected"];
        
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"bankBtn1"]forState:UIControlStateNormal];

        _isAllSelected = YES;
        
    }
    
    
    NSString *notifiStr;
    switch ([[YKLLocalUserDefInfo defModel].actType intValue]) {
        case 0:
            
            notifiStr = @"QMKJQuanXuanIsSelected";
            
            break;
        case 1:
            
            notifiStr = @"YYMSQuanXuanIsSelected";
            
            break;
        case 2:
            
            notifiStr = @"YYSDQuanXuanIsSelected";
            
            break;
            
        default:
            break;
    }
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:notifiStr object:nil userInfo:dict];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

#pragma mark - 设置按钮旋转动画

- (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    
    return animation;
    
}

#pragma mark - 设置页显隐及动画

/*!
 * 设置页面隐藏
 */
- (void)hidenSettingView:(BOOL)animat{
    
    [_settingBtn setSelected:YES];
    
    if (animat) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _settingBgView.hidden = YES;
            _settingBgView.top = -ScreenHeight;
            
            _settingView.top = -ScreenHeight;
            
            _settingBtn.userInteractionEnabled = NO;
            
        }completion:^(BOOL finished) {
        
            _settingView.hidden = YES;
            
            _settingBtn.userInteractionEnabled = YES;
            
        }];
    }else{
        _settingBgView.top = -ScreenHeight;
        _settingBgView.hidden = YES;
        
        _settingView.top = -ScreenHeight;
        _settingView.hidden = YES;
    }
}

/*!
 * 设置页面显示
 */
- (void)showSettingView:(BOOL)animat{
    
    [_settingBgView removeFromSuperview];
    [_settingView removeFromSuperview];
    
    if ([[YKLLocalUserDefInfo defModel].actType isEqual:@"0"]||[[YKLLocalUserDefInfo defModel].actType isEqual:@"1"]||[[YKLLocalUserDefInfo defModel].actType isEqual:@"2"]) {
        
        [self createSettingViewWithCellNum:2 Height:40];
    }
    else{
        [self createSettingViewWithCellNum:1 Height:40];
    }
    
    if (!_showHBFB) {
        
        [_settingBgView removeFromSuperview];
        [_settingView removeFromSuperview];
        
        [self createSettingViewWithCellNum:1 Height:40];
    }


    [_settingBtn setSelected:NO];
    
    if (animat) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _settingView.top = 64;
            _settingView.hidden = NO;
            _settingBtn.userInteractionEnabled = NO;
            
        }completion:^(BOOL finished) {
            _settingBgView.top = 0;
            _settingBgView.hidden = NO;
            
            _settingBtn.userInteractionEnabled = YES;
        }];
        
    }else{
        _settingBgView.top = 0;
        _settingBgView.hidden = NO;
        
        _settingView.top = 64;
        _settingView.hidden = NO;
    }
    
    
}

//查看分店点击
- (void)ckfdClicked{
    
    [self showMoreView];
    
    YKLChildNameListViewController *vc = [YKLChildNameListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//合并发布点击
- (void)hbfbClicked{
    
    [self showMoreView];
    
    [_settingBtn setBackgroundImage:[UIImage imageNamed:@"bankBtn2"]forState:UIControlStateNormal];
    [_settingBtn removeTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
    [_settingBtn addTarget:self action:@selector(quanxuanDidClicked)forControlEvents:UIControlEventTouchUpInside];
    
    switch ([[YKLLocalUserDefInfo defModel].actType intValue]) {
        case 0:
            [_JXZ_ActView show_QMKJ_Ctl:YES];

            break;
        case 1:
            [_JXZ_ActView show_YYMS_Ctl:YES];
            
            break;
        case 2:
            [_JXZ_ActView show_YYSD_Ctl:YES];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 取消合并发布代理

- (void)cancerBtnChange{
    
    [_settingBtn setBackgroundImage:[UIImage imageNamed:@"Add"]forState:UIControlStateNormal];
    [_settingBtn removeTarget:self action:@selector(quanxuanDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [_settingBtn addTarget:self action:@selector(showMoreView)forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)allSelectdIs:(BOOL)all
{
    
    if(all)
    {
    
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"bankBtn1"]forState:UIControlStateNormal];
        
        _isAllSelected = YES;
        
    }else{
        
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"bankBtn2"]forState:UIControlStateNormal];
        
        _isAllSelected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置标签栏上的图标和文字在选中状态下的颜色
    self.tabBar.tintColor = [UIColor flatLightRedColor];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    
    _moreView = [[UIView alloc]initWithFrame:CGRectMake(0,  -ScreenHeight-64-10-30 - 30, ScreenWidth, ScreenHeight-64-10-30 + 30)];
    _moreView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moreView];
    
    _arrowBgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 64+10, 40,30)];
    _arrowBgView.backgroundColor = [UIColor whiteColor];
    _arrowBgView.userInteractionEnabled = YES;
    [self.view addSubview:_arrowBgView];
    
    _arrowButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14,8)];
    _arrowButton.center = CGPointMake(_arrowBgView.width/2, _arrowBgView.height/2);
    _arrowButton.backgroundColor = [UIColor whiteColor];
    _arrowButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _arrowButton.image = [UIImage imageNamed:@"arrow_down"];
    _arrowButton.userInteractionEnabled = YES;
    [_arrowBgView addSubview:_arrowButton];
    
    [self viewShowShadow:_arrowBgView shadowRadius:1.0f shadowOpacity:0.1f];
    
    [self addTapGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([_shopDict isEqual:@{}]||_shopDict==nil) {
        self.title = [YKLLocalUserDefInfo defModel].userName;
    }else{
        self.title = _shopDict[@"shopName"];
    }
    
    [self reloadTabBar];
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
    [_arrowBgView addGestureRecognizer:tapGestureRecognizer];
}

- (void)functionButtonPressed
{
    _popItemMenu = !_popItemMenu;
    [self shouldPopNavgationItemMenu:_popItemMenu height:ScreenHeight-64-10-30];
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}


- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
        [UIView animateWithDuration:0.5f animations:^{
            
            _moreView.frame = CGRectMake(0,  64+10, ScreenWidth, height + 30);
            
            _arrowButton.image = [UIImage imageNamed:@"arrow_up"];
            
            [self refresh];
            
        }completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            
            _moreView.frame = CGRectMake(0,  -height - 30, ScreenWidth, height + 30);
            
            _arrowButton.image = [UIImage imageNamed:@"arrow_down"];
            
        }completion:^(BOOL finished) {
            
            [_moreView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
        }];
    }
    
}

- (void)refresh{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"选择活动";
    [_moreView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, 0.5)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [_moreView addSubview:lineView];
    
    NSArray *titleArr = @[@"全民砍价", @"一元秒杀", @"一元速定", @"口袋夺宝",@"一元抽奖",@"口袋红包"];
    NSArray *imageArr = @[@"kanjia_act_icon",@"miaosha_act_icon",@"suding_act_icon",@"duoBao_act_icon",@"higo_act_icon",@"prizes_act_icon"];
    
    for (int i = 1; i < 7; i++) {
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30+45*i, ScreenWidth, 0.5)];
        lineView.backgroundColor =[UIColor lightGrayColor];
        [_moreView addSubview:lineView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 30+45*(i-1)+15, 15, 15)];
        imageView.image = [UIImage imageNamed:imageArr[i-1]];
        [_moreView addSubview:imageView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 30+45*(i-1), 100, 45)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = titleArr[i-1];
        [_moreView addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 30+45*(i-1), ScreenWidth, 45);
        button.tag = 5000+i;
        [button addTarget:self action:@selector(buttonClickded:) forControlEvents:UIControlEventTouchUpInside];
        [_moreView addSubview:button];
    }
    
    _gouImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-50, ([[YKLLocalUserDefInfo defModel].actType intValue]+1)*45, 15, 15)];
    _gouImageView.image = [UIImage imageNamed:@"tick"];
    [_moreView addSubview:_gouImageView];
}

- (void)buttonClickded:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag-5000);
    
    [YKLLocalUserDefInfo defModel].actType = [NSString stringWithFormat:@"%ld",(long)sender.tag-5000-1];
    [[YKLLocalUserDefInfo defModel]saveActInfoDict];
    
    _gouImageView.top = ([[YKLLocalUserDefInfo defModel].actType intValue]+1)*45;
    
    [self reloadTabBar];
    [self functionButtonPressed];
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(YKLChildActManageViewController *)viewController
{
    switch (viewController.type) {
        case 0:
            NSLog(@"进行中");
            
            _showHBFB = YES;
            [self reloadTabBar];
            
            break;
        case 1:
            NSLog(@"待发布");
            
            _showHBFB = NO;
            [self reloadTabBar];
            
            break;
        case 2:
            NSLog(@"已完成");
            
            _showHBFB = NO;
            [self reloadTabBar];
            
            break;
            
        default:
            break;
    }
}

- (void)reloadTabBar{
    
     _tempVcArr = [NSArray array];
    
    //为空则传本地userID
    if ([_shopDict isEqual:@{}]||_shopDict==nil) {
        
        _shopDict = @{
                      @"shopID":[YKLLocalUserDefInfo defModel].userID,
                      @"shopName":[YKLLocalUserDefInfo defModel].userName,
                      };
    }
    
    _JXZ_ActView = [[YKLChildActManageViewController alloc]initWithShouldShowIndex:[[YKLLocalUserDefInfo defModel].actType integerValue] type:0 shopDict:_shopDict];
    _JXZ_ActView.childDelegate = self;
    _JXZ_ActView.tabBarItem.image = [UIImage imageNamed:@"ongoing"];
    _JXZ_ActView.tabBarItem.title = @"进行中";
    _JXZ_ActView.title = @"进行中";
    
    _DFB_ActView = [[YKLChildActManageViewController alloc]initWithShouldShowIndex:[[YKLLocalUserDefInfo defModel].actType integerValue] type:1 shopDict:_shopDict];
    _DFB_ActView.tabBarItem.image = [UIImage imageNamed:@"To-be-released"];
    _DFB_ActView.tabBarItem.title = @"待发布";
    _DFB_ActView.title = @"待发布";
    
    _YWC_ActView = [[YKLChildActManageViewController alloc]initWithShouldShowIndex:[[YKLLocalUserDefInfo defModel].actType integerValue] type:2 shopDict:_shopDict];
    _YWC_ActView.tabBarItem.image = [UIImage imageNamed:@"DONE"];
    _YWC_ActView.tabBarItem.title = @"已完成";
    _YWC_ActView.title = @"已完成";
    
    _tempVcArr = @[_JXZ_ActView,_DFB_ActView,_YWC_ActView];
    
    self.viewControllers = _tempVcArr;

}



@end
