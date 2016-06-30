//
//  YKLNoneSpecialModelViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLNoneSpecialModelViewController.h"
#import "YKLSpecialModelViewController.h"

@interface YKLNoneSpecialModelViewController ()

@end

@implementation YKLNoneSpecialModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"什么也没找到";
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+70,200, 150)];
    imageView.centerX = self.view.width/2;
    imageView.image = [UIImage imageNamed:@"no_Model"];
    [self.view addSubview:imageView];
    
    UIImageView *labelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView.bottom+30,257, 18)];
    labelImageView.centerX = self.view.width/2;
    labelImageView.image = [UIImage imageNamed:@"no_ModelLabel"];
    [self.view addSubview:labelImageView];
    
    UIButton *againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    againButton.backgroundColor = [UIColor flatLightBlueColor];
    againButton.layer.cornerRadius = 5;
    againButton.layer.masksToBounds = YES;
    againButton.frame = CGRectMake(35,labelImageView.bottom+25,self.view.width-70,40);
    [againButton addTarget:self action:@selector(againButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againButton];
    
    UIImageView *btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 0, 45, 26)];
    btnImageView.image = [UIImage imageNamed:@"no_model_神灯"];
    btnImageView.centerY = 20;
    [againButton addSubview:btnImageView];
    
    UILabel *btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnImageView.right+10, 0, 80, 40)];
    btnLabel.font = [UIFont systemFontOfSize:17];
    btnLabel.textColor = [UIColor whiteColor];
    btnLabel.text = @"再试一次";
    [againButton addSubview:btnLabel];
    
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    exitButton.backgroundColor = [UIColor flatLightRedColor];
    exitButton.layer.cornerRadius = 5;
    exitButton.layer.masksToBounds = YES;
    exitButton.frame = CGRectMake(35,againButton.bottom+13,self.view.width-70,40);
    [exitButton addTarget:self action:@selector(exitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}

- (void)againButton{
    
    [self exitButton];
    
    YKLSpecialModelViewController *spVC = [YKLSpecialModelViewController new];
    spVC.actName = self.actName;
    [self.navigationController pushViewController:spVC animated:YES];
    
}

- (void)exitButton{
    [self.navigationController popViewControllerAnimated:YES];
}
    
@end
