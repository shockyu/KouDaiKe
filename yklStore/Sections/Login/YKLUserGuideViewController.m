//
//  YKLUserGuideViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserGuideViewController.h"

@interface YKLUserGuideViewController ()
{
    BOOL isOut;
}
@end

@implementation YKLUserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeLaunchView];   //加载新用户指导页面
}

- (void)makeLaunchView{
    
    NSArray *arr=[NSArray arrayWithObjects:@"firstLogin1",@"firstLogin2", nil];//数组内存放的是我要显示的假引导页面图片
    //通过scrollView 将这些图片添加在上面，从而达到滚动这些图片
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scr.contentSize = CGSizeMake(320*arr.count,self.view.frame.size.height);
    scr.pagingEnabled = YES;
    scr.tag = 7000;
    
    scr.showsVerticalScrollIndicator = FALSE;
    scr.showsHorizontalScrollIndicator = FALSE;
    scr.bounces = NO;
    [self.view addSubview:scr];
    
    for (int i = 0; i<arr.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, self.view.frame.size.height)];
        img.image=[UIImage imageNamed:arr[i]];
        [scr addSubview:img];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setImage:[UIImage imageNamed:@"firstLoginGuideBtn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"firstLoginGuideBtn"] forState:UIControlStateHighlighted];
    [button setTitle:nil forState:UIControlStateNormal];
    [button setFrame:CGRectMake(320*1+160-100, self.view.height-115, 200, 45)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(firstpressed:) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:button];
    
}
- (void)firstpressed:(id)sender
{
    
    [self presentViewController:[[ViewController alloc] init] animated:YES completion:nil];//点击button跳转到根视图
    
//    [UIView animateWithDuration:1.0 animations:^{       
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

@end
