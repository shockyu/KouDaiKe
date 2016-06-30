//
//  YKLLoginViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLLoginViewController.h"
#import "AssetHelper.h"
#import "YKLMainMenuViewController.h"
#import "YKLChildUserManageViewController.h"
//#import "YKLActivityListViewController.h"


#import "YKLNetworkingConsumer.h"

#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"

#import "YKLUserModel.h"


@interface YKLLoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ImageCropViewControllerDelegate>

{
    NSTimer *_timer;

    UIImage *myImage;
    
}

@property (nonatomic, strong) UIWebView *callWebView;

@end

@implementation YKLLoginViewController

static const float barHeight = 64;
static const float inputFieldHeight = 26;
bool hidBtn = NO;
int photoNub;       //照相判断 1：身份证，2：营业执照，3：二维码，0：不添加
int addImageNub;    //相册判断 1：身份证，2：营业执照，3：二维码，0：不添加

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

//- (instancetype)initWithUserInfo:(id)info {
//    self = [super initWithUserInfo:info];
//    if (self) {
//        self.curUserType = YKLUserTypeNone;
//        
//        return self;
//    }
//    return self;
//}

- (UIBarButtonItem *)leftBarItem {
    return nil;
}

- (void)show {
    self.contentView.top = 0;
}

- (void)hide {
    self.contentView.top = self.view.height;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[YKLLocalUserDefInfo defModel].firstIN isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].firstIN = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        
    }else{
        
        if (([[YKLLocalUserDefInfo defModel].isLogin isEqualToString:@"YES"])) {
            [self.navigationController pushViewController:[YKLMainMenuViewController new] animated:YES];
        }
        
    }
    
    [self creatLoginView];
    
    //选择器初始化
    [self getPickerData];
    [self initView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self hide];
    
    if (self.mobileField.text.length > 0 && self.vcodeField.text.length > 0) {
        [self loginBtnClicked:nil];
    }
    
    if (self.curUserType == YKLUserTypeBoss) {
        
        [self.navigationController pushViewController:[YKLMainMenuViewController new] animated:YES];
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

- (void)creatLoginView{
    
    self.title = @"登陆";
    
    self.loginLogoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginLogo"]];
    self.loginLogoImageView.frame = CGRectMake(0, ScreenHeight-15-24, 70, 24);
    self.loginLogoImageView.centerX = self.view.width/2;
    [self.view addSubview:self.loginLogoImageView];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, barHeight+20, self.view.width, 110)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    UIImageView *mobileImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mobileIcon"]];
    mobileImageView.frame = CGRectMake(10, 12, 15, 26);
    [self.bgView addSubview:mobileImageView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, mobileImageView.bottom+12, self.view.width, 10)];
    self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView addSubview:self.lineView];
    
    self.mobileField = [[UITextField alloc] initWithFrame:CGRectMake(mobileImageView.right+10, mobileImageView.top, self.view.width-2*10-mobileImageView.right, inputFieldHeight)];
    self.mobileField.keyboardType = UIKeyboardTypePhonePad;
//    self.mobileField.backgroundColor = [UIColor redColor];
//    self.mobileField.delegate = self;
    self.mobileField.font = [UIFont systemFontOfSize:14];
    self.mobileField.returnKeyType = UIReturnKeyNext;
    //    self.mobileField.borderStyle= UITextBorderStyleRoundedRect;
    self.mobileField.placeholder = @"输入手机号码";
    [self.bgView addSubview:self.mobileField];
    
    UIImageView *vcodeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vcodeIcon"]];
    vcodeImageView.frame = CGRectMake(10, self.lineView.bottom+12, 15, 26);
    [self.bgView addSubview:vcodeImageView];
    
    self.vcodeField = [[UITextField alloc] initWithFrame:CGRectMake(vcodeImageView.right+10, vcodeImageView.top, 100, inputFieldHeight)];
    self.vcodeField.keyboardType = UIKeyboardTypePhonePad;
//    self.vcodeField.backgroundColor = [UIColor redColor];
//    self.vcodeField.delegate = self;
    self.vcodeField.font = [UIFont systemFontOfSize:14];
    self.vcodeField.returnKeyType = UIReturnKeyNext;
    self.vcodeField.placeholder = @"输入验证码";
//    self.vcodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.bgView addSubview:self.vcodeField];
    
    self.vcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-100-15, self.lineView.bottom+5, 100, 40)];
    self.vcodeBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.vcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.vcodeBtn addTarget:self action:@selector(vcodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.vcodeBtn setBackgroundColor: [UIColor flatLightRedColor]];
    [self.vcodeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.vcodeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateHighlighted];
//    [self.vcodeBtn.layer setBorderWidth:1.0]; //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//    [self.vcodeBtn.layer setBorderColor:colorref];
    self.vcodeBtn.layer.cornerRadius = 5;
    self.vcodeBtn.layer.masksToBounds = YES;
    [self.bgView addSubview:self.vcodeBtn];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.bgView.bottom+27, self.view.width - 2*10, 40)];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [self.loginBtn setBackgroundColor: [UIColor flatLightRedColor]];
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.loginBtn];
}

- (void)creatRegistView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 690);
    [self.view addSubview:self.scrollView];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, self.view.height-barHeight-10*3+40)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView];
    
    self.bgView.height = 40.0*15;
//    NSLog(@"%lf,%lf",self.bgView.height,self.bgView.height/14);
    _bgHeight = self.bgView.height/15;
    
    for (int i = 0; i < 15; i++) {
        if (i != 0 && i != 7 && i != 9 && i != 11 ) {
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

    self.idLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bgHeight*6.5, self.view.width-2*10, _bgHeight)];
    self.idLabel.backgroundColor = [UIColor clearColor];
    self.idLabel.font = [UIFont systemFontOfSize:14];
    self.idLabel.textColor = [UIColor blackColor];
    self.idLabel.text = @"身份证";
    [self.bgView addSubview:self.idLabel];
    
    self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bgHeight*8.5, self.view.width-2*10, _bgHeight)];
    self.businessLabel.backgroundColor = [UIColor clearColor];
    self.businessLabel.font = [UIFont systemFontOfSize:14];
    self.businessLabel.textColor = [UIColor blackColor];
    self.businessLabel.text = @"营业执照";
    [self.bgView addSubview:self.businessLabel];
    
    self.QRCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bgHeight*10.5, self.view.width-2*10, _bgHeight)];
    self.QRCodeLabel.backgroundColor = [UIColor clearColor];
    self.QRCodeLabel.font = [UIFont systemFontOfSize:14];
    self.QRCodeLabel.textColor = [UIColor blackColor];
    self.QRCodeLabel.text = @"二维码";
    [self.bgView addSubview:self.QRCodeLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, _bgHeight*10.5, 90, _bgHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"（可修改）";
    [self.bgView addSubview:self.titleLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*12, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"服务识别码：";
    [self.bgView addSubview:self.titleLabel];
    
    self.agentIDField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*12, self.view.width-110, _bgHeight)];
    self.agentIDField.keyboardType = UIKeyboardTypeDefault;
    self.agentIDField.backgroundColor = [UIColor clearColor];
    self.agentIDField.delegate = self;
    self.agentIDField.font = [UIFont systemFontOfSize:14];
    self.agentIDField.returnKeyType = UIReturnKeyNext;
//    self.agentIDField.placeholder = @"服务识别码";
    [self.bgView addSubview:self.agentIDField];
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*12, _bgHeight*2-10, _bgHeight)];
//    [phoneButton setBackgroundColor:[UIColor flatLightRedColor]];
    [phoneButton setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
    [phoneButton setTitle:@"联系客服" forState:UIControlStateNormal];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [phoneButton addTarget:self action:@selector(phoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:phoneButton];
    
    UIImageView *phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphone"]];
    phoneImageView.frame = CGRectMake(phoneButton.left-10, 0, 15, 15);
    phoneImageView.centerY = phoneButton.centerY;
    [self.bgView addSubview:phoneImageView];

    self.upView = [[UIView alloc]initWithFrame:CGRectMake(0, _bgHeight*13+1, self.view.width, _bgHeight*2)];
    self.upView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.upView];
    
    self.registLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _bgHeight*2)];
    self.registLabel.textAlignment = NSTextAlignmentCenter;
    self.registLabel.textColor = [UIColor flatLightRedColor];
    self.registLabel.font = [UIFont systemFontOfSize:14];
    self.registLabel.text = @"您尚未完善用户信息请提交";
    [self.upView addSubview:self.registLabel];
    
    self.agentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*13, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.agentNameLabel.font = [UIFont systemFontOfSize:14];
    self.agentNameLabel.text = @"服务商名称：";
    self.agentNameLabel.hidden = YES;
    [self.bgView addSubview:self.agentNameLabel];

    self.agentNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*13, self.view.width-110, _bgHeight)];
    self.agentNameField.keyboardType = UIKeyboardTypeDefault;
    self.agentNameField.backgroundColor = [UIColor clearColor];
    self.agentNameField.delegate = self;
    self.agentNameField.font = [UIFont systemFontOfSize:14];
    self.agentNameField.returnKeyType = UIReturnKeyNext;
//    self.agentNameField.placeholder = @"服务商名称";
    self.agentNameField.hidden = YES;
    [self.bgView addSubview:self.agentNameField];
    
    self.agentMobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgHeight*14, 90, _bgHeight)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    self.agentMobileLabel.font = [UIFont systemFontOfSize:14];
    self.agentMobileLabel.text = @"服务商电话：";
    self.agentMobileLabel.hidden = YES;
    [self.bgView addSubview:self.agentMobileLabel];
    
    self.agentMobileField = [[UITextField alloc] initWithFrame:CGRectMake(100, _bgHeight*14, self.view.width-110, _bgHeight)];
    self.agentMobileField.keyboardType = UIKeyboardTypeDefault;
    self.agentMobileField.backgroundColor = [UIColor clearColor];
    self.agentMobileField.delegate = self;
    self.agentMobileField.font = [UIFont systemFontOfSize:14];
    self.agentMobileField.returnKeyType = UIReturnKeyNext;
//    self.agentMobileField.placeholder = @"服务商电话";
    self.agentMobileField.hidden = YES;
    [self.bgView addSubview:self.agentMobileField];
    
    self.registBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.bgView.bottom+10, self.view.width - 2*10, 45)];
    self.registBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [self.registBtn setBackgroundColor: [UIColor flatLightRedColor]];
    [self.registBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.registBtn addTarget:self action:@selector(registClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.registBtn.layer.cornerRadius = 5;
    self.registBtn.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.registBtn];
    
}

//拨打电话方法
- (void)phoneButtonClicked{
    [self hidenKeyboard];
    
    NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", @"073189790322"]];
    if (self.callWebView == nil) {
        self.callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
}

- (void)reloadIDImageView{
    self.idImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*6+5, _bgHeight*2-10, _bgHeight*2-10)];
    self.idImageView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.idImageView];
    
    self.addIDImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addIDImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addIDImageBtn sizeToFit];
    self.addIDImageBtn.frame = CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*6+5, _bgHeight*2-10, _bgHeight*2-10);
    [self.addIDImageBtn addTarget:self action:@selector(addIDButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addIDImageBtn setHidden:hidBtn];
    [self.bgView addSubview:self.addIDImageBtn];
    
    _aIDIVs = @[self.idImageView];
}

- (void)reloadBusImageView{
    self.businessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*8+5, _bgHeight*2-10, _bgHeight*2-10)];
    self.businessImageView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.businessImageView];
    
    self.addBusinessImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBusinessImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addBusinessImageBtn sizeToFit];
    self.addBusinessImageBtn.frame = CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*8+5, _bgHeight*2-10, _bgHeight*2-10);
    [self.addBusinessImageBtn addTarget:self action:@selector(addBusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBusinessImageBtn setHidden:hidBtn];
    [self.bgView addSubview:self.addBusinessImageBtn];
    
    _aBusinessIVs =@[self.businessImageView];
}

- (void)reloadQRCodeImageView{
    
    self.QRCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*10+5, _bgHeight*2-10, _bgHeight*2-10)];
    self.QRCodeImageView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.QRCodeImageView];
    
    self.addQRCodeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addQRCodeImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addQRCodeImageBtn sizeToFit];
    self.addQRCodeImageBtn.frame = CGRectMake(self.bgView.width-_bgHeight*2, _bgHeight*10+5, _bgHeight*2-10, _bgHeight*2-10);
    [self.addQRCodeImageBtn addTarget:self action:@selector(addQRCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addQRCodeImageBtn setHidden:hidBtn];
    [self.bgView addSubview:self.addQRCodeImageBtn];
    
    _QRCodeIVs = @[self.QRCodeImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setFullScreen:NO];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setFullScreen:NO];
    self.mobileField.text = @"";
    self.vcodeField.text = @"";
    
    if (self.QRCodeHidden) {
        if ([[YKLLocalUserDefInfo defModel].QRcodeHelp isEqual:@"YES"]) {
            [YKLLocalUserDefInfo defModel].QRcodeHelp = @"NO";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        }
    }
}

- (void)setFullScreen:(BOOL)fullScreen {
    // 状态条
    [UIApplication sharedApplication].statusBarHidden = fullScreen;
    // 导航条
    [self.navigationController setNavigationBarHidden:fullScreen];
    // tabBar的隐藏通过在初始化方法中设置hidesBottomBarWhenPushed属性来实现。
    
}

- (void)vcodeBtnClicked:(id)sender {
    NSLog(@"-------获取验证码------");
    [self hidenKeyboard];

    if ([self.mobileField.text isBlankString]) {
        [UIAlertView showErrorMsg:@"请输入手机号码"];
        [self.mobileField becomeFirstResponder];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer getRegistVCodeWithMobile:self.mobileField.text success:^(NSString *verificationCode) {
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

int miaoS = 60;
-(void)timeFireMethod{

    miaoS--;
    
    NSString *str = [NSString stringWithFormat:@"(%ds)后获取",miaoS];
    [self.vcodeBtn setTitle:str forState:UIControlStateNormal];
    self.vcodeBtn.userInteractionEnabled=NO;
    
    if (miaoS == 0) {
        
        [_timer invalidate];
        
        [self.vcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.vcodeBtn.userInteractionEnabled=YES;
        miaoS = 60;
    }
    
}


- (void)loginBtnClicked:(id)sender {
    NSLog(@"------登陆按钮------");
    
    self.mobileText = self.mobileField.text;
    [self hidenKeyboard];
    
    if ([self.mobileField.text isBlankString] || [self.vcodeField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请输入完整信息"];
        [self.mobileField becomeFirstResponder];
        return;
    }
    
//    [YKLNetworkingConsumer getTokenWithAPIToken:API_Token Success:^(NSString *token) {
//        NSLog(@"-------获取Token为：%@--------",token);
//    } failure:^(NSError *error) {
//        
//    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    [YKLNetworkingConsumer loginWithMobile:self.mobileField.text
                                     Vcode:self.vcodeField.text
                                   success:^(YKLUserModel *userModel) {
//                                       userModel.shopName = nil;
                                       
                                       if (userModel == nil) {
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           return;
                                       }
                                       
                                       if (userModel.shopName == nil||[userModel.shopName isBlankString]) {
                                           
                                           [YKLLocalUserDefInfo defModel].isRegister = @"NO";
                                           
                                           [YKLLocalUserDefInfo defModel].mobile = userModel.mobile;
                                           [YKLLocalUserDefInfo defModel].status = userModel.status;
                                           [YKLLocalUserDefInfo defModel].userID = userModel.userID;
//                                           [YKLLocalUserDefInfo defModel].userName = @"口袋客";
                                           [YKLLocalUserDefInfo defModel].payStatus = @"默认支付状态";
                                           [YKLLocalUserDefInfo defModel].isLogin = @"YES";
                                                                                      
                                           //判断用户是否授权
                                           if (![userModel.status isEqual:@"1"]) {
                                               
                                               [YKLLocalUserDefInfo defModel].firstHelp = @"YES";
                                               
                                           }else{
                                               
                                               [YKLLocalUserDefInfo defModel].firstHelp = @"NO";
                                               [YKLLocalUserDefInfo defModel].QRcodeHelp = @"YES";
                                           }
                                           
                                           [YKLLocalUserDefInfo defModel].secondHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].actTypeHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].settingHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].onlinePayHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].shareHelp = @"YES";
                                           
                                           [YKLLocalUserDefInfo defModel].bargainDDHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].bargainCXHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].higoHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].duoBaoHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].miaoShaHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].suDingHelp = @"YES";
                                           
                                           [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                                           
                                          
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           [self.navigationController pushViewController:[YKLMainMenuViewController new] animated:YES];
                                           
                                           return;
                                           
                                       }else{
                                           
                                           [YKLLocalUserDefInfo defModel].isRegister = @"YES";
                                           [YKLLocalUserDefInfo defModel].mobile = userModel.mobile;
                                           [YKLLocalUserDefInfo defModel].status = userModel.status;
                                           [YKLLocalUserDefInfo defModel].userID = userModel.userID;
                                           [YKLLocalUserDefInfo defModel].userName = userModel.shopName;
                                           [YKLLocalUserDefInfo defModel].payStatus = @"默认支付状态";
                                           [YKLLocalUserDefInfo defModel].isLogin = @"YES";
                                           
                                           //判断用户是否授权
                                           if (![userModel.status isEqualToString:@"1"]) {
                                               
                                               [YKLLocalUserDefInfo defModel].firstHelp = @"YES";
                                               
                                           }else{
                                               
                                               [YKLLocalUserDefInfo defModel].firstHelp = @"NO";
                                               [YKLLocalUserDefInfo defModel].QRcodeHelp = @"YES";
                                           }
                                           
                                           [YKLLocalUserDefInfo defModel].secondHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].actTypeHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].settingHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].onlinePayHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].shareHelp = @"YES";
                                           
                                           [YKLLocalUserDefInfo defModel].bargainDDHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].bargainCXHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].higoHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].duoBaoHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].miaoShaHelp = @"YES";
                                           [YKLLocalUserDefInfo defModel].suDingHelp = @"YES";
                                           
                                           [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                                           
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           [self.navigationController pushViewController:[YKLMainMenuViewController new] animated:YES];
                                
                                       }
                                       
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showErrorMsg:error.domain.length>0 ? error.domain : @"登录失败"];

    }];

}

- (void)registClicked:(id)sender {
    NSLog(@"------注册按钮------");
    [self hidenKeyboard];
    
    NSData *dataID = [self.idImageView.image resizedAndReturnData];
    NSData *dataBus = [self.businessImageView.image resizedAndReturnData];
    
    //判断是否有未填写信息
//    if ([[NSString stringWithFormat:@"%@,%@,%@",self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.townBtn.titleLabel.text] isBlankString]) {
//        NSLog(@"xxx");
//    }else{
//        NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.townBtn.titleLabel.text]);
//    }
    
    if ([self.storeNameField.text isBlankString]||[[NSString stringWithFormat:@"%@,%@,%@",self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.townBtn.titleLabel.text] isBlankString]||[self.streetAddressField.text isBlankString]||[self.streetAddressField.text isBlankString]||[self.teleField.text isBlankString]||[self.contactsField.text isBlankString]||[self.idImageURL isBlankString]||[self.businessImageURL isBlankString]||[self.agentIDField.text isBlankString]||dataID == NULL || dataBus == NULL){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"请输入完整信息"];
//        [self.storeNameField becomeFirstResponder];
        return;
    }
//    else{
//        NSLog(@"成功注册");
//        return;
//    }
    
    [self qiniuUpload];

}

- (void)loginTitleBtnClicked {
    NSLog(@"------登陆页面------");
  
    [self hidenKeyboard];

//    [UIView animateWithDuration:1.3 animations:^{
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self creatLoginView];
        
//    } completion:^(BOOL finished) {
    
//    }];
}

- (void)registTitleBtnClicked{
    NSLog(@"------注册页面------");
    hidBtn = NO;
    [self hidenKeyboard];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"zizhanghao"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(zizhanghaoClicked)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self creatRegistView];
    [self reloadIDImageView];
    [self reloadBusImageView];
    [self reloadQRCodeImageView];
    
}

#pragma mark - 子账号按钮点击事件

- (void)zizhanghaoClicked{
    
    YKLChildUserManageViewController *vc = [YKLChildUserManageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)createFirstView{
    self.bgImageView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImageView];
    
    self.firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"二维码"]];
    self.firstImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.firstImageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.bgImageView addGestureRecognizer:singleTap];
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    
    self.singelTap++;
    if (self.singelTap == 1) {
        self.firstImageView.hidden = YES;
        self.bgImageView.hidden = YES;
        
        [YKLLocalUserDefInfo defModel].QRcodeHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
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
    [self.agentIDField resignFirstResponder];
    [self.agentNameField resignFirstResponder];
    [self.agentMobileField resignFirstResponder];
    
    [self resumeView];
}

- (void)addIDButtonClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];
    hidBtn = YES;
    photoNub = 1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)addBusButtonClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];
    hidBtn = YES;
    photoNub = 2;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)addQRCodeButtonClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];
    hidBtn = YES;
    photoNub = 3;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 && photoNub == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 0 && photoNub == 2) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 0 && photoNub == 3) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1 && photoNub == 1) {
        
        for (UIImageView *iv in _aIDIVs)
            iv.image = nil;

        addImageNub = 1;
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];

    }
    else if (buttonIndex == 1 && photoNub == 2) {
        
        for (UIImageView *iv in _aBusinessIVs)
            iv.image = nil;
        
        addImageNub = 2;
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
        
    }
    else if (buttonIndex == 1 && photoNub == 3) {
        
        for (UIImageView *iv in _QRCodeIVs)
            iv.image = nil;
        
        addImageNub = 3;
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
    
    if (photoNub == 1) {
        hidBtn = YES;
        [self reloadIDImageView];
        [self.idImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }else if (photoNub == 2){
        hidBtn = YES;
        [self reloadBusImageView];
        [self.businessImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    else if (photoNub == 3){
        hidBtn = YES;
        [self reloadQRCodeImageView];
        [self.QRCodeImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    photoNub = 0;
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
    if (addImageNub == 1) {
        
        hidBtn = YES;
        
        [self reloadIDImageView];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
        {
            for (int i = 0; i < MIN(1, aSelected.count); i++)
            {
                UIImageView *iv = _aIDIVs[i];
                iv.image = aSelected[i];
            }
        }
        else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
        {
            for (int i = 0; i < MIN(1, aSelected.count); i++)
            {
                UIImageView *iv = _aIDIVs[i];
                iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
            }
            
            [ASSETHELPER clearData];
        }
    }
    else if(addImageNub == 2)
    {
        
        hidBtn = YES;
        
        [self reloadBusImageView];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
        {
            for (int i = 0; i < MIN(1, aSelected.count); i++)
            {
                UIImageView *iv = _aBusinessIVs[i];
                iv.image = aSelected[i];
            }
        }
        else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
        {
            for (int i = 0; i < MIN(1, aSelected.count); i++)
            {
                UIImageView *iv = _aBusinessIVs[i];
                iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
            }
            
            [ASSETHELPER clearData];
        }
    }
    else if(addImageNub == 3)
    {
        
//        hidBtn = YES;
//        
//        [self reloadQRCodeImageView];
        
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

    
    addImageNub = 0;
    
}

#pragma mark - 裁剪功能协议

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    
    hidBtn = YES;
    
    [self reloadQRCodeImageView];

    UIImageView *iv = _QRCodeIVs[0];
    iv.image = croppedImage;
    
//    [_addImageBtn setImage:croppedImage forState:UIControlStateNormal];
    
    //    CGRect cropArea = controller.cropArea;
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    
    hidBtn = NO;
    
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

    NSData *dataID = [self.idImageView.image resizedAndReturnData];
    NSData *dataBus = [self.businessImageView.image resizedAndReturnData];
    NSData *dataQrCode = [self.QRCodeImageView.image resizedAndReturnData];
    
    
    [upManager putData:dataID
                   key:fileName
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                  self.idImageURL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                  
                   NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
                  
                  [upManager putData:dataBus
                                 key:fileName
                               token:token
                            complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                
                                self.businessImageURL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                                
                                NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
                                
                                [upManager putData:dataQrCode
                                               key:fileName
                                             token:token
                                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                              
                                              self.QRCodeImageURL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                                              
                                              
                                              NSLog(@"ID:%@--Bus:%@--QR:%@",self.idImageURL,self.businessImageURL,self.QRCodeImageURL);
                                              
                                              
                                              [YKLNetworkingConsumer registWithMobile:[YKLLocalUserDefInfo defModel].mobile
                                                                               UserID:[YKLLocalUserDefInfo defModel].userID
                                                                             ShopName:self.storeNameField.text
                                                                              Address:[NSString stringWithFormat:@"%@,%@,%@",self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.townBtn.titleLabel.text]
                                                                               Street:self.streetAddressField.text
                                                                           ServiceTel:self.teleField.text
                                                                            Lianxiren:self.contactsField.text
                                                                         IdentityCard:self.idImageURL
                                                                              License:self.businessImageURL
                                                                            AgentCode:self.agentIDField.text
                                                                           AlipayName:@""
                                                                        AlipayAccount:@""
                                                                               QRcode:self.QRCodeImageURL
                                                                              success:^(NSString *success) {
                                                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                  
                                                                                  [YKLLocalUserDefInfo defModel].isRegister = @"YES";
                                                                                  [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                                                                                  
                                                                                  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                                                                                 
                                                                              } failure:^(NSError *error) {
                                                                                  
                                                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                  [UIAlertView showErrorMsg:error.domain.length>0 ? error.domain : @"注册失败"];
                                                                                  
                                                                              }];
                                              
                                              
                                          }
                                            option:nil];
                               
                            }
                              option:nil];
                  
                  
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
