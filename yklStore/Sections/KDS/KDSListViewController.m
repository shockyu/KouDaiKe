//
//  KDSListViewController.m
//  yklStore
//
//  Created by 王硕 on 16/4/25.
//  Copyright © 2016年 wangshuo. All rights reserved.
//

#import "KDSListViewController.h"
#import "KDSDetailViewController.h"

#define DATE_FONT_COLOR                  HEXCOLOR(0xf87108)

#pragma mark - KDSListCell

@implementation KDSListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 灰色底
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
        bgView.backgroundColor = HEXCOLOR(0xEEEEEE);
        [self.contentView addSubview:bgView];
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 210)];
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.clipsToBounds = YES;
        sectionView.layer.cornerRadius = 3.0;
        [bgView addSubview:sectionView];
        
        _contentImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 275, 156)];
        [sectionView addSubview:_contentImage];
        
        UIView *wildView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(_contentImage)-15, 275, 15)];
        wildView.alpha = 0.8;
        wildView.backgroundColor = [UIColor whiteColor];
        [_contentImage addSubview:wildView];
        
        UIImageView *playIV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 2, 10, 10)];
        playIV.image = [UIImage imageNamed:@"play_index"];
        [wildView addSubview:playIV];
        
        _playNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(playIV)+WIDTH(playIV)+5, Y(playIV), 40, 10)];
        _playNumLabel.backgroundColor = [UIColor clearColor];
        _playNumLabel.textColor = HEXCOLOR(0x999999);
        _playNumLabel.font = [UIFont systemFontOfSize:12];
        [wildView addSubview:_playNumLabel];
        
        UIImageView *collectionIV = [[UIImageView alloc]initWithFrame:CGRectMake(X(_playNumLabel)+WIDTH(_playNumLabel)+20, Y(playIV), 10, 10)];
        collectionIV.image = [UIImage imageNamed:@"comment_num"];
        [wildView addSubview:collectionIV];
        
        _discussNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(collectionIV)+WIDTH(collectionIV)+5, Y(collectionIV), 40, 10)];
        _discussNumLabel.backgroundColor = [UIColor clearColor];
        _discussNumLabel.textColor = HEXCOLOR(0x999999);
        _discussNumLabel.font = [UIFont systemFontOfSize:12];
        [wildView addSubview:_discussNumLabel];
        
        _timeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(wildView)-40-6, Y(_discussNumLabel), 40, 10)];
        _timeNumLabel.backgroundColor = [UIColor clearColor];
        _timeNumLabel.textColor = HEXCOLOR(0x999999);
        _timeNumLabel.font = [UIFont systemFontOfSize:12];
        _timeNumLabel.numberOfLines = 0;
        [wildView addSubview:_timeNumLabel];
        
        _kdsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_contentImage), Y(_contentImage)+HEIGHT(_contentImage)+6, WIDTH(_contentImage), 15)];
        _kdsTitleLabel.backgroundColor = [UIColor clearColor];
        _kdsTitleLabel.textColor = HEXCOLOR(0x333333);
        _kdsTitleLabel.font = [UIFont systemFontOfSize:14];
        _kdsTitleLabel.numberOfLines = 0;
        [sectionView addSubview:_kdsTitleLabel];
        
        _kdsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_contentImage), Y(_kdsTitleLabel)+HEIGHT(_kdsTitleLabel)+4, WIDTH(_kdsTitleLabel), 11)];
        _kdsInfoLabel.backgroundColor = [UIColor clearColor];
        _kdsInfoLabel.textColor = HEXCOLOR(0x999999);
        _kdsInfoLabel.font = [UIFont systemFontOfSize:10];
        _kdsInfoLabel.numberOfLines = 0;
        [sectionView addSubview:_kdsInfoLabel];      
    }
    return self;
}

@end

@interface KDSListViewController ()<UITextFieldDelegate>
{
    BOOL            _isDescending;
    
    // search
    UITextField     *_searchTF;
    UIView          *_bgView;
}
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation KDSListViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"口袋说";
    }
    return self;
}

#pragma mark - viewLifeCycle

- (void)createSearchBar
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    _bgView.backgroundColor = [UIColor whiteColor];  //HEXCOLOR(0xEEEEEE);
    
    UIView *sbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, ScreenWidth, 30)];
    sbgView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:sbgView];
    
    UIImageView *sBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 250, 20)];
    sBgIV.image = [UIImage imageNamed:@"search_bg"];
    sBgIV.userInteractionEnabled = YES;
    [sbgView addSubview:sBgIV];
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(33, 2, WIDTH(sBgIV)-55, 20)];
    _searchTF.font = [UIFont systemFontOfSize:12];
    _searchTF.placeholder = @"搜索标题";
    [_searchTF becomeFirstResponder];
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchTF setReturnKeyType:UIReturnKeySearch];
    _searchTF.delegate = self;
    [sBgIV addSubview:_searchTF];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(WIDTH(sBgIV)-20, 2, 15, 15);
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(deleteSearch:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:[UIImage imageNamed:@"search_clear"] forState:UIControlStateNormal];
    [sBgIV addSubview:_deleteBtn];
    
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cButton.frame = CGRectMake(WIDTH(sbgView)-12-30, 5, 40, 20);
    [cButton addTarget:self action:@selector(exitSearch:) forControlEvents:UIControlEventTouchUpInside];
    [cButton setTitle:@"取消" forState:UIControlStateNormal];
    [cButton setTitleColor:HEXCOLOR(0x2FBBFC) forState:UIControlStateNormal];
    cButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [sbgView addSubview:cButton];
    
    [self.navigationController.navigationBar addSubview:_bgView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isDescending = YES;
    _pageInt = 1;
    

    if (_listType == KDSListTypeNormal)
    {
        [self createRightBar];
    }
    
    // 发送请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self refreshTableViewWithHasMore:YES];
    [self pullingTableViewDidStartRefreshing:_kDSTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (_listType == KDSListTypeSearch)
    {
        self.navigationItem.hidesBackButton = YES;
        [self createSearchBar];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_listType == KDSListTypeSearch)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [_bgView removeFromSuperview];
    }
}

- (void)refreshTableViewWithHasMore:(BOOL)hasMore
{
    if(!_kDSTableView)
    {
        _kDSTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kStatusbarHeight + kNavbarHeight,
                                                                                 ScreenWidth,
                                                                                 ScreenHeight - kStatusbarHeight - kNavbarHeight)
                                                              style:UITableViewStylePlain];
        _kDSTableView.pullingDelegate = self;
        _kDSTableView.delegate = self;
        _kDSTableView.dataSource = self;
        _kDSTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _kDSTableView.backgroundColor = HEXCOLOR(0xEEEEEE);
        _kDSTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        if (_listType == KDSListTypeNormal)
        {
            _kDSTableView.tableHeaderView = [self createHeadView];
        }
        
        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        fView.backgroundColor = HEXCOLOR(0xEEEEEE);
        _kDSTableView.tableFooterView = fView;
    
        [self.view addSubview:_kDSTableView];
    }
    [_kDSTableView tableViewDidFinishedLoading];
    _kDSTableView.reachedTheEnd = !hasMore;
    
    [_kDSTableView reloadData];    
}

- (UIView *)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10 + 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        topView.backgroundColor = HEXCOLOR(0xeeeeee);
        [headView addSubview:topView];
    }
    
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(14, 10+10, 15, 13);
    [sortBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [sortBtn setImage:[UIImage imageNamed:@"sort_p"] forState:UIControlStateSelected];
    [sortBtn addTarget:self
                action:@selector(sortBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:sortBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(X(sortBtn)+WIDTH(sortBtn)+32, 5+10, 250, 20);
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self
               action:@selector(searchBtnClicked)
     forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:searchBtn];
    
    return headView;
}

- (void)createRightBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(showFavourite) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0 , 0, 30, 22);
    [btn setImage:[UIImage imageNamed:@"my_favourite"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Funs

// 搜索
- (void)searchBtnClicked
{
    KDSListViewController *ctl = [[KDSListViewController alloc] init];
    ctl.title = @"";
    ctl.listType = KDSListTypeSearch;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)showFavourite
{
    KDSListViewController *ctl = [[KDSListViewController alloc] init];
    ctl.title = @"我的收藏";
    ctl.userIDStr = [YKLLocalUserDefInfo defModel].userID;
    ctl.listType = KDSListTypeFavorites;
    [self.navigationController pushViewController:ctl animated:YES];
}

// 排序
- (void)sortBtnClicked:(UIButton *)aBtn
{
    aBtn.selected = !aBtn.selected;
    
    _isDescending = !aBtn.selected;
    
    // refresh data
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    _pageInt = 1;
    [self requestKDSList];
}

#pragma mark - request

// 请求口袋说列表
- (void)requestKDSList
{
    NSString *urlStr = ROOTZZS_URL;
    NSDictionary *baseDict = @{
//                             @"act"           : KDS_LIST_ACT,
                             @"API_Token"     : API_Token,
                             @"sort_field"    : @"add_time",
                             @"sort"          : _isDescending ? @"desc" : @"asc",
                             @"current_page"  : [NSString stringWithFormat:@"%d", _pageInt],
                             @"page_count"    : @"10"
                             };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:baseDict];
    switch (_listType)
    {
        case KDSListTypeNormal:
        {
            params[@"act"] = KDS_LIST_ACT;
        }
            break;
        case KDSListTypeFavorites:
        {
            params[@"act"] = KDS_FAVOURITE_ACT;
            params[@"shop_id"] = [YKLLocalUserDefInfo defModel].userID;
        }
            break;
        case KDSListTypeSearch:
        {
            params[@"act"] = KDS_LIST_ACT;
            
            NSString *searchText = _searchTF.text;
            if (searchText.length)
            {
                params[@"key_word"] = searchText;
            }
            else
            {
                return;
            }
        }
            break;
        default:
            break;
    }
    
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         NSDictionary *returnDict = (NSDictionary *)responseObject;
         if (returnDict[@"success"])
         {
             NSArray *addedArr = returnDict[@"data"];
             if (!_kDSDicArr)
             {
                 _kDSDicArr = [[NSMutableArray alloc] init];
             }
             if (_pageInt == 1)
             {
                 [_kDSDicArr removeAllObjects];
             }
         
             if (addedArr)
             {
                 [_kDSDicArr addObjectsFromArray:addedArr];
             }
             
             int totals = [returnDict[@"total"] integerValue];
             
             if (_kDSDicArr.count >= totals)
             {
                 [self refreshTableViewWithHasMore:NO];
             }
             else
             {
                 [self refreshTableViewWithHasMore:YES];
             }
             
             if (![_kDSDicArr count])
             {
                 [self showEmptyView];
             }
             else
             {
                 [self removeEmptyView];
             }
         }
         else
         {
             [self showEmptyView];

             [self refreshTableViewWithHasMore:NO];
             
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self showEmptyView];

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark - PullingRefreshTableViewDelegate

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self requestKDSList];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    _pageInt = _pageInt + 1;
    [self requestKDSList];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
    [_kDSTableView tableViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [_kDSTableView tableViewDidScroll:scrollView];
}

#pragma mark - UITableViewDataSourceDelegate & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 220;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _kDSDicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KDSListCell";
    KDSListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[KDSListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_kDSDicArr count] > indexPath.row)
    {
        NSDictionary *aDict        = _kDSDicArr[indexPath.row];
        NSString *picUrl           = aDict[@"img"];
        [cell.contentImage sd_setImageWithURL:[NSURL URLWithString:picUrl]
                             placeholderImage:[UIImage imageNamed:@"no_image"]
                                      options:(SDWebImageOptions)SDWebImageRetryFailed];
        cell.kdsTitleLabel.text    = aDict[@"title"];
        cell.kdsInfoLabel.text     = aDict[@"desc"];
        cell.timeNumLabel.text     = aDict[@"time_long"];
        cell.playNumLabel.text     = aDict[@"play_num"];
        cell.discussNumLabel.text  = aDict[@"collection_num"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *aDict        = _kDSDicArr[indexPath.row];

    KDSDetailViewController *ctl = [[KDSDetailViewController alloc] init];
    ctl.idStr = aDict[@"id"];
    ctl.shopIdStr = [YKLLocalUserDefInfo defModel].userID;
    ctl.title = aDict[@"title"];
    [self.navigationController pushViewController:ctl animated:YES];
}

//删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listType == KDSListTypeFavorites)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary *aDict = _kDSDicArr[indexPath.row];
        NSString *idStr     = aDict[@"id"];
        NSString *shopIdStr = [YKLLocalUserDefInfo defModel].userID;
        
        //	1. 添加 2 取消收藏
        NSString *typeStr = @"2";
        NSString *urlStr = ROOTZZS_URL;
        NSDictionary *params = @{
                                 @"act"           : KDS_ADD_COLLECTION_ACT,
                                 @"API_Token"     : API_Token,
                                 @"shop_id"       : shopIdStr,
                                 @"file_id"       : idStr,
                                 @"type"       : typeStr,
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
                 [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
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
        
        // 默认删除成功
        [_kDSDicArr removeObjectAtIndex:indexPath.row];  //删除数组里的数据
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    }
}

#pragma mark - Search 

- (void)deleteSearch:(id)sender
{
    _searchTF.text = nil;
    _deleteBtn.hidden = YES;
}

// 返回
- (void)exitSearch:(id)sender
{
    [self leftBarItemClicked:sender];
}

#pragma mark - UITextField delegate

- (void)textFieldDidChange:(UITextField*)textField
{
    if(![_searchTF.text isEqualToString:@""])
    {
        _deleteBtn.hidden = NO;
    }
    else
    {
        _deleteBtn.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self requestKDSList];
    [textField resignFirstResponder];
    
    return YES;
}

@end
