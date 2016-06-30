//
//  YKLPosterResultViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/1.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLPosterResultViewController.h"

#import "YKLTogetherShareViewController.h"

#import "AssetHelper.h"

@interface YKLPosterResultViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageCropViewControllerDelegate>
{
    UIView *_bgView;
    
    UIImageView *_goodImage;
    
    UIButton *_addImageBtn;
    
    UIImage *myImage;
    
    UIImageView *tempImg;
    
    UIImageView *_ewmImage;
    
    UITextView *_rulelTextView;
    
    UILabel *_ruleLabel;

    UIView *_ruleView;
    
    UIView *_addressView;
    
}

@property (nonatomic,strong) UILabel *shopLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *mobileLabel;

@end

@implementation YKLPosterResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)createView{
    
    //边框颜色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0/255.0, 0/255.0, 0/255.0, 1 });

    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20)];
    [self.view addSubview:_bgView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 23, 75, 50);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"jizan_fanhui"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UIButton *shareWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareWXBtn.frame = CGRectMake(0, self.view.height-39-50, 75, 50);
    shareWXBtn.right = self.view.width;
    [shareWXBtn addTarget:self action:@selector(shareWX) forControlEvents:UIControlEventTouchUpInside];
    [shareWXBtn setImage:[UIImage imageNamed:@"jizan_fenxiang"] forState:UIControlStateNormal];
    [self.view addSubview:shareWXBtn];

    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0,self.view.height-39-50, 75, 50);
    [saveBtn addTarget:self action:@selector(savaPicBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setImage:[UIImage imageNamed:@"jizan_baocun"] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
    
    
    _goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(22.5, 50, self.view.width-45, self.view.width-45)];
    [_goodImage.layer setBorderWidth:4.0]; //边框宽度
    [_goodImage.layer setBorderColor:colorref];
    [_bgView addSubview:_goodImage];
    
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addImageBtn.backgroundColor = [UIColor clearColor];
    _addImageBtn.frame = CGRectMake(22.5, 50, self.view.width-45, self.view.width-45);
    [_addImageBtn setImage:[UIImage imageNamed:@"jizan_addImage"] forState:UIControlStateNormal];
    [_addImageBtn addTarget:self action:@selector(addImageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_addImageBtn];
    
    if (ScreenHeight == 480) {
        
        _goodImage.frame  = CGRectMake(65, 50, self.view.width-130, self.view.width-130);
        
        _addImageBtn.frame = CGRectMake(65+4, 50+4, self.view.width-130-8, self.view.width-130-8);
    }
    
    UIImageView *jizanTitleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (100-23)*2.5, 100-23)];
    jizanTitleImage.centerX = self.view.width/2;
    [_bgView addSubview:jizanTitleImage];
    
    UIImageView *jizanTitleImage02 = [[UIImageView alloc]initWithFrame:CGRectMake(9, 100, 50, 50)];
    [_bgView addSubview:jizanTitleImage02];
    
    UIImageView *jizanTitleImage01 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65, 50, 50)];
    jizanTitleImage01.right = self.view.width-12;
    [_bgView addSubview:jizanTitleImage01];
    
    switch (_type) {
        case 1:
            self.view.backgroundColor = [UIColor colorWithHexString:@"FED500"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"FED500"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_dianzhui_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_dianzhui_01"];
            break;
        case 2:
            self.view.backgroundColor = [UIColor colorWithHexString:@"58dd70"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"58dd70"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_qipao"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_lvse_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_lvse_01"];
            break;
        case 3:
            self.view.backgroundColor = [UIColor colorWithHexString:@"81bbff"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"81bbff"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_binggun"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_binggun_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_binggun_01"];
            break;
        case 4:
            self.view.backgroundColor = [UIColor colorWithHexString:@"299ea4"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"299ea4"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_fenbi"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_fenbi_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_fenbi_01"];
            break;
        case 5:
            self.view.backgroundColor = [UIColor colorWithHexString:@"f7f4ed"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"f7f4ed"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_xiaoji"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_xiaoji_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_xiaoji_01"];
            break;
        case 6:
            self.view.backgroundColor = [UIColor colorWithHexString:@"feb1d5"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"feb1d5"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_xiaoxingxing"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_xiaoxingxing_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_xiaoxingxing_01"];
            break;
        case 7:
            self.view.backgroundColor = [UIColor colorWithHexString:@"c30d23"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"c30d23"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_xiaoniao"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_xiaoniao_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_xiaoniao_01"];
            break;
        case 8:
            self.view.backgroundColor = [UIColor colorWithHexString:@"fef200"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"fef200"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_xiaohuangren"];
            jizanTitleImage02.image = [UIImage imageNamed:@"jizan_xiaohuangren_02"];
            jizanTitleImage01.image = [UIImage imageNamed:@"jizan_xiaohuangren_01"];
            break;
        case 9:
            self.view.backgroundColor = [UIColor colorWithHexString:@"f4b5fc"];
            _bgView.backgroundColor = [UIColor colorWithHexString:@"f4b5fc"];
            jizanTitleImage.image = [UIImage imageNamed:@"jizan_banner_hudiejie"];
            break;
            
        default:
            break;
    }
    
    UILabel *ewmLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, _goodImage.bottom+5, 105, 20)];
    ewmLabel.textAlignment = NSTextAlignmentCenter;
    ewmLabel.font = [UIFont systemFontOfSize:12];
    ewmLabel.text = @"长按关注本店";
    [_bgView addSubview:ewmLabel];
    
    _ewmImage = [[UIImageView alloc]initWithFrame:CGRectMake(22.5, ewmLabel.bottom, 105, 105)];
    [_ewmImage sd_setImageWithURL:[NSURL URLWithString:[YKLLocalUserDefInfo defModel].shopQRCode] placeholderImage:[UIImage imageNamed:@"Demo"]];
    _ewmImage.backgroundColor = [UIColor whiteColor];
    [_ewmImage.layer setBorderWidth:2.0]; //边框宽度
    [_ewmImage.layer setBorderColor:colorref];
    _ewmImage.layer.cornerRadius = 5;
    _ewmImage.layer.masksToBounds = YES;
    [_bgView addSubview:_ewmImage];
    
    UILabel *ruleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ewmLabel.right+10, ewmLabel.top, self.view.width-ewmLabel.right-10-22.5, 20)];
    ruleTitleLabel.textAlignment = NSTextAlignmentCenter;
    ruleTitleLabel.font = [UIFont systemFontOfSize:12];
    ruleTitleLabel.text = @"活动规则";
    [_bgView addSubview:ruleTitleLabel];
    
    _ruleView = [[UIView alloc]initWithFrame:CGRectMake(ruleTitleLabel.left, ruleTitleLabel.bottom, self.view.width-ewmLabel.right-10-22.5, 105)];
    _ruleView.backgroundColor = [UIColor whiteColor];
    [_ruleView.layer setBorderWidth:2.0]; //边框宽度
    [_ruleView.layer setBorderColor:colorref];
    _ruleView.layer.cornerRadius = 5;
    _ruleView.layer.masksToBounds = YES;
    [_bgView addSubview:_ruleView];
    
    _rulelTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, _ruleView.width-10, _ruleView.height-10)];
    _rulelTextView.backgroundColor = [UIColor whiteColor];
    [_rulelTextView.layer setBorderWidth:2.0]; //边框宽度
    [_rulelTextView.layer setBorderColor:colorref];
    _rulelTextView.layer.cornerRadius = 5;
    _rulelTextView.layer.masksToBounds = YES;
    _rulelTextView.font = [UIFont systemFontOfSize:14];
    _rulelTextView.textAlignment = NSTextAlignmentCenter;
    _rulelTextView.delegate = self;
    [_ruleView addSubview:_rulelTextView];
    
    _ruleLabel = [[UILabel alloc ]initWithFrame:CGRectMake(5, 0, _rulelTextView.width-10, 50)];
//    _ruleLabel.textAlignment = NSTextAlignmentCenter;
    _ruleLabel.text = @"输入规则,不超过40个字符";
    _ruleLabel.font = [UIFont systemFontOfSize:14];
    _ruleLabel.enabled = NO;//lable必须设置为不可用
    _ruleLabel.backgroundColor = [UIColor clearColor];
    _ruleLabel.numberOfLines = 0;
    [_rulelTextView addSubview:_ruleLabel];
    
    UILabel *addressTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _ruleView.bottom+7.5, 75, 20)];
    addressTitleLabel.centerX = self.view.width/2;
    addressTitleLabel.backgroundColor = [UIColor blackColor];
    addressTitleLabel.textColor = [UIColor whiteColor];
    addressTitleLabel.textAlignment = NSTextAlignmentCenter;
    addressTitleLabel.font = [UIFont systemFontOfSize:12];
    addressTitleLabel.text = @"小店地址";
    addressTitleLabel.layer.cornerRadius = 10;
    addressTitleLabel.layer.masksToBounds = YES;
    [_bgView addSubview:addressTitleLabel];
    
    _addressView = [[UIView alloc]initWithFrame:CGRectMake(10, addressTitleLabel.bottom, self.view.width-20, 60)];
    _addressView.backgroundColor = [UIColor whiteColor];
    [_addressView.layer setBorderWidth:4.0]; //边框宽度
    [_addressView.layer setBorderColor:colorref];
    _addressView.layer.cornerRadius = 30;
    _addressView.layer.masksToBounds = YES;
    [_bgView addSubview:_addressView];
    
    _shopLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, _addressView.width-10, 15)];
    _shopLabel.textAlignment = NSTextAlignmentCenter;
    _shopLabel.font = [UIFont systemFontOfSize:10];
    _shopLabel.text = [NSString stringWithFormat:@"店铺名称:%@",[YKLLocalUserDefInfo defModel].userName];
    [_addressView addSubview:_shopLabel];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, _shopLabel.bottom, _addressView.width-10, 15)];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.font = [UIFont systemFontOfSize:10];
    _addressLabel.text = [NSString stringWithFormat:@"地址:%@%@",[YKLLocalUserDefInfo defModel].address,[YKLLocalUserDefInfo defModel].street];
    [_addressView addSubview:_addressLabel];

    _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, _addressLabel.bottom, _addressView.width-10, 15)];
    _mobileLabel.textAlignment = NSTextAlignmentCenter;
    _mobileLabel.font = [UIFont systemFontOfSize:10];
    _mobileLabel.text = [NSString stringWithFormat:@"电话:%@",[YKLLocalUserDefInfo defModel].servicTel];
    [_addressView addSubview:_mobileLabel];
    
    
    

}

#pragma mark -TextViewDelegate

//开始编辑代金券textView时会调用该代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-180,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
    return YES;
}

//UITextView的协议方法，当开始编辑时监听
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length == 0){
        return YES;
    }
    
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength > 40) {
        return NO;
    }
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _ruleLabel.text = @"输入规则,不超过40个字符";
    }else{
        _ruleLabel.text = @"";
    }
    
    if (textView.text.length > 40) {
        textView.text = [textView.text substringToIndex:40];
    }
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
    [_rulelTextView resignFirstResponder];
    
    [self resumeView];
}

#pragma mark - 按钮方法

/*
 * 返回
 */
- (void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * 分享
 */
- (void)shareWX{
    
    UIGraphicsBeginImageContextWithOptions(_bgView.frame.size, NO, 0.0);
    [_bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [YKLTogetherShareViewController sharedByWeChatWithImage:viewImage sceneType:1];
}

/**
 * 保存
 */
- (void)savaPicBtnClicked{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定保存预览图片到相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UIGraphicsBeginImageContextWithOptions(_bgView.frame.size, NO, 0.0);
        [_bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//添加照片
- (void)addImageBtnClicked{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 ) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1) {
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        //        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [_addImageBtn setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //跳转裁剪页面
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    controller.type = 1;
    controller.delegate = self;
    controller.blurredBackground = YES;
    // set the cropped area
    // controller.cropArea = CGRectMake(0, 0, 100, 200);
    [[self navigationController] pushViewController:controller animated:NO];
    
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
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
//        [_addImageBtn setImage:aSelected[0] forState:UIControlStateNormal];
        
        myImage = aSelected[0];
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
//        [_addImageBtn setImage:[ASSETHELPER getImageFromAsset:aSelected[0] type:ASSET_PHOTO_SCREEN_SIZE] forState:UIControlStateNormal];
        
        myImage = [ASSETHELPER getImageFromAsset:aSelected[0] type:ASSET_PHOTO_SCREEN_SIZE];
        
        [ASSETHELPER clearData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    [_addImageBtn setImage:croppedImage forState:UIControlStateNormal];
    
    //    CGRect cropArea = controller.cropArea;
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
