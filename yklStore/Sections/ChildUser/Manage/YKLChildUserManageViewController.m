//
//  YKLChildUserManageViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLChildUserManageViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLVipPayIntroViewController.h"
#import "YKLAddChildUserNumViewController.h"
#import "YKLSetChildUserViewController.h"
#import "YKLLoginViewController.h"
#import "YKLSetChildUserViewController.h"

@interface YKLChildUserListCell : UITableViewCell
{
    UIImageView *_iconImage;
}

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *gsNameLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *addressLabel;



@end

@implementation YKLChildUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.width, 80)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(293, 0, 12,22)];
        _iconImage.centerY = bgView.height/2;
        _iconImage.image = [UIImage imageNamed:@"setting箭头"];
        [bgView addSubview:_iconImage];
        
        self.gsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 280, 20)];
        self.gsNameLabel.font = [UIFont systemFontOfSize:18];
//        self.gsNameLabel.text = @"长沙钉子科技信息有限公司";
        [bgView addSubview:self.gsNameLabel];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, self.gsNameLabel.bottom+5, 13,13)];
        _iconImage.image = [UIImage imageNamed:@"zzh_userName_icon"];
        [bgView addSubview:_iconImage];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.right+3, _iconImage.top, 105, 13)];
        self.userNameLabel.font = [UIFont systemFontOfSize:12];
        self.userNameLabel.textColor = [UIColor grayColor];
//        self.userNameLabel.text = @"乌云";
        [bgView addSubview:self.userNameLabel];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.userNameLabel.right, self.userNameLabel.top, 13, 13)];
        _iconImage.image = [UIImage imageNamed:@"zzh_tel_icon"];
        [bgView addSubview:_iconImage];
        
        self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.right+3, _iconImage.top, 100, 13)];
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor flatLightBlueColor];
//        self.mobileLabel.text = @"186xxxxxxxxx";
        [bgView addSubview:self.mobileLabel];

        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, self.mobileLabel.bottom+5, 13, 13)];
        _iconImage.image = [UIImage imageNamed:@"zzh_address_icon"];
        [bgView addSubview:_iconImage];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.right+3, self.mobileLabel.bottom, 265, 25)];
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.textColor = [UIColor grayColor];
        [self.addressLabel setNumberOfLines:0];
//        self.addressLabel.text = @"长沙市天心区摩天一号一座1208";
        [bgView addSubview:self.addressLabel];
        
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end


@interface YKLChildUserManageViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLShopAdressListModel *shopListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIView *actingNoneView;

@property (nonatomic, strong) UILabel *markInfo;

@end

@implementation YKLChildUserManageViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"分店管理";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"add_zizhanghao"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addZizhanghaoClicked)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 40, 40);
        
        _markInfo = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 15, 10)];
        _markInfo.backgroundColor = [UIColor flatLightRedColor];
        _markInfo.layer.cornerRadius = 5;
        _markInfo.layer.masksToBounds = YES;
        _markInfo.font = [UIFont systemFontOfSize:8];
        _markInfo.textColor = [UIColor whiteColor];
        _markInfo.textAlignment = NSTextAlignmentCenter;
        _markInfo.hidden = YES;
        [button addSubview:_markInfo];
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLChildUserListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    self.records = [NSMutableArray array];
    [self createBgNoneView];//创建没用数据背景

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestMoreProduct];
    
}

- (NSArray *)indexPathsWithStart:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *arIndex = [NSMutableArray array];
    for (NSInteger i=start; i<end; i++) {
        [arIndex addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return [arIndex copy];
}

- (void)requestMoreProduct {
    self.page += 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    [self.records removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    
    [YKLNetworkingConsumer getChildAccountWithPid:[YKLLocalUserDefInfo defModel].userID Act:@"childnum" IsShow:@"1" success:^(NSDictionary *dict)  {
        
        
        NSString *childnum = [dict objectForKey:@"childnum"];
        if (![childnum isEqual:@"0"]) {
            _markInfo.hidden = NO;
            _markInfo.text = childnum;
        }
        
        NSArray *arr = [dict objectForKey:@"childList"];
        if (arr.count == 0) {
            self.actingNoneView.hidden = NO;
            self.tableView.loadMoreEnable = NO;
        }else{
            self.actingNoneView.hidden = YES;
        }

        [self.records addObjectsFromArray:arr];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-arr.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endLoad];
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.tableView endLoad];
        
    }];
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLChildUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *tempDict = self.records[indexPath.row];
    cell.gsNameLabel.text = [tempDict objectForKey:@"shop_name"];
    cell.userNameLabel.text = [tempDict objectForKey:@"lianxiren"];
    cell.mobileLabel.text = [tempDict objectForKey:@"mobile"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",[tempDict objectForKey:@"address"],[tempDict objectForKey:@"street"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    YKLSetChildUserViewController *vc = [YKLSetChildUserViewController new];
    vc.childInfoDict = self.records[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 按钮点击方法

- (void)addZizhanghaoClicked{
    
//    YKLAddChildUserNumViewController *vc = [YKLAddChildUserNumViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (_markInfo.text == nil) {
        NSLog(@"充值子账号个数");
        
        YKLAddChildUserNumViewController *vc = [YKLAddChildUserNumViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        NSLog(@"添加子账号信息");
        
        YKLSetChildUserViewController *vc = [YKLSetChildUserViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
    
    
    /*
    if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        
        if ([_markInfo.text isBlankString]) {
            NSLog(@"充值子账号个数");
        }
        else{
            NSLog(@"添加子账号信息");
        }

    }
    else if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"2"]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"黄钻充值" message:@"此功能只对黄钻用户开放，如需使用请先充值黄钻。成为黄钻后所有子账号均可免费发布活动" delegate:self cancelButtonTitle:@"立即充值" otherButtonTitles: @"暂不充值",nil];
        [alertView show];
    }
     */
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        YKLVipPayIntroViewController *vc = [YKLVipPayIntroViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)createBgNoneView{
    
    self.actingNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255,  225)];
    self.actingNoneView.centerX = self.view.width/2;
    self.actingNoneView.backgroundColor = [UIColor clearColor];
    self.actingNoneView.hidden = YES;
    [self.tableView addSubview:self.actingNoneView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [self.actingNoneView addSubview:imageView];
    
}
@end
