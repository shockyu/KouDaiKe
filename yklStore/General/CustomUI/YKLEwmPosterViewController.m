//
//  YKLEwmPosterViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/21.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLEwmPosterViewController.h"

NSString *BargainColor = @"e60111";
NSString *HigoColor = @"e75260";
NSString *MiaoShaColor = @"febbbd";

@interface YKLEwmPosterViewController ()

@end

@implementation YKLEwmPosterViewController

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
    
    self.bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ewmBg"]];
    //    self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bgImageView.backgroundColor = [UIColor flatLightBlueColor];
    //    self.bgImageView.contentMode = UIViewContentModeCenter;
    self.bgImageView.frame = CGRectMake(0, 0, self.bgView.width, self.bgView.height);
    [self.bgView addSubview:self.bgImageView];
    
    self.tempImageView = [[UIImageView alloc]init];
    self.tempImageView.backgroundColor = [UIColor colorWithHexString:@"e60111"];
    self.tempImageView.frame = CGRectMake(17, self.bgView.height-90-17, 140, 95);
    //将图层的边框设置为圆脚
    self.tempImageView.layer.cornerRadius = 5;
    self.tempImageView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    self.tempImageView.layer.borderWidth = 5;
    self.tempImageView.layer.borderColor = [[UIColor colorWithHexString:@"e60111"] CGColor];
    [self.bgView addSubview:self.tempImageView];
    
    self.tempImage = [[UIImageView alloc]init];
    self.tempImage.backgroundColor = [UIColor flatLightYellowColor];
    self.tempImage.frame = CGRectMake(5, 5, 130, 85);
    self.tempImage.layer.cornerRadius = 5;
    self.tempImage.layer.masksToBounds = YES;
    [self.tempImageView addSubview:self.tempImage];
    
    
    self.robLabelImageView = [[UIImageView alloc]init];
    self.robLabelImageView.backgroundColor = [UIColor colorWithHexString:@"e60111"];
    self.robLabelImageView.frame = CGRectMake(self.tempImageView.right, self.tempImageView.top, 50, 95);
    self.robLabelImageView.layer.cornerRadius = 5;
    self.robLabelImageView.layer.masksToBounds = YES;
    self.robLabelImageView.layer.borderWidth = 5;
    self.robLabelImageView.layer.borderColor = [[UIColor colorWithHexString:@"e60111"] CGColor];
    [self.bgView addSubview:self.robLabelImageView];
    
    self.robImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"抢"]];
    self.robImageView.frame = CGRectMake(5, 0, 40, 40);
    self.robImageView.centerY = self.robLabelImageView.height/2;
    [self.robLabelImageView addSubview:self.robImageView];
    
    self.goodsImageView = [[UIImageView alloc]init];
    self.goodsImageView.backgroundColor = [UIColor colorWithHexString:@"e60111"];
    self.goodsImageView.frame = CGRectMake(self.robLabelImageView.right, self.tempImageView.top, 95, 95);
    self.goodsImageView.layer.cornerRadius = 5;
    self.goodsImageView.layer.masksToBounds = YES;
    self.goodsImageView.layer.borderWidth = 5;
    self.goodsImageView.layer.borderColor = [[UIColor colorWithHexString:@"e60111"] CGColor];
    [self.bgView addSubview:self.goodsImageView];
    
    self.goodsImage = [[UIImageView alloc]init];
    self.goodsImage.backgroundColor = [UIColor flatLightYellowColor];
    self.goodsImage.frame = CGRectMake(5, 5, 85, 85);
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    [self.goodsImageView addSubview:self.goodsImage];
    

    self.ewmImageView = [[UIImageView alloc]init];
    self.ewmImageView.backgroundColor = [UIColor whiteColor];
    self.ewmImageView.frame = CGRectMake(0, 0, 75, 75);
    self.ewmImageView.right = self.goodsImageView.right;
    self.ewmImageView.bottom = self.goodsImageView.top-5;
    [self.bgView addSubview:self.ewmImageView];
    
    self.LabelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ewmLabel"]];
    self.LabelImageView.backgroundColor = [UIColor clearColor];
    self.LabelImageView.frame = CGRectMake(0, 0, 160, 15);
    self.LabelImageView.right = self.ewmImageView.left-10;
    self.LabelImageView.bottom = self.ewmImageView.bottom;
    [self.bgView addSubview:self.LabelImageView];
    
    
    switch (self.type) {
        case 1:
            self.bgImageView.image = [UIImage imageNamed:@"ewmBg"];
            self.LabelImageView.image = [UIImage imageNamed:@"ewmLabel"];
            self.robImageView.image = [UIImage imageNamed:@"抢"];
            self.robLabelImageView.backgroundColor = [UIColor colorWithHexString:BargainColor];
            self.robLabelImageView.layer.borderColor = [[UIColor colorWithHexString:BargainColor] CGColor];
            self.tempImageView.backgroundColor = [UIColor colorWithHexString:BargainColor];
            self.tempImageView.layer.borderColor = [[UIColor colorWithHexString:BargainColor] CGColor];
            self.goodsImageView.backgroundColor = [UIColor colorWithHexString:BargainColor];
            self.goodsImageView.layer.borderColor = [[UIColor colorWithHexString:BargainColor] CGColor];
            
            break;
        case 2:
            
            self.bgImageView.image = [UIImage imageNamed:@"Higo_ewmBg"];
            self.LabelImageView.image = [UIImage imageNamed:@"Higo_ewmLabel"];
            self.robImageView.image = [UIImage imageNamed:@"Higo_抢"];
            self.robLabelImageView.backgroundColor = [UIColor colorWithHexString:HigoColor];
            self.robLabelImageView.layer.borderColor = [[UIColor colorWithHexString:HigoColor] CGColor];
            self.tempImageView.backgroundColor = [UIColor colorWithHexString:HigoColor];
            self.tempImageView.layer.borderColor = [[UIColor colorWithHexString:HigoColor] CGColor];
            self.goodsImageView.backgroundColor = [UIColor colorWithHexString:HigoColor];
            self.goodsImageView.layer.borderColor = [[UIColor colorWithHexString:HigoColor] CGColor];
            
            break;
        case 3:
            
            self.bgImageView.image = [UIImage imageNamed:@"miaoShaBg"];
            self.LabelImageView.image = [UIImage imageNamed:@"miaoSha_ewmLabel"];
            self.robImageView.image = [UIImage imageNamed:@"miaoSha"];
            self.robLabelImageView.backgroundColor = [UIColor colorWithHexString:MiaoShaColor];
            self.robLabelImageView.layer.borderColor = [[UIColor colorWithHexString:MiaoShaColor] CGColor];
            self.tempImageView.backgroundColor = [UIColor colorWithHexString:MiaoShaColor];
            self.tempImageView.layer.borderColor = [[UIColor colorWithHexString:MiaoShaColor] CGColor];
            self.goodsImageView.backgroundColor = [UIColor colorWithHexString:MiaoShaColor];
            self.goodsImageView.layer.borderColor = [[UIColor colorWithHexString:MiaoShaColor] CGColor];
            
            break;
        case 4:
            
            self.bgImageView.image = [UIImage imageNamed:@"suDingBg"];
            self.LabelImageView.image = [UIImage imageNamed:@"miaoSha_ewmLabel"];
            self.robImageView.image = [UIImage imageNamed:@"suDing"];
            self.robLabelImageView.backgroundColor = [UIColor colorWithHexString:MiaoShaColor];
            self.robLabelImageView.layer.borderColor = [[UIColor colorWithHexString:MiaoShaColor] CGColor];
            self.tempImageView.backgroundColor = [UIColor colorWithHexString:MiaoShaColor];
            self.tempImageView.layer.borderColor = [[UIColor colorWithHexString:MiaoShaColor] CGColor];
            self.goodsImageView.backgroundColor = [UIColor colorWithHexString:MiaoShaColor];
            self.goodsImageView.layer.borderColor = [[UIColor colorWithHexString:MiaoShaColor] CGColor];
            
            break;
        default:
            break;
    }

    
}

- (UIImage *)drawRect:(UIImage *)iamge
{
    
    [iamge drawAtPoint:CGPointMake(100, 100)];
    return iamge;
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
