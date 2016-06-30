//
//  YKLDuoBaoActivityUserListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoActivityUserListViewController.h"
#import "MUILoadMoreTableView.h"

@interface YKLDuoBaoUserListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mobileLabel;

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
- (void)updateWithFanModel:(YKLHighGoUserListModel *)model;

@end

@implementation YKLDuoBaoUserListCell

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
    
    self.textLabel.text = [NSString stringWithFormat:@"%@",model.nickName];
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.addTime];
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.indianaName];
    
    self.mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 5, 100, 20);
    
    self.mobileLabel.frame = CGRectMake(self.textLabel.right, 5, self.textLabel.width, 20);
    
    self.detailTextLabel.frame = CGRectMake(self.mobileLabel.right, 5, self.textLabel.width, 20);
    
    //    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8, self.textLabel.width, 18);
    
}
@end

@interface YKLDuoBaoActivityUserListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

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

@implementation YKLDuoBaoActivityUserListViewController

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.userType isEqual:@"参与人"]) {
        self.title = @"参与人";
        
        self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+64, self.view.width, 40)];
        self.titleView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.titleView];
        
        self.winnerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 40)];
        self.winnerNameLabel.font = [UIFont systemFontOfSize:16];
        self.winnerNameLabel.text = @"参与用户";
        [self.titleView addSubview:self.winnerNameLabel];
        
        self.mobleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.winnerNameLabel.right+50, 0, 65, 40)];
        self.mobleLabel.font = [UIFont systemFontOfSize:16];
        self.mobleLabel.text = @"手机号码";
        [self.titleView addSubview:self.mobleLabel];
        
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.mobleLabel.right+50, 0, 65, 40)];
        self.typeLabel.font = [UIFont systemFontOfSize:16];
        self.typeLabel.text = @"参与时间";
        [self.titleView addSubview:self.typeLabel];
    }
    else if ([self.userType isEqual:@"获奖人"]){
        
        self.title = @"获奖人";
        
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
        self.typeLabel.text = @"奖品名称";
        [self.titleView addSubview:self.typeLabel];
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleView.height-0.5, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.titleView addSubview:lineView];
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64+50, self.view.width, self.view.height-64-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLDuoBaoUserListCell class] forCellReuseIdentifier:@"cell"];
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
    
    if ([self.userType isEqual:@"参与人"]) {
        
        [YKLNetworkingDuoBao getJoinListWithIndianaID:self.goodID Success:^(NSArray *joinList) {
            
            if (joinList.count == 0) {
                
                self.actingNoneView.hidden = NO;
                self.tableView.loadMoreEnable = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.records addObjectsFromArray:joinList];
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-joinList.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endLoad];
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.tableView endLoad];
            //        [UIAlertView showInfoMsg:error.domain];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }];
    }
    else if([self.userType isEqual:@"获奖人"]){
        
        [YKLNetworkingDuoBao getSuccessListWithIndianaID:self.goodID Success:^(NSArray *joinList) {
            
            if (joinList.count == 0) {
            
                self.actingNoneView.hidden = NO;
                self.tableView.loadMoreEnable = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.records addObjectsFromArray:joinList];
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-joinList.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endLoad];
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.tableView endLoad];
            //        [UIAlertView showInfoMsg:error.domain];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }];

    }
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLDuoBaoUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.userListModel = self.records[indexPath.row];
    
//    [cell updateWithFanModel:self.userListModel];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.nickName];
    cell.mobileLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.mobile];
    
    if ([self.userType isEqual:@"参与人"]) {
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.addTime];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    else if([self.userType isEqual:@"获奖人"]){
        
        if ([self.userListModel.userType isEqual:@"1"]) {
            
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@代金券",self.userListModel.voucherValue];
            
            NSMutableAttributedString *hintString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@代金券",self.userListModel.voucherValue]];
            //获取要调整颜色的文字位置,调整颜色
            NSRange range2_1=[[hintString2 string]rangeOfString:@"代金券"];
            [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range2_1];
            cell.detailTextLabel.attributedText= hintString2;
            
        }
        else if([self.userListModel.userType isEqual:@"2"]){
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.indianaName];
        }
        
    }

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
