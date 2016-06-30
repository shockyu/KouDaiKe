//
//  YKLShopOrderListViewController.m
//  yklStore
//
//  Created by willbin on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopOrderListViewController.h"
#import "YKLWebViewController.h"
#import "YKLShopPayViewController.h"


#define kNormalCellHeight   180
#define kExtendCellHeight   (180+40)

#define OrderBtnTitleLJFK   @"立即付款"
#define kActionTagLJFK      111

#define OrderBtnTitleQRSH   @"确认收货"
#define kActionTagQRSH      222

#define OrderBtnTitleLXKDK   @"联系口袋客"
#define kActionTagLXKDK     333

#define OrderBtnTitleQRDZ   @"款项于七个工作日内到帐"
#define OrderBtnTitleTKCG   @"退款成功"


#pragma mark - OrderListCell

@implementation OrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIColor *statusColor = YKLRedColor;
        UIFont *textFont = [UIFont systemFontOfSize:13];
        // 灰色底
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        bgView.backgroundColor = HEXCOLOR(0xebebeb);
        [self.contentView addSubview:bgView];
        
        NSInteger xPos = 12;
        NSInteger yPos = bgView.height + 10;
        
        // top
        UIImageView *shopIV = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 17, 17)];
        shopIV.image = [UIImage imageNamed:@"dingdanguanli_changjia"];
        [self.contentView addSubview:shopIV];
        
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, yPos, 200, 16)];
        _shopNameLabel.textColor = YKLTextColor;
        _shopNameLabel.font = textFont;
        [self.contentView addSubview:_shopNameLabel];
        
        _lcStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-80, yPos, 80, 16)];
        _lcStatusLabel.textAlignment = NSTextAlignmentRight;
        _lcStatusLabel.textColor = statusColor;
        _lcStatusLabel.font = textFont;
        [self.contentView addSubview:_lcStatusLabel];
        
        // center
        UIView *redBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 90)];
        redBGView.backgroundColor = HEXCOLOR(0xffe3e3);
        [self.contentView addSubview:redBGView];
        
        _imageIV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, 76, 76)];
        [redBGView addSubview:_imageIV];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_imageIV)+WIDTH(_imageIV)+11, Y(_imageIV), 150, 40)];
        _titleLabel.textColor = YKLTextColor;
        _titleLabel.font = textFont;
        _titleLabel.numberOfLines = 0;
        [redBGView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-65, Y(_imageIV), 65, 14)];
        _priceLabel.textColor = YKLTextColor;
        _priceLabel.font = [UIFont systemFontOfSize:12];
        [redBGView addSubview:_priceLabel];
        
        _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _infoBtn.frame = CGRectMake(X(_imageIV)+WIDTH(_imageIV)+11, 60, 100, 22);
        [_infoBtn setTitle:@"查看联采进度" forState:UIControlStateNormal];
        [_infoBtn addTarget:self
                     action:@selector(infoBtnClicked)
           forControlEvents:UIControlEventTouchUpInside];
        [_infoBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        _infoBtn.titleLabel.font = textFont;
        _infoBtn.clipsToBounds = YES;
        _infoBtn.layer.cornerRadius = 11;
        _infoBtn.layer.borderWidth = 1.0;
        _infoBtn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
        [redBGView addSubview:_infoBtn];
        
        _goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-70, 60, 70, 15)];
        _goodsNumLabel.backgroundColor = [UIColor clearColor];
        _goodsNumLabel.textColor = HEXCOLOR(0x9B9B9B);
        _goodsNumLabel.font = [UIFont systemFontOfSize:12];
        [redBGView addSubview:_goodsNumLabel];
        
        // bottom
        _sumPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, ScreenWidth-10-10, 40)];
        _sumPriceLabel.textAlignment = NSTextAlignmentRight;
        _sumPriceLabel.textColor = YKLTextColor;
        _sumPriceLabel.font = textFont;
        [self.contentView addSubview:_sumPriceLabel];
        
        // extend
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 180-0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xd8d8d8);
        [self.contentView addSubview:lineView];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.clipsToBounds = YES;
        _leftBtn.layer.borderWidth = 1.0;
        _leftBtn.layer.cornerRadius = 3.0;
        _leftBtn.frame = CGRectMake(ScreenWidth-10-100-10-100, 185, 100, 25);
        [_leftBtn addTarget:self action:@selector(actionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.titleLabel.font = textFont;
        [self.contentView addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.clipsToBounds = YES;
        _rightBtn.layer.borderWidth = 1.0;
        _rightBtn.layer.cornerRadius = 3.0;
        _rightBtn.frame = CGRectMake(ScreenWidth-10-100, 185, 100, 25);
        [_rightBtn addTarget:self action:@selector(actionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = textFont;
        [self.contentView addSubview:_rightBtn];
        
        _leftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return self;
}

- (void)infoBtnClicked
{
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(OrderListCell:didBtnClickedForDetailWithDict:)])
    {
        [_cellDelegate OrderListCell:self didBtnClickedForDetailWithDict:_cellDict];
    }
}

- (void)actionBtnClicked:(UIButton *)aBtn
{
    switch (aBtn.tag)
    {
        case kActionTagLJFK:
        {
            if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(OrderListCell:didBtnClickedForLJFKWithDict:)])
            {
                [_cellDelegate OrderListCell:self didBtnClickedForLJFKWithDict:_cellDict];
            }
        }
            break;
        case kActionTagQRSH:
        {
            if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(OrderListCell:didBtnClickedForQRSHWithDict:)])
            {
                [_cellDelegate OrderListCell:self didBtnClickedForQRSHWithDict:_cellDict];
            }
        }
            break;
        case kActionTagLXKDK:
        {
            NSURL *telURL = [NSURL URLWithString:@"tel://0731-89790322"];
            [[UIApplication sharedApplication] openURL:telURL];
        }
            break;
        default:
            break;
    }
}

- (void)showSubViewsWithType:(YKLShopOrderStateType)aType;
{
    NSString *picUrl = _cellDict[@"cover_img"];
//    [_imageIV sd_setImageWithURL:[NSURL URLWithString:picUrl]
//                placeholderImage:[UIImage imageNamed:@"no_image"]];
    [_imageIV sd_setImageWithURL:[NSURL URLWithString:picUrl]
                placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSLog(@"%@", error);
                }];
    
    _titleLabel.text     = _cellDict[@"goods_name"];
    _priceLabel.text     = [NSString stringWithFormat:@"￥%@/%@", _cellDict[@"price"], _cellDict[@"units"]];
    _goodsNumLabel.text  = [NSString stringWithFormat:@"共%@件", _cellDict[@"goods_num"]];
    _shopNameLabel.text = _cellDict[@"supplier"];

    switch ([_cellDict[@"status"] integerValue])
    {
        case 1:
        {
            _lcStatusLabel.text = @"联采进行中";
        }
            break;
        case 2:
        {
            _lcStatusLabel.text = @"联采失败";
        }
            break;
        case 3:
        {
            _lcStatusLabel.text = @"联采成功";
        }
            break;
        default:
            break;
    }
    _sumPriceLabel.text = [NSString stringWithFormat:@"合计: ¥ %@ (不含运费)", _cellDict[@"order_amount"]];
    
    // left and right buttons
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    
    _leftBtn.tag = 0;
    _rightBtn.tag = 0;
    
    _leftBtn.backgroundColor = [UIColor clearColor];
    _rightBtn.backgroundColor = [UIColor clearColor];
    switch (aType)
    {
        case YKLShopOrderStateTypeUnpay:
        {
            _rightBtn.hidden = NO;
            
            [_infoBtn setTitle:@"查看联采进度" forState:UIControlStateNormal];
            
            [_rightBtn setTitle:OrderBtnTitleLJFK forState:UIControlStateNormal];
            _rightBtn.tag = kActionTagLJFK;
            
            [_rightBtn setTitleColor:YKLRedColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = YKLRedColor.CGColor;
        }
            break;
        case YKLShopOrderStateTypePayed:
        {
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            
            [_infoBtn setTitle:@"查看商品详情" forState:UIControlStateNormal];
            
            [_leftBtn setTitle:_cellDict[@"express_info"] forState:UIControlStateNormal];
            [_rightBtn setTitle:OrderBtnTitleQRSH forState:UIControlStateNormal];
            _rightBtn.tag = kActionTagQRSH;

            
            [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _leftBtn.layer.borderColor = YKLRedColor.CGColor;
            _leftBtn.backgroundColor = YKLRedColor;

            [_rightBtn setTitleColor:YKLRedColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = YKLRedColor.CGColor;
            _rightBtn.backgroundColor = [UIColor whiteColor];
      }
            break;
        case YKLShopOrderStateTypeReceived:
        {
            [_infoBtn setTitle:@"查看商品详情" forState:UIControlStateNormal];
        }
            break;
        case YKLShopOrderStateTypeRefund:
        {
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            
            _infoBtn.hidden = YES;
            
            [_leftBtn setTitle:OrderBtnTitleLXKDK forState:UIControlStateNormal];
            _leftBtn.tag = kActionTagLXKDK;

            _rightBtn.backgroundColor = YKLRedColor;
            NSInteger refundState = [_cellDict[@"refund_state"] integerValue];
            if (refundState == 2) {
                [_rightBtn setTitle:OrderBtnTitleQRDZ forState:UIControlStateNormal];
            }
            if (refundState == 3) {
                [_rightBtn setTitle:OrderBtnTitleTKCG forState:UIControlStateNormal];
            }
            
            [_leftBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
            _leftBtn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
            _leftBtn.backgroundColor = [UIColor whiteColor];
            
            [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = YKLRedColor.CGColor;
            _rightBtn.backgroundColor = YKLRedColor;
         }
            break;
        default:
            break;
    }
}

@end

@interface YKLShopOrderListViewController ()
{
    PullingRefreshTableView     *_orderListTableView;
    
    NSMutableArray              *_orderDicArr;
    
    NSDictionary                *_orderDic;
    
    NSInteger                   _pageInt;
}
@end

@implementation YKLShopOrderListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(0xeaeaea);

    _pageInt = 1;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.y = 40;
    
    [self refreshTableViewWithHasMore:YES];
    [self pullingTableViewDidStartRefreshing:_orderListTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)refreshTableViewWithHasMore:(BOOL)hasMore
{
    if(!_orderListTableView)
    {
        _orderListTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0,
                                                                                 ScreenWidth,
                                                                                 ScreenHeight - kStatusbarHeight - kNavbarHeight - 40)
                                                                style:UITableViewStylePlain];
        _orderListTableView.pullingDelegate = self;
        _orderListTableView.delegate = self;
        _orderListTableView.dataSource = self;
        _orderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderListTableView.backgroundColor = HEXCOLOR(0xEEEEEE);
        [self.view addSubview:_orderListTableView];
    }
    [_orderListTableView tableViewDidFinishedLoading];
    _orderListTableView.reachedTheEnd = !hasMore;
    
    [_orderListTableView reloadData];
}

#pragma mark - Request

- (void)sendOrderListRequest
{
    /*
    参数名	参数类型	必传	缺省值	描述
    act	string	Y	get_orderList
    API_Token	string	Y	EPveMP8T-dJ_NGsoNN7VNZAX
    shop_id	int	Y		商户ID
     
    page_count	int	Y	10	页面显示条数
    current_page	int	Y		当前页码
    order_state	int	N		订单状态 0(已取消)10(默认):未付款;20:已付款;30:已发货;40:已收货;
     refund_state	int	N		退款状态 0 未申请 1 全部退款记录 2 退款中 3 退款成功
    */
    // 发送请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = ROOTShop_URL;
    NSDictionary *tmpDict = @{
                              @"act"           : ORDER_LIST_ACT,
                              @"API_Token"     : API_Token,
                              @"shop_id"       : [YKLLocalUserDefInfo defModel].userID,
                              
                              @"page_count"    : @"10",
                              @"current_page"  : [NSString stringWithFormat:@"%ld", (long)_pageInt],
                              };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:tmpDict];
    if (_orderType == YKLShopOrderStateTypeRefund)
    {
        params[@"refund_state"] = @"1";
    }
    else
    {
        params[@"order_state"] = [NSString stringWithFormat:@"%ld", (long)_orderType];
    }
    
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // 发送请求
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSDictionary *returnDict = (NSDictionary *)responseObject;
         returnDict = [returnDict dictionaryByReplacingNullsWithBlanks];
         
         BOOL isSuccess = [returnDict[@"success"] boolValue];
         if (isSuccess)
         {
             NSArray *addedArr = returnDict[@"data"];
             if (!_orderDicArr)
             {
                 _orderDicArr = [[NSMutableArray alloc] init];
             }
             if (_pageInt == 1)
             {
                 [_orderDicArr removeAllObjects];
             }
             
             if (addedArr)
             {
                 [_orderDicArr addObjectsFromArray:addedArr];
             }
             
             int totals = [returnDict[@"total"] integerValue];
             
             if (_orderDicArr.count >= totals)
             {
                 [self refreshTableViewWithHasMore:NO];
             }
             else
             {
                 [self refreshTableViewWithHasMore:YES];
             }
             
             if (![_orderDicArr count])
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
             
             [self refreshTableViewWithHasMore:NO];
             
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark - PullingRefreshTableViewDelegate

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    _pageInt = 1;
    [self sendOrderListRequest];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    _pageInt = _pageInt + 1;
    [self sendOrderListRequest];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
    [_orderListTableView tableViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [_orderListTableView tableViewDidScroll:scrollView];
}

#pragma mark - UITableViewDataSourceDelegate & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderDicArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger aHeight = kExtendCellHeight;
    if (_orderType == YKLShopOrderStateTypeReceived)
    {
        aHeight = kNormalCellHeight;
    }
    return aHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderListCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_orderDicArr count] > indexPath.row)
    {
        NSDictionary *aDict = _orderDicArr[indexPath.row];
        cell.cellDict = aDict;
        [cell showSubViewsWithType:_orderType];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - OrderListCellDelegate

- (void)OrderListCell:(OrderListCell *)cell didBtnClickedForDetailWithDict:(NSDictionary *)cellDict;
{
    NSString *idStr = cellDict[@"goods_id"];
    NSString *urlStr = [NSString stringWithFormat:@"http://ykl.meipa.net/admin.php/bargain/lc_goods/from/order_center/goods_id/%@.html", idStr];
    YKLWebViewController *ctl = [[YKLWebViewController alloc] init];
    ctl.lcUrl = urlStr;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)OrderListCell:(OrderListCell *)cell didBtnClickedForLJFKWithDict:(NSDictionary *)cellDict;
{
    /*
    {
        "add_time" = 1464015524;
        "buyer_id" = 29;
        "buyer_name" = "\U5065\U6765\U798f\U5f00\U798f\U65d7\U8230\U5e97";
        "cover_img" = "http://img4.youxiake.com/ps/2014/12/cover/20ad54675376560adc5bad5277477d4b.jpg";
        "end_time" = 1462949342;
        "express_info" = "";
        "finnshed_time" = 0;
        "goods_id" = 2;
        "goods_name" = "\U60c5\U4fa3\U62d6\U978b";
        "goods_num" = 234;
        id = 94;
        message = "";
        "order_amount" = "2316.60";
        "order_sn" = 2016052394;
        "order_state" = 10;
        "pay_sn" = "";
        "payment_code" = 0;
        "payment_time" = 0;
        price = "9.90";
        "refund_state" = 0;
        status = 1;
        supplier = "\U4e49\U4e4c\U5c0f\U5546\U54c1\U96c6\U56e2";
        units = "\U53cc";
    }
    */
    
//    NSDictionary *payDict = @{
//                              @"add_time"       : cellDict[@"add_time"],
//                              @"goods_name"     : cellDict[@"goods_name"],
//                              @"order_amount"   : cellDict[@"order_amount"],
//                              @"order_sn"       : cellDict[@"order_sn"],
//                              };
    
    YKLShopPayViewController *payVC = [YKLShopPayViewController new];
    payVC.payDict = cellDict; //payDict;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)OrderListCell:(OrderListCell *)cell didBtnClickedForQRSHWithDict:(NSDictionary *)cellDict;
{
    NSLog(@"222%@", cellDict);
 
    NSString *urlStr = ROOTShop_URL;
    NSDictionary *params = @{
                              @"act"           : ORDER_QRSH_ACT,
                              @"API_Token"     : API_Token,
                              @"order_id"      : cellDict[@"id"],
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
             
             // reload
             [self pullingTableViewDidStartRefreshing:_orderListTableView];
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

@end
