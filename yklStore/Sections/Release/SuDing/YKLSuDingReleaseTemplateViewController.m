//
//  YKLSuDingReleaseTemplateViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/6.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLSuDingReleaseTemplateViewController.h"
#import "YKLReleaseModelTableViewCell.h"
#import "YKLMiaoShaReleaseViewController.h"
#import "YKLSpecialModelViewController.h"
#import "YKLPushWebViewController.h"
#import "YKLNoneSpecialModelViewController.h"


@implementation YKLSuDingReleaseTemplateView

- (instancetype)initWithFrame:(CGRect)frame
                     TempCode:(NSString *)tempCode{
    
    if (self = [super initWithFrame:frame]) {
        
        _tempCateIDStr = kTemplateFakeIDStr;

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

- (void)showEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
    
    _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 568)];
    _emptyImageView.image = [UIImage imageNamed:@"no_data"];
    [self addSubview:_emptyImageView];
}

- (void)removeEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
}

- (void)getActivitylist{
    
    [YKLNetWorkingSuDing getSuDingTemplateWithTempCode:self.tempCode
                                                 cateID:_tempCateIDStr
                                                Success:^(NSArray *templateModel)
    {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        [self removeEmptyView];

        if (templateModel.count == 0) {
            self.tableView.loadMoreEnable = NO;
            
            [self showEmptyView];

            if (self.tempCode.length)
            {
                [self.delegate noneTemplateListView];
            }
        }else{
            
            [self.delegate TemplateListView];
        }
        
        //         [self.TemplateArr addObjectsFromArray:templateModel];
        //        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.TemplateArr.count-templateModel.count end:self.TemplateArr.count]
        //                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        {
            [self.TemplateArr removeAllObjects];
            [self.TemplateArr addObjectsFromArray:templateModel];
            
            [self.tableView reloadData];
        }
        
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
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.templateModel.templateImage] placeholderImage:[UIImage imageNamed:@"Demo"]];
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

@interface YKLSuDingReleaseTemplateViewController ()<YKLSuDingReleaseTemplateViewDelegate>
{
    NSArray         *_cateListArr;
    UIButton        *_selectedBtn;
    UIImageView     *_rightTipIV;
    UIScrollView    *_cateHorizontalScrollView;
    NSString        *_currentCateIDStr;
    
    UIScrollView    *_cateVerticalScrollView;
    BOOL            _isShowingList;
    UIImageView     *_checkIV;
    UIView          *_tipTextView;
}
@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

@property (nonatomic, strong) NSString *tempCode;

@end

@implementation YKLSuDingReleaseTemplateViewController

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
    
    [self sendCategoryListRequest];

    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40, self.contentView.width, self.contentView.height-40)];
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
    spVC.actName = @"一元速定";
    [self.navigationController pushViewController:spVC animated:YES];
    
}

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode {
    
    YKLSuDingReleaseTemplateView *releaseTemplateView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment]];
    
    [self.scrollView setContentOffset:CGPointMake(segment*self.scrollView.width, 0) animated:YES];
    
    
    if (segment == 0) {
        
        releaseTemplateView = [[YKLSuDingReleaseTemplateView alloc] initWithFrame:CGRectMake(segment*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) TempCode:@""];
    }
    else if (segment == 1) {
        
        releaseTemplateView = [[YKLSuDingReleaseTemplateView alloc] initWithFrame:CGRectMake(segment*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) TempCode:tempCode];
    }
    
    releaseTemplateView.delegate = self;
    releaseTemplateView.tag = kTemplateViewTag;

    [self.scrollView addSubview:releaseTemplateView];
    
    [self.orderListDictionary setObject:releaseTemplateView forKey:[NSNumber numberWithInteger:segment]];
    
}

- (void)consumerTemplateListView:(YKLSuDingReleaseTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model{
    
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
    vc.actName = @"全民秒杀";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.scrollView.scrollEnabled = NO;
}

//找到特殊模板
- (void)TemplateListView{
    
    self.scrollView.scrollEnabled = YES;
}


#pragma mark -

- (void)sendCategoryListRequest
{
    NSString *urlStr = @"http://ykl.meipa.net/admin.php/Api/getTempCategory";
    NSDictionary *params = @{
                             @"API_Token" : API_Token,
                             };
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *returnDict = (NSDictionary *)responseObject;
         returnDict = [returnDict dictionaryByReplacingNullsWithBlanks];
         BOOL isSuccess = [returnDict[@"success"] boolValue];
         if (isSuccess)
         {
             _cateListArr = returnDict[@"data"];
             [self showCategoryListView];
             
             UIButton *dstBtn = [_cateHorizontalScrollView viewWithTag:100];
             [self cateBtnClicked:dstBtn];
         }
         else
         {
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

- (void)showCategoryListView
{
    UIView *cateListBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    cateListBGView.backgroundColor = HEXCOLOR(0xebebeb);
    [self.view addSubview:cateListBGView];
    
    // left
    _cateHorizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 40, 30)];
    _cateHorizontalScrollView.backgroundColor = [UIColor whiteColor];
    _cateHorizontalScrollView.showsVerticalScrollIndicator = NO;
    _cateHorizontalScrollView.showsHorizontalScrollIndicator = NO;
    [cateListBGView addSubview:_cateHorizontalScrollView];
    
    // right
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_cateHorizontalScrollView.width-0.5, 10+7.5, 0.5, 15)];
        lineView.backgroundColor = HEXCOLOR(0x999999);
        [cateListBGView addSubview:lineView];
        
        UIView *tipBGView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 10, 40, 30)];
        tipBGView.backgroundColor = [UIColor whiteColor];
        [cateListBGView addSubview:tipBGView];
        
        _rightTipIV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 11, 14, 8)];
        _rightTipIV.backgroundColor = [UIColor whiteColor];
        _rightTipIV.image = [UIImage imageNamed:@"arrow_down"];
        [tipBGView addSubview:_rightTipIV];
        
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(showOrHideList)];
        [tipBGView addGestureRecognizer:aTap];
    }
    
    NSInteger aWidth = 80;
    _cateHorizontalScrollView.contentSize = CGSizeMake(aWidth * _cateListArr.count, _cateHorizontalScrollView.height);
    
    for (int i = 0; i < _cateListArr.count; i++)
    {
        NSDictionary *aDict = _cateListArr[i];
        
        UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.tag = 100 + i;
        aBtn.frame = CGRectMake(i * aWidth, 0, aWidth, _cateHorizontalScrollView.height);
        [aBtn addTarget:self action:@selector(cateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [aBtn setTitleColor:HEXCOLOR(0x585858) forState:UIControlStateNormal];
        [aBtn setTitleColor:HEXCOLOR(0xf64548) forState:UIControlStateSelected];
        [aBtn setTitle:aDict[@"name"] forState:UIControlStateNormal];
        [_cateHorizontalScrollView addSubview:aBtn];
        
        if (i == 0)
        {
            aBtn.selected = YES;
            _selectedBtn = aBtn;
        }
    }
}

- (void)cateBtnClicked:(UIButton *)aBtn
{
    _selectedBtn.selected = NO;
    aBtn.selected = !aBtn.selected;
    _selectedBtn = aBtn;
    
    NSInteger indexInt = aBtn.tag - 100;
    NSDictionary *aDict = _cateListArr[indexInt];
    _currentCateIDStr = aDict[@"id"];
    
    YKLSuDingReleaseTemplateView *templateView = (YKLSuDingReleaseTemplateView *)[self.scrollView viewWithTag:kTemplateViewTag];
    templateView.tempCateIDStr = _currentCateIDStr;
    [templateView refreshList];
}

- (void)cateCellClicked:(UIButton *)aBtn
{
    if (_isShowingList)
    {
        [self showOrHideList];
    }
    
    UIButton *dstBtn = [_cateHorizontalScrollView viewWithTag:aBtn.tag];
    [self cateBtnClicked:dstBtn];
}

- (void)showOrHideList
{
    _isShowingList = !_isShowingList;
    
    _cateVerticalScrollView.hidden = !_isShowingList;
    _tipTextView.hidden = _cateVerticalScrollView.hidden;
    if (_isShowingList)
    {
        _rightTipIV.image = [UIImage imageNamed:@"arrow_down"];
    }
    else
    {
        _rightTipIV.image = [UIImage imageNamed:@"arrow_up"];
    }
    
    
    // show list view
    if (!_cateVerticalScrollView)
    {
        _cateVerticalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, ScreenWidth, self.contentView.height - 40)];
        _cateVerticalScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_cateVerticalScrollView];
        
        _checkIV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-14, 14.5, 14, 11)];
        _checkIV.image = [UIImage imageNamed:@"tick"];
        
        {
            _tipTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, _cateHorizontalScrollView.width - 0.5, _cateHorizontalScrollView.height)];
            _tipTextView.backgroundColor = [UIColor whiteColor];
            [_cateHorizontalScrollView.superview addSubview:_tipTextView];
            
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, _tipTextView.height)];
            aLabel.textColor = HEXCOLOR(0xf64548);
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = @"    选择你需要的类型";
            [_tipTextView addSubview:aLabel];
        }
        
        NSInteger aHeight = 40;
        _cateVerticalScrollView.contentSize = CGSizeMake(_cateVerticalScrollView.width, aHeight * _cateListArr.count);
        for (int i = 0; i < _cateListArr.count; i++)
        {
            NSDictionary *aDict = _cateListArr[i];
            
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, i * aHeight, ScreenWidth, aHeight)];
            aView.backgroundColor = [UIColor whiteColor];
            [_cateVerticalScrollView addSubview:aView];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth, 0.5)];
            lineView1.backgroundColor = HEXCOLOR(0x999999);
            [aView addSubview:lineView1];
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.tag = 100 + i;
            aBtn.frame = CGRectMake(0, 0, ScreenWidth, aHeight);
            [aBtn addTarget:self action:@selector(cateCellClicked:) forControlEvents:UIControlEventTouchUpInside];
            aBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            aBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //            aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            
            [aBtn setTitleColor:HEXCOLOR(0x585858) forState:UIControlStateNormal];
            [aBtn setTitleColor:HEXCOLOR(0xf64548) forState:UIControlStateSelected];
            [aBtn setTitle:[NSString stringWithFormat:@"    %@", aDict[@"name"]] forState:UIControlStateNormal];
            
            [aView addSubview:aBtn];
            
            if (i == _cateListArr.count - 1)
            {
                UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, aView.height-0.5, ScreenWidth, 0.5)];
                lineView2.backgroundColor = HEXCOLOR(0x999999);
                [aView addSubview:lineView2];
            }
        }
    }
    
    [_checkIV removeFromSuperview];
    for (int i = 0; i < _cateListArr.count; i++)
    {
        UIButton *dstBtn = [_cateVerticalScrollView viewWithTag:100 + i];
        
        if (dstBtn.tag == _selectedBtn.tag)
        {
            dstBtn.selected = YES;
            [dstBtn addSubview:_checkIV];
        }
        else
        {
            dstBtn.selected = NO;
        }
    }
}

@end
