//
//  YKLBargainActListView.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/20.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBargainActListView.h"
#import "YKLActivityListTableViewCell.h"
#import "YKLActivityListDetailViewController.h"
#import "YKLReleaseViewController.h"
#import "YKLLoginViewController.h"
#import "YKLShareContentModel.h"
#import "YKLShareViewController.h"
#import "YKLTogetherShareViewController.h"

@implementation YKLBargainActListView

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLActivityListType)type shopDict:(NSDictionary *)shopDict{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        _shopDict = shopDict;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLActivityListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.showShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.showShareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.showShareButton setTitle:@"合并分享" forState:UIControlStateNormal];
        [self.showShareButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [self.showShareButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
        self.showShareButton.backgroundColor = [UIColor flatOrangeColor];
        self.showShareButton.layer.cornerRadius = 10;
        self.showShareButton.layer.masksToBounds = YES;
        self.showShareButton.frame = CGRectMake(10, self.height-50, (ScreenWidth-60)/2, 40);
        [self.showShareButton addTarget:self action:@selector(showShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.showShareButton.hidden= YES;
        [self addSubview: self.showShareButton];
        
        
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
        self.cancelButton.backgroundColor = [UIColor flatLightRedColor];
        self.cancelButton.layer.cornerRadius = 10;
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.frame = CGRectMake(self.showShareButton.right+40, self.height-50, (ScreenWidth-60)/2, 40);
        [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.hidden= YES;
        [self addSubview: self.cancelButton];
        
        
        
        self.activityList = [NSMutableArray array];
        self.deleteDic = [[NSMutableDictionary alloc] init];
        
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.tintColor = [UIColor clearColor];
        [self.refreshControl addTarget:self action:@selector(refreshListView) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        
        self.refreshView = [[XHJDRefreshView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        [self.refreshView refreing];
        [self.refreshControl addSubview:self.refreshView];
        
        [self createBgNoneView];//创建没用数据背景
        [self requestMoreOrder];
     
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isSelected:) name:@"QMKJQuanXuanIsSelected"object:nil];
        
    }
    return self;
}

- (void)isSelected:(NSNotification *)text{
    
    if([text.userInfo[@"isSelected"]isEqual:@"YES"])
    {
        for (int row=0; row<self.activityList.count; row++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //点击添加存储
            [self.deleteDic setObject:self.activityList[indexPath.row] forKey:indexPath];
        }
    }
    else
    {
        for (int row=0; row<self.activityList.count; row++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
            //点击添加存储
            [self.deleteDic removeAllObjects];
        }
    }
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
            //            NSLog(@"%@--%@",timeArray[i],timeArray[i-1]);
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

- (void)refreshList {
    self.page = 0;
    [self requestMoreOrder];
}

- (void)refreshWaitList {
    self.page = 1;
    self.type = YKLActivityListTypeWait;
    [self requestMoreOrder];
}

- (void)refreshListView {
    [self.refreshControl endRefreshing];
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
    
    [YKLNetworkingConsumer releaseWithUserID:_shopDict[@"shopID"] Status:status Success:^(NSArray *activityListSummaryModel) {
        
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
        }
        
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
        
        [self.activityList addObjectsFromArray:activityListSummaryModel];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.activityList.count-activityListSummaryModel.count end:self.activityList.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //合并分享按钮显隐控制
        self.showShareButton.hidden = !_showBool;
        self.cancelButton.hidden = !_showBool;
        
        [self.tableView endLoad];
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.userInteractionEnabled = YES;
        
//        [UIAlertView showErrorMsg:error.domain];
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
    {
        expanded=[[d objectForKey:@"expanded"]intValue];
    }
    
    
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
    YKLActivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLActivityListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.type == YKLActivityListTypeIng) {
        
        cell.participantNubLabel.frame = CGRectMake(0,cell.lineView.bottom+10,106,18);
        cell.participantLabel.frame = CGRectMake(0,cell.participantNubLabel.bottom,106,18);
        cell.participantLineView.frame = CGRectMake(cell.participantLabel.right, cell.lineView.bottom+15, 0.5, 30);
        
        cell.successNubLabel.frame = CGRectMake(cell.participantNubLabel.right,cell.lineView.bottom+10,106,18);
        cell.successLabel.frame = CGRectMake(cell.participantNubLabel.right,cell.successNubLabel.bottom,106,18);
        cell.successLineView.frame = CGRectMake(cell.successLabel.right, cell.lineView.bottom+15, 0.5, 30);
        
        cell.dealLabel.hidden = YES;
        cell.dealNubLabel.hidden = YES;
        cell.dealLineView.hidden = YES;
        cell.dealMoneyLabel.hidden = YES;
        cell.dealMoneyNubLabel.hidden = YES;
        cell.shareReleaseBtn.hidden = YES;
        
        if (self.activityList.count){
            self.model = self.activityList[indexPath.row];
            cell.titleLabel.text = self.model.title;
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            cell.originalPriceLabel.text = self.model.originalPrice;
            cell.originalPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.model.originalPrice];
            //删除线
            NSUInteger length = [cell.originalPriceLabel.text length];
            cell.originalPriceLabel.size = CGSizeMake(length*8, 13);
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.originalPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
            [cell.originalPriceLabel setAttributedText:attri];
            
            cell.bargainLabel.text = [NSString stringWithFormat:@"¥%@",self.model.basePrice];
            cell.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.model.activityEndTime];
            if ([self.model.type isEqualToString:@"1"]) {
                cell.activityNameLabel.text = @"到店";
            }else{
                cell.activityNameLabel.text = @"促销";
            }
            cell.participantNubLabel.text = self.model.playersNum;
            cell.successNubLabel.text = self.model.playersOverNum;
            
            [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.shareBtn.tag = indexPath.row;
            
        }
    }
    
    if (self.type == YKLActivityListTypeWait) {
        cell.participantNubLabel.frame = CGRectMake(0,cell.lineView.bottom+10,106,18);
        cell.participantLabel.frame = CGRectMake(0,cell.participantNubLabel.bottom,106,18);
        cell.participantLineView.frame = CGRectMake(cell.participantLabel.right, cell.lineView.bottom+15, 0.5, 30);
        
        cell.successNubLabel.frame = CGRectMake(cell.participantNubLabel.right,cell.lineView.bottom+10,106,18);
        cell.successLabel.frame = CGRectMake(cell.participantNubLabel.right,cell.successNubLabel.bottom,106,18);
        cell.successLineView.frame = CGRectMake(cell.successLabel.right, cell.lineView.bottom+15, 0.5, 30);
        
        
        cell.dealLabel.hidden = YES;
        cell.dealNubLabel.hidden = YES;
        cell.dealLineView.hidden = YES;
        cell.dealMoneyLabel.hidden = YES;
        cell.dealMoneyNubLabel.hidden = YES;
        cell.shareBtn.hidden = YES;
        
        
        if (self.activityList.count){
            self.model = self.activityList[indexPath.row];
            cell.titleLabel.text = self.model.title;
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            cell.originalPriceLabel.text = self.model.originalPrice;
            cell.originalPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.model.originalPrice];
            //删除线
            NSUInteger length = [cell.originalPriceLabel.text length];
            cell.originalPriceLabel.size = CGSizeMake(length*8, 13);
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.originalPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
            [cell.originalPriceLabel setAttributedText:attri];
            
            cell.bargainLabel.text = [NSString stringWithFormat:@"¥%@",self.model.basePrice];
            cell.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.model.activityEndTime];
            if ([self.model.type isEqualToString:@"1"]) {
                cell.activityNameLabel.text = @"到店";
            }else{
                cell.activityNameLabel.text = @"促销";
            }
            [cell.shareReleaseBtn addTarget:self action:@selector(shareReleaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.shareReleaseBtn.tag = indexPath.row;
            
            UILongPressGestureRecognizer *deleteTapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteWaitActivity:)];
            [cell addGestureRecognizer:deleteTapGestureRecognizer];
            
            UIView *deleteTapView = [deleteTapGestureRecognizer view];
            deleteTapView.tag = indexPath.row;
        }
    }
    
    if (self.type == YKLActivityListTypeDone) {
        cell.shareBtn.hidden = YES;
        cell.shareReleaseBtn.hidden = YES;
        
        NSDictionary* m= (NSDictionary*)[_doneData objectAtIndex: indexPath.section];
        NSArray *d = (NSArray*)[m objectForKey:@"users"];
        
        if (d == nil) {
            return cell;
        }
        
        //        //显示联系人名称
        //        cell.titleLabel.text = [d objectAtIndex: indexPath.row];
        //
        //        //    UIColor *newColor = [[UIColor alloc] initWithRed:(float) green:(float) blue:(float) alpha:(float)];
        //        cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_listbg.png"]];
        //        cell.titleImageView.image = [UIImage imageNamed:@"mod_user.png"];
        
        if (d){
            self.model = d[indexPath.row];
            cell.titleLabel.text = self.model.title;
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
            cell.originalPriceLabel.text = self.model.originalPrice;
            cell.originalPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.model.originalPrice];
            //删除线
            NSUInteger length = [cell.originalPriceLabel.text length];
            cell.originalPriceLabel.size = CGSizeMake(length*8, 18);
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.originalPriceLabel.text];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
            [cell.originalPriceLabel setAttributedText:attri];
            
            cell.bargainLabel.text = [NSString stringWithFormat:@"¥%@",self.model.basePrice];
            cell.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",self.model.activityEndTime];
            
            if ([self.model.type isEqualToString:@"1"]) {
                cell.activityNameLabel.text = @"到店";
            }else{
                cell.activityNameLabel.text = @"促销";
            }
            cell.participantNubLabel.text = self.model.playersNum;
            cell.successNubLabel.text = self.model.playersOverNum;
            cell.dealNubLabel.text = self.model.orderVol;
            cell.dealMoneyNubLabel.text = self.model.orderSale;
        }
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
    //合并发布状态点击反应
    if (!self.showBool) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    //点击添加存储
    [self.deleteDic setObject:self.activityList[indexPath.row] forKey:indexPath];
    
    NSArray *deleteArr = [self.deleteDic allValues];
    
    if (deleteArr.count == self.activityList.count) {
        [self.delegate allSelectdIs:YES];
    }
    else{
        [self.delegate allSelectdIs:NO];
    }

    
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
            [self.delegate showActivityListTypeIngDetailView:self didSelectOrder:self.activityList[indexPath.row]];
            break;
        case 1:
            [self.delegate showYKLActivityListTypeWaitDetailView:self didSelectOrder:self.activityList[indexPath.row]];
            break;
        case 2:
            [self.delegate showYKLActivityListTypeEndDetailView:self didSelectOrder:arry[row]];
            break;
            
        default:
            break;
    }
    
}

//点击移除存储
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.deleteDic removeObjectForKey:indexPath];
    
    [self.delegate allSelectdIs:NO];
}

//合并分享按钮
- (void)showShareButtonClick{
    
    NSLog(@"%@",[self.deleteDic allValues]);
    NSArray *deleteArr = [self.deleteDic allValues];
    NSMutableArray *deleteArr2 = [NSMutableArray array];
    
    if (deleteArr.count<2) {
        [UIAlertView showInfoMsg:@"请选择两个以上的活动合并发布"];
        return;
    }
    for (int i=0; i<deleteArr.count; i++) {
        self.model = deleteArr[i];
        [deleteArr2 addObject:self.model.activityID];
    }
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deleteArr2 options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    if (deleteArr.count == 0) {
        [UIAlertView showInfoMsg:@"请选择合并发布的活动"];
    }else{
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        HUD.labelText = @"正在合并发布信息";
        
        [YKLNetworkingConsumer shareActWithActArray:str Success:^(NSDictionary *shareDic) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            NSString *title = [shareDic objectForKey:@"title"];
            NSString *shareURL = [shareDic objectForKey:@"share_url"];
            NSString *shareImage = [shareDic objectForKey:@"share_img"];
            NSString *shareDesc = [shareDic objectForKey:@"share_desc"];
            
            NSString *strName = [YKLLocalUserDefInfo defModel].userName;
            title = [title stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
            shareDesc = [shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
            
            
            self.model.title = title;
            self.model.shareUrl = shareURL;
            self.model.shareDesc = shareDesc;
            self.model.shareImage = shareImage;
            
            [self.delegate showShareViewDidSelectOrder:self.model isPay:@"NO"];
            
            //取消合并发布状态
            [self cancelButtonClick];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            self.userInteractionEnabled = YES;
            [UIAlertView showErrorMsg:error.domain];
            
        }];
        
    }
    
}

//取消分享
- (void)cancelButtonClick{
    
    //合并分享处理
    _showBool = NO;
    self.showShareButton.hidden = YES;
    self.cancelButton.hidden = YES;
    [self.tableView setEditing:NO animated:YES];
    
    [self.delegate cancer_QMKJ_HB_ShareClicked];
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}

- (void)shareBtnClick:(UIButton *)sender{
    NSLog(@"点击了==--分享--==按钮");
    
    //合并发布状态点击反应
    if (self.showBool) {
        return;
    }
    
    self.model = self.activityList[sender.tag];
    [self.delegate showShareViewDidSelectOrder:self.model isPay:@"NO"];
    
}

- (void)shareReleaseBtnClick:(UIButton *)sender{
    NSLog(@"点击了==--分享并发布--==按钮");
    self.model = self.activityList[sender.tag];
    //    NSLog(@"%@,%@===%@",self.model.title,self.model.activityID,self.model.coverImg);
    
    //当前时间获取
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayTimeString = [dateFormatter stringFromDate:[NSDate date]];
    //    NSLog(@"当前：%@<<--->>结束时间：%@",todayTimeString,self.model.activityEndTime);
    
    //当前时间转换纯
    NSArray *todayArray = [todayTimeString componentsSeparatedByString:@"-"];
    todayTimeString = [todayArray componentsJoinedByString:@""];
    int today = [todayTimeString intValue];
    
    //结束时间转换
    NSString*endString = self.model.activityEndTime;
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    endString = [endArray componentsJoinedByString:@""];
    int end = [endString intValue];
    
    //    NSLog(@"%d--%d",today,end);
    
    if (endString == nil) {
        [UIAlertView showInfoMsg:@"未获取到活动结束时间"];
        return;
    }
    if (today > end ) {
        [UIAlertView showInfoMsg:@"活动结束时间已失效请重新设置"];
        return;
    }
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        
        [self.delegate showShareViewDidSelectOrder:self.model isPay:@"NO"];
        
    }else{
        
        [YKLNetworkingConsumer releaseActAndShareWithUserID:[YKLLocalUserDefInfo defModel].userID ActivityID:self.model.activityID Status:@"1" Success:^(NSDictionary *templateModel) {
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
            [YKLLocalUserDefInfo defModel].shareURL = self.model.shareUrl;
            [YKLLocalUserDefInfo defModel].shareTitle = self.model.title;
            [YKLLocalUserDefInfo defModel].shareDesc = self.model.shareDesc;
            [YKLLocalUserDefInfo defModel].shareImage = self.model.shareImage;
            [YKLLocalUserDefInfo defModel].shareActType = @"大砍价";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
            if (![[templateModel objectForKey:@"pay"] isEqual:@""]) {
                
                [self.delegate payViewDidSelectOrder:templateModel ActID:self.model.activityID];
                
            }else{
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                super.window.rootViewController = ShareVC;
                
            }
            
        } failure:^(NSError *error) {
            
            [UIAlertView showInfoMsg:error.domain];
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
        
        [YKLNetworkingConsumer delActivityWithActivityID:self.deletActivityID Success:^{
            
            //刷新待发布活动列表
            [self getActivitylist:@"2"];
        } failure:^(NSError *error) {
            [UIAlertView showInfoMsg:error.domain];
        }];
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end
