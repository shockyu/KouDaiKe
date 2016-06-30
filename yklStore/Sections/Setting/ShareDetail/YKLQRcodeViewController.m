//
//  YKLQRcodeViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/28.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLQRcodeViewController.h"
#import "QRCodeGenerator.h"
#import "YKLShareContentModel.h"
#import "YKLShareViewController.h"
#import "YKLTogetherShareViewController.h"

@interface YKLQRcodeViewController ()
@property (nonatomic, strong) UIImageView *qRImageView;

@end

@implementation YKLQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"分享按钮"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareRightItemClicked)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 35, 35);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImageView *grayImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"二维码页面灰底.png"]];
    grayImageView.frame = CGRectMake(35, 50+64, 250, 275);
    [self.view addSubview:grayImageView];
    
    UIImageView *greenImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"二维码页面青条.png"]];
    greenImageView.frame = CGRectMake(grayImageView.left, grayImageView.bottom-5, 250, 65);
    [self.view addSubview:greenImageView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, greenImageView.width-20, 20)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.centerX = greenImageView.width/2;
//    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = [NSString stringWithFormat:@"店铺名：%@",[YKLLocalUserDefInfo defModel].userName];
    [greenImageView addSubview:nameLabel];
    
    UILabel *mobLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, nameLabel.bottom, nameLabel.width-20, nameLabel.height)];
    mobLabel.font = [UIFont systemFontOfSize:14];
    mobLabel.textColor = [UIColor whiteColor];
//    mobLabel.centerX = greenImageView.width/2;
//    mobLabel.textAlignment = NSTextAlignmentCenter;
    mobLabel.text = [NSString stringWithFormat:@"电话号码：%@",[YKLLocalUserDefInfo defModel].mobile];
    [greenImageView addSubview:mobLabel];
    
    //Y--->Y:140
    self.qRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 215, 215)];
//    self.qRImageView.centerX = self.view.width/2;
    self.qRImageView.backgroundColor = [UIColor whiteColor];
    self.qRImageView.image = [QRCodeGenerator qrImageForString:self.shareURL imageSize:self.qRImageView.bounds.size.width];
    [grayImageView addSubview:self.qRImageView];
    
}

- (void)shareRightItemClicked{
    NSLog(@"点击右键分享按钮");
    
    YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
    VC.hidenBar = NO;
    VC.shareTitle = @"推荐您使用口袋客为门店聚客";
    VC.shareDesc = [NSString stringWithFormat:@"我们%@用口袋客给店里带来了不少新客人，你也赶紧注册口袋客为门店聚客推广！",[YKLLocalUserDefInfo defModel].userName];
    VC.shareImg = @"logo";
    VC.shareURL = self.shareURL;
    VC.actType = @"店铺推荐";
    [self.navigationController pushViewController:VC animated:YES];
    
//    [YKLShareContentModel defModel].number = [YKLLocalUserDefInfo defModel].userID;
//    [YKLShareContentModel defModel].userActionType = EMPSUserActionTypeShareProduct;
//    [YKLShareContentModel defModel].title = @"推荐您使用口袋客为门店聚客";
//    [YKLShareContentModel defModel].introduction = [NSString stringWithFormat:@"我们%@用口袋客给店里带来了不少新客人，你也赶紧注册口袋客为门店聚客推广！",[YKLLocalUserDefInfo defModel].userName];
//    [YKLShareContentModel defModel].url = self.shareURL;
//    [YKLShareContentModel defModel].shareVisible = YES;
//    [YKLShareContentModel defModel].thumbImage = [UIImage imageWithMainBundle:@"logo.png"];
//    [[YKLShareViewController shareViewController] showInView:self.view];
//    [[YKLShareViewController shareViewController] showViewController];
    
}

@end
