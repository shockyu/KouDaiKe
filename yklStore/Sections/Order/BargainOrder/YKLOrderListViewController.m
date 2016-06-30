//
//  YKLOderListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLOrderListViewController.h"
#import "YKLOrderListTableViewCell.h"
#import "TWTSideMenuViewController.h"


@implementation YKLOrderListView

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type {
    if (self = [super initWithFrame:frame]) {

        self.type = type;

        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLOrderListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
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


- (void)initDoneActData{
    
    self.monthDateArr = [NSMutableArray array];
    
    //创建demo数据
    _doneData = [[NSMutableArray alloc]initWithCapacity : 2];
    
    //利用数组来填充数据
    NSMutableArray *actArray = [[NSMutableArray alloc] initWithCapacity : 2];
    
    actArray = self.orders;
    
    for (int i = 0; i < actArray.count; i++) {
        
        self.model =  actArray[i];
        
        //按年月排序
        NSArray *array = [self.model.addTime componentsSeparatedByString:@"-"];
        NSString *monthStr = [NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        
        //按结束时间排序
        [self.monthDateArr addObject:monthStr];
        
//        [self.monthDateArr addObject:self.model.addTime];
        
    }
    
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:self.monthDateArr ];
    
    for (int i = 0; i < timeArray.count; i ++) {
        NSString *string = timeArray[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:string];
        if (i == 0) {
            _dict = [[NSMutableDictionary alloc]initWithCapacity : 2];
            [_dict setObject:timeArray[0] forKey:@"groupname"];
            NSMutableArray *tArr=[NSMutableArray array];
            [tArr addObject:actArray[0]];
            [_dict setObject:tArr forKey:@"users"];
            [_doneData addObject: _dict];
        }
        if (i > 0) {
            NSLog(@"%@--%@",timeArray[i],timeArray[i-1]);
            NSString *str1 = timeArray[i];
            NSString *str2 = timeArray[i-1];
            
            if ([str1 isEqualToString:str2]) {
                
                
                NSMutableArray *tArr=[_doneData.lastObject objectForKey:@"users"];
                [tArr addObject:actArray[i]];
                [_doneData.lastObject setObject:tArr forKey:@"users"];
                
                
            }else{
                _dict = [[NSMutableDictionary alloc]initWithCapacity : 2];
                [_dict setObject:string forKey:@"groupname"];
                NSMutableArray *tArr=[NSMutableArray array];
                [tArr addObject:actArray[i]];
                [_dict setObject:tArr forKey:@"users"];
                [_doneData addObject: _dict];
            }
            
        }
    }
    NSLog(@"%@",_doneData);
    
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
            [self getOrderslist:@"10"];
            break;
        case 1:
            [self getOrderslist:@"50"];
            break;
        default:
            break;
    }

}

- (void)getOrderslist:(NSString *)status{
    
    [self.orders removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    //订单中心接口
    [YKLNetworkingConsumer getOrderListWithOrderState:status PayType:@"1" Success:^(NSArray *orderModel) {
        if (orderModel.count == 0) {
            
            if ([status isEqual:@"10"]) {
                self.actingNoneView.hidden = NO;
            }
            if ([status isEqual:@"50"]) {
                self.actWaitNoneView.hidden = NO;
            }

            self.tableView.loadMoreEnable = NO;
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            return;
        }
        [self.orders addObjectsFromArray:orderModel];
        [self initDoneActData];
        [self collapseOrExpand:0];
        
        [self.tableView reloadData];
        [self.tableView endLoad];
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.userInteractionEnabled = YES;
        [UIAlertView showErrorMsg:error.domain];

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

//对指定的节进行“展开/折叠”操作
-(void)collapseOrExpand:(int)section{
    
    Boolean expanded = NO;
    //Boolean searched = NO;
    
    NSMutableDictionary* d=[_doneData objectAtIndex:section];
    
    if([d objectForKey:@"expanded"] == nil)
    {
        [self initDoneActData];
    }
    
    d=[_doneData objectAtIndex:section];
    
    //若本节model中的“expanded”属性不为空，则取出来
    if([d objectForKey:@"expanded"]!=nil)
    {
        //        expanded=[[d objectForKey:@"expanded"]intValue];
        //若原来是折叠的则展开，若原来是展开的则折叠
        [d setObject:[NSNumber numberWithBool:expanded] forKey:@"expanded"];
        [self initDoneActData];
    }
    else{
        //若原来是折叠的则展开，若原来是展开的则折叠
        [d setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
    }
}


//返回指定节的“expanded”值
-(Boolean)isExpanded:(int)section{
    Boolean expanded = NO;
    NSMutableDictionary* d=[_doneData objectAtIndex:section];
    
    //若本节model中的“expanded”属性不为空，则取出来
    if([d objectForKey:@"expanded"]!=nil)
        expanded=[[d objectForKey:@"expanded"]intValue];
    
    return expanded;
}


//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn= (UIButton*)sender;
    int section= btn.tag; //取得tag知道点击对应哪个块
    
    //	NSLog(@"click %d", section);
    [self collapseOrExpand:section];
    
    //刷新tableview
    [self.tableView reloadData];
    
}

#pragma mark - table view delegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    switch (self.type) {
//        case 0:
//            return self.orders.count;
//            break;
//        case 1:
//            return self.orders.count;
//            break;
//      
//        default:
//            break;
//    }
//    return self.orders.count;
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //     Return the number of sections.
    
    return [_doneData count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //        对指定节进行“展开”判断
    if (![self isExpanded:(int)section]) {
        
        //若本节是“折叠”的，其行数返回为0
        return 0;
    }
    NSDictionary* d=[_doneData objectAtIndex:section];
    NSLog(@"%@",[d objectForKey:@"users"]);
    return [[d objectForKey:@"users"] count];
}

// 设置header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
//
    NSDictionary* m= (NSDictionary*)[_doneData objectAtIndex: indexPath.section];
    NSArray *d = (NSArray*)[m objectForKey:@"users"];
    
    if (d == nil) {
        return cell;
    }
    if (d){
        self.model = d[indexPath.row];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.model.buyerName];
        cell.mobleLabel.text =[NSString stringWithFormat:@"联系方式：%@",self.model.mobile];
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
        cell.actTitleLabel.text = self.model.goodsName;
        cell.priceLabel.text = [NSString stringWithFormat:@"原价¥%@",self.model.goodsOriginalPrice];
        cell.lowestPriceLabel.text = [NSString stringWithFormat:@"最低砍到¥%@",self.model.goodsBasePrice];
        cell.peducePriceLabel.text = [NSString stringWithFormat:@"成交价¥%@",self.model.orderAmount];
        
        if ([self.model.orderType isEqual:@"1"]) {
            cell.typeImageView.image = [UIImage imageNamed:@"到店"];
        }
        else if ([self.model.orderType isEqual:@"2"]){
            cell.typeImageView.image = [UIImage imageNamed:@"动销"];
        }
    }
//    switch (self.type) {
//        case YKLFaceExchangeStatusWait:
//            self.model = self.orders[indexPath.row];
//            
//            cell.nameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.model.buyerName];
//            cell.mobleLabel.text =[NSString stringWithFormat:@"联系方式：%@",self.model.mobile];
//            [cell.avatarImageView setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
//            cell.actTitleLabel.text = self.model.goodsName;
//            cell.priceLabel.text = [NSString stringWithFormat:@"原价¥%@",self.model.goodsOriginalPrice];
//            cell.lowestPriceLabel.text = [NSString stringWithFormat:@"最低砍到¥%@",self.model.goodsBasePrice];
//            cell.peducePriceLabel.text = [NSString stringWithFormat:@"成交价¥%@",self.model.orderAmount];
//            
//            break;
//        case YKLFaceExchangeStatusDone:
//            self.model = self.orders[indexPath.row];
//            
//            cell.nameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.model.buyerName];
//            cell.mobleLabel.text =[NSString stringWithFormat:@"联系方式：%@",self.model.mobile];
//            [cell.avatarImageView setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
//            cell.actTitleLabel.text = self.model.goodsName;
//            cell.priceLabel.text = [NSString stringWithFormat:@"原价¥%@",self.model.goodsOriginalPrice];
//            cell.lowestPriceLabel.text = [NSString stringWithFormat:@"最低砍到¥%@",self.model.goodsBasePrice];
//            cell.peducePriceLabel.text = [NSString stringWithFormat:@"成交价¥%@",self.model.orderAmount];
//            
//            
//            break;
//        case YKLLineReceiveStatusNotReceive:
//            cell.bgView.size = CGSizeMake(self.width, 130+45);
//            
//            cell.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, self.width, 1)];
//            cell.lineView.backgroundColor = [UIColor flatLightWhiteColor];
//            [cell.bgView addSubview:cell.lineView];
//            
//            cell.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            cell.sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//            [cell.sendBtn setTitle:@"发给员工处理" forState:UIControlStateNormal];
//            [cell.sendBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//            [cell.sendBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
//            cell.sendBtn.backgroundColor = [UIColor flatLightRedColor];
//            cell.sendBtn.layer.cornerRadius = 15;
//            cell.sendBtn.layer.masksToBounds = YES;
//            cell.sendBtn.frame = CGRectMake(160,self.lineView.bottom+10,150,self.bgView.height-self.lineView.bottom-20);
//            [cell.sendBtn addTarget:self action:@selector(sendBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.bgView addSubview: cell.sendBtn];
//            
//            break;
//        case YKLLineReceiveStatusWaitReceived:
//            cell.bgView.size = CGSizeMake(self.width, 130+45);
//      
//            cell.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, self.width, 1)];
//            cell.lineView.backgroundColor = [UIColor flatLightWhiteColor];
//            [cell.bgView addSubview:cell.lineView];
//            
//            break;
//        case YKLLineReceiveStatusDone:
//            cell.bgView.size = CGSizeMake(self.width, 130+45);
//            
//            cell.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, self.width, 1)];
//            cell.lineView.backgroundColor = [UIColor flatLightWhiteColor];
//            [cell.bgView addSubview:cell.lineView];
//            
//            break;
//        default:
//            break;
//    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    
    
    UIView *hView;
    if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
        UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
    {
        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 40)];
    }
    else
    {
        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        //self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
    }
    //UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UIButton* eButton = [[UIButton alloc] init];
    
    //按钮填充整个视图
    eButton.frame = hView.frame;
    [eButton addTarget:self action:@selector(expandButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    //根据是否展开，切换按钮显示图片
    if ([self isExpanded:section])
        [eButton setImage: [ UIImage imageNamed: @"btn_down.png" ] forState:UIControlStateNormal];
    else
        [eButton setImage: [ UIImage imageNamed: @"btn_right.png" ] forState:UIControlStateNormal];
    
    
    //由于按钮的标题，
    //4个参数是上边界，左边界，下边界，右边界。
    eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    
    
    //设置按钮显示颜色
    eButton.backgroundColor = [UIColor lightGrayColor];
    [eButton setTitle:[[_doneData objectAtIndex:section] objectForKey:@"groupname"] forState:UIControlStateNormal];
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [eButton setBackgroundImage: [ UIImage imageNamed: @"btn_listbg.png" ] forState:UIControlStateNormal];//btn_line.png"
    //[eButton setTitleShadowColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
    //[eButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    
    [hView addSubview: eButton];
    
    return hView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    [self.delegate consumerOrderListView:self didSelectOrder:self.orders[indexPath.row]];
    
    
    //获取第几分区
    NSUInteger section = [indexPath section];
    //获取行
    NSUInteger row=[indexPath row];
    NSLog(@"%lu-%lu",(unsigned long)section,(unsigned long)row);
    _dict = _doneData[section];
    NSMutableArray *arry = [_dict objectForKey:@"users"];
    ;
    [self.delegate consumerOrderListView:self didSelectOrder:arry[row]];
    
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}



@end

const float YKLOderListUpViewH = 40;
@interface YKLOrderListViewController ()<YKLConsumerOrderListViewDelegate>

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UISegmentedControl *typeSegment2;
@property (nonatomic, strong) UISegmentedControl *typeSegment3;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *upView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;
@end

@implementation YKLOrderListViewController

- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLOderListUpViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLOderListUpViewH;
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
        
        self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLOderListUpViewH);
        [self.upView2 addSubview:self.typeSegment2];
    }
    return _typeSegment2;
}

//- (UISegmentedControl *)typeSegment3{
//    if (_typeSegment3 == nil) {
//        _typeSegment3 = [[UISegmentedControl alloc] initWithItems:@[@"待发货", @"待收货",@"已完成"]];
//        _typeSegment3.selectedSegmentIndex = 0;
//        
//        _typeSegment3.tintColor = [UIColor whiteColor];
//        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                                 NSForegroundColorAttributeName: [UIColor flatLightRedColor]};
//        [_typeSegment3 setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
//        [_typeSegment3 setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
//        
//        [_typeSegment3 addTarget:self action:@selector(typeSegmentValueLineChanged:) forControlEvents:UIControlEventValueChanged];
//        
//        self.typeSegment3.frame = CGRectMake(self.contentView.width, 0, self.contentView.width, YKLOderListUpViewH);
//        [self.upView2 addSubview:self.typeSegment3];
//    }
//    return _typeSegment3;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"订单中心";

    
//    self.upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLOderListUpViewH)];
//    self.upView.backgroundColor = [UIColor flatLightWhiteColor];
//    [self.view addSubview:self.upView];
    
//    self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, YKLOderListUpViewH);
//    [self.upView addSubview:self.typeSegment];
    
    self.upView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLOderListUpViewH)];
    self.upView2.scrollEnabled = YES;
    self.upView2.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView2];
    
    self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLOderListUpViewH);
    [self.upView2 addSubview:self.typeSegment2];
    
//    self.typeSegment3.frame = CGRectMake(self.contentView.width, 0, self.contentView.width, YKLOderListUpViewH);
//    [self.upView2 addSubview:self.typeSegment3];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLOderListUpViewH+64, self.contentView.width, self.contentView.height-YKLOderListUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueChanged:self.typeSegment];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:MPS_MSG_ORDER_STATUS_CHANGE object:nil];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 50);
    leftButton.centerY = self.view.height/2;
    [leftButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"leftButton1"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationController setNavigationBarHidden:YES];
    
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}


//- (void)refreshOrderList {
//   
//    YKLOrderListView *waitList = [self.orderListDictionary objectForKey:@0];
//    [waitList refreshList];
//    YKLOrderListView *doneList = [self.orderListDictionary objectForKey:@1];
//    [doneList refreshList];
//}

//总选择器
- (void)typeSegmentValueChanged:(UISegmentedControl *)segment {
    YKLOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
    
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
      
        listView = [[YKLOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height) orderType:type];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
        
        [self createBgNoneView];
    }
}

//到店付
- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {

    YKLOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];

    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
            
            
        }
       
        listView = [[YKLOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }

    
}

//线上付
- (void)typeSegmentValueLineChanged:(UISegmentedControl *)segment {
    
    YKLOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex+2]];
    
    [self.scrollView setContentOffset:CGPointMake((segment.selectedSegmentIndex+2)*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLLineReceiveStatusNotReceive;
            
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLLineReceiveStatusWaitReceived;
            
        }
        else if (segment.selectedSegmentIndex == 2) {
            type = YKLLineReceiveStatusDone;
            
        }
        
        listView = [[YKLOrderListView alloc] initWithFrame:CGRectMake((segment.selectedSegmentIndex+2)*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex+2]];
    }

}

- (void)consumerOrderListView:(YKLOrderListView *)listView didSelectOrder:(YKLOrderListModel *)model {
//    [self.switchManager switchToNextViewWithType:MPSUserViewTypeOrderDetail userInfo:model];
}

- (void)createBgNoneView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255, 225)];
    view.centerX = self.view.width/2;
    view.backgroundColor = [UIColor clearColor];
    view.hidden = YES;
    [self.scrollView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [view addSubview:imageView];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255, 225)];
    view2.centerX = self.scrollView.width+self.view.width/2;
    view2.backgroundColor = [UIColor clearColor];
    view2.hidden = YES;
    [self.scrollView addSubview:view2];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView2.frame = CGRectMake(0, 0, 255, 225);
    [view2 addSubview:imageView2];
    

}

@end
