//
//  YKLPosterReleaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/18.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLPosterReleaseViewController.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"

#import "YKLPosterPreviewViewController.h"

@interface YKLPosterReleaseViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property int colorStatus;  //1.红 2.橙 3.黄 4.绿 5.青 6.蓝 7.紫
@property BOOL isShareColorBtn; //是否显示颜色按钮
@property (nonatomic,strong) UIButton *selectColorBtn;
@property (nonatomic,strong) UIButton *redBtn;
@property (nonatomic,strong) UIButton *orangeBtn;
@property (nonatomic,strong) UIButton *yellowBtn;
@property (nonatomic,strong) UIButton *greenBtn;
@property (nonatomic,strong) UIButton *lightGreenBtn;
@property (nonatomic,strong) UIButton *blueBtn;
@property (nonatomic,strong) UIButton *purpleBtn;

@property (nonatomic,strong) UILabel *addImageLabel;
@property (nonatomic,strong) UIButton *addImageBtn;
@property (nonatomic,strong) UIImageView *addImageView;
@property (strong, nonatomic) NSArray *imageIVs;

@property (nonatomic,strong) UIImageView *swearImageView;
@property (nonatomic,strong) UILabel *weLabel;
@property (nonatomic,strong) UITextField *weTextField;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *previewBtn;
@property (nonatomic,strong) UIButton *savaPicBtn;
@property (nonatomic,strong) UIButton *shareURLBtn;
@end

@implementation YKLPosterReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发誓体海报";
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
    [self createColorBtn];
    _isShareColorBtn = YES;
    _colorStatus = 1;//默认红色
    
    self.selectColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectColorBtn.frame = CGRectMake(10, 64+10, 45, 45);
    self.selectColorBtn.backgroundColor = [UIColor PosterRedColor];
    self.selectColorBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.selectColorBtn setTitle:@"点击选颜色" forState:UIControlStateNormal];
    [self.selectColorBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.selectColorBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.selectColorBtn.layer.cornerRadius = 45/2;
    self.selectColorBtn.layer.masksToBounds = YES;
    [self.selectColorBtn addTarget:self action:@selector(selectColorBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectColorBtn];
    
    self.addImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.selectColorBtn.bottom+8, 150, 30)];
    self.addImageLabel.centerX = self.view.width/2;
    self.addImageLabel.textAlignment = NSTextAlignmentCenter;
    self.addImageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.addImageLabel.textColor = [UIColor grayColor];
    self.addImageLabel.text = @"老板来卖个萌";
    [self.view addSubview:self.addImageLabel];
    
    [self reloadImage];
    [self createContent];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    if (ScreenHeight == 480) {
        
        self.selectColorBtn.frame = CGRectMake(10, 64+10, 45, 45);
        self.addImageLabel.frame = CGRectMake(0, self.selectColorBtn.bottom+8, 150, 30);
        self.addImageLabel.centerX = self.view.width/2;
        
        self.addImageView.frame = CGRectMake(0, self.addImageLabel.bottom+10, 100, 100);
        self.addImageView.centerX = self.view.width/2;
        self.addImageBtn.frame = CGRectMake(0, self.addImageLabel.bottom+10, 100, 100);
        self.addImageBtn.centerX = self.view.width/2;
       
        self.swearImageView.frame = CGRectMake(15, self.addImageBtn.bottom+38-10, 150, 60);
        self.weLabel.frame = CGRectMake(15, self.swearImageView.bottom+10, 60, 20);
        self.weTextField.frame = CGRectMake(self.weLabel.right, self.weLabel.top, 200, 20);
        self.lineView.frame = CGRectMake(self.weTextField.left, self.weTextField.bottom, self.weTextField.width, 1);
        
        self.previewBtn.frame = CGRectMake(20, self.lineView.bottom+50-20, 120, 40);
        self.savaPicBtn.frame = CGRectMake(self.view.width-120-20, self.previewBtn.top, self.previewBtn.width, self.previewBtn.height);
//        self.shareURLBtn.frame = CGRectMake(self.savaPicBtn.right+20, self.savaPicBtn.top, self.previewBtn.width, self.previewBtn.height);
    }
    
    [self performSelector:@selector(selectColorBtnClicked) withObject:nil afterDelay:0.5];

}


//加载图片和添加图片按钮
- (void)reloadImage{
    
    self.addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.addImageLabel.bottom+10, 150, 150)];
    self.addImageView.centerX = self.view.width/2;
    self.addImageView.backgroundColor = [UIColor flatWhiteColor];
//    [self.addImageView.layer setBorderWidth:5.0]; //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 94.0/255.0, 94.0/255.0, 94.0/255.0, 1 });
//    [self.addImageView.layer setBorderColor:colorref];
//    self.addImageView.layer.cornerRadius = 2;
//    self.addImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.addImageView];
    _imageIVs = @[self.addImageView];
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addImageBtn.backgroundColor = [UIColor clearColor];
    self.addImageBtn.frame = CGRectMake(0, self.addImageLabel.bottom+10, 150, 150);
    self.addImageBtn.centerX = self.view.width/2;
    [self.addImageBtn setImage:[UIImage imageNamed:@"相机icon"] forState:UIControlStateNormal];
    [self.addImageBtn addTarget:self action:@selector(addImageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addImageBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.addImageBtn.bottom, 150, 20)];
    label.centerX = self.view.width/2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"(建议使用拍照)";
    [self.view addSubview:label];
}

//加载内容发誓
- (void)createContent{
    
    self.swearImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我发誓"]];
    self.swearImageView.frame = CGRectMake(15, self.addImageBtn.bottom+38, 150, 60);
    [self.view addSubview:self.swearImageView];
    
    self.weLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.swearImageView.bottom+25, 60, 20)];
    self.weLabel.textAlignment = NSTextAlignmentCenter;
    self.weLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.weLabel.textColor = [UIColor PosterRedColor];
    self.weLabel.text = @"我们只";
    [self.view addSubview:self.weLabel];
    
    self.weTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.weLabel.right, self.weLabel.top, 200, 20)];
    self.weTextField.delegate = self;
    self.weTextField.keyboardType = UIKeyboardTypeDefault;
    self.weTextField.placeholder = @"    10个字以内";
    self.weTextField.font = [UIFont systemFontOfSize:14];
    self.weTextField.textColor = [UIColor PosterRedColor];
    [self.view addSubview:self.weTextField];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.weTextField.left, self.weTextField.bottom, self.weTextField.width, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.lineView];
    
    self.previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previewBtn.frame = CGRectMake(20, self.lineView.bottom+50, 120, 40);
    self.previewBtn.backgroundColor = [UIColor PosterRedColor];
    self.previewBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [self.previewBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.previewBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    [self.previewBtn addTarget:self action:@selector(previewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.previewBtn];
    
    self.savaPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.savaPicBtn.frame = CGRectMake(self.view.width-120-20, self.previewBtn.top, self.previewBtn.width, self.previewBtn.height);
    self.savaPicBtn.backgroundColor = [UIColor PosterRedColor];
    self.savaPicBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.savaPicBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [self.savaPicBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.savaPicBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    [self.savaPicBtn addTarget:self action:@selector(savaPicBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.savaPicBtn];
    
//    self.shareURLBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.shareURLBtn.frame = CGRectMake(self.savaPicBtn.right+20, self.savaPicBtn.top, self.previewBtn.width, self.previewBtn.height);
//    self.shareURLBtn.backgroundColor = [UIColor PosterRedColor];
//    self.shareURLBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    [self.shareURLBtn setTitle:@"分享链接" forState:UIControlStateNormal];
//    [self.shareURLBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [self.shareURLBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
//    [self.shareURLBtn addTarget:self action:@selector(shareURLBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.shareURLBtn];
    
}

int colorBtnSize = 20;//颜色按钮大小
int colorBtnSpace = 10;//颜色按钮间距
- (void)createColorBtn{
    
    self.redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.redBtn.backgroundColor = [UIColor PosterRedColor];
    self.redBtn.layer.cornerRadius = 20/2;
    self.redBtn.layer.masksToBounds = YES;
    [self.redBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.redBtn.tag = 5101;
    [self.view addSubview:self.redBtn];
    
    self.orangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.orangeBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.orangeBtn.backgroundColor = [UIColor PosterOrangeColor];
    self.orangeBtn.layer.cornerRadius = 20/2;
    self.orangeBtn.layer.masksToBounds = YES;
    [self.orangeBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.orangeBtn.tag = 5102;
    [self.view addSubview:self.orangeBtn];
    
    self.yellowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yellowBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.yellowBtn.backgroundColor = [UIColor PosterYellowColor];
    self.yellowBtn.layer.cornerRadius = 20/2;
    self.yellowBtn.layer.masksToBounds = YES;
    [self.yellowBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.yellowBtn.tag = 5103;
    [self.view addSubview:self.yellowBtn];
    
    self.greenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.greenBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.greenBtn.backgroundColor = [UIColor PosterGreenColor];
    self.greenBtn.layer.cornerRadius = 20/2;
    self.greenBtn.layer.masksToBounds = YES;
    [self.greenBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.greenBtn.tag = 5104;
    [self.view addSubview:self.greenBtn];
    
    self.lightGreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lightGreenBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.lightGreenBtn.backgroundColor = [UIColor PosterLightGreenColor];
    self.lightGreenBtn.layer.cornerRadius = 20/2;
    self.lightGreenBtn.layer.masksToBounds = YES;
    [self.lightGreenBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.lightGreenBtn.tag = 5105;
    [self.view addSubview:self.lightGreenBtn];
    
    self.blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blueBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.blueBtn.backgroundColor = [UIColor PosterBlueColor];
    self.blueBtn.layer.cornerRadius = 20/2;
    self.blueBtn.layer.masksToBounds = YES;
    [self.blueBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.blueBtn.tag = 5106;
    [self.view addSubview:self.blueBtn];
    
    self.purpleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.purpleBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    self.purpleBtn.backgroundColor = [UIColor PosterPurpleColor];
    self.purpleBtn.layer.cornerRadius = 20/2;
    self.purpleBtn.layer.masksToBounds = YES;
    [self.purpleBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.purpleBtn.tag = 5107;
    [self.view addSubview:self.purpleBtn];
}

//选择主题颜色以及小彩球动画效果
- (void)selectColorBtnClicked{
    
    if (_isShareColorBtn == YES) {
        
        //动画未完成不能点击
        self.selectColorBtn.enabled = NO;
        self.redBtn.enabled = NO;
        self.orangeBtn.enabled = NO;
        self.yellowBtn.enabled = NO;
        self.greenBtn.enabled = NO;
        self.lightGreenBtn.enabled = NO;
        self.blueBtn.enabled = NO;
        self.purpleBtn.enabled = NO;
        
        [UIView animateWithDuration:0.7 animations:^{
            self.redBtn.frame = CGRectMake(60+14, 64+25, colorBtnSize, colorBtnSize);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.redBtn.frame = CGRectMake(60+14-10, 64+25, colorBtnSize, colorBtnSize);
                
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.redBtn.frame = CGRectMake(60+14, 64+25, colorBtnSize, colorBtnSize);
                    
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        self.redBtn.frame = CGRectMake(60+14-10, 64+25, colorBtnSize, colorBtnSize);
                        
                    }completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            self.redBtn.frame = CGRectMake(60+14, 64+25, colorBtnSize, colorBtnSize);
                            
                            //开启按钮点击
                            self.selectColorBtn.enabled = YES;
                            self.redBtn.enabled = YES;
                            self.orangeBtn.enabled = YES;
                            self.yellowBtn.enabled = YES;
                            self.greenBtn.enabled = YES;
                            self.lightGreenBtn.enabled = YES;
                            self.blueBtn.enabled = YES;
                            self.purpleBtn.enabled = YES;
                            
                            _isShareColorBtn = NO;
                            
                        }];
                    }];
                }];
            }];
        }];
        
        [self createAnimal:self.orangeBtn Space:1 Time:0.6];
        [self createAnimal:self.yellowBtn Space:2 Time:0.5];
        [self createAnimal:self.greenBtn Space:3 Time:0.4];
        [self createAnimal:self.lightGreenBtn Space:4 Time:0.3];
        [self createAnimal:self.blueBtn Space:5 Time:0.2];
        [self createAnimal:self.purpleBtn Space:6 Time:0.1];
        
        
    }
    else{
        self.redBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
        self.orangeBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
        self.yellowBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
        self.greenBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
        self.lightGreenBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
        self.blueBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
        self.purpleBtn.frame = CGRectMake(25, 64+25, colorBtnSize, colorBtnSize);
    
        _isShareColorBtn = YES;
    }


}

//动画方法
- (void)createAnimal:(UIButton *)btn
               Space:(int)space
                Time:(float)time
{
    
    
    [UIView animateWithDuration:time animations:^{
        btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25, colorBtnSize, colorBtnSize);
    
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space-10, 64+25, colorBtnSize, colorBtnSize);
            
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25, colorBtnSize, colorBtnSize);
                
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space-5, 64+25, colorBtnSize, colorBtnSize);
                    
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25, colorBtnSize, colorBtnSize);
                        
                    }];
                }];
            }];
        }];
    }];
}

//上下动画效果
- (void)createUpAnimal:(UIButton *)btn
                 Space:(int)space
                  Time:(float)time
{
    
    
    [UIView animateWithDuration:time animations:^{
        btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25-15, colorBtnSize, colorBtnSize);
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time animations:^{
            btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25, colorBtnSize, colorBtnSize);
            
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:time/2 animations:^{
                btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25-10, colorBtnSize, colorBtnSize);
                
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:time/2 animations:^{
                    btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25, colorBtnSize, colorBtnSize);
                    
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:time/4 animations:^{
                        btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25-5, colorBtnSize, colorBtnSize);
                        
                    }completion:^(BOOL finished) {
                        [UIView animateWithDuration:time/4 animations:^{
                            btn.frame = CGRectMake(60+14+colorBtnSize*space+colorBtnSpace*space, 64+25, colorBtnSize, colorBtnSize);
                            
                        }];
                    }];
                }];
            }];
        }];
    }];
    
}


//小彩球点击事件
- (void)changeColor:(UIButton*)sender{
//    _isShareColorBtn = YES;
//    [self selectColorBtnClicked];
    
    switch (sender.tag) {
        case 5101:
            [self createUpAnimal:self.redBtn Space:0 Time:0.2];//上下动画效果
            _colorStatus = 1;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓"];
            self.selectColorBtn.backgroundColor = [UIColor PosterRedColor];
            self.weLabel.textColor = [UIColor PosterRedColor];
            self.weTextField.textColor = [UIColor PosterRedColor];
            self.previewBtn.backgroundColor = [UIColor PosterRedColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterRedColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterRedColor];
            break;
        case 5102:
            [self createUpAnimal:self.orangeBtn Space:1 Time:0.2];
            _colorStatus = 2;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓-橙"];
            self.selectColorBtn.backgroundColor = [UIColor PosterOrangeColor];
            self.weLabel.textColor = [UIColor PosterOrangeColor];
            self.weTextField.textColor = [UIColor PosterOrangeColor];
            self.previewBtn.backgroundColor = [UIColor PosterOrangeColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterOrangeColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterOrangeColor];
            break;
        case 5103:
            [self createUpAnimal:self.yellowBtn Space:2 Time:0.2];
            _colorStatus = 3;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓-黄"];
            self.selectColorBtn.backgroundColor = [UIColor PosterYellowColor];
            self.weLabel.textColor = [UIColor PosterYellowColor];
            self.weTextField.textColor = [UIColor PosterYellowColor];
            self.previewBtn.backgroundColor = [UIColor PosterYellowColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterYellowColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterYellowColor];
            break;
        case 5104:
            [self createUpAnimal:self.greenBtn Space:3 Time:0.2];
            _colorStatus = 4;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓-绿"];
            self.selectColorBtn.backgroundColor = [UIColor PosterGreenColor];
            self.weLabel.textColor = [UIColor PosterGreenColor];
            self.weTextField.textColor = [UIColor PosterGreenColor];
            self.previewBtn.backgroundColor = [UIColor PosterGreenColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterGreenColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterGreenColor];
            break;
        case 5105:
            [self createUpAnimal:self.lightGreenBtn Space:4 Time:0.2];
            _colorStatus = 5;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓-青"];
            self.selectColorBtn.backgroundColor = [UIColor PosterLightGreenColor];
            self.weLabel.textColor = [UIColor PosterLightGreenColor];
            self.weTextField.textColor = [UIColor PosterLightGreenColor];
            self.previewBtn.backgroundColor = [UIColor PosterLightGreenColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterLightGreenColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterLightGreenColor];
            break;
        case 5106:
            [self createUpAnimal:self.blueBtn Space:5 Time:0.2];
            _colorStatus = 6;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓-蓝"];
            self.selectColorBtn.backgroundColor = [UIColor PosterBlueColor];
            self.weLabel.textColor = [UIColor PosterBlueColor];
            self.weTextField.textColor = [UIColor PosterBlueColor];
            self.previewBtn.backgroundColor = [UIColor PosterBlueColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterBlueColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterBlueColor];
            break;
        case 5107:
            [self createUpAnimal:self.purpleBtn Space:6 Time:0.2];
            _colorStatus = 7;
            self.swearImageView.image = [UIImage imageNamed:@"我发誓-紫"];
            self.selectColorBtn.backgroundColor = [UIColor PosterPurpleColor];
            self.weLabel.textColor = [UIColor PosterPurpleColor];
            self.weTextField.textColor = [UIColor PosterPurpleColor];
            self.previewBtn.backgroundColor = [UIColor PosterPurpleColor];
            self.savaPicBtn.backgroundColor = [UIColor PosterPurpleColor];
            self.shareURLBtn.backgroundColor = [UIColor PosterPurpleColor];
            break;
            
        default:
            break;
    }
    
//    //收起弹出小彩球
//    [self selectColorBtnClicked];
    
}

//添加照片
- (void)addImageBtnClicked{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
}

//预览
- (void)previewBtnClicked{
    
    if ([self.weTextField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请填写海报内容"];
        [self.weTextField becomeFirstResponder];
        return;
    }
    
    if (self.addImageView.image == nil) {
        [UIAlertView showInfoMsg:@"请选择海报照片"];
        return;
    }
    
    YKLPosterPreviewViewController *postPreview = [YKLPosterPreviewViewController new];
    
    [postPreview createBgView];
    postPreview.bgImageView.image = self.addImageView.image;
    postPreview.swearImageView.image = self.swearImageView.image;
    
    //传递已选颜色状态
    postPreview.colorStatus = _colorStatus;
    postPreview.weString = self.weTextField.text;
    [postPreview createContent];
    
    
    [self presentViewController:postPreview animated:YES completion:^{
        
        
    }];
}

//保存图片
- (void)savaPicBtnClicked{
    
    if ([self.weTextField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请填写海报内容"];
        [self.weTextField becomeFirstResponder];
        return;
    }
    
    if (self.addImageView.image == nil) {
        [UIAlertView showInfoMsg:@"请选择海报照片"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定保存预览图片到相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        YKLPosterPreviewViewController *postPreview = [YKLPosterPreviewViewController new];
        
        [postPreview createBgView];
        postPreview.bgImageView.image = self.addImageView.image;
        postPreview.swearImageView.image = self.swearImageView.image;
        
        //传递已选颜色状态
        postPreview.colorStatus = _colorStatus;
        postPreview.weString = self.weTextField.text;
        [postPreview createContent];
        
        
        UIGraphicsBeginImageContextWithOptions(postPreview.bgView.frame.size, NO, 0.0);
        [postPreview.bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        
        [UIAlertView showInfoMsg:@"已成功保存到本地相册"];
        
    }
}


//分享链接
- (void)shareURLBtnClicked{
    
}


#pragma mark - 选择照片

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1) {
        
        for (UIImageView *iv in _imageIVs)
            iv.image = nil;
    
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
        
    }
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self reloadImage];
    
    //视觉上隐藏添加照片按钮
    [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    //显示照片边框
    [self.addImageView.layer setBorderWidth:5.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 94.0/255.0, 94.0/255.0, 94.0/255.0, 1 });
    [self.addImageView.layer setBorderColor:colorref];
    
    [self.addImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self reloadImage];
    
    //视觉上隐藏添加照片按钮
    [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    //显示照片边框
    [self.addImageView.layer setBorderWidth:5.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 94.0/255.0, 94.0/255.0, 94.0/255.0, 1 });
    [self.addImageView.layer setBorderColor:colorref];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(1, aSelected.count); i++)
        {
            UIImageView *iv = _imageIVs[i];
            iv.image = aSelected[i];
        }
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        for (int i = 0; i < MIN(1, aSelected.count); i++)
        {
            UIImageView *iv = _imageIVs[i];
            iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
        }
        
        [ASSETHELPER clearData];
    }

}


#pragma mark - keyboard

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-212,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.weTextField resignFirstResponder];
    
    
    [self resumeView];
}

//UITextField的协议方法，当开始编辑时监听
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.weTextField) {
        if (string.length == 0){
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.weTextField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

@end
