//
//  YKLHighGoTokenListView.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/10.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoTokenListView.h"
//#import "YKLHighGoOrderListTableViewCell.h"
#import "YKLHigoGoTokenTableViewCell.h"

@implementation YKLHighGoTokenListView

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type goodsID:(NSString *)goodsID{
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        self.goodsID = goodsID;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLHigoGoTokenTableViewCell class] forCellReuseIdentifier:@"Cell"];
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
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
//    self.userInteractionEnabled = YES;
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
    
    [YKLNetworkingHighGo getGoodsRewardWithGoodsID:self.goodsID Success:^(NSDictionary *orderDict) {
        
//        self.goodsName = [orderDict objectForKey:@"goods_name"];
        
        if ([status isEqualToString:@"1"]) {
            
            NSArray *orderArr1 = [orderDict objectForKey:@"already_exchange"];
            
            if (orderArr1.count == 0) {
                self.actingNoneView.hidden = NO;
                self.tableView.loadMoreEnable = NO;
                [self.tableView endLoad];
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                return;
            }
            
            NSArray *orderDetilModelArr = [YKLNetworkingHighGo constructModelsForClass:[YKLHighGoGoodsRewardModel class] withData: orderArr1];
            [self.orders addObjectsFromArray:orderDetilModelArr];
            
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-orderDetilModelArr.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            
        }else{
            
            NSArray *orderArr2 = [orderDict objectForKey:@"unredeemed"];
            
            if (orderArr2.count == 0) {
                self.actWaitNoneView.hidden = NO;
                self.tableView.loadMoreEnable = NO;
                [self.tableView endLoad];
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                return;
            }
            
            NSArray *orderDetilModelArr = [YKLNetworkingHighGo constructModelsForClass:[YKLHighGoGoodsRewardModel class] withData: orderArr2];
            [self.orders addObjectsFromArray:orderDetilModelArr];
            
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-orderDetilModelArr.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            
        }

        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLHigoGoTokenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLHigoGoTokenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    self.rewardModel = self.orders[indexPath.row];
    
    if ([self.rewardModel.nickName isBlankString]) {
        cell.nameLabel.text = @"暂无";
    }else{
        cell.nameLabel.text = self.rewardModel.nickName;
    }
    
    if ([self.rewardModel.mobile isBlankString]) {
        cell.mobleLabel.text = @"暂无";
    }else{
        cell.mobleLabel.text = self.rewardModel.mobile;
    }
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@¥",self.rewardModel.reward]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range=[[hintString string]rangeOfString:@"¥"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    cell.monneyLabel.attributedText=hintString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [self.delegate consumerOrderListView:self didSelectOrder:self.orders[indexPath.row]];
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
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

@end
