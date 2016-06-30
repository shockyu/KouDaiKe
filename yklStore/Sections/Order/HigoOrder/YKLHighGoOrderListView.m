//
//  YKLHighGoOrderListView.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoOrderListView.h"

@implementation YKLHighGoOrderListView

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
        [self.tableView registerClass:[YKLHighGoOrderListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
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
        default:
            break;
    }
    
}

- (void)getOrderslist:(NSString *)status{
    
    [self.orders removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    [YKLNetworkingHighGo getOrderDetailWithActID:self.orderID Success:^(NSDictionary *orderDict) {
       

        if ([status isEqualToString:@"1"]) {
            
            NSArray *orderArr1 = [orderDict objectForKey:@"convert"];
            
            if (orderArr1.count == 0) {
                self.actingNoneView.hidden = NO;
                self.tableView.loadMoreEnable = NO;
                [self.tableView endLoad];
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                return;
            }
            
            NSArray *orderDetilModelArr = [YKLNetworkingHighGo constructModelsForClass:[YKLHighGoOrderDetailModel class] withData: orderArr1];
            [self.orders addObjectsFromArray:orderDetilModelArr];
            
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-orderDetilModelArr.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];

            
        }else{
            
            NSArray *orderArr2 = [orderDict objectForKey:@"converted"];
            
            if (orderArr2 == 0) {
                self.actWaitNoneView.hidden = NO;
                self.tableView.loadMoreEnable = NO;
                [self.tableView endLoad];
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                return;
            }
            
            NSArray *orderDetilModelArr = [YKLNetworkingHighGo constructModelsForClass:[YKLHighGoOrderDetailModel class] withData: orderArr2];
            [self.orders addObjectsFromArray:orderDetilModelArr];
            
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-orderDetilModelArr.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
        }
        
    } failure:^(NSError *error) {
        
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
    
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLHighGoOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLHighGoOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    //
    switch (self.type) {
        case YKLFaceExchangeStatusWait:
            self.model = self.orders[indexPath.row];
            
            cell.nameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.model.nickName];
            cell.mobleLabel.text =[NSString stringWithFormat:@"联系方式：%@",self.model.mobile];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.goodsImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            cell.actTitleLabel.text = self.model.goodsName;
            cell.priceLabel.text = [NSString stringWithFormat:@"共%@人参与",self.model.joinNum];
            cell.lowestPriceLabel.hidden = YES;
            cell.peducePriceLabel.text = @"查看代金券";
            cell.typeImageView.hidden =YES;
            
            break;
        case YKLFaceExchangeStatusDone:
            self.model = self.orders[indexPath.row];
            
            cell.nameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.model.nickName];
            cell.mobleLabel.text =[NSString stringWithFormat:@"联系方式：%@",self.model.mobile];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.goodsImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            cell.actTitleLabel.text = self.model.goodsName;
            cell.priceLabel.text = [NSString stringWithFormat:@"共%@人参与",self.model.joinNum];
            cell.lowestPriceLabel.hidden = YES;
            cell.peducePriceLabel.text = @"查看代金券";
            cell.typeImageView.hidden =YES;
            
            break;
            
        default:
            break;
    }
    
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
