//
//  YKLExposureViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/12.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLExposureViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLExposureTableViewCell.h"
#import "YKLExposureModel.h"
#import "YKLChildUserExpoListViewController.h"

@interface YKLExposureViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>
@property (nonatomic, strong) UIView *timeBgView;
@property (nonatomic, strong) UIView *timeLineView;
@property (nonatomic, strong) UIImageView *startTimeImageView;
@property (nonatomic, strong) UIImageView *endTimeImageView;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *startTimeChooseLabel;
@property (nonatomic, strong) UILabel *endTimeChooseLabel;
@property (nonatomic, strong) UIButton *startTimeBtn;
@property (nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSDate *selectedDate;

//判断时间按钮点击情况
@property (nonatomic, strong) NSString *selectedStr;

@property (nonatomic, strong) UIView *tableUpView;
@property (nonatomic, strong) UILabel *timeUpLbael;
@property (nonatomic, strong) UILabel *nubUpLabel;

@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *exposureList;
@property (nonatomic, strong) YKLExposureModel *exposureModel;

@property (strong, nonatomic) UIView *maskTimeView;
@property (strong, nonatomic) UIView *pickerBgTimeView;
@property (strong, nonatomic) UIDatePicker *myTimePicker;

@end


@implementation YKLExposureViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"分店管理";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"chakanfendian"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightButtonClicked)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 40, 40);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
        
    }
    return self;
}

- (void)rightButtonClicked{
    
    YKLChildUserExpoListViewController *vc = [YKLChildUserExpoListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"访问详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    bgView.backgroundColor = [UIColor flatWhiteColor];
    [self.view addSubview:bgView];
    
    [self createTimeView];
    [self showTime];
    
    self.tableUpView = [[UIView alloc]initWithFrame:CGRectMake(10, self.selectBtn.bottom+10, self.view.width-20, 50)];
    self.tableUpView.backgroundColor = [UIColor lightGrayColor];
    self.tableUpView.layer.cornerRadius = 15;
    self.tableUpView.layer.masksToBounds = YES;
    [self.view addSubview:self.tableUpView];
    
    self.timeUpLbael = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.view.width-20)/2, 40)];
    //    self.timeUpLbael.backgroundColor = [UIColor yellowColor];
    self.timeUpLbael.textAlignment = NSTextAlignmentCenter;
    self.timeUpLbael.textColor = [UIColor whiteColor];
    self.timeUpLbael.font = [UIFont systemFontOfSize:14];
    self.timeUpLbael.text = @"日期";
    [self.tableUpView addSubview:self.timeUpLbael];
    
    self.nubUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.timeUpLbael.right, 0, (self.view.width-20)/2, 40)];
    //    self.nubUpLabel.backgroundColor = [UIColor blueColor];
    self.nubUpLabel.textAlignment = NSTextAlignmentCenter;
    self.nubUpLabel.textColor = [UIColor whiteColor];
    self.nubUpLabel.font = [UIFont systemFontOfSize:14];
    self.nubUpLabel.text = @"访问量";
    [self.tableUpView addSubview:self.nubUpLabel];
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(10, self.tableUpView.bottom-10, self.view.width-20, self.view.height-self.tableUpView.bottom+10);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerClass:[YKLExposureTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorColor = [UIColor flatLightWhiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;//滑动条不显示
    [self.view addSubview:self.tableView];
    
    self.exposureList = [NSMutableArray array];
    [self requestMoreProduct];

}

- (void)createTimeView{
    self.timeBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    self.timeBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.timeBgView];
    
    self.timeLineView = [[UIView alloc]initWithFrame:CGRectMake(50, self.timeBgView.height/2, self.view.width-50, 1)];
    self.timeLineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.timeBgView addSubview:self.timeLineView];
    
    self.startTimeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"开始时间"]];
    self.startTimeImageView.frame = CGRectMake(15, 15, 20, 20);
    [self.timeBgView addSubview:self.startTimeImageView];
    
    self.endTimeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"结束时间"]];
    self.endTimeImageView.frame = CGRectMake(15, self.startTimeImageView.bottom+15+15, 20, 20);
    [self.timeBgView addSubview:self.endTimeImageView];
    
    self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.startTimeImageView.right+15, self.startTimeImageView.top, 80, self.startTimeImageView.height)];
//    self.startTimeLabel.backgroundColor = [UIColor redColor];
    self.startTimeLabel.text = @"开始时间";
    self.startTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.timeBgView addSubview:self.startTimeLabel];
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeImageView.right+15, self.endTimeImageView.top, 80, self.endTimeImageView.height)];
//    self.endTimeLabel.backgroundColor = [UIColor redColor];
    self.endTimeLabel.text = @"结束时间";
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.timeBgView addSubview:self.endTimeLabel];
    
    self.startTimeChooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.startTimeLabel.right, self.startTimeLabel.top, 100, self.startTimeImageView.height)];
//    self.startTimeChooseLabel.backgroundColor = [UIColor redColor];
//    self.startTimeChooseLabel.text = @"2015-11-11";
    self.startTimeChooseLabel.font = [UIFont systemFontOfSize:14];
    [self.timeBgView addSubview:self.startTimeChooseLabel];
    
    self.endTimeChooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, 100, self.endTimeImageView.height)];
//    self.endTimeChooseLabel.backgroundColor = [UIColor redColor];
//    self.endTimeChooseLabel.text = @"2015-11-12";
    self.endTimeChooseLabel.font = [UIFont systemFontOfSize:14];
    [self.timeBgView addSubview:self.endTimeChooseLabel];
    
    self.startTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startTimeBtn.frame = CGRectMake(self.startTimeImageView.right+15, 0, self.view.width-self.startTimeImageView.right-15, 50);
    self.startTimeBtn.backgroundColor = [UIColor clearColor];
    self.startTimeBtn.tag = 4000;
    [self.startTimeBtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeBgView addSubview:self.startTimeBtn];
    
    self.endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endTimeBtn.frame = CGRectMake(self.startTimeBtn.left, self.startTimeBtn.bottom+1, self.startTimeBtn.width, 50);
    self.endTimeBtn.backgroundColor = [UIColor clearColor];
    self.endTimeBtn.tag = 4001;
    [self.endTimeBtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeBgView addSubview:self.endTimeBtn];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(self.view.width-60, self.timeBgView.bottom+10, 50, 25);
    [self.selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn setImage:[UIImage imageNamed:@"查询"] forState:(UIControlStateNormal)];
    [self.selectBtn setImage:[UIImage imageNamed:@"查询hover"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:self.selectBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:self.selectBtn.frame];
    label.text = @"查询";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
}

- (void)selectBtnClicked:(id)sender{
    NSLog(@"查询按钮");
    NSString*startString = self.startTimeChooseLabel.text;
    NSArray *startArray = [startString componentsSeparatedByString:@"-"];
    
    NSString*endString = self.endTimeChooseLabel.text;
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    
    startString = [startArray componentsJoinedByString:@""];
    endString = [endArray componentsJoinedByString:@""];
    
    int start = [startString intValue];
    int end = [endString intValue];
    NSLog(@"%d--%d",start,end);
    if (self.startTimeChooseLabel.text == nil||self.endTimeChooseLabel.text == nil) {
        [UIAlertView showInfoMsg:@"请先选择时间区间"];
        return;
    }
    if (start > end) {
        [UIAlertView showInfoMsg:@"开始时间不能大于结束时间"];
        return;
    }else if(start < end||start == end){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
        [self.exposureList removeAllObjects];
        [self.tableView reloadData];
        [self.tableView startLoad];

        [YKLNetworkingConsumer getExposureWithUserID:_shopID StartTime:self.startTimeChooseLabel.text EndTime:self.endTimeChooseLabel.text Success:^(NSArray *exposureModel) {
            
            if (exposureModel.count == 0) {
                self.tableView.loadMoreEnable = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.exposureList addObjectsFromArray:exposureModel];
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.exposureList.count-exposureModel.count end:self.exposureList.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endLoad];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.tableView endLoad];
            [UIAlertView showInfoMsg:error.domain];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }];
        
    }
    
}

- (void)showTime{
    
    self.maskTimeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskTimeView.backgroundColor = [UIColor blackColor];
    self.maskTimeView.alpha = 0;
    [self.maskTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyTimePicker)]];
    
    self.pickerBgTimeView.width = ScreenWidth;
    
    self.pickerBgTimeView = [[UIView alloc]initWithFrame: CGRectMake(0, 100, ScreenWidth, 266)];
    self.pickerBgTimeView.backgroundColor = [UIColor whiteColor];
    
    UIButton *yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [yesBtn setBackgroundColor: [UIColor clearColor]];
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [yesBtn addTarget:self action:@selector(ensureTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgTimeView addSubview:yesBtn];
    
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.pickerBgTimeView.width-50, 0, 50, 30)];
    [noBtn setBackgroundColor: [UIColor clearColor]];
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [noBtn addTarget:self action:@selector(cancelTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgTimeView addSubview:noBtn];
    
//    NSDate *minDate =[NSDate dateWithTimeIntervalSinceNow:0];//最小时间不小于今天
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Date滚轮"]];
    imageView.frame = CGRectMake(0, 50, ScreenWidth, 216);
    [self.pickerBgTimeView addSubview:imageView];
    
    self.myTimePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 216)];
    self.myTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.myTimePicker.datePickerMode = UIDatePickerModeDate;
//    self.myTimePicker.minimumDate = minDate;
    [self.pickerBgTimeView addSubview:self.myTimePicker];
    
}

//显示时间选择器
#pragma mark - private method
- (void)showMyTimePicker:(UIButton*)sender {
    NSLog(@"%ld",(long)sender.tag);
    self.selectedStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    [self.view addSubview:self.maskTimeView];
    [self.view addSubview:self.pickerBgTimeView];
    self.maskTimeView.alpha = 0;
    self.pickerBgTimeView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskTimeView.alpha = 0.3;
        self.pickerBgTimeView.bottom = self.view.height;
    }];
}


- (void)hideMyTimePicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskTimeView.alpha = 0;
        self.pickerBgTimeView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskTimeView removeFromSuperview];
        [self.pickerBgTimeView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (void)cancelTime:(id)sender {
    [self hideMyTimePicker];
}

- (void)ensureTime:(id)sender {
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [self.myTimePicker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =  [NSString stringWithFormat:
                          @"%@", destDateString];
    
    if ([self.selectedStr isEqualToString:@"4000"]) {
        self.startTimeChooseLabel.text = message;
    }
    if ([self.selectedStr isEqualToString:@"4001"]) {
        self.endTimeChooseLabel.text = message;
    }
    
    [self hideMyTimePicker];
    
}

- (void)refreshList {
    self.page = 0;
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
    [self.exposureList removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    //为空则传本地userID
    if (ISNULLSTR(_shopID)) {
        _shopID = [YKLLocalUserDefInfo defModel].userID;
    }
    
    [YKLNetworkingConsumer getExposureWithUserID:_shopID StartTime:@"" EndTime:@"" Success:^(NSArray *exposureModel) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (exposureModel.count == 0) {
            self.tableView.loadMoreEnable = NO;
        }
        
        self.view.userInteractionEnabled = YES;
        [self.exposureList addObjectsFromArray:exposureModel];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.exposureList.count-exposureModel.count end:self.exposureList.count] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    return self.exposureList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";
    
    // 让表格缓冲区查找可重用cell
    YKLExposureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLExposureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
//    YKLExposureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.exposureModel = self.exposureList[indexPath.row];

    cell.createTimeLabel.text = self.exposureModel.createTime;
    cell.exposureNumLabel.text = self.exposureModel.exposureNum;
   
    return cell;
}


@end
