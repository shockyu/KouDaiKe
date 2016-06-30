//
//  YKLHighGoRealeaseMainViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/8.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLHighGoRealeaseMainViewController.h"
#import "YKLHighGoGoodsEditViewController.h"
#import "YKLHighGoEditActRuleViewController.h"
#import "YKLHighGoTemplateViewController.h"
#import "YKLHighGoReleaseCollectionViewCell.h"
#import "YKLTogetherShareViewController.h"
#import "YKLLoginViewController.h"
#import "YKLPopupView.h"

@interface YKLHighGoRealeaseMainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong) UIScrollView *bgScrollview;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *templateBtn;

@property (nonatomic, strong) UIView *ruleBgView;
@property (nonatomic, strong) UILabel *ruleTitle;
@property (nonatomic, strong) UILabel *ruleStatus;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *editImageView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *releaseBgView;
@property (nonatomic, strong) UIButton *releaseBtn;
@property (nonatomic, strong) UIView *releaseDoneBgView;
@property (nonatomic, strong) UIButton *releaseDoneBtn;

@property BOOL isDetailPop;

@property (nonatomic, strong) YKLPopupView *PopupView;

@end

@implementation YKLHighGoRealeaseMainViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"一元抽奖";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop  target:self action:@selector(activityLeftBarItemClicked:)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"question"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showHelpView)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 25, 25);
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.goodsDict = [[NSMutableDictionary alloc]init];
    self.actDict = [[NSMutableDictionary alloc]init];
    
    //若无本地数据，需加载
    if (self.layout) {
        
        [self.actDict setObject:self.layout forKey:@"layout"];
        [self.actDict setObject:self.goodsNum forKey:@"goods_num"];
        [self.actDict setObject:self.imageURL forKey:@"banner"];
        [self.actDict setObject:self.tempID forKey:@"template_id"];
        
    }
    
    self.isGoodsList = NO;//默认不刷新商品列表
    [self createBgView];
    [self reloadActDict];

    _PopupView = [[YKLPopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)activityLeftBarItemClicked:(UIBarButtonItem *)sender {
    
    if (self.activityID == NULL) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否保存活动到草稿箱？" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        
        [alertView show];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否放弃当前修改的活动信息？" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 6001){
        return;
    }
    
    if (buttonIndex == 0) {
        
        //发布活动键盘未收起推出时闪屏修改,延迟两个0.25来执行键盘收起的动画。
//        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        
        [self popHidden];
        //保存到本地
        [self saveDictForFiled];
        
    }else if (buttonIndex == 1){
        
        if (self.activityID == NULL) {
            [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        }else{
            //不做操作留在本页
        }
        
    }
}

- (void)popHidden{
    
    if (self.activityID == NULL) {
        
        //如果本地存储活动字典不为空
        if (![[YKLLocalUserDefInfo defModel].saveHighGoActInfoDict isEqual:@{}]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        }
        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //首次进入弹出帮助页面
    if ([[YKLLocalUserDefInfo defModel].higoHelp isEqual:@"YES"]) {
        
        [self showHelpView];
        
        [YKLLocalUserDefInfo defModel].higoHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"%@",self.actDict);
    
    
    NSString*couponString = [_actDict objectForKey:@"coupon_time"];
    NSArray *startArray = [couponString componentsSeparatedByString:@"-"];
    
    NSString*endString = [_actDict objectForKey:@"end"];
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    
    couponString = [startArray componentsJoinedByString:@""];
    endString = [endArray componentsJoinedByString:@""];
    
    int coupon = [couponString intValue];
    int end = [endString intValue];
    NSLog(@"%d--%d",coupon,end);
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    int today = [locationString intValue];
    
    
    if (self.activityID == NULL) {
        
        self.imageURL = [self.actDict objectForKey:@"banner"];
        self.goodsNum = [self.actDict objectForKey:@"goods_num"];
        self.layout = [self.actDict objectForKey:@"layout"];
        self.tempID = [self.actDict objectForKey:@"template_id"];
        
        [self createBgView];
    }else{
        
        if (self.isReloadActDict == YES) {
            self.imageURL = [self.actDict objectForKey:@"banner"];
            self.goodsNum = [self.actDict objectForKey:@"goods_num"];
            self.layout = [self.actDict objectForKey:@"layout"];
            self.tempID = [self.actDict objectForKey:@"template_id"];
            
            [self createBgView];
        }
        
//        self.ruleStatus.text = @"规则已编辑";
//        self.ruleStatus.textColor = [UIColor blackColor];
    }
    
    
    if ([self.actDict objectForKey:@"goods"]) {
        self.goodsDict = [self.actDict objectForKey:@"goods"];
    }
    
    if ([_actDict objectForKey:@"coupon_end"]) {
        if (coupon<today || end<today) {
            self.ruleStatus.text = @"活动结束时间已过期";
            self.ruleStatus.textColor = [UIColor redColor];
        }else{
            self.ruleStatus.text = @"规则已编辑";
            self.ruleStatus.textColor = [UIColor blackColor];
        }
        
    }
    
    if (self.imageURL) {
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"HighGo_imageing"]];
    }
    
    if ([self.actDict objectForKey:@"end"]) {
        self.actEndTime = [self.actDict objectForKey:@"end"];
    }
    
    
    [self.collectionView reloadData];
    
    
    //进行中，已完成活动，不调此方法
    if (self.isAgainRealease==YES||self.isWaitActivity==YES) {
        
        if (self.isFirstIn==YES) {
            
            self.isFirstIn = NO;
            
            return;
        }
    }
    
    
    if ([_actDict objectForKey:@"coupon_end"]&&!(coupon<today || end<today)&&(_goodsDict.count == [self.goodsNum integerValue])) {
        
        self.releaseBgView.hidden = YES;
        
        self.bgScrollview.height = self.view.height-64-60;
        self.bgScrollview.contentSize = CGSizeMake(self.view.width,self.bgImageView.height+10+50+10+self.collectionView.height+10+60-60);
        
        self.releaseDoneBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgScrollview.bottom, self.view.width, 60)];
        self.releaseDoneBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.releaseDoneBgView];
        
        self.releaseDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.releaseDoneBtn.frame = CGRectMake(10, 10, self.view.width-20, 40);
        self.releaseDoneBtn.backgroundColor = [UIColor flatLightRedColor];
        [self.releaseDoneBtn setTitle:@"确定发布" forState:UIControlStateNormal];
        [self.releaseDoneBtn addTarget:self action:@selector(releaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.releaseDoneBgView addSubview:self.releaseDoneBtn];

    }
    
}

- (void)reloadActDict{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (!(self.activityID == NULL)) {
        NSLog(@"%@",self.activityID);
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"加载活动信息中";
        
        [YKLNetworkingHighGo getActListWithActID:self.activityID Success:^(NSDictionary *dict) {
            
            NSLog(@"%@",dict);
            self.actDictionary = [[NSMutableDictionary alloc]initWithDictionary:dict];
            
            self.imageURL = [dict objectForKey:@"banner"];
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@""]];
            
            NSArray *goodsArry = [dict objectForKey:@"goods"];
            for (int i = 0; i < goodsArry.count; i++) {
                [self.goodsDict setObject:goodsArry[i] forKey:[NSString stringWithFormat:@"cell%d",i+1]];
            }
            
            self.layout = [self.actDictionary objectForKey:@"layout"];
            self.goodsNum = [self.actDictionary objectForKey:@"goods_num"];
            self.tempID = [self.actDictionary objectForKey:@"template_id"];
            
            //            NSString *tempIDStr = [self.actDictionary objectForKey:@"template_id"];
            NSString *tIDStr = [self.actDictionary objectForKey:@"id"];
            NSString *titleStr = [self.actDictionary objectForKey:@"title"];
            NSString *couponEndStr = [self.actDictionary objectForKey:@"coupon_end"];
            NSString *couponNoteStr = [self.actDictionary objectForKey:@"coupon_note"];
            NSString *couponStartStr = [self.actDictionary objectForKey:@"coupon_start"];
            NSString *couponTimeStr = [[self.actDictionary objectForKey:@"coupon_time"] timeNumber];
            NSString *rewardCodeStr = [self.actDictionary objectForKey:@"reward_code"];
            NSString *descStr = [self.actDictionary objectForKey:@"desc"];
            NSString *endTimeStr = [[self.actDictionary objectForKey:@"end_time"] timeNumber];
            
            //            NSMutableArray *goodsArr = [NSMutableArray array];
            //            goodsArr = [self.actDictionary objectForKey:@"goods"];
            //
            [_actDict setObject:self.goodsDict forKey:@"goods"];
            
            [_actDict setObject:endTimeStr forKey:@"end"];
            [_actDict setObject:couponTimeStr forKey:@"coupon_time"];
            [_actDict setObject:titleStr forKey:@"title"];
            [_actDict setObject:descStr forKey:@"desc"];
            [_actDict setObject:couponStartStr forKey:@"coupon_start"];
            [_actDict setObject:couponEndStr forKey:@"coupon_end"];
            [_actDict setObject:couponNoteStr forKey:@"coupon_note"];
            [_actDict setObject:rewardCodeStr forKey:@"reward_code"];
            
            [_actDict setObject:tIDStr forKey:@"tid"];
            //            [_actDict setObject:tempIDStr forKey:@"tmp_id"];
            
            [self createBgView];
            [self.collectionView reloadData];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    //如果本地存储活动字典不为空则加载其数据
    else if (![[YKLLocalUserDefInfo defModel].saveHighGoActInfoDict isEqual:@{}]) {
        
        
        self.actDictionary = [[NSMutableDictionary alloc]initWithDictionary:[YKLLocalUserDefInfo defModel].saveHighGoActInfoDict];
        
        
        _actDict =  [[NSMutableDictionary alloc]initWithDictionary:[YKLLocalUserDefInfo defModel].saveHighGoActInfoDict];
        
        
        [self.collectionView reloadData];
        
    }
}


- (void)createBgView{
    
    self.bgScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.bgScrollview.backgroundColor = [UIColor flatLightWhiteColor];
    self.bgScrollview.contentSize = CGSizeMake(self.view.width,self.view.height+200);
//    self.bgScrollview.pagingEnabled = YES;
    [self.view addSubview:self.bgScrollview];
    
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/3*2)];
    self.bgImageView.image = [UIImage imageNamed:@"HighGo_imageing"];
    self.bgImageView.backgroundColor = [UIColor whiteColor];
    self.bgImageView.userInteractionEnabled= YES;
    [self.bgScrollview addSubview:self.bgImageView];
    
    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 122, 25)];
    selectLabel.centerX = self.bgImageView.centerX;
    selectLabel.font = [UIFont systemFontOfSize:12];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.text = @"点击图片更换模板";
    selectLabel.textColor = [UIColor whiteColor];
    selectLabel.backgroundColor = [UIColor colorWithHex:0 alpha:0.6];
    selectLabel.layer.cornerRadius = 5;
    selectLabel.layer.masksToBounds = YES;
    [self.bgImageView addSubview:selectLabel];
    
    self.templateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.templateBtn.frame = CGRectMake(self.bgImageView.width-45-20, self.bgImageView.height-45-15, 45, 45);
    self.templateBtn.backgroundColor = [UIColor clearColor];
    [self.templateBtn setImage:[UIImage imageNamed:@"衣服icon"] forState:UIControlStateNormal];
    [self.templateBtn addTarget:self action:@selector(templateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:self.templateBtn];
    
    
    UIButton *template = [UIButton buttonWithType:UIButtonTypeCustom];
    template.frame = self.bgImageView.frame;
    template.backgroundColor = [UIColor clearColor];
    [template addTarget:self action:@selector(templateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:template];
    
    self.ruleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgImageView.bottom+10, self.view.width, 50)];
    self.ruleBgView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollview addSubview:self.ruleBgView];
    
    self.ruleTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    self.ruleTitle.font = [UIFont systemFontOfSize:14];
    self.ruleTitle.text = @"活动规则";
    [self.ruleBgView addSubview:self.ruleTitle];
    
    UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-25, 0, 10, 20)];
    imageView.centerY = self.ruleBgView.height/2;
    imageView.image = [UIImage imageNamed:@"箭头默认"];
    [self.ruleBgView addSubview:imageView];
    
    self.ruleStatus = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left-155, 0, 150, 50)];
    self.ruleStatus.textAlignment = NSTextAlignmentRight;
    self.ruleStatus.font = [UIFont systemFontOfSize:14];
    self.ruleStatus.text = @"当前未编辑";
    self.ruleStatus.textColor = [UIColor lightGrayColor];
    [self.ruleBgView addSubview:self.ruleStatus];
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(0, 0, self.ruleBgView.width, self.ruleBgView.height);
    self.editBtn.backgroundColor = [UIColor clearColor];
    [self.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ruleBgView addSubview:self.editBtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width, ScreenHeight*0.6);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.ruleBgView.bottom+10, self.view.width, ScreenHeight*0.6) collectionViewLayout:layout];
    
    int goodsNum = [self.goodsNum intValue];
    if ([self.layout isEqualToString:@"1"]) {
        
        switch (goodsNum) {
            case 1:
                goodsNum=1;
                break;
            case 2:
                goodsNum=1;
                break;
            case 4:
                goodsNum=2;
                break;
            case 6:
                goodsNum=3;
                break;
            default:
                break;
        }
        self.collectionView.size = CGSizeMake(self.view.width, 190*goodsNum);
    }else{
        self.collectionView.size = CGSizeMake(self.view.width, 115*goodsNum);
    }
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[YKLHighGoReleaseCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.bgScrollview addSubview:self.collectionView];
    
    self.releaseBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.collectionView.bottom+10, self.view.width, 60)];
    self.releaseBgView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollview addSubview:self.releaseBgView];

    self.releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.releaseBtn.frame = CGRectMake(10, 10, self.view.width-20, 40);
    self.releaseBtn.backgroundColor = [UIColor flatLightRedColor];
    [self.releaseBtn setTitle:@"确定发布" forState:UIControlStateNormal];
    [self.releaseBtn addTarget:self action:@selector(releaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.releaseBgView addSubview:self.releaseBtn];
    
    
    self.bgScrollview.contentSize = CGSizeMake(self.view.width,self.bgImageView.height+10+50+10+self.collectionView.height+10+60);
}


//===========================================================================================

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.goodsNum intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLHighGoReleaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.layoutNum = self.layout;
    NSMutableDictionary *cellDict = [[NSMutableDictionary alloc]init];
    
    if (self.isGoodsList) {
        
        if (!(self.actEndTime == nil)) {
            cell.timeLabel.textColor = [UIColor blackColor];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.actEndTime];
        }
        
        
        if ([self.goodsDict objectForKey:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row+1]]) {
            
            cellDict = [self.goodsDict objectForKey:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row+1]];
            
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.nameLabel.text = [cellDict objectForKey:@"name"];
            cell.goodsImageView.image = [UIImage imageWithData:[cellDict objectForKey:@"image"]];
            
            if ([cellDict objectForKey:@"id"]) {
                
//                NSArray *imageArr = [cellDict objectForKey:@"goods_img"];
//                if (![imageArr isEqual:@[]]) {
//                    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"Demo"]];
//                }
                cell.nameLabel.textColor = [UIColor blackColor];
                cell.nameLabel.text = [cellDict objectForKey:@"goods_name"];
            }
            
        }else{
            cell.nameLabel.textColor = [UIColor lightGrayColor];
            cell.nameLabel.text = @"点击编辑";
            cell.goodsImageView.image = [UIImage imageNamed:@"添加商品.png"];
        }
    }else{
        
        //收到活动ID加载
        if (!(self.activityID == NULL)) {
            if (self.actEndTime) {
                cell.timeLabel.textColor = [UIColor blackColor];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.actEndTime];
            }else{
                cell.timeLabel.textColor = [UIColor blackColor];
                NSString *endTime = [self.actDictionary objectForKey:@"end_time"];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@",[endTime timeNumber]];
            }
        }
        
        if ([self.goodsDict objectForKey:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row+1]]) {
            
            cellDict = [self.goodsDict objectForKey:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row+1]];
            
            //收到活动ID加载
            if (!(self.activityID == NULL)) {
                
                NSArray *imageArr = [cellDict objectForKey:@"goods_img"];
                if (![imageArr isEqual:@[]]) {
                    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"Demo"]];
                }
                cell.nameLabel.textColor = [UIColor blackColor];
                cell.nameLabel.text = [cellDict objectForKey:@"goods_name"];
            }else{
                
                //保存本地读取数据
                cell.goodsImageView.image = [UIImage imageWithData:[cellDict objectForKey:@"image"]];
                cell.nameLabel.textColor = [UIColor blackColor];
                cell.nameLabel.text = [cellDict objectForKey:@"name"];
                
                if (self.actEndTime) {
                    cell.timeLabel.textColor = [UIColor blackColor];
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.actEndTime];
                }
            }
            
        }else{
            cell.nameLabel.textColor = [UIColor lightGrayColor];
            cell.nameLabel.text = @"点击编辑";
            cell.goodsImageView.image = [UIImage imageNamed:@"添加商品.png"];
            
            if (self.actEndTime) {
                cell.timeLabel.textColor = [UIColor blackColor];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.actEndTime];
            }
            if ([cellDict objectForKey:@"image"]) {
                cell.goodsImageView.image = [UIImage imageWithData:[cellDict objectForKey:@"image"]];
            }
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.layout isEqualToString:@"1"]) {
        return CGSizeMake((self.collectionView.size.width-1)/2, 190);
    }else{
        return CGSizeMake(self.view.width, 115);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row+2);
    
    YKLHighGoGoodsEditViewController *editVC = [YKLHighGoGoodsEditViewController new];
    //    NSString *indexLong = [NSString stringWithFormat:@"产品详情%ld",(long)indexPath.row+1];
    //    editVC.titleText = [NSString stringWithFormat:@"%@",indexLong];
    editVC.cellNum = (long)indexPath.row+2;
    editVC.actID = self.activityID;
    
    editVC.goodsDictionary = [self.goodsDict objectForKey:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row+1]];
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}


//保存文件到本地
- (void)saveDictForFiled{
    
    if (self.activityID == NULL) {
        
        NSLog(@"%@",self.goodsDict);
        
        [_actDict setObject:self.goodsDict forKey:@"goods"];
        [YKLLocalUserDefInfo defModel].saveHighGoActInfoDict = _actDict;
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    
    
}

- (void)releaseBtnClick:(id)sender{
    
    //收到活动ID加载
    if (!(self.activityID == NULL)) {
        self.isDetailPop = YES;
        
    }else{
        self.isDetailPop = NO;
        [_actDict setObject:@"" forKey:@"tid"];
    }
    
    if (self.isAgainRealease) {
        [_actDict setObject:@"" forKey:@"tid"];
    }
    
    if (![_actDict objectForKey:@"coupon_end"]) {
        [UIAlertView showInfoMsg:@"请设置活动规则"];
        return;
    }
    
    NSString*couponString = [_actDict objectForKey:@"coupon_time"];
    NSArray *startArray = [couponString componentsSeparatedByString:@"-"];
    
    NSString*endString = [_actDict objectForKey:@"end"];
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    
    couponString = [startArray componentsJoinedByString:@""];
    endString = [endArray componentsJoinedByString:@""];
    
    int coupon = [couponString intValue];
    int end = [endString intValue];
    NSLog(@"%d--%d",coupon,end);
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    int today = [locationString intValue];
    
    if (coupon<today || end<today) {
        [UIAlertView showInfoMsg:@"活动结束时间已过期，请重新设置"];
        return;
    }
    
    NSMutableArray *goodsArray = [NSMutableArray array];
    for (int i = 0;i < _goodsDict.count; i++) {
        
        NSMutableDictionary *tempGoodsDict = [[NSMutableDictionary alloc]initWithDictionary:[_goodsDict objectForKey:[NSString stringWithFormat:@"cell%d",i+1]]];
        
        if ([tempGoodsDict objectForKey:@"image"]) {
            [tempGoodsDict removeObjectForKey:@"image"];//删除临时存储图像Image对象
        }
        
        if ([tempGoodsDict objectForKey:@"id"]) {
            
            [tempGoodsDict removeObjectForKey:@"id"];
            [tempGoodsDict removeObjectForKey:@"together_id"];
            
            NSString *img = [tempGoodsDict objectForKey:@"goods_img"];
            [tempGoodsDict removeObjectForKey:@"goods_img"];
            
            NSString *name = [tempGoodsDict objectForKey:@"goods_name"];
            [tempGoodsDict removeObjectForKey:@"goods_name"];
            
            NSString *note = [tempGoodsDict objectForKey:@"goods_note"];
            [tempGoodsDict removeObjectForKey:@"goods_note"];
            
            NSString *price = [tempGoodsDict objectForKey:@"goods_price"];
            [tempGoodsDict removeObjectForKey:@"goods_price"];
            
            NSString *joinNum = [tempGoodsDict objectForKey:@"count_need"];
            [tempGoodsDict removeObjectForKey:@"count_need"];
            
            
            [tempGoodsDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"sid"];
            [tempGoodsDict setObject:@"" forKey:@"gid"];
            [tempGoodsDict setObject:self.activityID forKey:@"tid"];
            
            [tempGoodsDict setObject:img forKey:@"img"];
            [tempGoodsDict setObject:name forKey:@"name"];
            [tempGoodsDict setObject:note forKey:@"note"];
            [tempGoodsDict setObject:price forKey:@"price"];
            [tempGoodsDict setObject:@"1" forKey:@"once"];
            [tempGoodsDict setObject:joinNum forKey:@"join_num"];
            
        }
        
        [goodsArray addObject:tempGoodsDict];
    }
    
    [_actDict setObject:self.goodsNum forKey:@"goods_num"];
    if (!(goodsArray.count == [[_actDict objectForKey:@"goods_num"]integerValue])) {
        [UIAlertView showInfoMsg:@"请设置商品信息"];
        return;
    }
    
    [_actDict setObject:goodsArray forKey:@"goods"];
    
    [_actDict setObject:self.tempID forKey:@"tmp_id"];
    [_actDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"sid"];
    [_actDict setObject:self.layout forKey:@"layout"];
    //    [_actDict setObject:self.goodsNum forKey:@"goods_num"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_actDict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
    
    //先注册后发布
    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
        
        [YKLNetworkingHighGo releaseActWithData:str Success:^(NSDictionary *dict) {
            
            //待发布发布不清空草稿箱
            if (self.activityID == NULL) {
                //清空本地数据
                _actDict = [NSMutableDictionary new];
                [YKLLocalUserDefInfo defModel].saveHighGoActInfoDict = [NSMutableDictionary new];
                [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            }
            
            self.payArray = [NSMutableArray array];
            
            self.orderStatus = [[dict objectForKey:@"state"]integerValue];
            self.content = [dict objectForKey:@"content"];
            self.totleMoney = [dict objectForKey:@"totleMoney"];
            self.payArray = [dict objectForKey:@"pay"];
            self.activityID = [dict objectForKey:@"tid"];
            
            NSDictionary *tempDict = [dict objectForKey:@"together"];
            self.shareImage = [tempDict objectForKey:@"share_img"];
            self.shareURL = [tempDict objectForKey:@"share_url"];
            self.shareTitle = [tempDict objectForKey:@"title"];
            self.shareDesc = [tempDict objectForKey:@"share_desc"];
            NSString *strName = [YKLLocalUserDefInfo defModel].userName;
            self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
            [YKLLocalUserDefInfo defModel].shareURL = self.shareURL;
            [YKLLocalUserDefInfo defModel].shareTitle = self.shareTitle;
            [YKLLocalUserDefInfo defModel].shareDesc = self.shareDesc;
            [YKLLocalUserDefInfo defModel].shareImage = self.shareImage;
            [YKLLocalUserDefInfo defModel].shareActType = @"一元抽奖";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
            if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                super.view.window.rootViewController = ShareVC;
                
            }else{
                
                if ([[dict objectForKey:@"pay"] isEqual:@""] || [[dict objectForKey:@"pay"] isEqual:@[]]) {
                    
                    YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                    ShareVC.hidenBar = YES;
                    ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                    ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                    ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                    ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                    ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                    super.view.window.rootViewController = ShareVC;
                    
                }else{
                    
                    YKLPayViewController *payVC = [YKLPayViewController new];
                    payVC.templateModel = dict;
                    payVC.activityID = self.activityID;
                    payVC.orderType = @"2";
                    payVC.isListDetailPop = self.isDetailPop;
                    [self.navigationController pushViewController:payVC animated:YES];
                    
                }
                
            }
            
            
        } failure:^(NSError *error) {
            [self saveDictForFiled];
            [UIAlertView showInfoMsg:error.domain];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
        
        [self saveDictForFiled];
        
        if ([[YKLLocalUserDefInfo defModel].agentCode isEqual:@""]) {
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }else{
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            
            loginVC.agentIDField.enabled = NO;
            loginVC.agentIDField.text = [YKLLocalUserDefInfo defModel].agentCode;
            loginVC.agentIDField.textColor = [UIColor lightGrayColor];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)editBtnClick:(id)sender{
    NSLog(@"点击了==--编辑活动规则--==按钮");
    
    YKLHighGoEditActRuleViewController *ruleVC = [YKLHighGoEditActRuleViewController new];
    
    //    //收到活动ID加载
    //    if (!(self.activityID == NULL)) {
    ruleVC.actDictionary = self.actDict;
    ruleVC.actID = self.activityID;
    //    }
    [self.navigationController pushViewController:ruleVC animated:YES];
    
}

- (void)templateBtnClick:(id)sender{
    NSLog(@"点击了==--模板选择--==按钮");
    
    YKLHighGoTemplateViewController *tempVC = [YKLHighGoTemplateViewController new];
    [self.navigationController pushViewController:tempVC animated:YES];
    
}

- (void)refreshList {
    self.page = 0;
    [self requestMoreOrder];
}

- (NSArray *)indexPathsWithStart:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *arIndex = [NSMutableArray array];
    for (NSInteger i=start; i<end; i++) {
        [arIndex addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return [arIndex copy];
}

- (void)requestMoreOrder {
    self.page += 1;
    if (self.page == 1) {
        NSLog(@"进行中分类");
    }
    self.view.userInteractionEnabled = YES;
}

- (void)showHelpView{
    
    if (_PopupView.isClose) {
        
        [_PopupView hideRechargeAlertBgView];
        
    }else{
        
        [_PopupView createView:@{
                                 @"imgName":@"higoHelp",
                                 @"imgFram":@[@10, @10, @300, @350],
                                 @"closeBtn":@"higoClose",
                                 @"btnFram":@[@(310-18), @5, @23, @23]
                                 }];
        [self.view addSubview:_PopupView];
    }
}

@end
