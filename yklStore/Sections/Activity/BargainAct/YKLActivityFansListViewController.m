//
//  YKLActivityFansListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLActivityFansListViewController.h"
#import "SJAvatarBrowser.h"
#import "TWTSideMenuViewController.h"

@interface YKLActivityFanInfoCell : UITableViewCell
@property (nonatomic, strong) YKLFanModel *fanModel;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *callImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *moneyTitle;
@property (nonatomic, strong) UILabel *moneyNum;
@property (nonatomic, strong) UILabel *payTimeTitle;
@property (nonatomic, strong) UILabel *payTime;
@property (nonatomic, strong) UILabel *exchangeTimeTitle;
@property (nonatomic, strong) UILabel *exchangeTime;

- (void)updateWithFanModel:(YKLFanModel *)model;

@end

@implementation YKLActivityFanInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 70)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.callImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo"]];
        self.callImageView.frame = CGRectMake(10, 0, 30, 30);
        self.callImageView.centerY = self.bgView.height/2;
        self.callImageView.layer.cornerRadius = 15;
        self.callImageView.layer.masksToBounds = YES;
        [self.bgView addSubview:self.callImageView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.callImageView.right+5, 0, 150, 17)];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.bgView addSubview:self.nameLabel];
        
        self.mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right+20, 0, 100, 17)];
//        self.mobileLabel.backgroundColor = [UIColor redColor];
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.mobileLabel];
        
        self.moneyTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, 60, 17)];
//        self.moneyTitle.backgroundColor = [UIColor redColor];
        self.moneyTitle.font = [UIFont systemFontOfSize:12];
        self.moneyTitle.textColor = [UIColor blackColor];
        self.moneyTitle.text = @"成交金额：";
        [self.bgView addSubview:self.moneyTitle];
        
        self.moneyNum = [[UILabel alloc]initWithFrame:CGRectMake(self.moneyTitle.right, self.moneyTitle.top, 100, 17)];
//        self.moneyNum.backgroundColor = [UIColor redColor];
        self.moneyNum.font = [UIFont systemFontOfSize:12];
        self.moneyNum.textColor = [UIColor flatLightRedColor];
        self.moneyNum.text = @"¥12";
        [self.bgView addSubview:self.moneyNum];
        
        self.payTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.moneyTitle.bottom, 60, 17)];
//        self.payTimeTitle.backgroundColor = [UIColor redColor];
        self.payTimeTitle.font = [UIFont systemFontOfSize:12];
        self.payTimeTitle.textColor = [UIColor blackColor];
        self.payTimeTitle.text = @"支付时间：";
        [self.bgView addSubview:self.payTimeTitle];
        
        self.payTime = [[UILabel alloc]initWithFrame:CGRectMake(self.payTimeTitle.right, self.payTimeTitle.top, 100, 17)];
//        self.payTime.backgroundColor = [UIColor redColor];
        self.payTime.font = [UIFont systemFontOfSize:12];
        self.payTime.textColor = [UIColor lightGrayColor];
        self.payTime.text = @"2016-03-18";
        [self.bgView addSubview:self.payTime];
        
        self.exchangeTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.payTimeTitle.bottom, 60, 17)];
//        self.exchangeTimeTitle.backgroundColor = [UIColor redColor];
        self.exchangeTimeTitle.font = [UIFont systemFontOfSize:12];
        self.exchangeTimeTitle.textColor = [UIColor blackColor];
        self.exchangeTimeTitle.text = @"兑换时间：";
        [self.bgView addSubview:self.exchangeTimeTitle];
        
        self.exchangeTime = [[UILabel alloc]initWithFrame:CGRectMake(self.exchangeTimeTitle.right, self.exchangeTimeTitle.top, 100, 17)];
//        self.exchangeTime.backgroundColor = [UIColor redColor];
        self.exchangeTime.font = [UIFont systemFontOfSize:12];
        self.exchangeTime.textColor = [UIColor lightGrayColor];
        self.exchangeTime.text = @"2016-03-28";
        [self.bgView addSubview:self.exchangeTime];
        
        
    }
    return self;
}

- (void)updateWithFanModel:(YKLFanModel *)model {
    
    self.mobileLabel.text = model.mobile;
    self.nameLabel.text = model.nickName;
    self.moneyNum.text = [NSString stringWithFormat:@"¥%@",model.orderAmount];
    self.payTime.text = model.paymentTime;
    self.exchangeTime.text = model.finnshedTime;
    [self.callImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"Demo"]];
}


@end


@implementation YKLFunsListView

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (instancetype)initWithFrame:(CGRect)frame
                    orderType:(YKLOrderListType)type
                   ActivityID:(NSString *)activityID
                     FansType:(NSString *)fansType
                      PayType:(NSString *)payType{
    
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        self.activityID = activityID;
        self.fansType = fansType;
        self.payType = payType;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor flatLightWhiteColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[YKLActivityFanInfoCell class] forCellReuseIdentifier:@"cell"];
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
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
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
    
    [YKLNetworkingConsumer getActivityPlayerWithActivityID:self.activityID IsExpiry:status PayType:self.payType Success:^(NSArray *fansModel) {
        
        if (fansModel.count == 0) {
            
            if ([status isEqual:@"1"]) {
                self.actingNoneView.hidden = NO;
            }
            if ([status isEqual:@"2"]) {
        
                self.actWaitNoneView.hidden = NO;
            }
            
            
            self.tableView.loadMoreEnable = NO;
        }
        [self.orders addObjectsFromArray:fansModel];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-fansModel.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"cell";
    
    // 让表格缓冲区查找可重用cell
    YKLActivityFanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLActivityFanInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    YKLFanModel *model = self.orders[indexPath.row];
    cell.callImageView.userInteractionEnabled= YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
    [cell.callImageView addGestureRecognizer:singleTap];
    
    [cell updateWithFanModel:model];
    
    return cell;
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKLFanModel *model = self.orders[indexPath.row];
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

const float YKLFunsListViewH = 40;
@interface YKLActivityFansListViewController ()<YKLConsumerOrderListViewDelegate>

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UISegmentedControl *typeSegment2;
@property (nonatomic, strong) UISegmentedControl *typeSegment3;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *upView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;

@end

@implementation YKLActivityFansListViewController

- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLFunsListViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLFunsListViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}

- (UISegmentedControl *)typeSegment2{
    if (_typeSegment2 == nil) {
        _typeSegment2 = [[UISegmentedControl alloc] initWithItems:@[@"待兑换", @"已兑换"]];
        _typeSegment2.selectedSegmentIndex = 0;
        
        _typeSegment2.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment2 setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment2 setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment2 addTarget:self action:@selector(typeSegmentValueFaceChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLFunsListViewH);
        [self.upView2 addSubview:self.typeSegment2];
    }
    return _typeSegment2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.listTitle;
    
    self.upView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLFunsListViewH)];
    self.upView2.scrollEnabled = YES;
    self.upView2.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView2];
    
    self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLFunsListViewH);
    [self.upView2 addSubview:self.typeSegment2];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLFunsListViewH+64, self.contentView.width, self.contentView.height-YKLFunsListViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueChanged:self.typeSegment];

    if (!self.hideSideButton) {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 20, 50);
        leftButton.centerY = self.view.height/2;
        [leftButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"leftButton1"] forState:UIControlStateNormal];
        
        if ([self.payType isEqual:@""]) {
            leftButton.hidden = YES;
        }else{
            leftButton.hidden = NO;
        }
        
        [self.view addSubview:leftButton];
    }
   
    
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

//总选择器
- (void)typeSegmentValueChanged:(UISegmentedControl *)segment {
    YKLFunsListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
        
    //还原选择器的原始位置
    self.typeSegment2.selectedSegmentIndex = 0;
    self.typeSegment3.selectedSegmentIndex = 0;
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0) animated:YES];
    [self.upView2 setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
            
            
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLLineReceiveStatusNotReceive;
            
            
        }
        
        listView = [[YKLFunsListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height) orderType:type ActivityID:self.activityID FansType:self.fansType PayType:self.payType];
        listView.delegate = self;

        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
        
    }
}

//到店付
- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLFunsListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
            
            
        }
        
        listView = [[YKLFunsListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type ActivityID:self.activityID FansType:self.fansType PayType:self.payType];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}

- (void)consumerOrderListView:(YKLFunsListView *)listView didSelectOrder:(YKLOrderListModel *)model {
    //    [self.switchManager switchToNextViewWithType:MPSUserViewTypeOrderDetail userInfo:model];
}


@end
