//
//  YKLChildNameListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/29.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLChildNameListViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLActListTabBarViewController.h"

@interface YKLChildNameListCell : UITableViewCell
{
    UIImageView *_iconImage;
}

@property (nonatomic, strong) UILabel *gsNameLabel;
@end

@implementation YKLChildNameListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.width, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        self.gsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 290, 50)];
        self.gsNameLabel.font = [UIFont systemFontOfSize:14];
        //        self.gsNameLabel.text = @"长沙钉子科技信息有限公司";
        [bgView addSubview:self.gsNameLabel];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.gsNameLabel.right, 0, 8,15)];
        _iconImage.centerY = bgView.height/2;
        _iconImage.image = [UIImage imageNamed:@"setting箭头"];
        [bgView addSubview:_iconImage];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end


@interface YKLChildNameListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLShopAdressListModel *shopListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLChildNameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"分店列表";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLChildNameListCell class] forCellReuseIdentifier:@"cell"];
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
    
    
    [YKLNetworkingConsumer getChildAccountWithPid:[YKLLocalUserDefInfo defModel].userID Act:@"" IsShow:@"0" success:^(NSDictionary *dict) {
        
        
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLChildNameListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *tempDict = self.records[indexPath.row];
    cell.gsNameLabel.text = [tempDict objectForKey:@"shop_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tempDict = self.records[indexPath.row];
    
    YKLActListTabBarViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    vc.shopDict = @{
                    @"shopID":[tempDict objectForKey:@"id"],
                    @"shopName":[tempDict objectForKey:@"shop_name"],
                    };
    [self.navigationController popToViewController:vc animated:YES];
    
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
