//
//  YKLSetChildUserViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/16.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLSetChildUserViewController.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"
#import "AssetHelper.h"

@interface YKLSetChildUserViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ImageCropViewControllerDelegate>
{
    NSTimer *_timer;
    
    UIImage *myImage;
    
}

@end

@implementation YKLSetChildUserViewController
bool ishidBtn = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"授权信息";
    
    //选择器初始化
    [self getPickerData];
    [self initView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];

    
    [self creatRegistView];
    [self reloadQRCodeImageView];
    
    //子账号userID默认为空
    self.childUserID = @"";

    
    if (![_childInfoDict isEqual:@[]]) {
        
        self.childUserID = [_childInfoDict objectForKey:@"id"];
        self.mobileField.text = [_childInfoDict objectForKey:@"mobile"];
        self.storeNameField.text = [_childInfoDict objectForKey:@"shop_name"];
        self.streetAddressField.text = [_childInfoDict objectForKey:@"street"];
        
        self.teleField.text = [_childInfoDict objectForKey:@"service_tel"];
        self.contactsField.text = [_childInfoDict objectForKey:@"lianxiren"];
        
        [self.addQRCodeImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        if (![[_childInfoDict objectForKey:@"qr_code"] isEqual:@""]) {
            [self.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:[_childInfoDict objectForKey:@"qr_code"]] placeholderImage:[UIImage imageNamed:@"Demo"]];
        }else{
            [self.addQRCodeImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        }
    
        NSArray *addressArray = [[_childInfoDict objectForKey:@"address"] componentsSeparatedByString:@","];
//        self.locationBtn.hidden = YES;
        self.provinceBtn.hidden = self.cityBtn.hidden = self.townBtn.hidden = NO;
//        self.provinceBtn.enabled = self.cityBtn.enabled = self.townBtn.enabled = NO;
        [self.provinceBtn setTitle:addressArray[0] forState:UIControlStateNormal];
        
        if (addressArray.count>1) {
            [self.cityBtn setTitle:addressArray[1] forState:UIControlStateNormal];
        }else{
//            self.cityBtn.hidden = YES;
//            self.townBtn.hidden = YES;
        }
        if (addressArray.count>2) {
            [self.townBtn setTitle:addressArray[2] forState:UIControlStateNormal];
        }else{
//            self.townBtn.hidden = YES;
        }

    }
}

#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = ScreenWidth;
    
    self.pickerBgView = [[UIView alloc]initWithFrame: CGRectMake(0, 100, ScreenWidth, 266)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [yesBtn setBackgroundColor: [UIColor clearColor]];
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [yesBtn addTarget:self action:@selector(ensure:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:yesBtn];
    
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.pickerBgView.width-50, 0, 50, 30)];
    [noBtn setBackgroundColor: [UIColor clearColor]];
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [noBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:noBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"地址滚轮"]];
    imageView.frame = CGRectMake(0, 50, ScreenWidth, 216);
    [self.pickerBgView addSubview:imageView];
    
    self.myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 216)];
    // 显示选中框
    self.myPicker.showsSelectionIndicator=YES;
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    [self.pickerBgView addSubview:self.myPicker];
    
    
}

#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}


- (void)creatRegistView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 510);
    [self.view addSubview:self.scrollView];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, self.view.height-64-10*3+40)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView];
    
    self.bgView.height = 40.0*10+25;
    _bgHeight = 40;
    
    for (int i = 0; i < 11; i++) {
        if (i != 0 && i != 9 ) {
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _bgHeight*i, self.view.width-2*10, 1)];
            self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
            [self.bgView addSubview:self.lineView];
        }
    }
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, _bgHeight)];
    //    self.loginTitle.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"登陆账号：";
    [self.bgView addSubview:self.titleLabel];
    
    self.loginNum = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, _bgHeight)];
    self.loginNum.backgroundColor = [UIColor clearColor];
    self.loginNum.font = [UIFont systemFontOfSize:14];
    self.loginNum.text = [YKLLocalUserDefInfo defModel].mobile;
    self.loginNum.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.loginNum];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"店铺名称：";
    [self.bgView addSubview:self.titleLabel];
    
    self.storeNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight, self.view.width-110, _bgHeight)];
    self.storeNameField.keyboardType = UIKeyboardTypeDefault;
    self.storeNameField.backgroundColor = [UIColor clearColor];
    //    self.storeNameField.delegate = self;
    self.storeNameField.font = [UIFont systemFontOfSize:14];
    self.storeNameField.returnKeyType = UIReturnKeyNext;
    //    self.storeNameField.placeholder = @"店铺名称";
    [self.bgView addSubview:self.storeNameField];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*2, 90, _bgHeight)];
    //    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"地址：";
    [self.bgView addSubview:self.titleLabel];
    
    self.provinceBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, _bgHeight*2, (self.view.width-110)/3, _bgHeight)];
    self.provinceBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.provinceBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    //    [self.provinceBtn setBackgroundColor: [UIColor flatPinkColor]];
    [self.provinceBtn setTitle:@"省" forState:UIControlStateNormal];
    self.provinceBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.provinceBtn.hidden = YES;
    [self.provinceBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.provinceBtn];
    
    self.cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(100+(self.view.width-110)/3, _bgHeight*2, (self.view.width-2*10)/3, _bgHeight)];
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.cityBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    //    [self.cityBtn setBackgroundColor: [UIColor flatPinkColor]];
    [self.cityBtn setTitle:@"市" forState:UIControlStateNormal];
    self.cityBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.cityBtn.hidden = YES;
    [self.cityBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.cityBtn];
    
    self.townBtn = [[UIButton alloc] initWithFrame:CGRectMake(100+(self.view.width-110)/3*2, _bgHeight*2, (self.view.width-2*10)/3, _bgHeight)];
    self.townBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.townBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    //    [self.townBtn setBackgroundColor: [UIColor flatPinkColor]];
    [self.townBtn setTitle:@"区" forState:UIControlStateNormal];
    self.townBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.townBtn.hidden = YES;
    [self.townBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.townBtn];
    
    self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, _bgHeight*2, self.view.width-2*10, _bgHeight)];
    self.locationBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    //    [self.locationBtn setBackgroundColor: [UIColor flatPinkColor]];
    //    [self.locationBtn setTitle:@"地址" forState:UIControlStateNormal];
    [self.locationBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    self.locationBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.locationBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn.hidden = NO;
    [self.bgView addSubview:self.locationBtn];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*3, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"街道地址：";
    [self.bgView addSubview:self.titleLabel];
    
    self.streetAddressField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*3, self.view.width-110, _bgHeight)];
    self.streetAddressField.keyboardType = UIKeyboardTypeDefault;
    self.streetAddressField.backgroundColor = [UIColor clearColor];
    //    self.streetAddressField.delegate = self;
    self.streetAddressField.font = [UIFont systemFontOfSize:14];
    self.streetAddressField.returnKeyType = UIReturnKeyNext;
    //    self.streetAddressField.placeholder = @"街道地址";
    [self.bgView addSubview:self.streetAddressField];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*4, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"服务热线：";
    [self.bgView addSubview:self.titleLabel];
    
    self.teleField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*4, self.view.width-200, _bgHeight)];
    self.teleField.keyboardType = UIKeyboardTypePhonePad;
    self.teleField.backgroundColor = [UIColor clearColor];
    //    self.teleField.delegate = self;
    self.teleField.font = [UIFont systemFontOfSize:14];
    self.teleField.returnKeyType = UIReturnKeyNext;
    //    self.teleField.placeholder = @"服务热线";
    [self.bgView addSubview:self.teleField];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.teleField.right, _bgHeight*4, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"（可修改）";
    [self.bgView addSubview:self.titleLabel];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*5, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"联系人：";
    [self.bgView addSubview:self.titleLabel];
    
    self.contactsField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*5, self.view.width-200, _bgHeight)];
    self.contactsField.keyboardType = UIKeyboardTypeDefault;
    self.contactsField.backgroundColor = [UIColor clearColor];
    //    self.contactsField.delegate = self;
    self.contactsField.font = [UIFont systemFontOfSize:14];
    self.contactsField.returnKeyType = UIReturnKeyNext;
    //    self.contactsField.placeholder = @"联系人";
    [self.bgView addSubview:self.contactsField];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contactsField.right, _bgHeight*5, 90, _bgHeight)];
    //    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"（可修改）";
    [self.bgView addSubview:self.titleLabel];
    
    self.idLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bgHeight*6, 90, _bgHeight)];
    self.idLabel.backgroundColor = [UIColor clearColor];
    self.idLabel.font = [UIFont systemFontOfSize:14];
    self.idLabel.textColor = [UIColor blackColor];
    self.idLabel.text = @"授权手机号码:";
    [self.bgView addSubview:self.idLabel];
    
    self.mobileField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*6, self.view.width-200, _bgHeight)];
    self.mobileField.keyboardType = UIKeyboardTypeDefault;
    self.mobileField.backgroundColor = [UIColor clearColor];
    self.mobileField.font = [UIFont systemFontOfSize:14];
    self.mobileField.returnKeyType = UIReturnKeyNext;
    [self.bgView addSubview:self.mobileField];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.mobileField.right, _bgHeight*6, 90, _bgHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"（可修改）";
    [self.bgView addSubview:self.titleLabel];

    self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bgHeight*7, 90, _bgHeight)];
    self.businessLabel.backgroundColor = [UIColor clearColor];
    self.businessLabel.font = [UIFont systemFontOfSize:14];
    self.businessLabel.textColor = [UIColor blackColor];
    self.businessLabel.text = @"验证码:";
    [self.bgView addSubview:self.businessLabel];
    
    self.vcodeField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*7, self.view.width-200, _bgHeight)];
    self.vcodeField.keyboardType = UIKeyboardTypeDefault;
    self.vcodeField.backgroundColor = [UIColor clearColor];
    self.vcodeField.font = [UIFont systemFontOfSize:14];
    self.vcodeField.returnKeyType = UIReturnKeyNext;
    [self.bgView addSubview:self.vcodeField];
    
    self.vcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.vcodeField.right, _bgHeight*7+5, 70, _bgHeight-10)];
    self.vcodeBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.vcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.vcodeBtn addTarget:self action:@selector(vcodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.vcodeBtn setBackgroundColor: [UIColor flatLightBlueColor]];
    [self.vcodeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.vcodeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateHighlighted];
    //    [self.vcodeBtn.layer setBorderWidth:1.0]; //边框宽度
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    //    [self.vcodeBtn.layer setBorderColor:colorref];
    self.vcodeBtn.layer.cornerRadius = 5;
    self.vcodeBtn.layer.masksToBounds = YES;
    [self.bgView addSubview:self.vcodeBtn];
    
    self.QRCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bgHeight*8.5, self.view.width-2*10, _bgHeight)];
    self.QRCodeLabel.backgroundColor = [UIColor clearColor];
    self.QRCodeLabel.font = [UIFont systemFontOfSize:14];
    self.QRCodeLabel.textColor = [UIColor blackColor];
    self.QRCodeLabel.text = @"二维码";
    [self.bgView addSubview:self.QRCodeLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, _bgHeight*8.5, 90, _bgHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"（可修改）";
    [self.bgView addSubview:self.titleLabel];

    
    self.registBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.bgView.bottom, self.view.width - 2*10, 45)];
    self.registBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [self.registBtn setBackgroundColor: [UIColor flatLightRedColor]];
    [self.registBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.registBtn addTarget:self action:@selector(registClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.registBtn.layer.cornerRadius = 5;
    self.registBtn.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.registBtn];
    
}

- (void)vcodeBtnClicked:(id)sender {
    NSLog(@"-------获取验证码------");
    [self hidenKeyboard];
    
    if ([self.loginNum.text isBlankString]) {
        [UIAlertView showErrorMsg:@"请输入手机号码"];

        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer getRegistVCodeWithMobile:self.loginNum.text success:^(NSString *verificationCode) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"验证号已发送到指定手机，请耐心等待。"];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [self timeFireMethod];
        //
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showErrorMsg:error.domain.length>0 ? error.domain : @"获取验证码失败，请再试一次"];
    }];
}

int childMiaoS = 60;
-(void)timeFireMethod{
    
    childMiaoS--;
    
    NSString *str = [NSString stringWithFormat:@"(%ds)后获取",childMiaoS];
    [self.vcodeBtn setTitle:str forState:UIControlStateNormal];
    self.vcodeBtn.userInteractionEnabled=NO;
    
    if (childMiaoS == 0) {
        
        [_timer invalidate];
        
        [self.vcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.vcodeBtn.userInteractionEnabled=YES;
        childMiaoS = 60;
    }
    
}

- (void)registClicked:(id)sender {
    NSLog(@"------注册按钮------");
    [self hidenKeyboard];
    
    if ([self.storeNameField.text isBlankString]||[[NSString stringWithFormat:@"%@,%@,%@",self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.townBtn.titleLabel.text] isBlankString]||[self.streetAddressField.text isBlankString]||[self.streetAddressField.text isBlankString]||[self.teleField.text isBlankString]||[self.contactsField.text isBlankString]||[self.vcodeField.text isBlankString]){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"请输入完整信息"];
        
        return;
    }
 
    [self qiniuUpload];
    
}


//拨打电话方法
- (void)phoneButtonClicked{
    [self hidenKeyboard];
    

}

- (void)reloadQRCodeImageView{
    
    self.QRCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*8+5, _bgHeight*2-10, _bgHeight*2-10)];
    self.QRCodeImageView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.QRCodeImageView];
    
    self.addQRCodeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addQRCodeImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addQRCodeImageBtn sizeToFit];
    self.addQRCodeImageBtn.frame = CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*8+5, _bgHeight*2-10, _bgHeight*2-10);
    [self.addQRCodeImageBtn addTarget:self action:@selector(addQRCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addQRCodeImageBtn setHidden:ishidBtn];
    [self.bgView addSubview:self.addQRCodeImageBtn];
    
    _QRCodeIVs = @[self.QRCodeImageView];
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
    CGRect rect=CGRectMake(0.0f,-210,width,height);
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
    [self.mobileField resignFirstResponder];
    [self.vcodeField resignFirstResponder];
    
    [self.storeNameField resignFirstResponder];
    [self.locationBtn resignFirstResponder];
    [self.streetAddressField resignFirstResponder];
    [self.teleField resignFirstResponder];
    [self.contactsField resignFirstResponder];
    
    [self resumeView];
}

- (void)addIDButtonClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];

}

- (void)addBusButtonClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];

}

- (void)addQRCodeButtonClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];
    ishidBtn = YES;
//    photoNub = 3;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];

    }
    else if (buttonIndex == 1){
        
        for (UIImageView *iv in _QRCodeIVs)
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
    
    ishidBtn = YES;
    [self reloadQRCodeImageView];
    [self.QRCodeImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(1, aSelected.count); i++)
        {
            //                UIImageView *iv = _QRCodeIVs[i];
            //                iv.image = aSelected[i];
            
            myImage = aSelected[i];
        }
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        for (int i = 0; i < MIN(1, aSelected.count); i++)
        {
            //                UIImageView *iv = _QRCodeIVs[i];
            //                iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
            
            myImage = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
        }
        
        [ASSETHELPER clearData];
    }
    
    //跳转裁剪页面
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:myImage];
    controller.delegate = self;
    controller.blurredBackground = YES;
    controller.type = 1;
    // set the cropped area
    // controller.cropArea = CGRectMake(0, 0, 100, 200);
    [[self navigationController] pushViewController:controller animated:NO];
    
}

#pragma mark - 裁剪功能协议

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    
    ishidBtn = YES;
    
    [self reloadQRCodeImageView];
    
    UIImageView *iv = _QRCodeIVs[0];
    iv.image = croppedImage;
    
    //    [_addImageBtn setImage:croppedImage forState:UIControlStateNormal];
    
    //    CGRect cropArea = controller.cropArea;
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    
    ishidBtn = NO;
    
    [self reloadQRCodeImageView];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

#pragma mark - private method
- (void)showMyPicker:(id)sender {
    [self hidenKeyboard];
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (void)cancel:(id)sender {
    [self hideMyPicker];
}

- (void)ensure:(id)sender {
    self.locationBtn.hidden = YES;
    self.provinceBtn.hidden = self.cityBtn.hidden = self.townBtn.hidden = NO;
    
    [self.provinceBtn setTitle:[self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]] forState:UIControlStateNormal];
    [self.cityBtn setTitle:[self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]] forState:UIControlStateNormal];
    
    if (self.townArray.count) {
        
        [self.townBtn setTitle:[self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]] forState:UIControlStateNormal];
    }else{
        [self.townBtn setTitle:@"" forState:UIControlStateNormal];
        self.townBtn.titleLabel.text = @"";
    }
    [self hideMyPicker];
}


#pragma mark - Helpers &七牛
- (void)qiniuUpload{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"图片上传中请稍等";
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSString *token = @"5_06q8nFxevqEx7XeBFn5VBRtwVySPeQg2UCDo0R:cCvb_Qn5ayw5ulB7dVbpS-HSCvM=:eyJzY29wZSI6InlrbC1tZWlwYS1uZXQiLCJkZWFkbGluZSI6MzA0Mjc2NzQxMn0=";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
    
    // ------------------- Test putData -------------------------
    
    NSData *dataQrCode = [self.QRCodeImageView.image resizedAndReturnData];
    
    
    [upManager putData:dataQrCode
                   key:fileName
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  self.QRCodeImageURL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                  
                  
                  NSLog(@"QR:%@",self.QRCodeImageURL);
                  
                  
                  [YKLNetworkingConsumer registWithMobile:self.mobileField.text
                                                   UserID:self.childUserID
                                                 ShopName:self.storeNameField.text
                                                  Address:[NSString stringWithFormat:@"%@,%@,%@",self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.townBtn.titleLabel.text]
                                                   Street:self.streetAddressField.text
                                               ServiceTel:self.teleField.text
                                                Lianxiren:self.contactsField.text
                                             IdentityCard:@""
                                                  License:@""
                                                AgentCode:@""
                                               AlipayName:@""
                                            AlipayAccount:@""
                                                   QRcode:self.QRCodeImageURL
                                                    Vcode:self.vcodeField.text
                                                      Pid:[YKLLocalUserDefInfo defModel].userID
                                                  success:^(NSString *success) {
                                                      
                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                      
                                                      if ([self.childUserID isEqual:@""])
                                                      {
                                                          [UIAlertView showInfoMsg:@"添加成功"];
                                                      }
                                                      else
                                                      {
                                                          [UIAlertView showInfoMsg:@"修改成功"];
                                                      }
                                                      
                                                      
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                      
                                                  } failure:^(NSError *error) {
                                                      
                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                      [UIAlertView showErrorMsg:error.domain.length>0 ? error.domain : @"添加失败"];
                                                      
                                                  }];
                  
                  
              }
                option:nil];
}

- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

@end
