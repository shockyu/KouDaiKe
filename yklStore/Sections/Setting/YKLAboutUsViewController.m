//
//  YKLAboutUsViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/10/6.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLAboutUsViewController.h"

@interface YKLAboutUsViewController ()

@end

@implementation YKLAboutUsViewController
{
    UIToolbar *bgView;
    UIWebView *callView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithMainBundle:@"logo.png"]];
    logoImageView.size = CGSizeMake(100, 100);
    logoImageView.center = CGPointMake(self.view.width/2, self.contentView.height/2-40);
    logoImageView.layer.cornerRadius = 10;
    logoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:logoImageView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logoImageView.bottom+15, self.view.width-20, 20)];
    versionLabel.text = [NSString stringWithFormat:@"V1.6"];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor midnightTextColor];
    [self.contentView addSubview:versionLabel];
    
    UILabel *qqLable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.contentView.height-120, self.view.width-40, 30)];
    qqLable.text = [NSString stringWithFormat:@"客服QQ：409408337"];
    qqLable.textAlignment = NSTextAlignmentCenter;
    qqLable.font = [UIFont systemFontOfSize:16];
    qqLable.textColor = [UIColor midnightTextColor];
    [self.contentView addSubview:qqLable];
    
    NSString *title = @"客服热线：0731-89790322";
    UIButton *contactUs = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactUs setTitle:title forState:UIControlStateNormal];
    [contactUs setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
    //    [contactUs setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    contactUs.titleLabel.font = [UIFont systemFontOfSize:16];
    contactUs.frame = CGRectMake(20, self.contentView.height-90, self.view.width-40, 30);
    [contactUs addTarget:self action:@selector(contactUsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:contactUs];
    
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentView.height-60, self.view.width-20, 20)];
    copyrightLabel.text = @"Copyright © 2015-2016 All Rights Reserved";
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:12];
    copyrightLabel.textColor = [UIColor midnightTextColor];
    [self.contentView addSubview:copyrightLabel];
}

- (void)contactUsBtnClicked:(id)sender
{
    NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://0731-89790322"]];
    if (callView == nil) {
        callView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [callView loadRequest:[NSURLRequest requestWithURL:callURL]];
}

@end
