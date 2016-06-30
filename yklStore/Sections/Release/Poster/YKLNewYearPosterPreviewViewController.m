//
//  YKLNewYearPosterPreviewViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/22.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLNewYearPosterPreviewViewController.h"

@interface YKLNewYearPosterPreviewViewController ()

@end

@implementation YKLNewYearPosterPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //点击视图返回
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savaPicBtnClicked)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)createBgView{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.bgImageView.contentMode = UIViewContentModeCenter;
    self.bgImageView.frame = CGRectMake(0, 0, self.view.width, self.view.width/0.75);
    self.bgImageView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.bgImageView];
    
    self.upImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新年海报"]];
    self.upImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height-20);
    [self.bgView addSubview:self.upImageView];
    
}

- (UIImage *)drawRect:(UIImage *)iamge
{
    
    [iamge drawAtPoint:CGPointMake(100, 100)];
    return iamge;
}

- (void)createContent{
    
    self.labelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我就是我"]];
    self.labelImageView.frame = CGRectMake(0, self.bgView.height-45, self.view.width, 10);
    [self.bgView addSubview:self.labelImageView];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.labelImageView.top-35, self.view.width, 25)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.text = [NSString stringWithFormat:@"我为%@",self.weString];
    [self.bgView addSubview:self.textLabel];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView.height-15, self.view.width, 25)];
    downView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:downView];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    self.addressLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    self.addressLabel.textColor = [UIColor blackColor];
    //地址取市区
    NSArray *addressArray = [[YKLLocalUserDefInfo defModel].address componentsSeparatedByString:@","];
    self.addressLabel.text = [NSString stringWithFormat:@"我在%@%@",addressArray[2],[YKLLocalUserDefInfo defModel].street];
    NSUInteger length = [self.addressLabel.text length];
    //一字节等于8个像素，通过字节来自适应label宽度
    self.addressLabel.size = CGSizeMake(length*12, 15);
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.centerX = self.view.width/2;
    [downView addSubview:self.addressLabel];
    
//    self.addressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addressIcon"]];
//    self.addressImageView.frame = CGRectMake(self.addressLabel.left-15, 0, 12, 15);
//    [downView addSubview:self.addressImageView];
    
    self.shopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bgView.height-15-15, self.view.width, 15)];
    self.shopLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    self.shopLabel.textAlignment = NSTextAlignmentCenter;
    self.shopLabel.textColor = [UIColor blackColor];
    self.shopLabel.text = [NSString stringWithFormat:@"我是%@",[YKLLocalUserDefInfo defModel].userName];
    [self.bgView addSubview:self.shopLabel];
}

- (void)savaPicBtnClicked{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定保存预览图片到相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UIGraphicsBeginImageContextWithOptions(self.bgView.frame.size, NO, 0.0);
        [self.bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [UIAlertView showInfoMsg:@"已成功保存到本地相册"];
        }];
        
    }else{
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
