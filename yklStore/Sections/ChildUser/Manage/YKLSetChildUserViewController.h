//
//  YKLSetChildUserViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/6/16.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLSetChildUserViewController : YKLUserBaseViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *loginLogoImageView;
@property (nonatomic, strong) UIView *bgView;
@property float bgHeight;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextField *mobileField;
@property (nonatomic, strong) NSString *mobileText;
@property (nonatomic, strong) UITextField *vcodeField;
@property (nonatomic, strong) UIButton *vcodeBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *agentNameLabel;
@property (nonatomic, strong) UILabel *agentMobileLabel;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UILabel *registLabel;
@property (readwrite, nonatomic) BOOL hiden;

@property (nonatomic, strong) UILabel *loginTitle;
@property (nonatomic, strong) UILabel *loginNum;
@property (nonatomic, strong) UITextField *storeNameField;
//@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *streetAddressField;
@property (nonatomic, strong) UITextField *teleField;
@property (nonatomic, strong) UITextField *contactsField;       //联系人
@property (nonatomic, strong) UILabel *idLabel;                 //身份证
@property (nonatomic, strong) UILabel *businessLabel;           //营业执照
@property (nonatomic, strong) UILabel *QRCodeLabel;             //二维码
@property (nonatomic, strong) UIButton *registBtn;

//图片信息
@property (strong, nonatomic)  UIImageView *idImageView;
@property (strong, nonatomic)  UIImageView *businessImageView;
@property (strong, nonatomic)  UIImageView *QRCodeImageView;

@property (strong, nonatomic)  UIButton *addIDImageBtn;
@property (strong, nonatomic)  UIButton *addBusinessImageBtn;
@property (strong, nonatomic)  UIButton *addQRCodeImageBtn;

@property (strong, nonatomic) NSArray *aIDIVs;
@property (strong, nonatomic) NSArray *aBusinessIVs;
@property (strong, nonatomic) NSArray *QRCodeIVs;

//@property (strong, nonatomic) NSString *idImageURL;
//@property (strong, nonatomic) NSString *businessImageURL;
@property (strong, nonatomic) NSString *QRCodeImageURL;
@property (strong, nonatomic) NSString *isRegister;    //判断是否注册

//Picker view
@property (strong, nonatomic) UIButton *locationBtn;
@property (strong, nonatomic) UIPickerView *myPicker;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIButton *provinceBtn;
@property (strong, nonatomic) UIButton *cityBtn;
@property (strong, nonatomic) UIButton *townBtn;
//Picker data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

@property (nonatomic, strong) UIView *bgImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property int singelTap;

@property (strong, nonatomic) NSDictionary *childInfoDict;
@property (strong, nonatomic) NSString *childUserID;
@end
