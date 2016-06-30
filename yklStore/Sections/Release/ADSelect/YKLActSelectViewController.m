//
//  YKLActSelectViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/17.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLActSelectViewController.h"
#import "YKLReleaseTypeViewController.h"
#import "YKLReleaseViewController.h"
#import "YKLPushWebViewController.h"
#import "YKLHighGoTemplateViewController.h"
//#import "YKLHighGoRealeaseViewController.h"
#import "YKLHighGoRealeaseMainViewController.h"
#import "YKLPosterTypeViewController.h"
#import "YKLGetADModel.h"
#import "YKLHighGoReleaseCollectionViewCell.h"
#import "YKLPrizesReleaseViewController.h"
#import "YKLDuoBaoReleaseViewController.h"
#import "YKLVipPayIntroViewController.h"
#import "YKLMiaoShaReleaseViewController.h"
#import "YKLSuDingReleaseViewController.h"
#import "YKLPopupView.h"
#import "YKLLoginViewController.h"

#import "WYScrollView.h"

#define kBtnImageKey        @"kBtnImageKey"
#define kBtnTitleKey        @"kBtnTitleKey"

/*
@interface YKLActSelectCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YKLActSelectCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5,5,self.contentView.width-10,self.contentView.height-10);

}

@end
*/



@interface YKLActSelectViewController ()<WYScrollViewLocalDelegate,WYScrollViewNetDelegate>//UICollectionViewDataSource, UICollectionViewDelegate,
{
    NSURL *callURL;
    UIWebView *callView;
}

@property (nonatomic, strong) YKLGetADModel *adModel;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *adModelArr;

@property (nonatomic, strong) UIView *bgImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property int singelTap;

@property (nonatomic, strong) WYScrollView *ADView;

@property (nonatomic, strong) YKLPopupView *PopupView;

@end

@implementation YKLActSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动选择";
    
    self.view.backgroundColor = [UIColor whiteColor];

    //ScreenHeight*0.3+64
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-ScreenHeight*0.563+30, self.view.width, ScreenHeight*0.563-30)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"] || [[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        
        self.bgView.top = self.view.height-ScreenHeight*0.563;
        
        
    }
    else
    {
        self.bgView.top = self.view.height-ScreenHeight*0.563+30;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bgView.top-30, self.view.width, 30)];
        imageView.image = [UIImage imageNamed:@"推荐"];
        [self.view addSubview:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = imageView.frame;
        [button addTarget:self action:@selector(VipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(45, 7, 200, 16)];
        imageView2.image = [UIImage imageNamed:@"推荐文案"];
        [imageView addSubview:imageView2];
    }
    
    NSInteger aX = 0;
    NSInteger aY = 0;
    NSInteger aWidth = (ScreenWidth)/4;
    UIColor *lineColor = HEXCOLOR(0xefefef);
    
    // 第一部分
    {
        {
            UIImageView *hdBGIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 103, 20)];
            hdBGIV.image = [UIImage imageNamed:@"hd_bg"];
            [_bgView addSubview:hdBGIV];
            
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
            aLabel.textColor = [UIColor whiteColor];
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = @"平台游戏";
            [hdBGIV addSubview:aLabel];
        }
        
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-92-7, 0, 92, 20)];
            aLabel.textAlignment = NSTextAlignmentRight;
            aLabel.textColor = HEXCOLOR(0x323232);
            aLabel.font = [UIFont systemFontOfSize:11];
            aLabel.text = @"什么是平台游戏";
            [_bgView addSubview:aLabel];
            aLabel.userInteractionEnabled = YES;
            {
                UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(tipPTYX)];
                [aLabel addGestureRecognizer:aTap];
            }
            
            UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 16, 16)];
            tipIV.image = [UIImage imageNamed:@"hd_question"];
            [aLabel addSubview:tipIV];
        }
        
        
        NSArray *firstArr = @[
                              @{ kBtnTitleKey   : @"秒杀",
                                 kBtnImageKey   : [UIImage imageNamed:@"ptyx_ms"]},
                              @{ kBtnTitleKey   : @"一元速定",
                                 kBtnImageKey   : [UIImage imageNamed:@"ptyx_sd"]},
                              @{ kBtnTitleKey   : @"一元抽奖",
                                 kBtnImageKey   : [UIImage imageNamed:@"ptyx_cj"]},
                              @{ kBtnTitleKey   : @"集赞海报",
                                 kBtnImageKey   : [UIImage imageNamed:@"ptyx_jz"]},
                              @{ kBtnTitleKey   : @"口袋红包",
                                 kBtnImageKey   : [UIImage imageNamed:@"ptyx_hb"]},
                              ];
        //一行5个 不足空白
        NSInteger line, row;
        for (int i = 0; i < 5; i++)
        {
            line    = i / 4;
            row     = i % 4;
            aX = aWidth * row;
            aY = 20 + aWidth * line;
            
            NSDictionary *aDict = firstArr[i];
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.layer.borderWidth = 0.5;
            aBtn.layer.borderColor = lineColor.CGColor;
            aBtn.tag = 100 + i;
            aBtn.frame = CGRectMake(aX, aY, aWidth+0.5, aWidth+0.5);
            [aBtn addTarget:self action:@selector(actionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:aBtn];
            
            if (i == 1) {
                
                UIImageView *hotImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HOT"]];
                hotImage.frame = CGRectMake(aWidth+0.5-23, 0, 23, 23);
                [aBtn addSubview:hotImage];
                
            }
            
            // add image and label
            {
                UIImageView *aIV = [[UIImageView alloc] initWithFrame:CGRectMake(22.5, 13, 35, 35)];
                aIV.image = aDict[kBtnImageKey];
                [aBtn addSubview:aIV];
                
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, aWidth, 15)];
                aLabel.textAlignment = NSTextAlignmentCenter;
                aLabel.textColor = HEXCOLOR(0x323232);
                aLabel.font = [UIFont systemFontOfSize:13];
                aLabel.text = aDict[kBtnTitleKey];
                [aBtn addSubview:aLabel];
            }
        }
    }
    
    // 第二部分
    {
        //NSInteger yOffset = 110;
        NSInteger yOffset = 190;
        {
            UIImageView *hdBGIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+yOffset, 103, 20)];
            hdBGIV.image = [UIImage imageNamed:@"hd_bg"];
            [_bgView addSubview:hdBGIV];
            
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
            aLabel.textColor = [UIColor whiteColor];
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = @"门店定制";
            [hdBGIV addSubview:aLabel];
        }
        
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-92-7, 0+yOffset, 92, 20)];
            aLabel.textAlignment = NSTextAlignmentRight;
            aLabel.textColor = HEXCOLOR(0x323232);
            aLabel.font = [UIFont systemFontOfSize:11];
            aLabel.text = @"什么是门店定制";
            [_bgView addSubview:aLabel];
            aLabel.userInteractionEnabled = YES;
            {
                UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(tipMDDZ)];
                [aLabel addGestureRecognizer:aTap];
            }
            
            UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 16, 16)];
            tipIV.image = [UIImage imageNamed:@"hd_question"];
            [aLabel addSubview:tipIV];
        }
        
        NSArray *firstArr = @[
                              @{ kBtnTitleKey   : @"全民砍价",
                                 kBtnImageKey   : [UIImage imageNamed:@"mddz_kj"]},
                              @{ kBtnTitleKey   : @"口袋夺宝",
                                 kBtnImageKey   : [UIImage imageNamed:@"mddz_db"]},
                              ];
        //一行5个 不足空白
        NSInteger line, row;
        for (int i = 0; i < 2; i++)
        {
            line    = i / 4;
            row     = i % 4;
            aX = aWidth * row;
            aY = 20 + aWidth * line + yOffset;
            
            NSDictionary *aDict = firstArr[i];
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.layer.borderWidth = 0.5;
            aBtn.layer.borderColor = lineColor.CGColor;
            aBtn.tag = 100 + i + 5;
            aBtn.frame = CGRectMake(aX, aY, aWidth+0.5, aWidth+0.5);
            [aBtn addTarget:self action:@selector(actionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:aBtn];
            
            // add image and label
            {
                UIImageView *aIV = [[UIImageView alloc] initWithFrame:CGRectMake(22.5, 13, 35, 35)];
                aIV.image = aDict[kBtnImageKey];
                [aBtn addSubview:aIV];
                
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, aWidth, 15)];
                aLabel.textAlignment = NSTextAlignmentCenter;
                aLabel.textColor = HEXCOLOR(0x323232);
                aLabel.font = [UIFont systemFontOfSize:13];
                aLabel.text = aDict[kBtnTitleKey];
                [aBtn addSubview:aLabel];
            }
        }
    }

    
    /*
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width, ScreenHeight*0.563-1);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 10, self.view.width-24, ScreenHeight*0.563-1) collectionViewLayout:layout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YKLActSelectCell class] forCellWithReuseIdentifier:@"cell"];
    [self.bgView addSubview:self.collectionView];
     
     if (![[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        if ([[YKLLocalUserDefInfo defModel].actTypeHelp isEqualToString:@"YES"]) {
        self.singelTap = 0;
        [self createFirstView];
        }
     }
     
     */
    
    
    //加载的数据
    self.imgArray = [NSMutableArray array];
    self.adModelArr = [NSMutableArray array];
    
    
    [YKLNetworkingConsumer getADWithName:@"index_head_ad" Type:@"1" Success:^(NSArray *fansModel) {
        self.adModelArr = [NSMutableArray arrayWithArray:fansModel];
        
        for (int i = 0; i < fansModel.count; i++) {
            self.adModel =fansModel[i];
        
            [self.imgArray addObject:self.adModel.adImg];
        }
        
        /** 创建网络滚动视图*/
        [self createNetScrollView];
        
    } failure:^(NSError *error) {
        
    }];
    
    

    
}

-(void)createNetScrollView
{
    /** 设置网络scrollView的Frame及所需图片*/
    self.ADView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, ScreenHeight*0.3)];
    
    [self.ADView reloadImageWith:self.imgArray];
    
    /** 设置滚动延时*/
    self.ADView.AutoScrollDelay = 4;
    
    /** 设置占位图*/
    self.ADView.placeholderImage = [UIImage imageNamed:@""];
    
    
    /** 获取网络图片的index*/
    self.ADView.netDelagate = self;
    
    /** 添加到当前View上*/
    [self.view addSubview:self.ADView];
    
}

/** 获取网络图片的index*/
-(void)didSelectedNetImageAtIndex:(NSInteger)index
{
    NSLog(@"点中网络图片的下标是:%ld",(long)index);
    
    YKLGetADModel *adModel = self.adModelArr[index];
    NSLog(@"%@，%@",adModel.title,adModel.link);
    
    
    if ([adModel.jumpType isEqual:@"2"]){
        
        YKLPushWebViewController *webVC = [YKLPushWebViewController new];
        webVC.hidenBar = NO;
        webVC.webURL = adModel.link;
        webVC.webTitle = adModel.title;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    else if([adModel.jumpType isEqual:@"1"]){
        
        if ([adModel.link isEqual:@"vip_pay"]) {
            YKLVipPayIntroViewController *vc = [YKLVipPayIntroViewController new];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 定时滚动scrollView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.ADView setUpTimer];
}

-(void)viewWillDisappear:(BOOL)animated{  
    [super viewWillDisappear:animated];
    
    [self.ADView removeTimer];
    
}

- (void)VipBtnClick{
    
    YKLVipPayIntroViewController *vc = [YKLVipPayIntroViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/*
- (void)createFirstView{
    
    self.bgImageView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImageView];
    
    self.firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"活动类型1"]];
    self.firstImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.firstImageView];
    
    self.secondImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"活动类型2"]];
    self.secondImageView.hidden = YES;
    self.secondImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.secondImageView];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.bgImageView addGestureRecognizer:singleTap];
}


- (void)singleTap:(UITapGestureRecognizer *)sender{

    self.singelTap++;
    if (self.singelTap == 1) {
        self.secondImageView.hidden = NO;
    }
    if (self.singelTap == 2) {
        self.firstImageView.hidden = YES;
        self.secondImageView.hidden = YES;
        self.bgImageView.hidden = YES;
        [YKLLocalUserDefInfo defModel].actTypeHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKLActSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor clearColor];

    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"suding_icon"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"DuoBao_icon"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"一起嗨购"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"全民砍价"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"口袋红包"];
            break;
        case 5:
            cell.imageView.image = [UIImage imageNamed:@"Poster_icon"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.collectionView.size.width-2-2)/3, (self.collectionView.size.height-24-12)/3-3);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%ld",(long)indexPath.row);
    YKLHighGoTemplateViewController *tempVC = [YKLHighGoTemplateViewController new];
    YKLHighGoRealeaseMainViewController *realeaseTempVC = [YKLHighGoRealeaseMainViewController new];
   

    
    int purnum;
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[YKLSuDingReleaseViewController new] animated:YES];
            
            break;
        case 1:
            
            purnum = [[[YKLLocalUserDefInfo defModel].purview substringWithRange:NSMakeRange(3,1)] intValue];
            
            if (purnum == 0) {
                
                [UIAlertView showInfoMsg:@"口袋客为了让门店实现更好的营销体验，此活动需对接到门店公众号，进行独立部署，方可进行；联系客服，我们为您将门店活动直接与门店公众号进行对接，并为您匹配门店独立的域名！只要进行一次对接，便可享受口袋客简单的操作和独立部署带来的更稳定服务！具体请咨询：18390811334 小文"];
                
            }
            else if (purnum == 1){
                
                [self.navigationController pushViewController:[YKLDuoBaoReleaseViewController new] animated:YES];
            }
            
            break;
        case 2:
            
            if (![[YKLLocalUserDefInfo defModel].saveHighGoActInfoDict isEqual:@{}]){
                
                [self.navigationController pushViewController:realeaseTempVC animated:YES];
                return;
            }
            tempVC.firstIn = YES;
            [self.navigationController pushViewController:tempVC animated:YES];
            
            break;
        case 3:
        
            purnum = [[[YKLLocalUserDefInfo defModel].purview substringWithRange:NSMakeRange(2,1)] intValue];
            
            if (purnum == 0) {
                
                [UIAlertView showInfoMsg:@"口袋客为了让门店实现更好的营销体验，此活动需对接到门店公众号，进行独立部署，方可进行；联系客服，我们为您将门店活动直接与门店公众号进行对接，并为您匹配门店独立的域名！只要进行一次对接，便可享受口袋客简单的操作和独立部署带来的更稳定服务！具体请咨询：18390811334 小文"];
                
            }
            else if (purnum == 1){
                
//                [self.navigationController pushViewController:[YKLReleaseTypeViewController new] animated:YES];
                
                YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
                releaseVC.typePushStr = @"到店模式";
                releaseVC.typePushNub = @"1";
                releaseVC.activityIngHidden = YES;
                
                [self.navigationController pushViewController:releaseVC animated:YES];
            }
            
            break;
        case 4:
            [self.navigationController pushViewController:[YKLPrizesReleaseViewController new] animated:YES];
            
            break;
        case 5:
            [self.navigationController pushViewController:[YKLPosterTypeViewController new] animated:YES];
            
            break;
            
        default:
            break;
    }

}
*/


#pragma mark -

- (void)actionBtnClicked:(UIButton *)aBtn
{
    NSInteger tagInt = aBtn.tag - 100;

    YKLHighGoTemplateViewController *tempVC = [YKLHighGoTemplateViewController new];
    YKLHighGoRealeaseMainViewController *realeaseTempVC = [YKLHighGoRealeaseMainViewController new];

    switch (tagInt)
    {
        case 0:
            
            if ([self pushCtrlWithRange:8]) {
                [self.navigationController pushViewController:[YKLMiaoShaReleaseViewController new] animated:YES];
            }
            break;
            
        case 1:
            
            if ([self pushCtrlWithRange:4]) {
                [self.navigationController pushViewController:[YKLSuDingReleaseViewController new] animated:YES];
            }
            break;
            
        case 2:
            
            if ([self pushCtrlWithRange:5]) {
                
                if (![[YKLLocalUserDefInfo defModel].saveHighGoActInfoDict isEqual:@{}]){
                    [self.navigationController pushViewController:realeaseTempVC animated:YES];
                    return;
                }
                tempVC.firstIn = YES;
                [self.navigationController pushViewController:tempVC animated:YES];
                
            }
            break;
            
        case 3:
            
            if ([self pushCtrlWithRange:6]) {
                [self pushPosterView];
            }
            
            break;
            
        case 4:
            
            if ( [self pushCtrlWithRange:7]) {
                [self.navigationController pushViewController:[YKLPrizesReleaseViewController new] animated:YES];
            }
            
            break;
        case 5:
            
            if ([self pushCtrlWithRange:2]) {
                
                YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
                releaseVC.typePushStr = @"到店模式";
                releaseVC.typePushNub = @"1";
                releaseVC.activityIngHidden = YES;
                [self.navigationController pushViewController:releaseVC animated:YES];
            }
            
            break;
        case 6:
            
            if ( [self pushCtrlWithRange:3]) {
                [self.navigationController pushViewController:[YKLDuoBaoReleaseViewController new] animated:YES];
            }
            
            break;
        default:
            break;
    }
}

//权限位控制方法
- (BOOL)pushCtrlWithRange:(int)range{
    
    int purnum = [[[YKLLocalUserDefInfo defModel].purview substringWithRange:NSMakeRange(range,1)] intValue];
    if (purnum == 0) {
        [UIAlertView showInfoMsg:@"口袋客为了让门店实现更好的营销体验，此活动需对接到门店公众号，进行独立部署，方可进行；联系客服，我们为您将门店活动直接与门店公众号进行对接，并为您匹配门店独立的域名！只要进行一次对接，便可享受口袋客简单的操作和独立部署带来的更稳定服务！具体请咨询：18390811334 小文"];
        return NO;
    }
    else{
        return YES;
    }
}

- (void)tipPTYX
{
    NSLog(@"tipPTYX");

    _PopupView = [[YKLPopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_PopupView createView:@{
                             @"imgName":@"pingtaiyouxi",
                             @"imgFram":@[@10, @10, @300, @300],
                             @"closeBtn":@"ptyx_close",
                             @"btnFram":@[@(300-20), @20, @22, @22]
                             }];
    [self.view addSubview:_PopupView];
}

- (void)tipMDDZ
{
    NSLog(@"tipMDDZ");

    _PopupView = [[YKLPopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_PopupView createView:@{
                             @"imgName":@"mendiandingzhi",
                             @"imgFram":@[@10, @10, @300, @300],
                             @"closeBtn":@"mddz_close",
                             @"btnFram":@[@(300-20), @20, @22, @22]
                             }];
    [self.view addSubview:_PopupView];
}

- (void)pushPosterView
{
    
    if ([[YKLLocalUserDefInfo defModel].shopQRCode isEqual:@""]) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在加载商户信息";
        
        if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
            [YKLNetworkingConsumer getShopInfoWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLShopInfoModel *shopInfoDic) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                YKLLoginViewController *loginVC = [YKLLoginViewController new];
                [loginVC registTitleBtnClicked];
                loginVC.title = @"商户信息";
                
                //打开隐藏开关
                loginVC.upView.hidden = loginVC.registLabel.hidden = YES;
                loginVC.agentNameField.hidden = loginVC.agentMobileField.hidden = loginVC.agentNameLabel.hidden = loginVC.agentMobileLabel.hidden = NO;
                
                UIColor *unchangedColor = [UIColor lightGrayColor];
                loginVC.storeNameField.enabled = loginVC.streetAddressField.enabled = loginVC.addIDImageBtn.enabled = loginVC.agentIDField.enabled = loginVC.agentNameField.enabled = loginVC.agentMobileField.enabled = NO;
                
                loginVC.loginNum.text = shopInfoDic.mobile;
                loginVC.storeNameField.text = shopInfoDic.shopName;
                loginVC.storeNameField.textColor = unchangedColor;
                
                NSArray *addressArray = [shopInfoDic.address componentsSeparatedByString:@","];
                loginVC.locationBtn.hidden = YES;
                loginVC.provinceBtn.hidden = loginVC.cityBtn.hidden = loginVC.townBtn.hidden = NO;
                loginVC.provinceBtn.enabled = loginVC.cityBtn.enabled = loginVC.townBtn.enabled = NO;
                [loginVC.provinceBtn setTitleColor:unchangedColor forState:UIControlStateNormal];
                [loginVC.cityBtn setTitleColor:unchangedColor forState:UIControlStateNormal];
                [loginVC.townBtn setTitleColor:unchangedColor forState:UIControlStateNormal];
                [loginVC.provinceBtn setTitle:addressArray[0] forState:UIControlStateNormal];
                
                if (addressArray.count>1) {
                    [loginVC.cityBtn setTitle:addressArray[1] forState:UIControlStateNormal];
                }else{
                    loginVC.cityBtn.hidden = YES;
                    loginVC.townBtn.hidden = YES;
                }
                if (addressArray.count>2) {
                    [loginVC.townBtn setTitle:addressArray[2] forState:UIControlStateNormal];
                }else{
                    loginVC.townBtn.hidden = YES;
                }
                
                loginVC.streetAddressField.text = shopInfoDic.street;
                loginVC.streetAddressField.textColor = unchangedColor;
                
                /*
                 *可更改内容
                 *************************************************/
                loginVC.teleField.text = shopInfoDic.servicTel;
                loginVC.contactsField.text = shopInfoDic.lianxiren;
                /**************************************************/
                
                loginVC.addIDImageBtn.hidden = YES;
                loginVC.addBusinessImageBtn.hidden = YES;
                [loginVC.addQRCodeImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [loginVC.idImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoDic.identityCard] placeholderImage:[UIImage imageNamed:@"Demo"]];
                [loginVC.businessImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoDic.license] placeholderImage:[UIImage imageNamed:@"Demo"]];
                
                if (![shopInfoDic.shopQRCode isBlankString]) {
                    [loginVC.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoDic.shopQRCode] placeholderImage:[UIImage imageNamed:@"Demo"]];
                }else{
                    [loginVC.addQRCodeImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
                }
                
                loginVC.agentIDField.text = shopInfoDic.agentCode;
                loginVC.agentIDField.textColor = unchangedColor;
                
                loginVC.agentNameField.text = shopInfoDic.agentName;
                loginVC.agentNameField.textColor = unchangedColor;
                
                loginVC.agentMobileField.text = shopInfoDic.agentMobile;
                loginVC.agentMobileField.textColor = [UIColor flatLightBlueColor];
                
                callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",shopInfoDic.agentMobile]];
                
                UIButton *contactUs = [UIButton buttonWithType:UIButtonTypeCustom];
                contactUs.backgroundColor = [UIColor clearColor];
                contactUs.frame = loginVC.agentMobileField.frame;
                [contactUs addTarget:self action:@selector(contactUsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [loginVC.bgView addSubview:contactUs];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                
            } failure:^(NSError *error) {
                
                [UIAlertView showErrorMsg:error.domain];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
            
        }else{
            
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
    else
    {
        
        [self.navigationController pushViewController:[YKLPosterTypeViewController new] animated:YES];

    }
    
}

- (void)contactUsBtnClicked:(id)sender
{
    
    if (callView == nil) {
        callView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [callView loadRequest:[NSURLRequest requestWithURL:callURL]];
}

@end
