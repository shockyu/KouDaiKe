//
//  YKLCommentViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLCommentViewController.h"
#import "MUILoadMoreTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XHJDRefreshView.h"
#import "YKLPayViewController.h"

@interface YKLCommentListCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *deleteButton;


@end

@implementation YKLCommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.width, 105)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
//        self.nameLabel.text = @"乌云";
        [self.bgView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-90, 10, 80, 20)];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
//        self.timeLabel.text = @"2016-03-15";
        [self.bgView addSubview:self.timeLabel];
        
        self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.nameLabel.bottom+5, self.width-20, 40)];
        self.descLabel.textColor = [UIColor lightGrayColor];
        self.descLabel.numberOfLines = 0;
//        self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        CGSize size = [self.descLabel sizeThatFits:CGSizeMake(self.descLabel.frame.size.width, MAXFLOAT)];
//        self.descLabel.frame =CGRectMake(10, self.nameLabel.bottom+5, self.width-20, size.height);
        self.descLabel.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:self.descLabel];
        
        /*
         ******************画虚线******************
         */
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为whiteColor
        [shapeLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
        //[shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
        // 3.0f设置虚线的宽度
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
          [NSNumber numberWithInt:2],nil]];
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, self.descLabel.height-1);
        CGPathAddLineToPoint(path, NULL, 320,self.descLabel.height-1);
        // Setup the path CGMutablePathRef path = CGPathCreateMutable(); // 0,10代表初始坐标的x，y
        // 320,10代表初始坐标的x，y CGPathMoveToPoint(path, NULL, 0, 10);
        CGPathAddLineToPoint(path, NULL, 320,10);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的 [[self layer] addSublayer:shapeLa
        [[self.descLabel layer] addSublayer:shapeLayer];
        
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.deleteButton.backgroundColor = [UIColor redColor];
        self.deleteButton.frame = CGRectMake(self.width-55, self.descLabel.bottom+10, 55, 30);
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
        [self addSubview:self.deleteButton];
        
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end

@interface YKLCommentViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLCommentListModel *commentListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评论管理";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLCommentListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.fd_debugLogEnabled = YES;
    [self.view addSubview:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor clearColor];
    [self.refreshControl addTarget:self action:@selector(refreshListView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.refreshView = [[XHJDRefreshView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self.refreshView refreing];
    [self.refreshControl addSubview:self.refreshView];
    
    self.records = [NSMutableArray array];
    [self createBgNoneView];//创建没用数据背景
    [self requestMoreProduct];
}


- (void)refreshListView {
    [self.refreshControl endRefreshing];
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
    
    [self.records removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    if ([self.actType isEqual:@"全民砍价"]) {
        
        [YKLNetworkingConsumer getCommentWithActID:self.actID success:^(NSArray *list) {
            
            if (list.count == 0) {
                self.tableView.loadMoreEnable = NO;
                self.actingNoneView.hidden = NO;
            }
            [self.records addObjectsFromArray:list];
            
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-list.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endLoad];
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.tableView endLoad];
            
        }];
    }
    else if ([self.actType isEqual:@"全民秒杀"])
    {

        [YKLNetworkingMiaoSha getCommentWithActID:self.actID success:^(NSArray *list) {
            
            if (list.count == 0) {
                self.tableView.loadMoreEnable = NO;
                self.actingNoneView.hidden = NO;
            }
            [self.records addObjectsFromArray:list];
            
            [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-list.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endLoad];
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [self.tableView endLoad];
            
        }];

    }
    
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    self.commentListModel = self.records[indexPath.row];
    
    cell.nameLabel.text = self.commentListModel.nickName;
    cell.timeLabel.text = self.commentListModel.addtime;
    cell.descLabel.text = self.commentListModel.content;
    
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)deleteButtonClick:(UIButton *)sender{
    
    self.commentListModel = self.records[sender.tag];
    NSLog(@"%@",self.commentListModel.commentID);
    
    if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除评论" message:@"确定删除此评论？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
        
        [alertView show];
    }
    else if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"2"]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"对不起，删除评论功能只限黄钻用户使用。请先开通黄钻功能。" delegate:self cancelButtonTitle:@"开通VIP" otherButtonTitles: @"取消",nil];
        alertView.tag = 6000;
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 6000) {
        if (buttonIndex == 0) {
            
            YKLPayViewController *vc = [YKLPayViewController new];
            vc.payType = @"vip充值";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (buttonIndex == 0) {
        
         if ([self.actType isEqual:@"全民砍价"]) {
             
             [YKLNetworkingConsumer deleteCommentWithCommentID:self.commentListModel.commentID success:^(NSDictionary *dict) {
                 
                 [UIAlertView showInfoMsg:@"评论已成功删除！"];
                 [self refreshListView];
                 
             } failure:^(NSError *error) {
                 [UIAlertView showErrorMsg:error.domain];
             }];
         }
        else if ([self.actType isEqual:@"全民秒杀"])
        {
            [YKLNetworkingMiaoSha deleteCommentWithCommentID:self.commentListModel.commentID success:^(NSDictionary *dict) {
                
                [UIAlertView showInfoMsg:@"评论已成功删除！"];
                [self refreshListView];
                
            } failure:^(NSError *error) {
                [UIAlertView showErrorMsg:error.domain];
            }];

        }
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

- (void)createBgNoneView{
    
    self.actingNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255, 225)];
    self.actingNoneView.centerX = self.view.width/2;
    self.actingNoneView.backgroundColor = [UIColor clearColor];
    self.actingNoneView.hidden = YES;
    [self.tableView addSubview:self.actingNoneView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [self.actingNoneView addSubview:imageView];
    
    
}


@end
