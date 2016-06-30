//
//  YKLBalanceDetailsListView.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBalanceDetailsListView.h"

@interface YKLBalanceDetailsListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *actTypeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moblieLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
- (void)updateWithFanModel:(YKLWithDrawCashModel *)model;

@end

@implementation YKLBalanceDetailsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor blackColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:10];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:18];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.statusLabel];
        
        self.actTypeLabel = [[UILabel alloc] init];
        self.actTypeLabel.font = [UIFont systemFontOfSize:9];
        self.actTypeLabel.textColor = [UIColor flatLightBlueColor];
        self.actTypeLabel.hidden = YES;
        [self.contentView addSubview:self.actTypeLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:9];
        self.nameLabel.textColor = [UIColor flatLightRedColor];
//        self.nameLabel.hidden = YES;
//        self.nameLabel.text = @"XXXX";
        [self.contentView addSubview:self.nameLabel];
        
//        self.moblieLabel = [[UILabel alloc] init];
//        self.moblieLabel.font = [UIFont systemFontOfSize:10];
//        self.moblieLabel.textColor = [UIColor lightGrayColor];
////        self.moblieLabel.hidden = YES;
////        self.moblieLabel.text = @"1511617321";
//        [self.contentView addSubview:self.moblieLabel];

        
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
    
//    self.nameLabel.text = model.nickname;
//    self.moblieLabel.text = [model.mobile isEqual:@"0"]? @"":model.mobile;
    
//    self.nameLabel.text = @"此处显示店铺名称";
    
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
    

    self.actTypeLabel.hidden = YES;
    
    if ([model.activityType isEqual:@"1"]) {
        self.actTypeLabel.hidden = NO;
        self.actTypeLabel.text = @"大砍价";
    }
    else if ([model.activityType isEqual:@"2"]){
        self.actTypeLabel.hidden = NO;
        self.actTypeLabel.text = @"一元抽奖";
    }
    else if ([model.activityType isEqual:@"3"]){
        self.actTypeLabel.hidden = NO;
        self.actTypeLabel.text = @"口袋红包";
    }
    else if ([model.activityType isEqual:@"4"]){
        self.actTypeLabel.hidden = NO;
        self.actTypeLabel.text = @"口袋夺宝";
    }
    else if ([model.activityType isEqual:@"5"]){
        self.actTypeLabel.hidden = NO;
        self.actTypeLabel.text = @"一元速定";
    }

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
    
    self.textLabel.frame = CGRectMake(20, 4, self.width/3*2-40, 18);
    self.nameLabel.frame = CGRectMake(20, 4+18+2, self.textLabel.width, 10);
    self.actTypeLabel.frame = CGRectMake(20, 4+18+10+2, self.textLabel.width, 10);
//    self.moblieLabel.frame = CGRectMake(self.nameLabel.right, 4+18+10+2, self.textLabel.width/2, 10);
    
    self.detailTextLabel.frame = CGRectMake(20, 4+18+10+10+4, self.textLabel.width, 10);
    
    self.statusLabel.frame = CGRectMake(self.textLabel.right, 8+9, self.width/3, 18);
    self.lineView.frame = CGRectMake(20,self.detailTextLabel.bottom+2,self.width-40, 0.5);
}
@end

@implementation YKLBalanceDetailsListView

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type orderID:(NSString *)orderID{
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        self.orderID = orderID;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLBalanceDetailsListCell class] forCellReuseIdentifier:@"Cell"];
        
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.records = [NSMutableArray array];
        
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
    actArray = self.records;
    
    for (int i = 0; i < actArray.count; i++) {
        
        self.recordModel =  actArray[i];
        
        //按年月排序
        NSArray *array = [[self.recordModel.createTime timeNumber] componentsSeparatedByString:@"-"];
        NSString *monthStr = [NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        //按结束时间排序
        [self.monthDateArr addObject:monthStr];
        
        //[self.monthDateArr addObject:self.model.createTime];
        
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
            [self getOrderslist:@""];
            break;
        case 1:
            [self getOrderslist:@"1"];
            break;
        case 2:
            [self getOrderslist:@"2"];
            break;
        default:
            break;
    }
    
}

- (void)getOrderslist:(NSString *)status{
    
    [self.records removeAllObjects];
    [self.tableView reloadData];
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.tableView.userInteractionEnabled = NO;
    [self.tableView startLoad];
    
    [YKLNetworkingConsumer getTransactionDetailWithShopID:[YKLLocalUserDefInfo defModel].userID Type:status success:^(NSArray *list) {
        if (list.count == 0) {
            self.tableView.loadMoreEnable = NO;
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            [self.tableView endLoad];
            
            if ([status isEqual:@""]) {
                self.actingNoneView.hidden = NO;
            }
            if ([status isEqual:@"1"]) {
                self.actWaitNoneView.hidden = NO;
            }
            if ([status isEqual:@"2"]) {
                self.actDoneNoneView.hidden = NO;
            }
            
            return;
        }
        [self.records addObjectsFromArray:list];
        [self initDoneActData];
        [self collapseOrExpand:0];
        
        [self.tableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.tableView.userInteractionEnabled = YES;
        [self.tableView endLoad];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.tableView.userInteractionEnabled = YES;
        [self.tableView endLoad];
        [UIAlertView showInfoMsg:error.domain];
        
    }];
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
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLBalanceDetailsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLBalanceDetailsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary* m= (NSDictionary*)[_doneData objectAtIndex: indexPath.section];
    NSArray *d = (NSArray*)[m objectForKey:@"users"];
    
    if (d == nil) {
        return cell;
    }
    if (d){
        
        self.recordModel = d[indexPath.row];
        [cell updateWithFanModel:self.recordModel];
        
    }
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


@end
