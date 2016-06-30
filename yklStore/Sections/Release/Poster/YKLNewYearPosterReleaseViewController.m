//
//  YKLNewYearPosterReleaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/22.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLNewYearPosterReleaseViewController.h"
#import "YKLNewYearPosterPreviewViewController.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"

@interface YKLNewYearPosterReleaseViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UILabel *addImageLabel;
@property (nonatomic,strong) UIButton *addImageBtn;
@property (nonatomic,strong) UIImageView *addImageView;
@property (strong, nonatomic) NSArray *imageIVs;

//@property (nonatomic,strong) UIImageView *swearImageView;
@property (nonatomic,strong) UILabel *weLabel;
@property (nonatomic,strong) UITextField *weTextField;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *previewBtn;
@property (nonatomic,strong) UIButton *savaPicBtn;
@property (nonatomic,strong) UIButton *shareURLBtn;

@end

@implementation YKLNewYearPosterReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"励志体海报";
    
    self.addImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+10, 150, 30)];
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
    
    self.weLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.height-100, 60, 20)];
    self.weLabel.textAlignment = NSTextAlignmentCenter;
    self.weLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.weLabel.textColor = [UIColor PosterRedColor];
    self.weLabel.text = @"我为";
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
    self.previewBtn.frame = CGRectMake(20, self.view.height-50, 120, 40);
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
    
    YKLNewYearPosterPreviewViewController *postPreview = [YKLNewYearPosterPreviewViewController new];
    
    [postPreview createBgView];
    postPreview.bgImageView.image = self.addImageView.image;
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
        
        YKLNewYearPosterPreviewViewController *postPreview = [YKLNewYearPosterPreviewViewController new];
        
        [postPreview createBgView];
        postPreview.bgImageView.image = self.addImageView.image;
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
