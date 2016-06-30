//
//  YKLHighGoActivityListView.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivityListView.h"
#import "YKLTogetherShareViewController.h"


@implementation YKLHighGoActivityListView


- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLActivityListType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLHighGOActivityListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.activityList = [NSMutableArray array];
        
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.tintColor = [UIColor clearColor];
        [self.refreshControl addTarget:self action:@selector(refreshListView) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        
        self.refreshView = [[XHJDRefreshView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        [self.refreshView refreing];
        [self.refreshControl addSubview:self.refreshView];
        
        
        [self createBgNoneView];//创建没用数据背景
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
    actArray = self.activityList;
    
    for (int i = 0; i < actArray.count; i++) {
        
        self.model =  actArray[i];
        
        //按年月排序
        NSArray *array = [self.model.activityEndTime componentsSeparatedByString:@"-"];
        NSString *monthStr = [NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        
        //按结束时间排序
        [self.monthDateArr addObject:monthStr];
        
//        [self.monthDateArr addObject:self.model.activityEndTime];
        
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
//    NSLog(@"%@",_doneData);
    
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

- (void)refreshWaitList {
    self.page = 1;
    self.type = YKLActivityListTypeWait;
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
            [self getActivitylist:@"1"];
            break;
        case 1:
            [self getActivitylist:@"2"];
            break;
        case 2:
            [self getActivitylist:@"3"];
            break;
        default:
            break;
    }
}

- (void)getActivitylist:(NSString *)status{
    
    [self.activityList removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    //[YKLNetworkingConsumer releaseWithUserID
    
    [YKLNetworkingHighGo getActListWithUserID:[YKLLocalUserDefInfo defModel].userID Status:status Success:^(NSArray *activityListSummaryModel) {
        if (activityListSummaryModel.count == 0) {
            
            if ([status isEqual:@"1"]) {
                self.actingNoneView.hidden = NO;
            }
            if ([status isEqual:@"2"]) {
                self.actWaitNoneView.hidden = NO;
            }
            if ([status isEqual:@"3"]) {
                self.actDoneNoneView.hidden= NO;
            }
            
            self.tableView.loadMoreEnable = NO;
            [self.tableView endLoad];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            
            return;
            
        }else{
            if ([status isEqual:@"1"]) {
                self.actingNoneView.hidden = YES;
            }
            if ([status isEqual:@"2"]) {
                self.actWaitNoneView.hidden = YES;
            }
            if ([status isEqual:@"3"]) {
                self.actDoneNoneView.hidden= YES;
            }
            
            if ([status isEqual:@"3"]) {
                [self.activityList addObjectsFromArray:activityListSummaryModel];
                [self initDoneActData];
                [self collapseOrExpand:0];

                [self.tableView reloadData];
                [self.tableView endLoad];
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                return ;
            }
        }
        
        [self.activityList addObjectsFromArray:activityListSummaryModel];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.activityList.count-activityListSummaryModel.count end:self.activityList.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //     Return the number of sections.
    if (self.type == 2) {
        return [_doneData count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.type == 2) {
        //        对指定节进行“展开”判断
        if (![self isExpanded:(int)section]) {
            
            //若本节是“折叠”的，其行数返回为0
            return 0;
        }
        
        NSDictionary* d=[_doneData objectAtIndex:section];
        NSLog(@"%@",[d objectForKey:@"users"]);
        
        return [[d objectForKey:@"users"] count];
        
    }
    
    return self.activityList.count;
}

// 设置header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == 2) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLHighGOActivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLHighGOActivityListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.type == YKLActivityListTypeIng) {

        cell.shareReleaseBtn.hidden = YES;

        if (self.activityList.count){
            
            self.model = self.activityList[indexPath.row];
            
            cell.actTitleLabel.text = self.model.title;
            cell.descLabel.text = self.model.desc;
            cell.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.model.activityEndTime];
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            
            cell.participantNubLabel.text = self.model.joinNum;
            cell.successNubLabel.text = self.model.successNum;
            
            [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.shareBtn.tag = indexPath.row;

        }
    }
    
    if (self.type == YKLActivityListTypeWait) {

        cell.shareBtn.hidden = YES;
//
        if (self.activityList.count){
            self.model = self.activityList[indexPath.row];
            cell.actTitleLabel.text = self.model.title;
            cell.descLabel.text = self.model.desc;
            cell.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.model.activityEndTime];
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            
            [cell.shareReleaseBtn addTarget:self action:@selector(shareReleaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.shareReleaseBtn.tag = indexPath.row;
//
            UILongPressGestureRecognizer *deleteTapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteWaitActivity:)];
            [cell addGestureRecognizer:deleteTapGestureRecognizer];
//
            UIView *deleteTapView = [deleteTapGestureRecognizer view];
            deleteTapView.tag = indexPath.row;
        }
    }
//
    if (self.type == YKLActivityListTypeDone) {
        cell.participantLabel.hidden = YES;
        cell.participantNubLabel.hidden = YES;
        cell.participantLineView.hidden = YES;
        cell.successLabel.hidden = YES;
        cell.successNubLabel.hidden = YES;
        cell.successLineView.hidden = YES;
        
        cell.shareBtn.hidden = YES;
        cell.shareReleaseBtn.hidden = YES;

        NSDictionary* m= (NSDictionary*)[_doneData objectAtIndex: indexPath.section];
        NSArray *d = (NSArray*)[m objectForKey:@"users"];
        
        if (d == nil) {
            return cell;
        }
        
        if (d){
            self.model = d[indexPath.row];
            
//            self.model = self.activityList[indexPath.row];
            cell.actTitleLabel.text = self.model.title;
            cell.descLabel.text = self.model.desc;
            cell.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.model.activityEndTime];
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"xxx%ld",(long)indexPath.row);
    
    //获取第几分区
    NSUInteger section = [indexPath section];
    //获取行
    NSUInteger row=[indexPath row];
    NSLog(@"%lu-%lu",(unsigned long)section,(unsigned long)row);
    _dict = _doneData[section];
    NSMutableArray *arry = [_dict objectForKey:@"users"];
    ;

    switch (self.type) {
        case 0:
            [self.delegate showHigoActivityListTypeIngDetailView:self didSelectOrder:self.activityList[indexPath.row]];
            break;
        case 1:
            [self.delegate showYKLHigoActivityListTypeWaitDetailView:self didSelectOrder:self.activityList[indexPath.row]];
            break;
        case 2:
            [self.delegate showYKLHigoActivityListTypeEndDetailView:self didSelectOrder:arry[row]];
            break;
            
        default:
            break;
    }
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

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}

- (void)shareBtnClick:(UIButton *)sender{
    NSLog(@"点击了==--分享--==按钮");
    self.model = self.activityList[sender.tag];
    NSLog(@"%@",self.model.title);
    
    //调取显示分享页面方法
    [self.delegate showShareViewDidSelectHigoOrder:self.model isPay:@"NO"];
}

- (void)shareReleaseBtnClick:(UIButton *)sender{
    NSLog(@"点击了==--分享并发布--==按钮");
    self.model = self.activityList[sender.tag];
    NSLog(@"%@,%@===%@",self.model.title,self.model.activityID,self.model.coverImg);
    
//    //当前时间获取
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *todayTimeString = [dateFormatter stringFromDate:[NSDate date]];
//    NSLog(@"当前：%@<<--->>结束时间：%@",todayTimeString,self.model.activityEndTime);
//    
//    //当前时间转换纯
//    NSArray *todayArray = [todayTimeString componentsSeparatedByString:@"-"];
//    todayTimeString = [todayArray componentsJoinedByString:@""];
//    int today = [todayTimeString intValue];
//    
//    //结束时间转换
    NSString*endString = self.model.activityEndTime;
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    endString = [endArray componentsJoinedByString:@""];
//    int end = [endString intValue];
//
//    
//    NSLog(@"%d--%d",today,end);
    if (endString == nil) {
        [UIAlertView showInfoMsg:@"未获取到活动结束时间"];
        return;
    }
//    if (today > end ) {
//        [UIAlertView showInfoMsg:@"活动结束时间已失效请重新设置"];
//        return;
//    }
    
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
    
        [self.delegate showShareViewDidSelectHigoOrder:self.model isPay:@"NO"];
    
    }else{
        
        [YKLNetworkingHighGo releaseActWithActID:self.model.activityID Success:^(NSDictionary *dict) {
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
            [YKLLocalUserDefInfo defModel].shareURL = self.model.shareUrl;
            [YKLLocalUserDefInfo defModel].shareTitle = self.model.title;
            [YKLLocalUserDefInfo defModel].shareDesc = self.model.shareDesc;
            [YKLLocalUserDefInfo defModel].shareImage = self.model.shareImage;
            [YKLLocalUserDefInfo defModel].shareActType = @"一元抽奖";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
            
            if ([[dict objectForKey:@"pay"] isEqual:@""] || [[dict objectForKey:@"pay"] isEqual:@[]]) {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                super.window.rootViewController = ShareVC;
                
            }else{
                
                [self.delegate payViewHigoDidSelectOrder:dict ActID:self.model.activityID];
            }
        } failure:^(NSError *error) {
            
            [UIAlertView showErrorMsg:error.domain];
        }];
    }
}

- (void)deleteWaitActivity:(UILongPressGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        
        UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
        self.model = self.activityList[[singleTap view].tag];
        self.deletActivityID = self.model.activityID;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定删除此活动？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
        [alertView show];
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"%@",self.deletActivityID);
        
        [YKLNetworkingHighGo delActWithActID:self.deletActivityID Success:^{
            
            //刷新待发布活动列表
            [self getActivitylist:@"2"];
        } failure:^(NSError *error) {
            [UIAlertView showInfoMsg:error.domain];
        }];

    }
}



@end
