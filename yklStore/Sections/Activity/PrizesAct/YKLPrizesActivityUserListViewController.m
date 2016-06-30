//
//  YKLPrizesActivityUserListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/15.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPrizesActivityUserListViewController.h"
#import "MUILoadMoreTableView.h"

@interface YKLPrizesUserListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mobileLabel;

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
- (void)updateWithFanModel:(YKLHighGoUserListModel *)model;

@end

@implementation YKLPrizesUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor lightGrayColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor flatLightRedColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        
        self.mobileLabel = [[UILabel alloc] init];
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor lightGrayColor];
        self.mobileLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.mobileLabel];

        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateWithFanModel:(YKLHighGoUserListModel *)model {
    
    self.textLabel.text = model.nickName;
    
    self.detailTextLabel.text = [model.prizeName isEqual:@""] ? @"(未领奖)" : model.prizeName;
    
    self.mobileLabel.text = model.mobile;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 5, 100, 20);
    
    self.mobileLabel.frame = CGRectMake(self.textLabel.right, 5, self.textLabel.width, 20);
    
    self.detailTextLabel.frame = CGRectMake(self.mobileLabel.right, 5, self.textLabel.width, 20);
    
    //    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8, self.textLabel.width, 18);
    
}
@end

@interface YKLPrizesActivityUserListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *winnerNameLabel;
@property (nonatomic, strong) UILabel *mobleLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) YKLHighGoUserListModel *userListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIWebView *callWebView;
@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLPrizesActivityUserListViewController

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"获奖人";

    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+64, self.view.width, 40)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    self.winnerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 40)];
    self.winnerNameLabel.font = [UIFont systemFontOfSize:16];
    self.winnerNameLabel.text = @"中奖用户";
    [self.titleView addSubview:self.winnerNameLabel];
    
    self.mobleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.winnerNameLabel.right+50, 0, 65, 40)];
    self.mobleLabel.font = [UIFont systemFontOfSize:16];
    self.mobleLabel.text = @"手机号码";
    [self.titleView addSubview:self.mobleLabel];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.mobleLabel.right+50, 0, 65, 40)];
    self.typeLabel.font = [UIFont systemFontOfSize:16];
    self.typeLabel.text = @"奖品类型";
    [self.titleView addSubview:self.typeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleView.height-0.5, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.titleView addSubview:lineView];
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64+50, self.view.width, self.view.height-64-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLPrizesUserListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    self.records = [NSMutableArray array];
    [self createBgNoneView];//创建没用数据背景
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
    [self.tableView startLoad];

    [YKLNetworkingPrizes  getRedWinnerWithRID:self.goodID Status:@"0" Success:^(NSArray *winnerList) {
        
        if (winnerList.count == 0) {
            
            self.actingNoneView.hidden = NO;
            self.tableView.loadMoreEnable = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.records addObjectsFromArray:winnerList];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-winnerList.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endLoad];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.tableView endLoad];
//        [UIAlertView showInfoMsg:error.domain];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }];
    

}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLPrizesUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.userListModel = self.records[indexPath.row];
    [cell updateWithFanModel:self.userListModel];
    
//    cell.textLabel.text = @"自由自在的昵称";
//    cell.detailTextLabel.text = @"神奇奖品X号";
//    cell.mobileLabel.text = @"12020201314";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKLHighGoUserListModel *model = self.records[indexPath.row];
    
    NSLog(@"%@-%@",model.nickName,model.mobile);
    if (model.mobile.length > 0) {
        NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", model.mobile]];
        if (self.callWebView == nil) {
            self.callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [self.callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
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
