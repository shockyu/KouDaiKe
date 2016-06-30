//
//  YKLActivityOnlyFansViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLActivityOnlyFansViewController.h"
#import "MUILoadMoreTableView.h"

@interface YKLOnlyFansListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mobileLabel;

@property (nonatomic, strong) YKLFanModel *recordModel;
- (void)updateWithFanModel:(YKLFanModel *)model;

@end

@implementation YKLOnlyFansListCell

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

- (void)updateWithFanModel:(YKLFanModel *)model {
    
    self.textLabel.text = [NSString stringWithFormat:@"%@",model.nickName];
//    
//    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.addTime];
//    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.indianaName];
    
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

@interface YKLActivityOnlyFansViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLFanModel *userListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIWebView *callWebView;

@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLActivityOnlyFansViewController

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.listTitle;
   
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLOnlyFansListCell class] forCellReuseIdentifier:@"cell"];
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
    
    [YKLNetworkingConsumer getActivityPlayerWithActivityID:self.actID IsOver:self.userType Success:^(NSArray *fansModel) {
        
        if (fansModel.count == 0) {
            
            self.actingNoneView.hidden = NO;
            self.tableView.loadMoreEnable = NO;
        }
        [self.records addObjectsFromArray:fansModel];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-fansModel.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLOnlyFansListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.userListModel = self.records[indexPath.row];
    
    //    [cell updateWithFanModel:self.userListModel];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.nickName];
    cell.mobileLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.mobile];
    
//    if ([self.userType isEqual:@"参与人"]) {
//        
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.addTime];
//        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//    }
//    else if([self.userType isEqual:@"获奖人"]){
//        
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userListModel.indianaName];
//    }
    
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
