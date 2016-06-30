//
//  YKLDuoBaoOrderListView.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/7.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoOrderListView.h"

@implementation YKLDuoBaoOrderListView

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type orderID:(NSString *)orderID{
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        self.orderID = orderID;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLPrizesOrderListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.orders = [NSMutableArray array];
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.tintColor = [UIColor clearColor];
        [self.refreshControl addTarget:self action:@selector(refreshListView) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        
        self.refreshView = [[XHJDRefreshView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        [self.refreshView refreing];
        [self.refreshControl addSubview:self.refreshView];
        
        [self createBgNoneView];
        [self requestMoreOrder];
    }
    return self;
}

- (void)refreshListView {
    [self.refreshControl endRefreshing];
    self.page = 0;
    [self requestMoreOrder];
    
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
    switch (self.type) {
        case 0:
            [self getOrderslist:@"1"];
            break;
        case 1:
            [self getOrderslist:@"2"];
            break;
        case 2:
            [self getOrderslist:@"3"];
            break;
        default:
            break;
    }
    
}

- (void)getOrderslist:(NSString *)status{
    
    [self.orders removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
//    @"order_no_redemption"未兑换
//    @"order_already_paid"已付款
//    @"order_redeemed"已兑换
    
    NSString *actName;
    if ([status isEqual:@"1"]) {
        actName = @"order_no_redemption";
    }
    if ([status isEqual:@"2"]) {
        actName = @"order_already_paid";
    }
    if ([status isEqual:@"3"]) {
        actName = @"order_redeemed";
    }
    
    [YKLNetworkingDuoBao getIndianaPlayerListWithIndianaID:self.orderID ActName:actName Success:^(NSArray *activityList) {
        if (activityList.count == 0) {
            
            if ([status isEqual:@"1"]) {
                self.actingNoneView.hidden = NO;
            }
            if ([status isEqual:@"2"]) {
                self.actWaitNoneView.hidden = NO;
            }
            if ([status isEqual:@"3"]) {
                self.actDoneNoneView.hidden = NO;
            }
            
            self.tableView.loadMoreEnable = NO;
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            return;
        }
        
        [self.orders addObjectsFromArray:activityList];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-activityList.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endLoad];
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        [self.tableView endLoad];
        
    }];
}

- (void)createBgNoneView{
    
    self.actingNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255,  225)];
    self.actingNoneView.centerX = self.width/2;
    self.actingNoneView.backgroundColor = [UIColor clearColor];
    self.actingNoneView.hidden = YES;
    [self.tableView addSubview:self.actingNoneView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [self.actingNoneView addSubview:imageView];
    
    self.actWaitNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255,  225)];
    self.actWaitNoneView.centerX = self.width/2;
    self.actWaitNoneView.backgroundColor = [UIColor clearColor];
    self.actWaitNoneView.hidden = YES;
    [self.tableView addSubview:self.actWaitNoneView];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView2.frame = CGRectMake(0, 0, 255, 225);
    [self.actWaitNoneView addSubview:imageView2];
    
    self.actDoneNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255,  225)];
    self.actDoneNoneView.centerX = self.width/2;
    self.actDoneNoneView.backgroundColor = [UIColor clearColor];
    self.actDoneNoneView.hidden = YES;
    [self.tableView addSubview:self.actDoneNoneView];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView3.frame = CGRectMake(0, 0, 255, 225);
    [self.actDoneNoneView addSubview:imageView3];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLPrizesOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLPrizesOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    self.model = self.orders[indexPath.row];
    
//    [cell updateWithFanModel:self.model];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.model.nickName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.indianaName];
    cell.mobileLabel.text = [NSString stringWithFormat:@"%@",self.model.mobile];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate consumerOrderListView:self didSelectOrder:self.orders[indexPath.row]];
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}

@end
