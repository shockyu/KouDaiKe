//
//  YKLHighGoGoodsEditViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoGoodsEditViewController.h"
//#import "YKLHighGoRealeaseViewController.h"
#import "YKLHighGoRealeaseMainViewController.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"
#import "SJAvatarBrowser.h"

@interface YKLHighGoGoodsEditViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate>


@end

@implementation YKLHighGoGoodsEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"产品详情";
    
    [self createBgView];
    [self createContents];
    [self createImageView];
    [self createGoods];
    
    self.hidAddImageBtn = NO;
    self.totle = [[NSMutableArray alloc]init];
    self.actImageViewArr= [NSMutableArray array];
    self.imageArr = [NSMutableArray array];
    self.imagePopArr = [NSMutableArray array];
    
    if (self.goodsDictionary) {
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [NSArray array];
        
        if (!self.actID) {
            
            self.goodsTitleField.text = [self.goodsDictionary objectForKey:@"name"];
            self.goodsIntroTextField.text = [self.goodsDictionary objectForKey:@"note"];
            self.goodsTotalPriceField.text = [self.goodsDictionary objectForKey:@"price"];
//            self.goodsOncePriceField.text = [self.goodsDictionary objectForKey:@"once"];
            self.totalNumField.text = [self.goodsDictionary objectForKey:@"join_num"];
            
            tempArray = [self.goodsDictionary objectForKey:@"img"];
            if(IsEmpty(tempArray)){
                NSLog(@"图片数组为空");
                return;
            }else{
                _selectNub = tempArray.count;
                if (tempArray.count == 5) {
                    [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    self.addImageBtn.backgroundColor = [UIColor clearColor];
                }
                
                for (int i = 0; i < tempArray.count; i++) {
                    
                    [self.actImageViewArr addObject:tempArray[i]] ;
                    UIImageView *imageView = self.actIVs[i];
                    //self.imageViewArr[i].userInteractionEnabled = YES;
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                    [self.actIVs[i] addGestureRecognizer:singleTap];
                    //imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.actImageViewArr[i]]]];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.actImageViewArr[i]] placeholderImage:[UIImage imageNamed:@"Demo"]];
                }
            }

            
            return;

        }
        
        self.goodsTitleField.text = [self.goodsDictionary objectForKey:@"goods_name"];
        
        if ([self.goodsDictionary objectForKey:@"goods_note"] != nil && !([[self.goodsDictionary objectForKey:@"goods_note"] isEqual:[NSNull null]] )){
            
            self.goodsIntroTextField.text = [self.goodsDictionary objectForKey:@"goods_note"];
        }
        self.goodsTotalPriceField.text = [self.goodsDictionary objectForKey:@"goods_price"];
        
        if ([self.goodsDictionary objectForKey:@"join_num"] != nil && !([[self.goodsDictionary objectForKey:@"join_num"] isEqual:[NSNull null]] )){
            
            self.totalNumField.text = [self.goodsDictionary objectForKey:@"join_num"];
        }
//        else{
//            self.totalNumField.text = self.goodsTotalPriceField.text;
//        }
//        self.goodsOncePriceField.text = [self.goodsDictionary objectForKey:@"price_once"];
        self.totalNumField.text = [NSString stringWithFormat:@"%@",[self.goodsDictionary objectForKey:@"count_need"]];
        
        tempArray = [self.goodsDictionary objectForKey:@"goods_img"];
        if(IsEmpty(tempArray)){
            NSLog(@"图片数组为空");
        }else{
            _selectNub = tempArray.count;
            if (tempArray.count == 5) {
                [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                self.addImageBtn.backgroundColor = [UIColor clearColor];
            }
            
            for (int i = 0; i < tempArray.count; i++) {
                
                [self.actImageViewArr addObject:tempArray[i]] ;
                UIImageView *imageView = self.actIVs[i];
                //self.imageViewArr[i].userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                [self.actIVs[i] addGestureRecognizer:singleTap];
                //imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.actImageViewArr[i]]]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.actImageViewArr[i]] placeholderImage:[UIImage imageNamed:@"Demo"]];
            }
        }

    }
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
}
//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 568);
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, (ScreenHeight-64-10)/3)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, (ScreenHeight-64-10)/3*2)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.saveBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.saveBtn.backgroundColor = [UIColor flatLightRedColor];
    self.saveBtn.layer.cornerRadius = 10;
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.frame = CGRectMake(0,self.bgView2.bottom-60,self.view.width-120,40);
    self.saveBtn.centerX = self.view.width/2;
    [self.saveBtn addTarget:self action:@selector(saveGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: self.saveBtn];

}

- (void)createContents{
    
    self.goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    self.goodsTitleLabel.backgroundColor = [UIColor clearColor];
    self.goodsTitleLabel.font = [UIFont systemFontOfSize:14];
    self.goodsTitleLabel.textColor = [UIColor blackColor];
    self.goodsTitleLabel.text = @"商品名称:";
    [self.bgView1 addSubview:self.goodsTitleLabel];
    
    self.goodsTitleField = [[UITextField alloc] initWithFrame:CGRectMake(self.goodsTitleLabel.right, 0, self.view.width-self.goodsTitleLabel.right-20, 40)];
    self.goodsTitleField.keyboardType = UIKeyboardTypeDefault;
    self.goodsTitleField.backgroundColor = [UIColor clearColor];
//    self.goodsTitleField.delegate = self;
    self.goodsTitleField.font = [UIFont systemFontOfSize:14];
    self.goodsTitleField.returnKeyType = UIReturnKeyNext;
    self.goodsTitleField.placeholder = @"请输入商品名称";
//    self.actTitleField.enabled = self.activityIngHidde;
    [self.bgView1 addSubview:self.goodsTitleField];
    
    self.goodsIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsTitleLabel.bottom, 80, 40)];
    self.goodsIntroLabel.backgroundColor = [UIColor clearColor];
    self.goodsIntroLabel.font = [UIFont systemFontOfSize:14];
    self.goodsIntroLabel.textColor = [UIColor blackColor];
    self.goodsIntroLabel.text = @"商品描述:";
    [self.bgView1 addSubview:self.goodsIntroLabel];
    
    self.goodsIntroTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, self.goodsIntroLabel.bottom, self.view.width-20, self.bgView1.height-90)];
    self.goodsIntroTextField.keyboardType = UIKeyboardTypeDefault;
    self.goodsIntroTextField.backgroundColor = [UIColor flatLightWhiteColor];
    self.goodsIntroTextField.layer.cornerRadius = 5;
    self.goodsIntroTextField.layer.masksToBounds = YES;
    self.goodsIntroTextField.font = [UIFont systemFontOfSize:14];
    self.goodsIntroTextField.returnKeyType = UIReturnKeyNext;
    [self.bgView1 addSubview:self.goodsIntroTextField];
    
    self.actPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    self.actPhotoLabel.backgroundColor = [UIColor clearColor];
    self.actPhotoLabel.font = [UIFont systemFontOfSize:14];
    self.actPhotoLabel.textColor = [UIColor blackColor];
    self.actPhotoLabel.text = @"图片展示";
    [self.bgView2 addSubview:self.actPhotoLabel];
    
    UILabel *actPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actPhotoLabel.right, self.actPhotoLabel.top, self.view.width-self.actPhotoLabel.right-20, 40)];
    actPhotoLabel.backgroundColor = [UIColor clearColor];
    actPhotoLabel.font = [UIFont systemFontOfSize:14];
    actPhotoLabel.textColor = [UIColor lightGrayColor];
    actPhotoLabel.text = @"(请注意：最多添加3张图片哦)";
    [self.bgView2 addSubview:actPhotoLabel];
    
}

- (void)createImageView{
    
    self.actImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView1.userInteractionEnabled = YES;
    self.actImageView1.backgroundColor = [UIColor whiteColor];
    [self.bgView2 addSubview:self.actImageView1];
    
    self.actImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView1.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView2.userInteractionEnabled = YES;
    self.actImageView2.backgroundColor = [UIColor whiteColor];
    [self.bgView2 addSubview:self.actImageView2];
    
    self.actImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView2.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView3.userInteractionEnabled = YES;
    self.actImageView3.backgroundColor = [UIColor whiteColor];
    [self.bgView2 addSubview:self.actImageView3];
    
    self.actImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView3.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView4.userInteractionEnabled = YES;
    self.actImageView4.backgroundColor = [UIColor whiteColor];
    [self.bgView2 addSubview:self.actImageView4];
    
    self.actImageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView4.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView5.userInteractionEnabled = YES;
    self.actImageView5.backgroundColor = [UIColor whiteColor];
    [self.bgView2 addSubview:self.actImageView5];
    
    _actIVs = @[self.actImageView1,self.actImageView2,self.actImageView3,self.actImageView4,self.actImageView5];
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addImageBtn sizeToFit];
    self.addImageBtn.frame = CGRectMake(self.view.width-(self.view.width-60)/5-10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5);
    [self.addImageBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addImageBtn setHidden:self.hidAddImageBtn];
//    self.addImageBtn.enabled = self.activityIngHidden;
    [self.bgView2 addSubview:self.addImageBtn];
    
    
}

- (void)createGoods{
    
    self.goodsTotalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.addImageBtn.bottom, 80, 40)];
    self.goodsTotalPriceLabel.backgroundColor = [UIColor clearColor];
    self.goodsTotalPriceLabel.font = [UIFont systemFontOfSize:14];
    self.goodsTotalPriceLabel.textColor = [UIColor blackColor];
    self.goodsTotalPriceLabel.text = @"商品总价:";
    [self.bgView2 addSubview:self.goodsTotalPriceLabel];
    
    self.goodsTotalPriceField = [[UITextField alloc] initWithFrame:CGRectMake(self.goodsTotalPriceLabel.right, self.goodsTotalPriceLabel.top, self.view.width-self.goodsTotalPriceLabel.right-20, 40)];
    self.goodsTotalPriceField.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsTotalPriceField.backgroundColor = [UIColor clearColor];
    self.goodsTotalPriceField.font = [UIFont systemFontOfSize:14];
    self.goodsTotalPriceField.returnKeyType = UIReturnKeyNext;
    self.goodsTotalPriceField.placeholder = @"请输入商品总价";
    self.goodsTotalPriceField.delegate = self;
    [self.bgView2 addSubview:self.goodsTotalPriceField];
    
    self.goodsOncePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsTotalPriceLabel.bottom, 80, 40)];
    self.goodsOncePriceLabel.backgroundColor = [UIColor clearColor];
    self.goodsOncePriceLabel.font = [UIFont systemFontOfSize:14];
    self.goodsOncePriceLabel.textColor = [UIColor blackColor];
    self.goodsOncePriceLabel.text = @"单次价格:";
    [self.bgView2 addSubview:self.goodsOncePriceLabel];
    
    self.goodsOncePriceField = [[UITextField alloc] initWithFrame:CGRectMake(self.goodsOncePriceLabel.right, self.goodsOncePriceLabel.top, self.view.width-self.goodsOncePriceLabel.right-20, 40)];
    self.goodsOncePriceField.keyboardType = UIKeyboardTypeDecimalPad;
    self.goodsOncePriceField.backgroundColor = [UIColor clearColor];
    self.goodsOncePriceField.font = [UIFont systemFontOfSize:14];
    self.goodsOncePriceField.returnKeyType = UIReturnKeyNext;
//    self.goodsOncePriceField.placeholder = @"￥1/次";
    self.goodsOncePriceField.text = @"￥1/次";
    self.goodsOncePriceField.textColor = [UIColor flatLightRedColor];
    self.goodsOncePriceField.enabled = NO;
    self.goodsOncePriceField.delegate = self;
    [self.bgView2 addSubview:self.goodsOncePriceField];
    
    self.totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsOncePriceLabel.bottom, 80, 40)];
    self.totalNumLabel.backgroundColor = [UIColor clearColor];
    self.totalNumLabel.font = [UIFont systemFontOfSize:14];
    self.totalNumLabel.textColor = [UIColor blackColor];
    self.totalNumLabel.text = @"共需人次:";
    [self.bgView2 addSubview:self.totalNumLabel];
    
    self.totalNumField = [[UITextField alloc] initWithFrame:CGRectMake(self.totalNumLabel.right, self.totalNumLabel.top, self.view.width-self.totalNumLabel.right-20, 40)];
    self.totalNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.totalNumField.backgroundColor = [UIColor clearColor];
    self.totalNumField.font = [UIFont systemFontOfSize:14];
    self.totalNumField.returnKeyType = UIReturnKeyNext;
//    self.totalNumField.placeholder = @"";
    self.totalNumField.enabled = NO;
    self.totalNumField.delegate = self;
    [self.bgView2 addSubview:self.totalNumField];
}

- (void)addImageBtnClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}


- (void)saveGoodsBtnClick:(id)sender{
    NSLog(@"点击了----确定----按钮");
    
    [self hidenKeyboard];
    
    [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
    
}

- (void)popHidden{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确认设置商品信息无误？" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
    alertView.tag = 6002;
    
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self hidenKeyboard];
    
    if (buttonIndex == 0) {
        
        [self releaseGoodsInfo];
    }
    else if (buttonIndex == 1){
        
    }
}

- (void)releaseGoodsInfo{
    
    //清空活动图片数组避免重复数据
    self.imageArr = [NSMutableArray array];
    
    //判断是否显示提示信息，完成信息
    if ([self.goodsTitleField.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置商品名称"];
        [self.goodsTitleField becomeFirstResponder];
        return;
    }
    
    if ([self.goodsIntroTextField.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置商品描述"];
        [self.goodsIntroTextField becomeFirstResponder];
        return;
    }
    
    if ([self.goodsTotalPriceField.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置商品总价"];
        [self.goodsTotalPriceField becomeFirstResponder];
        return;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"图片上传中请稍等";
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    [self qiniuUpload:0];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 ) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1) {
        
        for (UIImageView *iv in _actIVs)
            iv.image = nil;
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        //        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 3;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (_isPhoto) {
        [self.totle removeAllObjects];
        _isPhoto = NO;
    }
    [self.totle addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    NSLog(@"%lu",(unsigned long)self.totle.count);
    
    //限制只能拍3张照片
    if (!(self.totle.count > 3)) {
        _selectNub = self.totle.count;
    }
    NSLog(@"%ld",(long)_selectNub);
    
    [self createImageView];
    for (int i = 0; i < MIN(3, self.totle.count); i++){
        UIImageView *iv = _actIVs[i];
        iv.image = self.totle[i];
    }
    
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
    _isPhoto=YES;
    
    [self.totle removeAllObjects];
    
    NSRange range =  NSMakeRange(self.totle.count, aSelected.count);
    NSIndexSet *index = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.totle insertObjects:aSelected atIndexes:index];
    
    _selectNub = self.totle.count;
    
    [self createImageView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(5, self.totle.count); i++)
        {
            UIImageView *iv = _actIVs[i];
            iv.image = self.totle[i];
        }
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        for (int i = 0; i < MIN(5, self.totle.count); i++)
        {
            UIImageView *iv = _actIVs[i];
            iv.image = [ASSETHELPER getImageFromAsset:self.totle[i] type:ASSET_PHOTO_SCREEN_SIZE];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.goodsTotalPriceField) {
        
        self.totalNumField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
        if (range.location > 0 && range.length == 1 && string.length == 0)
        {
            self.totalNumField.text = @"";
            textField.text = @"";
            
//            NSString *temp = [textField.text substringFromIndex:[textField.text length]-1];
//            
//            self.totalNumField.text = temp;
        }
        return YES;
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
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
    [self.goodsTitleField resignFirstResponder];
    [self.goodsIntroTextField resignFirstResponder];
    [self.addImageBtn resignFirstResponder];
    [self.goodsTotalPriceField resignFirstResponder];
    [self.goodsOncePriceField resignFirstResponder];
    [self.totalNumField resignFirstResponder];
    
    [self resumeView];
}

#pragma mark - Helpers &七牛
- (void)qiniuUpload:(int) index{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSString *token = @"5_06q8nFxevqEx7XeBFn5VBRtwVySPeQg2UCDo0R:cCvb_Qn5ayw5ulB7dVbpS-HSCvM=:eyJzY29wZSI6InlrbC1tZWlwYS1uZXQiLCJkZWFkbGluZSI6MzA0Mjc2NzQxMn0=";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
    
    // ------------------- Test putData -------------------------
    NSData *data;
    
    NSData *data1 = [self.actImageView1.image resizedAndReturnData];
    NSData *data2 = [self.actImageView2.image resizedAndReturnData];
    NSData *data3 = [self.actImageView3.image resizedAndReturnData];
    NSData *data4 = [self.actImageView4.image resizedAndReturnData];
    NSData *data5 = [self.actImageView5.image resizedAndReturnData];
    
    if (index == 0) {
        data = data1;
    }else if (index == 1){
        data = data2;
    }else if (index == 2){
        data = data3;
    }else if (index == 3){
        data = data4;
    }else if (index == 4){
        data = data5;
    }
    index++;
    
    QNUploadOption *option1 = [[QNUploadOption alloc]initWithProgessHandler:^(NSString *key, float percent) {
        NSLog(@"percent<%d>:%.2f",index,percent);
        _myPercent = percent;
    }];
    
    [upManager putData:data
                   key:fileName
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  //判断是否有上传图片
                  if (![resp objectForKey:@"key"]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [UIAlertView showInfoMsg:@"请选择商品图片"];
                      return;
                  }
                  
//                  self.imageArr = [NSMutableArray array];
                  
                  self.actImageView1_URL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                  NSLog(@"%d>>>%@",index,self.actImageView1_URL);
                  [self.imageArr addObject:self.actImageView1_URL];
//                  
//                  NSData *data = [NSJSONSerialization dataWithJSONObject:self.imageArr
//                                                                 options:NSJSONWritingPrettyPrinted
//                                                                   error:nil];
//                  NSString *jsonString = [[NSString alloc] initWithData:data
//                                                               encoding:NSUTF8StringEncoding];
//                  NSLog(@"%@",jsonString);
                  if (index<_selectNub){
                      
                      [self qiniuUpload:index];
                  }
                  else{
                      NSLog(@"完成");
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
//                      NSLog(@"%@",self.imageArr);
                      
                      YKLHighGoRealeaseMainViewController *releaseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];

                      NSMutableDictionary *cellDict = [[NSMutableDictionary alloc]init];
                      [cellDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"sid"];
                      [cellDict setObject:@"" forKey:@"gid"];
                      [cellDict setObject:@"" forKey:@"tid"];
                      
                      [cellDict setObject:self.imageArr forKey:@"img"];
                      
                      if (self.actImageView1.image) {

                          NSData *data = [self.actImageView1.image resizedAndReturnData];
                          [cellDict setObject:data forKey:@"image"];
                      }
                      
                      if (self.actID) {
                          [cellDict setObject:self.imageArr forKey:@"goods_img"];
                          [cellDict setObject:self.goodsTitleField.text forKey:@"goods_name"];
                          [cellDict setObject:self.goodsIntroTextField.text forKey:@"goods_note"];
                          [cellDict setObject:self.goodsTotalPriceField.text forKey:@"goods_price"];
                          [cellDict setObject:self.totalNumField.text forKey:@"count_need"];
                      }else{
                          [cellDict setObject:self.goodsTitleField.text forKey:@"name"];
                          [cellDict setObject:self.goodsIntroTextField.text forKey:@"note"];
                          [cellDict setObject:self.goodsTotalPriceField.text forKey:@"price"];
                          [cellDict setObject:self.totalNumField.text forKey:@"join_num"];
                      }
                      [cellDict setObject:@"1" forKey:@"once"];
                      
                      if (self.goodsDictionary) {
                          if (self.actID) {
                              [cellDict setObject:[self.goodsDictionary objectForKey:@"id"] forKey:@"id"];
                              [cellDict setObject:[self.goodsDictionary objectForKey:@"id"] forKey:@"gid"];
                              [cellDict setObject:self.actID forKey:@"tid"];

                          }                          
                      }
                      
                      if ([releaseVC.goodsDict objectForKey:[NSString stringWithFormat:@"cell%ld",(long)self.cellNum-1]]) {
//
                          [releaseVC.goodsDict removeObjectForKey:[NSString stringWithFormat:@"cell%ld",(long)self.cellNum-1]];
                          
                      }
                      [releaseVC.goodsDict setObject:cellDict forKey:[NSString stringWithFormat:@"cell%ld",(long)self.cellNum-1]];
                      
                      releaseVC.cellNum = self.cellNum;
                      releaseVC.isGoodsList = YES;
                      
//                      releaseVC.goodsImage = self.actImageView1.image;
//                      releaseVC.goodsTitle = self.goodsTitleField.text;
                      
                      [self.navigationController popToViewController:releaseVC animated:YES];
                      
                  }
                  
              }
                option:option1];
    
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

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

@end
