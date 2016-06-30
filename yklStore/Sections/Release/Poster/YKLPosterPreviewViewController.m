//
//  YKLPosterPreviewViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLPosterPreviewViewController.h"

@interface YKLPosterPreviewViewController ()


@end

@implementation YKLPosterPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
//    [self createBgView];
    
    //点击视图返回
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savaPicBtnClicked)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
}

- (void)createBgView{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    self.bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height-20);
    [self.bgView addSubview:self.bgImageView];
    
    self.upImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"渐变蒙版"]];
    self.upImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height-20);
    [self.bgView addSubview:self.upImageView];
    
    self.swearImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我发誓"]];
    self.swearImageView.frame = CGRectMake(15, self.view.height/3*2-20, 150, 60);
    
    if (ScreenHeight == 480) {
        self.swearImageView.frame = CGRectMake(15, self.view.height/3*2-20-20, 150, 60);
        
    }
    
    [self.bgView addSubview:self.swearImageView];
    
}

- (void)createContent{
    
    //选择颜色
    UIColor *color;
    switch (self.colorStatus) {
        case 1:
            color = [UIColor PosterRedColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证"]];
            break;
        case 2:
            color = [UIColor PosterOrangeColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证-橙"]];
            break;
        case 3:
            color = [UIColor PosterYellowColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证-黄"]];
            break;
        case 4:
            color = [UIColor PosterGreenColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证-绿"]];
            break;
        case 5:
            color = [UIColor PosterLightGreenColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证-青"]];
            break;
        case 6:
            color = [UIColor PosterBlueColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证-蓝"]];
            break;
        case 7:
            color = [UIColor PosterPurpleColor];
            self.witnessImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请你来见证-紫"]];
            break;
        default:
            break;
    }
    
    self.roundView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
    self.roundView.backgroundColor = color;
    self.roundView.layer.cornerRadius = 45/2;
    self.roundView.layer.masksToBounds = YES;
    [self.bgView addSubview:self.roundView];

    self.weLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.swearImageView.bottom+10, 240, 20)];
    self.weLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.weLabel.textColor = color;
    self.weLabel.text = [NSString stringWithFormat:@"我们只%@",self.weString];
    [self.bgView addSubview:self.weLabel];
    
    //创建在上判断
    self.witnessImageView.frame = CGRectMake(15, self.weLabel.bottom+10, 100, 20);
    [self.bgView addSubview:self.witnessImageView];
    
    self.shopLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.witnessImageView.bottom+10, 240, 20)];
    self.shopLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.shopLabel.textColor = color;
    self.shopLabel.text = [NSString stringWithFormat:@"%@",[YKLLocalUserDefInfo defModel].userName];
    [self.bgView addSubview:self.shopLabel];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-25-20, self.view.width, 25)];
    downView.backgroundColor = color;
    [self.bgView addSubview:downView];
    
    self.addressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addressIcon"]];
    self.addressImageView.frame = CGRectMake(15, 5, 15, 20);
    [downView addSubview:self.addressImageView];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addressImageView.right+5, 0, 240, 25)];
    self.addressLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.addressLabel.textColor = [UIColor whiteColor];
    //地址取市区
    NSArray *addressArray = [[YKLLocalUserDefInfo defModel].address componentsSeparatedByString:@","];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",addressArray[2],[YKLLocalUserDefInfo defModel].street];
    [downView addSubview:self.addressLabel];
    
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
