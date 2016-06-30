//
//  YKLIncomeListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/31.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLIncomeListViewController.h"
#import "MUILoadMoreTableView.h"

@interface YKLIncomeListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
- (void)updateWithFanModel:(YKLWithDrawCashModel *)model;

@end

@implementation YKLIncomeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor blackColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:18];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.statusLabel];

        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.lineView];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateWithFanModel:(YKLWithDrawCashModel *)model {
    
    self.textLabel.text = model.desc;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self timeNumber:model.createTime]];
    
    NSString *status;
    if ([model.status isEqual:@"1"]) {
        status = [NSString stringWithFormat:@"+%@",model.money];
        self.statusLabel.textColor = [UIColor flatLightGreenColor];
        
    }
    else if ([model.status isEqual:@"2"]){
        status = [NSString stringWithFormat:@"-%@",model.money];
        self.statusLabel.textColor = [UIColor blackColor];
        
    }
    self.statusLabel.text = status;
    
}

- (NSString *)timeNumber:(NSString*)time{
    
    NSTimeInterval time0=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time0];
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 8, self.width/3*2, 18);
    self.detailTextLabel.frame = CGRectMake(0, 8+18, self.textLabel.width, 16);
    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8+9, self.width/3, 18);
    self.lineView.frame = CGRectMake(0,self.detailTextLabel.bottom+6,self.width, 0.5);
}
@end


@interface YKLIncomeListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *goldIamgeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleNumLabel;
@property (nonatomic, strong) UILabel *tableTitleLabel;
@property (nonatomic, strong) UILabel *loadingLabel;
@property int oldOffset;

@end

@implementation YKLIncomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账单明细";
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.goldIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 80, 80)];
    self.goldIamgeView.centerX = self.view.width/2;
    self.goldIamgeView.image = [UIImage imageNamed:@"金币"];
    [self.bgView addSubview:self.goldIamgeView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.goldIamgeView.bottom+10, 70, 15)];
    self.titleLabel.centerX = self.view.width/2;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.text = @"我的零钱";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
    
    self.titleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom+10, self.view.width, 30)];
    self.titleNumLabel.centerX = self.view.width/2;
    self.titleNumLabel.backgroundColor = [UIColor clearColor];
    self.titleNumLabel.font = [UIFont systemFontOfSize:34];
    self.titleNumLabel.text = [NSString stringWithFormat:@"¥%@",self.money];
    self.titleNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleNumLabel];
    
    self.tableTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleNumLabel.bottom+30, 70, 15)];
    self.tableTitleLabel.centerX = self.view.width/2;
    self.tableTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.tableTitleLabel.font = [UIFont systemFontOfSize:14];
    self.tableTitleLabel.text = @"账单明细";
    [self.bgView addSubview:self.tableTitleLabel];
    
    UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(25, 0, 100, 0.5)];
    lineView.centerY = self.tableTitleLabel.centerY;
    lineView.backgroundColor = [UIColor blackColor];
    [self.bgView addSubview:lineView];
    
    lineView= [[UIView alloc]initWithFrame:CGRectMake(self.tableTitleLabel.right, 0, 100, 0.5)];
    lineView.centerY = self.tableTitleLabel.centerY;
    lineView.backgroundColor = [UIColor blackColor];
    [self.bgView addSubview:lineView];
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(25, self.tableTitleLabel.bottom, self.view.width-50, 250) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLIncomeListCell class] forCellReuseIdentifier:@"cell"];
    [self.bgView addSubview:self.tableView];
    
    self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.tableView.bottom+10, 200, 10)];
    self.loadingLabel.centerX = self.view.width/2;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.text = @"上拉加载更多...";
    self.loadingLabel.font = [UIFont systemFontOfSize:10];
    [self.bgView addSubview:self.loadingLabel];
    
    self.records = [NSMutableArray array];
    [self requestMoreProduct];
    
     if (ScreenHeight == 480) {
         
         self.tableView.height = 150;
         self.loadingLabel.frame = CGRectMake(0, self.tableView.bottom+10, 200, 20);
         self.loadingLabel.centerX = self.view.width/2;
     }
    
    //初始化
    _oldOffset = 0;
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
    
    [YKLNetworkingConsumer getTransactionDetailWithShopID:[YKLLocalUserDefInfo defModel].userID Type:@"" success:^(NSArray *list) {
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
    
    YKLIncomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.recordModel = self.records[indexPath.row];
    
    [cell updateWithFanModel:self.recordModel];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (scrollView.contentOffset.y<-100) {
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tableView.frame = CGRectMake(25, self.tableTitleLabel.bottom, self.view.width-50, 200);
//            self.loadingLabel.hidden = NO;
//        }];
//        
//        return;
//    }
//
//    
//    if (scrollView.contentOffset.y > _oldOffset && scrollView.contentOffset.y>0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tableView.frame = CGRectMake(25, 0, self.view.width-50, self.bgView.height);
//            self.loadingLabel.hidden = YES;
//            
//        }];
//        
//    }
//    
//    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
}

@end
