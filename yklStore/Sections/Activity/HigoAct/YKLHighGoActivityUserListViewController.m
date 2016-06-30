//
//  YKLHighGoActivityUserListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/6.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivityUserListViewController.h"
#import "MUILoadMoreTableView.h"

@interface YKLUserListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mobileLabel;

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
- (void)updateWithFanModel:(YKLHighGoUserListModel *)model;

@end

@implementation YKLUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor flatLightBlueColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.mobileLabel = [[UILabel alloc] init];
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.mobileLabel];
        
//        self.statusLabel = [[UILabel alloc] init];
//        self.statusLabel.font = [UIFont systemFontOfSize:12];
//        self.statusLabel.textColor = [UIColor blackColor];
//        [self.contentView addSubview:self.statusLabel];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateWithFanModel:(YKLHighGoUserListModel *)model {
    
    self.textLabel.text = [NSString stringWithFormat:@"支付金额:%@元",model.payPrice];
    self.detailTextLabel.text = [NSString stringWithFormat:@"昵称:%@",model.nickName];
    self.mobileLabel.text = [NSString stringWithFormat:@"联系电话:%@",model.mobile];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 8, (self.width-30)/2, 18);
    self.detailTextLabel.frame = CGRectMake(15, 8+18, self.textLabel.width, 16);
    self.mobileLabel.frame = CGRectMake(self.textLabel.right, 8+18, self.textLabel.width, 16);
//    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8, self.textLabel.width, 18);
    
}
@end

@interface YKLHighGoActivityUserListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLHighGoUserListModel *userListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIWebView *callWebView;

@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLHighGoActivityUserListViewController

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"活动参与者";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[YKLUserListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    self.records = [NSMutableArray array];
    [self createBgNoneView];
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
    
    NSLog(@"%@",self.goodID);
    
    [YKLNetworkingHighGo getUserListWithGoodsID:self.goodID Success:^(NSArray *userList) {
        
        if (userList.count == 0) {
            
            self.actingNoneView.hidden = NO;
            self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
            self.tableView.loadMoreEnable = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.records addObjectsFromArray:userList];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-userList.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endLoad];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.tableView endLoad];
        [UIAlertView showInfoMsg:error.domain];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.userListModel = self.records[indexPath.row];
    
    [cell updateWithFanModel:self.userListModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKLHighGoUserListModel *model = self.records[indexPath.row];
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
