//
//  YKLHighGoTemplateViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoTemplateViewController.h"
#import "YKLReleaseModelTableViewCell.h"
//#import "YKLHighGoRealeaseViewController.h"
#import "YKLHighGoRealeaseMainViewController.h"
#import "YKLSpecialModelViewController.h"
#import "YKLPushWebViewController.h"
#import "YKLNoneSpecialModelViewController.h"

@implementation YKLHighGoTemplateView

- (instancetype)initWithFrame:(CGRect)frame
                     TempCode:(NSString *)tempCode{
    if (self = [super initWithFrame:frame]) {
        
        _tempCateIDStr = kTemplateFakeIDStr;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLReleaseModelTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.TemplateArr = [NSMutableArray array];
        self.tempCode = tempCode;
        
        [self requestMoreOrder];
    }
    return self;
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
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.userInteractionEnabled = YES;
    [self.tableView startLoad];
    
    [self getActivitylist];
}

- (void)showEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
    
    _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 568)];
    _emptyImageView.image = [UIImage imageNamed:@"no_data"];
    [self addSubview:_emptyImageView];
}

- (void)removeEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
}

- (void)getActivitylist
{
    [YKLNetworkingHighGo getHighGoTemplateWithTempCode:self.tempCode
                                                cateID:_tempCateIDStr
                                               Success:^(NSArray *templateModel)
     {
        NSLog(@"%@",templateModel);
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
         [self removeEmptyView];

        if (templateModel.count == 0)
        {
            self.tableView.loadMoreEnable = NO;
            [self showEmptyView];
            if (self.tempCode.length)
            {
                [self.delegate noneTemplateListView];
            }
        }
        else
        {
            [self.delegate TemplateListView];
        }
         
//         [self.TemplateArr addObjectsFromArray:templateModel];
//        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.TemplateArr.count-templateModel.count end:self.TemplateArr.count]
//                              withRowAnimation:UITableViewRowAnimationAutomatic];

         {
             [self.TemplateArr removeAllObjects];
             [self.TemplateArr addObjectsFromArray:templateModel];
             
             [self.tableView reloadData];
         }
         
         
        [self.tableView endLoad];
    }
                                               failure:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.userInteractionEnabled = YES;
        [UIAlertView showErrorMsg:error.domain];
    }];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.TemplateArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 188-35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"Cell";
    YKLReleaseModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YKLReleaseModelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.TemplateArr.count){
        self.templateModel = self.TemplateArr[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"标题：%@",self.templateModel.templateName];
        cell.priceNubLabel.text = [NSString stringWithFormat:@"¥%@", self.templateModel.templateMoney];
        cell.explainMoreLabel.text = self.templateModel.templateDesc;
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.templateModel.templateImage] placeholderImage:[UIImage imageNamed:@"Demo"]];
        [cell.imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageBtn.tag = indexPath.row;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"xxx%ld",(long)indexPath.row);
    
    [self.delegate consumerTemplateListView:self didSelectOrder:self.TemplateArr[indexPath.row]];
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}

- (void)imageBtnClick:(UIButton *)sender{
    self.templateModel = self.TemplateArr[sender.tag];
    NSLog(@"%@",self.templateModel.templateThumb);
    
    [self.delegate  preViewTemplateListView:self.templateModel.templateThumb];
}

@end


@interface YKLHighGoTemplateViewController ()<YKLHighGoTemplateViewDelegate,CustomIOSAlertViewDelegate>
{
    NSArray         *_cateListArr;
    UIButton        *_selectedBtn;
    UIImageView     *_rightTipIV;
    UIScrollView    *_cateHorizontalScrollView;
    NSString        *_currentCateIDStr;
    
    UIScrollView    *_cateVerticalScrollView;
    BOOL            _isShowingList;
    UIImageView     *_checkIV;
    UIView          *_tipTextView;
}
@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

@property (nonatomic, strong) NSString *tempCode;

@end

@implementation YKLHighGoTemplateViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"模板选择";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"口令模板" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor flatLightBlueColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sendCategoryListRequest];
    
    [self createScrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, self.contentView.width, self.contentView.height - 40)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.bounces = NO;
    
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueFaceChanged:0 TempCode:@""];
}

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode
{
    YKLHighGoTemplateView *releaseTemplateView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment]];
    [self.scrollView setContentOffset:CGPointMake(segment*self.scrollView.width, 0) animated:YES];
    
    if (segment == 0)
    {
        releaseTemplateView = [[YKLHighGoTemplateView alloc] initWithFrame:CGRectMake(segment*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)
                                                                  TempCode:@""];
    }
    else if (segment == 1)
    {
        
        releaseTemplateView = [[YKLHighGoTemplateView alloc] initWithFrame:CGRectMake(segment*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)
                                                                  TempCode:tempCode];
    }
    
    releaseTemplateView.delegate = self;
    releaseTemplateView.tag = kTemplateViewTag;
    
    [self.scrollView addSubview:releaseTemplateView];
    [self.orderListDictionary setObject:releaseTemplateView forKey:[NSNumber numberWithInteger:segment]];
}

- (void)rightBarClicked{
    
    YKLSpecialModelViewController *spVC = [YKLSpecialModelViewController new];
    spVC.actName = @"一元抽奖";
    [self.navigationController pushViewController:spVC animated:YES];
    
}

- (void)preViewTemplateListView:(NSString *)url{
    
    YKLPushWebViewController *pushVC = [YKLPushWebViewController new];
    pushVC.webURL = url;
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

//未找到特殊模板
- (void)noneTemplateListView{
    
    YKLNoneSpecialModelViewController *vc = [YKLNoneSpecialModelViewController new];
    vc.actName = @"一元抽奖";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.scrollView.scrollEnabled = NO;
}

//找到特殊模板
- (void)TemplateListView{
    
    self.scrollView.scrollEnabled = YES;
}

- (void)consumerTemplateListView:(YKLHighGoTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model{
    
    NSLog(@"%@=>%@=>%@",model.templateName,model.templateMoney,model.templateThumb);
    
    self.model = model;
    [self createAlertView:[self createTemplateView]];
    
//    if (self.firstIn) {
//        
//        YKLHighGoRealeaseViewController *releaseVC = [YKLHighGoRealeaseViewController new];
//        releaseVC.layout = model.layout;
//        releaseVC.goodsNum = @"3";
//        releaseVC.imageURL = model.bgImage;
//        releaseVC.tempID = model.templateID;
//        [self.navigationController pushViewController:releaseVC animated:YES];
//        
//    }else{
//        
//        //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
//        YKLHighGoRealeaseViewController *releaseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//        NSLog(@"%@,%@",model.layout,model.goodsNum);
//        releaseVC.layout = model.layout;
//        releaseVC.goodsNum = @"2";
//        releaseVC.imageURL = model.templateImage;
//         releaseVC.tempID = model.bgImage;
//        //使用popToViewController返回并传值到上一页面
//        [self.navigationController popToViewController:releaseVC animated:YES];
//    }
    
    
}
- (void)createAlertView:(UIView *)createView{
    
    self.rechargeAlertView = [[CustomIOSAlertView alloc] init];
    [self.rechargeAlertView setContainerView:createView];
//    [self.rechargeAlertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [self.rechargeAlertView setDelegate:self];
    [self.rechargeAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];

    [self.rechargeAlertView setUseMotionEffects:true];
    [self.rechargeAlertView show];
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (buttonIndex==1) {
        NSLog(@"oooo");
    }
    [alertView close];
}


- (UIView *)createTemplateView
{
    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 264, 230)];
    self.rechargeAlertBgView.backgroundColor = [UIColor whiteColor];
    self.rechargeAlertBgView.layer.cornerRadius = 7;
    self.rechargeAlertBgView.layer.masksToBounds = YES;
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake(264-30-5,5,25,25);
    [self.closeBtn addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.closeBtn];
    
    self.rechargeAlertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.rechargeAlertTitleLabel.centerX = self.rechargeAlertBgView.width/2;
    self.rechargeAlertTitleLabel.font = [UIFont systemFontOfSize: 17.0];
    //        self.rechargeAlertTitleLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertTitleLabel.textColor = [UIColor flatLightBlueColor];
    self.rechargeAlertTitleLabel.text = @"模板设置";
    self.rechargeAlertTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.rechargeAlertBgView addSubview:self.rechargeAlertTitleLabel];
    
    self.modelLayoutLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 30,self.rechargeAlertBgView.width-20, 46)];
    self.modelLayoutLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertActivityLabel.backgroundColor = [UIColor redColor];
    self.modelLayoutLabel.textColor = [UIColor blackColor];
    self.modelLayoutLabel.text = @"请选择模板排列方式";
    [self.rechargeAlertBgView addSubview:self.modelLayoutLabel];
    
    self.crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crossBtn.tag = 4001;
    self.crossBtn.frame = CGRectMake(20, self.modelLayoutLabel.bottom+5, 15, 15);
    [self.crossBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.crossBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.crossBtn addTarget:self action:@selector(layoutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.crossBtn.selected = YES;
    [self.rechargeAlertBgView addSubview:self.crossBtn];
    
    self.rechargeAlertCrossLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.crossBtn.right+5, self.modelLayoutLabel.bottom,60, 26)];
    self.rechargeAlertCrossLabel.font = [UIFont systemFontOfSize: 14.0];
//    self.rechargeAlertCrossLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertCrossLabel.textColor = [UIColor blackColor];
    self.rechargeAlertCrossLabel.text = @"横向排列";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertCrossLabel];
    
    self.crossImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ModelCross.png"]];
    self.crossImageView.frame = CGRectMake(self.rechargeAlertCrossLabel.right+5, self.rechargeAlertCrossLabel.top, 15, 25);
    [self.rechargeAlertBgView addSubview:self.crossImageView];
    
    self.verticalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.verticalBtn.tag = 4002;
    self.verticalBtn.frame = CGRectMake(self.crossImageView.right+30, self.modelLayoutLabel.bottom+5, 15, 15);
    [self.verticalBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.verticalBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.verticalBtn addTarget:self action:@selector(layoutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.verticalBtn.selected = YES;
    [self.rechargeAlertBgView addSubview:self.verticalBtn];
    
    self.rechargeAlertVerticalLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.verticalBtn.right+5, self.modelLayoutLabel.bottom,60, 26)];
    self.rechargeAlertVerticalLabel.font = [UIFont systemFontOfSize: 14.0];
//    self.rechargeAlertVerticalLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertVerticalLabel.textColor = [UIColor blackColor];
    self.rechargeAlertVerticalLabel.text = @"纵向排列";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertVerticalLabel];
    
    self.verticalImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ModelVertical.png"]];
    self.verticalImageView.frame = CGRectMake(self.rechargeAlertVerticalLabel.right+5, self.rechargeAlertVerticalLabel.top, 15, 25);
    [self.rechargeAlertBgView addSubview:self.verticalImageView];
    
    self.goodsNumLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rechargeAlertCrossLabel.bottom,self.rechargeAlertBgView.width-20, 46)];
    self.goodsNumLabel.font = [UIFont systemFontOfSize: 14.0];
//    self.goodsNumLabel.backgroundColor = [UIColor redColor];
    self.goodsNumLabel.textColor = [UIColor blackColor];
    self.goodsNumLabel.text = @"请选择产品个数";
    [self.rechargeAlertBgView addSubview:self.goodsNumLabel];
    
    self.goodsNumBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsNumBtn1.tag = 5001;
    self.goodsNumBtn1.frame = CGRectMake(20, self.goodsNumLabel.bottom+5, 15, 15);
    [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.goodsNumBtn1 addTarget:self action:@selector(goodsNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.goodsNumBtn1.selected = YES;
    [self.rechargeAlertBgView addSubview:self.goodsNumBtn1];
    
    self.goodsNumLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsNumBtn1.right+5, self.goodsNumLabel.bottom,30, 26)];
    self.goodsNumLabel1.font = [UIFont systemFontOfSize: 14.0];
//    self.goodsNumLabel1.backgroundColor = [UIColor redColor];
    self.goodsNumLabel1.textColor = [UIColor blackColor];
    self.goodsNumLabel1.text = @"1个";
    [self.rechargeAlertBgView addSubview:self.goodsNumLabel1];
    
    self.goodsNumBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsNumBtn2.tag = 5002;
    self.goodsNumBtn2.frame = CGRectMake(self.goodsNumLabel1.right+5, self.goodsNumLabel.bottom+5, 15, 15);
    [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.goodsNumBtn2 addTarget:self action:@selector(goodsNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.goodsNumBtn2.selected = YES;
    [self.rechargeAlertBgView addSubview:self.goodsNumBtn2];
    
    self.goodsNumLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsNumBtn2.right+5, self.goodsNumLabel.bottom,30, 26)];
    self.goodsNumLabel2.font = [UIFont systemFontOfSize: 14.0];
//    self.goodsNumLabel2.backgroundColor = [UIColor redColor];
    self.goodsNumLabel2.textColor = [UIColor blackColor];
    self.goodsNumLabel2.text = @"2个";
    [self.rechargeAlertBgView addSubview:self.goodsNumLabel2];
    
    self.goodsNumBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsNumBtn4.tag = 5004;
    self.goodsNumBtn4.frame = CGRectMake(self.goodsNumLabel2.right+5, self.goodsNumLabel.bottom+5, 15, 15);
    [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.goodsNumBtn4 addTarget:self action:@selector(goodsNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    self.goodsNumBtn4.selected = YES;
    [self.rechargeAlertBgView addSubview:self.goodsNumBtn4];
    
    self.goodsNumLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsNumBtn4.right+5, self.goodsNumLabel.bottom,30, 26)];
    self.goodsNumLabel4.font = [UIFont systemFontOfSize: 14.0];
    //    self.goodsNumLabel4.backgroundColor = [UIColor redColor];
    self.goodsNumLabel4.textColor = [UIColor blackColor];
    self.goodsNumLabel4.text = @"4个";
    [self.rechargeAlertBgView addSubview:self.goodsNumLabel4];
    
    self.goodsNumBtn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsNumBtn6.tag = 5006;
    self.goodsNumBtn6.frame = CGRectMake(self.goodsNumLabel4.right+5, self.goodsNumLabel.bottom+5, 15, 15);
    [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.goodsNumBtn6 addTarget:self action:@selector(goodsNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    self.goodsNumBtn6.selected = YES;
    [self.rechargeAlertBgView addSubview:self.goodsNumBtn6];
    
    self.goodsNumLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsNumBtn6.right+5, self.goodsNumLabel.bottom,30, 26)];
    self.goodsNumLabel6.font = [UIFont systemFontOfSize: 14.0];
    //    self.goodsNumLabel6.backgroundColor = [UIColor redColor];
    self.goodsNumLabel6.textColor = [UIColor blackColor];
    self.goodsNumLabel6.text = @"6个";
    [self.rechargeAlertBgView addSubview:self.goodsNumLabel6];

    self.subOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.subOrderBtn setImage:[UIImage imageNamed:@"确认支付"] forState:UIControlStateNormal];
    //    [self.subOrderBtn setImage:[UIImage imageNamed:@"确认支付hover"] forState:UIControlStateHighlighted];
    self.subOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.subOrderBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.subOrderBtn.backgroundColor = [UIColor flatLightBlueColor];
    self.subOrderBtn.layer.cornerRadius = 15;
    self.subOrderBtn.layer.masksToBounds = YES;
    self.subOrderBtn.frame = CGRectMake(0,self.goodsNumLabel6.bottom+10,100,30);
    self.subOrderBtn.centerX = self.rechargeAlertBgView.width/2;
    [self.subOrderBtn addTarget:self action:@selector(subTemplateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.subOrderBtn];
    
    return self.rechargeAlertBgView;
}

- (void)layoutBtnClicked:(UIButton *)btn{
//    NSLog(@"%ld",(long)btn.tag);
    //cross:4001 vertical4002
    if (btn.tag==4001) {
        if(!self.crossBtn.selected)
        {
            
            [self.crossBtn setSelected:YES];
            [self.crossBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.crossBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
        if(self.verticalBtn.selected)
        {
            
            [self.verticalBtn setSelected:NO];
            [self.verticalBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.verticalBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
    }else{
        
        if(!self.verticalBtn.selected)
        {
            
            [self.verticalBtn setSelected:YES];
            [self.verticalBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.verticalBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
        if(self.crossBtn.selected)
        {
            
            [self.crossBtn setSelected:NO];
            [self.crossBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.crossBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
    }
    
    

}

- (void)goodsNumBtnClicked:(UIButton *)btn{
//    NSLog(@"%ld",(long)btn.tag);
    //Num1:5001 Num2:5002 Num4:5004 Num6:5006
    if (btn.tag==5001) {
        
        if(!self.goodsNumBtn1.selected)
        {
            [self.goodsNumBtn1 setSelected:YES];
            [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
        [self.goodsNumBtn2 setSelected:NO];
        [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn4 setSelected:NO];
        [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn6 setSelected:NO];
        [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    if (btn.tag == 5002) {
        if(!self.goodsNumBtn2.selected)
        {
            [self.goodsNumBtn2 setSelected:YES];
            [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
        [self.goodsNumBtn1 setSelected:NO];
        [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn4 setSelected:NO];
        [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn6 setSelected:NO];
        [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    if (btn.tag == 5004) {
        if(!self.goodsNumBtn4.selected)
        {
            [self.goodsNumBtn4 setSelected:YES];
            [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
        [self.goodsNumBtn1 setSelected:NO];
        [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn2 setSelected:NO];
        [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn6 setSelected:NO];
        [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    if (btn.tag == 5006) {
        if(!self.goodsNumBtn6.selected)
        {
            [self.goodsNumBtn6 setSelected:YES];
            [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
            [self.goodsNumBtn6 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        }
        
        [self.goodsNumBtn1 setSelected:NO];
        [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn1 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn2 setSelected:NO];
        [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn2 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
        
        [self.goodsNumBtn4 setSelected:NO];
        [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.goodsNumBtn4 setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
}


//提交模板排列
- (void)subTemplateBtnClick:(id)sender{
    NSLog(@"——————————————点击提交模板排列——————————————");
    [self closeAlertView];
    

    if (self.crossBtn.selected) {
        _layoutStr = @"1";
    }else{
        _layoutStr = @"2";
    }
    
    if (self.goodsNumBtn1.selected) {
        _goodsNumStr = @"1";
    }
    if (self.goodsNumBtn2.selected) {
        _goodsNumStr = @"2";
    }
    if (self.goodsNumBtn4.selected) {
        _goodsNumStr = @"4";
    }
    if (self.goodsNumBtn6.selected) {
        _goodsNumStr = @"6";
    }
    
    if (self.firstIn) {
        
        YKLHighGoRealeaseMainViewController *releaseVC = [YKLHighGoRealeaseMainViewController new];
        
        releaseVC.layout = _layoutStr;
        releaseVC.goodsNum = _goodsNumStr;
        releaseVC.imageURL = self.model.bgImage;
        releaseVC.tempID = self.model.templateID;
    
        [self.navigationController pushViewController:releaseVC animated:YES];
        
    }else{
        
        //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
        YKLHighGoRealeaseMainViewController *releaseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        NSLog(@"%@,%@",self.model.layout,self.model.goodsNum);
        
        
        if ([_goodsNumStr integerValue] < [releaseVC.goodsNum integerValue]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定减少产品个数，确定后，之前所设置好的商品信息将被清空重置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
            
            [alertView show];
            
            return;
        
        }
       
        
        [releaseVC.actDict setObject:_layoutStr forKey:@"layout"];
        [releaseVC.actDict setObject:_goodsNumStr forKey:@"goods_num"];
        [releaseVC.actDict setObject:self.model.bgImage forKey:@"banner"];
        [releaseVC.actDict setObject:self.model.templateID forKey:@"template_id"];
        
        releaseVC.isReloadActDict = YES;
        
        //使用popToViewController返回并传值到上一页面
        [self.navigationController popToViewController:releaseVC animated:YES];
    }

    
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
        YKLHighGoRealeaseMainViewController *releaseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        NSLog(@"%@,%@",self.model.layout,self.model.goodsNum);
        
        releaseVC.goodsDict = [NSMutableDictionary new];
        [YKLLocalUserDefInfo defModel].saveHighGoActInfoDict = [NSMutableDictionary new];
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    
        [releaseVC.actDict setObject:releaseVC.goodsDict forKey:@"goods"];
        [releaseVC.actDict setObject:_layoutStr forKey:@"layout"];
        [releaseVC.actDict setObject:_goodsNumStr forKey:@"goods_num"];
        [releaseVC.actDict setObject:self.model.bgImage forKey:@"banner"];
        [releaseVC.actDict setObject:self.model.templateID forKey:@"template_id"];
        
        releaseVC.isReloadActDict = YES;
        
        //使用popToViewController返回并传值到上一页面
        [self.navigationController popToViewController:releaseVC animated:YES];
    }
}

//关闭弹框方法
- (void)closeAlertView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self customIOS7dialogButtonTouchUpInside:self.rechargeAlertView clickedButtonAtIndex:1];
}

#pragma mark - 

- (void)sendCategoryListRequest
{
    NSString *urlStr = @"http://ykl.meipa.net/admin.php/Api/getTempCategory";
    NSDictionary *params = @{
                             @"API_Token" : API_Token,
                             };
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *returnDict = (NSDictionary *)responseObject;
         returnDict = [returnDict dictionaryByReplacingNullsWithBlanks];
         BOOL isSuccess = [returnDict[@"success"] boolValue];
         if (isSuccess)
         {
             _cateListArr = returnDict[@"data"];
             [self showCategoryListView];
             
             UIButton *dstBtn = [_cateHorizontalScrollView viewWithTag:100];
             [self cateBtnClicked:dstBtn];
         }
         else
         {
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

- (void)showCategoryListView
{
    UIView *cateListBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    cateListBGView.backgroundColor = HEXCOLOR(0xebebeb);
    [self.view addSubview:cateListBGView];
    
    // left
    _cateHorizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 40, 30)];
    _cateHorizontalScrollView.backgroundColor = [UIColor whiteColor];
    _cateHorizontalScrollView.showsVerticalScrollIndicator = NO;
    _cateHorizontalScrollView.showsHorizontalScrollIndicator = NO;
    [cateListBGView addSubview:_cateHorizontalScrollView];
    
    // right
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_cateHorizontalScrollView.width-0.5, 10+7.5, 0.5, 15)];
        lineView.backgroundColor = HEXCOLOR(0x999999);
        [cateListBGView addSubview:lineView];
        
        UIView *tipBGView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 10, 40, 30)];
        tipBGView.backgroundColor = [UIColor whiteColor];
        [cateListBGView addSubview:tipBGView];
        
        _rightTipIV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 11, 14, 8)];
        _rightTipIV.backgroundColor = [UIColor whiteColor];
        _rightTipIV.image = [UIImage imageNamed:@"arrow_down"];
        [tipBGView addSubview:_rightTipIV];
        
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(showOrHideList)];
        [tipBGView addGestureRecognizer:aTap];
    }
    
    NSInteger aWidth = 80;
    _cateHorizontalScrollView.contentSize = CGSizeMake(aWidth * _cateListArr.count, _cateHorizontalScrollView.height);
    
    for (int i = 0; i < _cateListArr.count; i++)
    {
        NSDictionary *aDict = _cateListArr[i];
        
        UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.tag = 100 + i;
        aBtn.frame = CGRectMake(i * aWidth, 0, aWidth, _cateHorizontalScrollView.height);
        [aBtn addTarget:self action:@selector(cateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [aBtn setTitleColor:HEXCOLOR(0x585858) forState:UIControlStateNormal];
        [aBtn setTitleColor:HEXCOLOR(0xf64548) forState:UIControlStateSelected];
        [aBtn setTitle:aDict[@"name"] forState:UIControlStateNormal];
        [_cateHorizontalScrollView addSubview:aBtn];
        
        if (i == 0)
        {
            aBtn.selected = YES;
            _selectedBtn = aBtn;
        }
    }
}

- (void)cateBtnClicked:(UIButton *)aBtn
{
    _selectedBtn.selected = NO;
    aBtn.selected = !aBtn.selected;
    _selectedBtn = aBtn;
    
    NSInteger indexInt = aBtn.tag - 100;
    NSDictionary *aDict = _cateListArr[indexInt];
    _currentCateIDStr = aDict[@"id"];
    
    YKLHighGoTemplateView *templateView = (YKLHighGoTemplateView *)[self.scrollView viewWithTag:kTemplateViewTag];
    templateView.tempCateIDStr = _currentCateIDStr;
    [templateView refreshList];
}

- (void)cateCellClicked:(UIButton *)aBtn
{
    if (_isShowingList)
    {
        [self showOrHideList];
    }
    
    UIButton *dstBtn = [_cateHorizontalScrollView viewWithTag:aBtn.tag];
    [self cateBtnClicked:dstBtn];
}

- (void)showOrHideList
{
    _isShowingList = !_isShowingList;
    
    _cateVerticalScrollView.hidden = !_isShowingList;
    _tipTextView.hidden = _cateVerticalScrollView.hidden;
    if (_isShowingList)
    {
        _rightTipIV.image = [UIImage imageNamed:@"arrow_down"];
    }
    else
    {
        _rightTipIV.image = [UIImage imageNamed:@"arrow_up"];
    }
    

    // show list view
    if (!_cateVerticalScrollView)
    {
        _cateVerticalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, ScreenWidth, self.contentView.height - 40)];
        _cateVerticalScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_cateVerticalScrollView];
        
        _checkIV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-14, 14.5, 14, 11)];
        _checkIV.image = [UIImage imageNamed:@"tick"];
        
        {
            _tipTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, _cateHorizontalScrollView.width - 0.5, _cateHorizontalScrollView.height)];
            _tipTextView.backgroundColor = [UIColor whiteColor];
            [_cateHorizontalScrollView.superview addSubview:_tipTextView];
            
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, _tipTextView.height)];
            aLabel.textColor = HEXCOLOR(0xf64548);
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = @"    选择你需要的类型";
            [_tipTextView addSubview:aLabel];
        }
        
        NSInteger aHeight = 40;
        _cateVerticalScrollView.contentSize = CGSizeMake(_cateVerticalScrollView.width, aHeight * _cateListArr.count);
        for (int i = 0; i < _cateListArr.count; i++)
        {
            NSDictionary *aDict = _cateListArr[i];
            
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, i * aHeight, ScreenWidth, aHeight)];
            aView.backgroundColor = [UIColor whiteColor];
            [_cateVerticalScrollView addSubview:aView];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth, 0.5)];
            lineView1.backgroundColor = HEXCOLOR(0x999999);
            [aView addSubview:lineView1];
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.tag = 100 + i;
            aBtn.frame = CGRectMake(0, 0, ScreenWidth, aHeight);
            [aBtn addTarget:self action:@selector(cateCellClicked:) forControlEvents:UIControlEventTouchUpInside];
            aBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            aBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

            [aBtn setTitleColor:HEXCOLOR(0x585858) forState:UIControlStateNormal];
            [aBtn setTitleColor:HEXCOLOR(0xf64548) forState:UIControlStateSelected];
            [aBtn setTitle:[NSString stringWithFormat:@"    %@", aDict[@"name"]] forState:UIControlStateNormal];
            
            [aView addSubview:aBtn];
            
            if (i == _cateListArr.count - 1)
            {
                UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, aView.height-0.5, ScreenWidth, 0.5)];
                lineView2.backgroundColor = HEXCOLOR(0x999999);
                [aView addSubview:lineView2];
            }
        }
    }
    
    [_checkIV removeFromSuperview];
    for (int i = 0; i < _cateListArr.count; i++)
    {
        UIButton *dstBtn = [_cateVerticalScrollView viewWithTag:100 + i];

        if (dstBtn.tag == _selectedBtn.tag)
        {
            dstBtn.selected = YES;
            [dstBtn addSubview:_checkIV];
        }
        else
        {
            dstBtn.selected = NO;
        }
    }
}

@end
