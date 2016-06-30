//
//  YKLMiaoShaReleaseTemplateViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMiaoShaReleaseTemplateViewController.h"
#import "YKLReleaseModelTableViewCell.h"
#import "YKLMiaoShaReleaseViewController.h"
#import "YKLSpecialModelViewController.h"
#import "YKLPushWebViewController.h"
#import "YKLNoneSpecialModelViewController.h"


@implementation YKLMiaoShaReleaseTemplateView

- (instancetype)initWithFrame:(CGRect)frame
                     TempCode:(NSString *)tempCode{
    
    if (self = [super initWithFrame:frame]) {
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLReleaseModelTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.TemplateArr = [NSMutableArray array];
        self.tempCode = tempCode;
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
    
    [self getActivitylist];
    
}
- (void)getActivitylist{
    
    [YKLNetworkingHighGo getHighGoTemplateWithTempCode:self.tempCode Success:^(NSArray *templateModel) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        if (templateModel.count == 0) {
            self.tableView.loadMoreEnable = NO;
            
            [self.delegate noneTemplateListView];
        }else{
            
            [self.delegate TemplateListView];
        }
        
        [self.TemplateArr addObjectsFromArray:templateModel];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.TemplateArr.count-templateModel.count end:self.TemplateArr.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        [self.tableView endLoad];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.userInteractionEnabled = YES;
        [UIAlertView showErrorMsg:error.domain];
        
    }];
    
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.TemplateArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 188-35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"Cell";
    YKLReleaseModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YKLReleaseModelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.TemplateArr.count){
        self.templateModel = self.TemplateArr[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"标题：%@",self.templateModel.templateName];
        cell.priceNubLabel.text = [NSString stringWithFormat:@"¥%@", self.templateModel.templateMoney];
        cell.explainMoreLabel.text = self.templateModel.templateDesc;
        
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:self.templateModel.templateImage] placeholderImage:[UIImage imageNamed:@"Demo"]];
        [cell.imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageBtn.tag = indexPath.row;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"xxx%ld",(long)indexPath.row);
    
    [self.delegate consumerTemplateListView:self didSelectOrder:self.TemplateArr[indexPath.row]];
    
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}

- (void)imageBtnClick:(UIButton *)sender{
    self.templateModel = self.TemplateArr[sender.tag];
    NSLog(@"%@",self.templateModel.templateThumb);
    
    [self.delegate preViewTemplateListView:self.templateModel.templateThumb];
    
}

@end

@interface YKLMiaoShaReleaseTemplateViewController ()<YKLMiaoShaReleaseTemplateViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

@property (nonatomic, strong) NSString *tempCode;

@end

@implementation YKLMiaoShaReleaseTemplateViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"模板选择";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"口令模板" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor flatLightBlueColor];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, self.contentView.height)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.bounces = NO;
    
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueFaceChanged:0 TempCode:@""];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)rightBarClicked{
    
    YKLSpecialModelViewController *spVC = [YKLSpecialModelViewController new];
    spVC.actName = @"大砍价";
    [self.navigationController pushViewController:spVC animated:YES];
    
}

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode {
    
    YKLMiaoShaReleaseTemplateView *releaseTemplateView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment]];
    
    [self.scrollView setContentOffset:CGPointMake(segment*self.scrollView.width, 0) animated:YES];
    
    
    if (segment == 0) {
        
        releaseTemplateView = [[YKLMiaoShaReleaseTemplateView alloc] initWithFrame:CGRectMake(segment*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) TempCode:@""];
    }
    else if (segment == 1) {
        
        releaseTemplateView = [[YKLMiaoShaReleaseTemplateView alloc] initWithFrame:CGRectMake(segment*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) TempCode:tempCode];
    }
    
    releaseTemplateView.delegate = self;
    [self.scrollView addSubview:releaseTemplateView];
    
    [self.orderListDictionary setObject:releaseTemplateView forKey:[NSNumber numberWithInteger:segment]];
    
}

- (void)consumerTemplateListView:(YKLMiaoShaReleaseTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model{
    
    NSLog(@"%@=>%@=>%@",model.templateName,model.templateMoney,model.templateThumb);
    
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    YKLMiaoShaReleaseViewController *releaseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //初始化其属性
    [releaseVC.actTemplateChangeBtn setTitle:@"" forState:UIControlStateNormal];
    //传递参数过去
    [releaseVC.actTemplateChangeBtn setTitle:model.templateName forState:UIControlStateNormal];
    releaseVC.templateNub = model.templateID;
    releaseVC.templatePrice = model.templateMoney;
    //使用popToViewController返回并传值到上一页面
    [self.navigationController popToViewController:releaseVC animated:YES];
    
}

//预览模板
- (void)preViewTemplateListView:(NSString *)url{
    
    YKLPushWebViewController *pushVC = [YKLPushWebViewController new];
    pushVC.webURL = url;
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

//未找到特殊模板
- (void)noneTemplateListView{
    
    YKLNoneSpecialModelViewController *vc = [YKLNoneSpecialModelViewController new];
    vc.actName = @"大砍价";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.scrollView.scrollEnabled = NO;
}

//找到特殊模板
- (void)TemplateListView{
    
    self.scrollView.scrollEnabled = YES;
}

@end
