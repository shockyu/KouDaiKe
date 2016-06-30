//
//  YKLMiaoShaActivityUserListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMiaoShaActivityUserListViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLMiaoShaActivityUserListTableViewCell.h"

@interface YKLMiaoShaActivityUserListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

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

@implementation YKLMiaoShaActivityUserListViewController

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.title = self.userType;
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLMiaoShaActivityUserListTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
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
    
    //测试数据
//    self.goodID = @"6";
    
    if ([self.userType isEqual:@"报名人"]) {
        
        
        [YKLNetworkingMiaoSha getGoodsJoinerWithGoodsID:self.goodID Success:^(NSArray *userList) {
            
            if (userList.count == 0) {
                
                self.actingNoneView.hidden = NO;
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
            //        [UIAlertView showInfoMsg:error.domain];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }];
    }
    else if([self.userType isEqual:@"成功秒杀人"]){
        

        [YKLNetworkingMiaoSha getGoodsWinnerWithGoodsID:self.goodID Success:^(NSArray *userList) {
            
            if (userList.count == 0) {
                
                self.actingNoneView.hidden = NO;
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
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLMiaoShaActivityUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    self.userListModel = self.records[indexPath.row];
    
    cell.nickName.text = [NSString stringWithFormat:@"%@",self.userListModel.wxNickName];
    cell.mobile.text = [NSString stringWithFormat:@"%@",self.userListModel.mobile];
    
    
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
