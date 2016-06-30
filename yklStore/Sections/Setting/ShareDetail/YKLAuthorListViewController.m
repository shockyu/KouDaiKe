//
//  YKLAuthorListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLAuthorListViewController.h"
#import "YKLAuthorListTableViewCell.h"

@implementation YKLAuthorListView

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (instancetype)initWithFrame:(CGRect)frame
                   AuthorType:(NSString *)authorType {
    if (self = [super initWithFrame:frame]) {
        
        self.authorType = authorType;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView registerClass:[YKLAuthorListTableViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        [self addSubview:self.tableView];
        
        self.orders = [NSMutableArray array];
        [self createBgNoneView];//创建没用数据背景
        [self requestMoreOrder];
    }
    return self;
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
    
    if ([self.authorType isEqual:@"1"]) {
        [self getOrderslist:@"1"];
    }
    else if ([self.authorType isEqual:@"2"]){
        [self getOrderslist:@"2"];
    }
    
}

- (void)getOrderslist:(NSString *)status{
    
    NSLog(@"%@",status);
    
    [YKLNetworkingConsumer shopRecommendListWithShopID:[YKLLocalUserDefInfo defModel].userID IsAuthor:status Success:^(NSArray *fans) {
        if (fans.count == 0) {
            self.tableView.loadMoreEnable = NO;
            
            if ([status isEqual:@"1"]) {
                self.actingNoneView.hidden = NO;
            }
            if ([status isEqual:@"2"]) {
                
                self.actWaitNoneView.hidden = NO;
            }
        }
        [self.orders addObjectsFromArray:fans];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-fans.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endLoad];
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.userInteractionEnabled = YES;
        [UIAlertView showErrorMsg:error.domain];
        
    }];
}


#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLAuthorListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    YKLAuthorFansModel *model = self.orders[indexPath.row];

    [cell updateWithFanModel:model];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKLAuthorFansModel *model = self.orders[indexPath.row];
    if (model.mobile.length > 0) {
        NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", model.mobile]];
        if (self.callWebView == nil) {
            self.callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [self.callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
    }
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

const float YKLAuthorListViewH = 40;
@interface YKLAuthorListViewController ()

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UISegmentedControl *typeSegment2;

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *upView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;

@end

@implementation YKLAuthorListViewController

- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLAuthorListViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLAuthorListViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}

- (UISegmentedControl *)typeSegment2{
    
    if (_typeSegment2 == nil) {
        _typeSegment2 = [[UISegmentedControl alloc] initWithItems:@[@"已授权", @"未授权"]];
        
        if ([self.authorType isEqualToString:@"1"]) {
            _typeSegment2.selectedSegmentIndex = 0;
        }
        else if([self.authorType isEqualToString:@"2"]){
            _typeSegment2.selectedSegmentIndex = 1;
        }
        
        _typeSegment2.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment2 setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment2 setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment2 addTarget:self action:@selector(typeSegmentValueFaceChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLAuthorListViewH);
        [self.upView2 addSubview:self.typeSegment2];
    }
    return _typeSegment2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"授权列表";
    
    self.upView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLAuthorListViewH)];
    self.upView2.scrollEnabled = YES;
    self.upView2.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView2];
    
    self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLAuthorListViewH);
    [self.upView2 addSubview:self.typeSegment2];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLAuthorListViewH+64, self.contentView.width, self.contentView.height-YKLAuthorListViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueFaceChanged:self.typeSegment2];
    
}


- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLAuthorListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        
        if (segment.selectedSegmentIndex == 0) {

            self.authorType = @"1";
        }
        else if (segment.selectedSegmentIndex == 1) {

            self.authorType = @"2";
        }
        
        listView = [[YKLAuthorListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) AuthorType:self.authorType];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}

- (void)consumerOrderListView:(YKLAuthorListView *)listView didSelectOrder:(YKLOrderListModel *)model {
    //    [self.switchManager switchToNextViewWithType:MPSUserViewTypeOrderDetail userInfo:model];
}

@end
