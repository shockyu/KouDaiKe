//
//  YKLShopNewAddressViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopNewAddressViewController.h"

@interface YKLShopNewAddressViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *mobileField;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *addressDetailField;

//Picker view
@property (strong, nonatomic) UIButton *locationBtn;
@property (strong, nonatomic) UIPickerView *myPicker;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;
//Picker data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

@end

@implementation YKLShopNewAddressViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"添加新地址";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //选择器初始化
    [self getPickerData];
    [self initView];

    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self createView];
    
    if (_addressListModel) {
        
        self.nameField.text = _addressListModel.consigneeName;
        self.mobileField.text = _addressListModel.consigneeMobile;
        
        NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",_addressListModel.province,_addressListModel.city,_addressListModel.area];
        
        self.addressLabel.frame = self.addressBtn.frame;
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.textAlignment = NSTextAlignmentRight;
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.text = addressStr;
        
        self.addressDetailField.text = _addressListModel.address;
        
    }
    
}

- (void)createView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.width, 225)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    for (int i = 0; i < 3; i++) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48*(i+1), self.view.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 48*i, 70, 48)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        //titleLabel.textColor = [UIColor grayColor];
        
        switch (i) {
            case 0:
                titleLabel.text = @"收货人";
                break;
            case 1:
                titleLabel.text = @"联系电话";
                break;
            case 2:
                titleLabel.text = @"所在地区";
                break;
                
            default:
                break;
        }
        [bgView addSubview:titleLabel];
        
    }
    
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.width-90, 48)];
    self.nameField.keyboardType = UIKeyboardTypeDefault;
    self.nameField.backgroundColor = [UIColor clearColor];
    self.nameField.font = [UIFont systemFontOfSize:14];
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.placeholder = @"请输入姓名";
    [bgView addSubview:self.nameField];
    
    self.mobileField = [[UITextField alloc]initWithFrame:CGRectMake(80, self.nameField.bottom, self.view.width-90, 48)];
    self.mobileField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileField.backgroundColor = [UIColor clearColor];
    self.mobileField.font = [UIFont systemFontOfSize:14];
    self.mobileField.returnKeyType = UIReturnKeyNext;
    self.mobileField.placeholder = @"请输入联系电话";
    [bgView addSubview:self.mobileField];

    UIImageView *jiantouImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-23, self.mobileField.bottom+15, 12, 18)];
    jiantouImage.image = [UIImage imageNamed:@"tianjiadizhi_jiantou"];
    [bgView addSubview:jiantouImage];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-75, self.mobileField.bottom, 50, 48)];
    self.addressLabel.textColor = [UIColor lightGrayColor];
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.text = @"请选择";
    [bgView addSubview:self.addressLabel];
    
    self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressBtn.backgroundColor = [UIColor clearColor];
    self.addressBtn.frame = CGRectMake(80, self.mobileField.bottom, self.view.width-80-26, 48);
    [self.addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addressBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:self.addressBtn];
    
    self.addressDetailField = [[UITextField alloc]initWithFrame:CGRectMake(10, self.addressBtn.bottom, self.view.width-20, 48)];
    self.addressDetailField.keyboardType = UIKeyboardTypeDefault;
    self.addressDetailField.backgroundColor = [UIColor clearColor];
    self.addressDetailField.font = [UIFont systemFontOfSize:14];
    self.addressDetailField.returnKeyType = UIReturnKeyDone;
    self.addressDetailField.placeholder = @"请填写详细地址，不少于5个字";
    [bgView addSubview:self.addressDetailField];

    
    
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
    [self hideMyPicker];
    
    NSString *townStr;
    if (self.townArray.count) {
        
        townStr = [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
        
    }else{
        townStr = @"";
    }
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",[self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]],townStr];
    
    self.addressLabel.frame = self.addressBtn.frame;
    self.addressLabel.textColor = [UIColor blackColor];
    self.addressLabel.textAlignment = NSTextAlignmentRight;
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.text = addressStr;
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
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.nameField resignFirstResponder];
    [self.mobileField resignFirstResponder];
    [self.addressDetailField resignFirstResponder];
    
    [self resumeView];
}



#pragma mark - 按钮点击方法

- (void)rightBarClicked{
    
    [self hidenKeyboard];
    
    if ([self.nameField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置收件人姓名"];
        [self.nameField becomeFirstResponder];
        return;
    }
    if ([self.mobileField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置联系电话"];
        [self.mobileField becomeFirstResponder];
        return;
    }
    if ([self.addressLabel.text isEqual:@"请选择"]) {
        [UIAlertView showInfoMsg:@"请设置选择所在地区"];
        return;
    }
    if([self.addressDetailField.text isBlankString]){
        [UIAlertView showInfoMsg:@"请设置详细地址"];
        [self.addressDetailField becomeFirstResponder];
        return;
    }
    
    int bytes = [self stringConvertToInt:self.addressDetailField.text];
    if(bytes < 5){
        [UIAlertView showInfoMsg:@"详细地址不少于5个字"];
        [self.addressDetailField becomeFirstResponder];
        return;
    }
    
    NSString *addressID;
    if (!_addressListModel.addressID) {
        addressID = @"";
    }
    else{
        addressID = _addressListModel.addressID;
    }
    NSString *townStr;
    if (self.townArray.count) {
        
        townStr = [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
        
    }else{
        townStr = @"";
    }
    NSString *cityStr = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    NSString *provinceStr = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [YKLNetWorkingShop saveAddressWithAdressID:addressID ShopID:[YKLLocalUserDefInfo defModel].userID Province:provinceStr City:cityStr Area:townStr Address:self.addressDetailField.text ConsigneeName:self.nameField.text ConsigneeMobile:self.mobileField.text IsDefault:@"1" Success:^(NSDictionary *dict) {
    
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
//        //保存到本地
//        [self saveDictForFiled];
        
        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self hidenKeyboard];
        [UIAlertView showErrorMsg:error.domain];
    }];
}

//得到字节数函数
- (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        } 
        else { 
            p++; 
        }
    }
    return (strlength+1)/2;
}

//返回上一次视图
- (void)popHidden{
    
    [self hidenKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
//保存到本地
- (void)saveDictForFiled{
    
    NSString *townStr;
    if (self.townArray.count) {
        
        townStr = [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
        
    }else{
        townStr = @"";
    }
    NSString *cityStr = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    NSString *provinceStr = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.nameField.text forKey:@"consignee_name"];
    [parameters setObject:self.mobileField.text forKey:@"consignee_mobile"];
    [parameters setObject:provinceStr forKey:@"province"];
    [parameters setObject:cityStr forKey:@"city"];
    [parameters setObject:townStr forKey:@"area"];
    [parameters setObject:self.addressDetailField.text forKey:@"address"];
    
    [YKLLocalUserDefInfo defModel].shopAdressInfoDict = parameters;
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
}
*/

@end
