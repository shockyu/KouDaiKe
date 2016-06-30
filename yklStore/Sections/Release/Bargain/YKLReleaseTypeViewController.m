//
//  YKLReleaseTypeViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/28.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLReleaseTypeViewController.h"
#import "YKLReleaseViewController.h"
#import "YKLReleaseModelTableViewCell.h"


@interface YKLReleaseTypeViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *expandLael;
@property (nonatomic, strong) UILabel *expandLael2;
@property (nonatomic, strong) UIImageView *expandImageView;
@property (nonatomic, strong) UIButton *expandBtn;

@property (nonatomic, strong) UILabel *moveSaleLabel;
@property (nonatomic, strong) UILabel *moveSaleLabel2;
@property (nonatomic, strong) UIImageView *moveSaleImageView;
@property (nonatomic, strong) UIButton *moveSaleBtn;


@end

@implementation YKLReleaseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"类型选择";
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.bgView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.view addSubview:self.bgView];
    
    [self createView];
    
}


- (void)createView{
    
    self.expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.expandBtn.frame = CGRectMake(0, 10, self.view.width, 140);
    //    self.expandBtn.backgroundColor = [UIColor redColor];
    [self.expandBtn addTarget:self action:@selector(expandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.expandBtn];
    
    self.expandImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"线下支付.png"]];
    self.expandImageView.frame = CGRectMake(0, 10, self.view.width, 140);
    [self.bgView addSubview: self.expandImageView];
    
    self.moveSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.moveSaleBtn.backgroundColor = [UIColor clearColor];
    self.moveSaleBtn.frame = CGRectMake(0, self.expandImageView.bottom+10, self.view.width, 140);
    [self.moveSaleBtn addTarget:self action:@selector(moveSaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.moveSaleBtn];
    
    self.moveSaleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"线上支付.png"]];
    self.moveSaleImageView.frame = CGRectMake(0, self.expandImageView.bottom+10, self.view.width, 140);
    self.moveSaleImageView.centerX = self.bgView.width/2;
    [self.bgView addSubview: self.moveSaleImageView];

}


- (void)expandBtnClick:(id)sender{
    NSLog(@"到店模式");
    YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
    releaseVC.typePushStr = @"到店模式";
    releaseVC.typePushNub = @"1";
    releaseVC.activityIngHidden = YES;
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)moveSaleBtnClick:(id)sender{
    NSLog(@"促销模式");
    YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
    releaseVC.typePushStr = @"促销模式";
    releaseVC.typePushNub = @"2";
    releaseVC.activityIngHidden = YES;
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}


@end
