//
//  YKLBalanceRecordListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/30.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBalanceRecordListViewController.h"
#import "MUILoadMoreTableView.h"


@interface YKLRecordListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *payTimeLabel;

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
- (void)updateWithFanModel:(YKLWithDrawCashModel *)model;

@end

@implementation YKLRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor flatLightBlueColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:12];
        self.statusLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.statusLabel];
        
        self.payTimeLabel = [[UILabel alloc] init];
        self.payTimeLabel.font = [UIFont systemFontOfSize:12];
        self.payTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.payTimeLabel];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateWithFanModel:(YKLWithDrawCashModel *)model {
    
    self.textLabel.text = [NSString stringWithFormat:@"提现金额:%@元",model.money];
    self.detailTextLabel.text = [NSString stringWithFormat:@"申请时间:%@",model.createTime];
    self.payTimeLabel.text = [NSString stringWithFormat:@"转账时间:%@",model.payTime];
    
    NSString *status;
    if ([model.status isEqual:@"1"]) {
        status = @"提现成功";
        self.payTimeLabel.hidden = NO;
    }
    else if ([model.status isEqual:@"2"]){
        status = @"提现中";
        self.payTimeLabel.hidden = YES;
    }
    self.statusLabel.text = status;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 8, (self.width-30)/2, 18);
    self.detailTextLabel.frame = CGRectMake(15, 8+18, self.textLabel.width, 16);
    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8, self.textLabel.width, 18);
    self.payTimeLabel.frame = CGRectMake(self.textLabel.right, 8+18, self.textLabel.width, 16);
}
@end

@interface YKLBalanceRecordListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@end

@implementation YKLBalanceRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"提现记录";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[YKLRecordListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

    self.records = [NSMutableArray array];
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
    
    [YKLNetworkingConsumer getWithdrawCashWithShopID:[YKLLocalUserDefInfo defModel].userID success:^(NSArray *list) {
        if (list.count == 0) {
            self.tableView.loadMoreEnable = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.records addObjectsFromArray:list];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-list.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    
    YKLRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.recordModel = self.records[indexPath.row];
    
    [cell updateWithFanModel:self.recordModel];
    
    return cell;
}

@end
