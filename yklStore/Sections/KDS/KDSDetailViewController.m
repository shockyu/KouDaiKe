//
//  KDSDetailViewController.m
//  yklStore
//
//  Created by willbin on 16/4/28.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "KDSDetailViewController.h"

#import "WMPlayer.h"
#import "KDSListViewController.h"
#import "YKLTogetherShareViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "AppDelegate.h"

#define RHPopViewBGColor        [HEXCOLOR(0x424242) colorWithAlphaComponent:0.4]

#define infoTextColor        HEXCOLOR(0x252525)


#define kCellHeightKey  @"kCellHeightKey"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@implementation KDSCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEXCOLOR(0xfefefe);
     
        UIColor *contentColor = HEXCOLOR(0x989898);
        NSInteger xPos = 11;
        NSInteger yPos = 8;
        
        _leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 31, 31)];
        _leftIV.clipsToBounds = YES;
        _leftIV.layer.cornerRadius = _leftIV.frame.size.width/2;
        [self.contentView addSubview:_leftIV];
        
        xPos = 50;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, ScreenWidth-xPos-100, 15)];
        _nameLabel.textColor = contentColor;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 10 -145, yPos, 145, 15)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = contentColor;
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 25, ScreenWidth-xPos-10, 0)];
        _contentLabel.textColor = HEXCOLOR(0x323232);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, yPos, ScreenWidth-50-10, 15)];
        _fromLabel.textAlignment = NSTextAlignmentRight;
        _fromLabel.textColor = contentColor;
        _fromLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_fromLabel];
        
        // 线
        UIImage *lineImg = [UIImage imageNamed:@"line"];
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        _lineView.image = lineImg;
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)showSubViews
{
    NSString *avatarStr = _cellDict[@"head_img"];
    [_leftIV sd_setImageWithURL:[NSURL URLWithString:avatarStr]
             placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    
    _nameLabel.text     = _cellDict[@"lianxiren"];
    _dateLabel.text     = _cellDict[@"add_time"];
    _contentLabel.text  = _cellDict[@"content"];
    _fromLabel.text     = [NSString stringWithFormat:@"来自: %@", _cellDict[@"shop_name"]];
    
    // 调整位置
    NSInteger yPos = _contentLabel.frame.origin.y;
    CGSize contentSize = WE_MULTILINE_TEXTSIZE(_contentLabel.text,
                                               _contentLabel.font,
                                               CGSizeMake(_contentLabel.frame.size.width, 10000),
                                               0);
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x,
                                     yPos,
                                     _contentLabel.frame.size.width,
                                     contentSize.height + 2);
    yPos = _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 3;
    
    _fromLabel.frame = CGRectMake(_fromLabel.frame.origin.x,
                                 yPos,
                                 _fromLabel.frame.size.width,
                                 _fromLabel.frame.size.height);
    yPos = _fromLabel.frame.origin.y + _fromLabel.frame.size.height + 3;
    
    _lineView.frame = CGRectMake(_lineView.frame.origin.x,
                                 yPos,
                                 _lineView.frame.size.width,
                                 _lineView.frame.size.height);
}

- (NSInteger)getCellHeight
{
    [self showSubViews];
    
    return _lineView.frame.origin.y + _lineView.frame.size.height;
}

@end


@interface KDSDetailViewController ()<UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView     *_KDSTableView;
    NSMutableArray              *_dataDictArr;
    NSMutableArray              *_heightNumArr;
    NSInteger                   _pageInt;

    NSString        *_oldIDStr;
    UILabel         *_cmtCountLabel;
    
    NSArray         *_seriesArr;
    
    NSDictionary    *_infoDict;
    WMPlayer        *_videoPlayer;
    CGRect          playerFrame;
    
    UIView          *_topHeaderView;
    
    // comment
    UIView          *_cmtBGView;
    UITextView      *_cmtTextView;
    UIButton        *_cmtBtn;
    
    // fav
    UIButton        *_favBtn;
    
    //
    UIView          *_netErrorView;
    UIView          *_netCarrierView;
    UIView          *_netErrorBigView;
    UIView          *_netCarrierBigView;
    
}
@end

@implementation KDSDetailViewController

- (void)releaseWMPlayer
{
    [_videoPlayer.player.currentItem cancelPendingSeeks];
    [_videoPlayer.player.currentItem.asset cancelLoading];
    
    [_videoPlayer.player pause];
    [_videoPlayer removeFromSuperview];
    [_videoPlayer.playerLayer removeFromSuperlayer];
    [_videoPlayer.player replaceCurrentItemWithPlayerItem:nil];
    _videoPlayer = nil;
    _videoPlayer.player = nil;
    _videoPlayer.currentItem = nil;
    
    _videoPlayer.playOrPauseBtn = nil;
    _videoPlayer.playerLayer = nil;
}

- (void)dealloc
{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate removeObserver:self forKeyPath:@"networkStatus"];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"networkStatus"])
    {
        [self refreshViewForNetworkChange];
    }
}

- (void)refreshViewForNetworkChange
{
    [_netCarrierView removeFromSuperview];
    [_netErrorView removeFromSuperview];
    [_netCarrierBigView removeFromSuperview];
    [_netErrorBigView removeFromSuperview];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    switch (delegate.networkStatus)
    {
        case AFNetworkReachabilityStatusNotReachable:
        {
            [_videoPlayer addSubview:_videoPlayer.isFullscreen ? _netErrorBigView : _netErrorView];
                        
            [_videoPlayer.player pause];
            
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [_videoPlayer.player play];
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [_videoPlayer addSubview:_videoPlayer.isFullscreen ? _netCarrierBigView : _netCarrierView];
            
            [_videoPlayer.player pause];
            
            break;
        }
        case AFNetworkReachabilityStatusUnknown:
        {
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _oldIDStr = _idStr;
    
    _pageInt = 1;
    _dataDictArr     = [[NSMutableArray alloc] init];
    _heightNumArr   = [[NSMutableArray alloc] init];

    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];
    
    // watch appdelegate
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate addObserver:self forKeyPath:@"networkStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    // 发送请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self refreshTableViewWithHasMore:YES];
    [self pullingTableViewDidStartRefreshing:_KDSTableView];
}

- (void)createVideoView
{
    NSString *vStr = _infoDict[@"file_url"];
    if (_videoPlayer)
    {
        if (![vStr isEqualToString:_videoPlayer.videoURLStr])
        {
            // remove old
            {
                [_videoPlayer removeFromSuperview];
                [_videoPlayer.player replaceCurrentItemWithPlayerItem:nil];
                [_videoPlayer setVideoURLStr:vStr];
                [_videoPlayer play];
                
                [self releaseWMPlayer];
            }
          
            [self showNewVideoPlayer];
        }
    }
    else
    {
        [self showNewVideoPlayer];
    }
}

- (void)createNetTipView
{
    // 无网络
    if (!_netErrorView)
    {
        _netErrorView = [[UIView alloc] initWithFrame:_videoPlayer.bounds];
        _netErrorView.backgroundColor = [UIColor blackColor];
        
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, ScreenWidth-90, 15)];
            aLabel.textColor = [UIColor whiteColor];
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = @"世界上最遥远的距离就是没有网络";
            [_netErrorView addSubview:aLabel];
        }
        
        {
            UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 60, 174/2, 128/2)];
            tipIV.image = [UIImage imageNamed:@"no_small_web"];
            [_netErrorView addSubview:tipIV];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.frame = CGRectMake(160, 90, 71, 31);
            [aBtn setImage:[UIImage imageNamed:@"play_retry"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"play_retry"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(retryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netErrorView addSubview:aBtn];
        }
    }
    
    if (!_netErrorBigView)
    {
        _netErrorBigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _netErrorBigView.backgroundColor = [UIColor blackColor];
        
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(370/2, 120, ScreenHeight, 15)];
            aLabel.textColor = [UIColor whiteColor];
            aLabel.font = [UIFont systemFontOfSize:23];
            aLabel.text = @"世界上最遥远的距离就是没有网络";
            [_netErrorBigView addSubview:aLabel];
        }
        
        {
            UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 436/2, 297/2)];
            tipIV.image = [UIImage imageNamed:@"no_big_web"];
            [_netErrorBigView addSubview:tipIV];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.frame = CGRectMake(300, 170, 234/2, 100/2);
            [aBtn setImage:[UIImage imageNamed:@"screen_retry"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"screen_retry"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(retryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netErrorBigView addSubview:aBtn];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.showsTouchWhenHighlighted = YES;
            aBtn.frame = CGRectMake(ScreenHeight-50-20, 20, 50, 50);
            [aBtn setImage:[UIImage imageNamed:@"kdk_nonfullscreen"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"kdk_nonfullscreen"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netErrorBigView addSubview:aBtn];
        }
    }
    
    // 流量
    if (!_netCarrierView)
    {
        _netCarrierView = [[UIView alloc] initWithFrame:_videoPlayer.bounds];
        _netCarrierView.backgroundColor = [UIColor blackColor];
        
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 15)];
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.textColor = [UIColor whiteColor];
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = @"当前网络为2G/3G/4G是否继续观看";
            [_netCarrierView addSubview:aLabel];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.frame = CGRectMake(50, 85, 70, 30);
            [aBtn setImage:[UIImage imageNamed:@"play_continue"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"play_continue"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(continueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netCarrierView addSubview:aBtn];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.frame = CGRectMake(ScreenWidth-50-70, 85, 70, 30);
            [aBtn setImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(setWiFiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netCarrierView addSubview:aBtn];
        }
    }
  
    if (!_netCarrierBigView)
    {
        _netCarrierBigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _netCarrierBigView.backgroundColor = [UIColor blackColor];
        
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ScreenHeight, 30)];
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.textColor = [UIColor whiteColor];
            aLabel.font = [UIFont systemFontOfSize:23];
            aLabel.text = @"当前网络为2G/3G/4G是否继续观看";
            [_netCarrierBigView addSubview:aLabel];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.frame = CGRectMake(90, 160, 220/2, 94/2);
            [aBtn setImage:[UIImage imageNamed:@"screen_continue"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"screen_continue"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(continueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netCarrierBigView addSubview:aBtn];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.frame = CGRectMake(ScreenHeight-90-110, 160, 220/2, 94/2);
            [aBtn setImage:[UIImage imageNamed:@"set_wifi"] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"set_wifi"] forState:UIControlStateSelected];
            [aBtn addTarget:self action:@selector(setWiFiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_netCarrierBigView addSubview:aBtn];
        }
    }
    
    [self refreshTipViewFrame];
}

- (void)refreshTipViewFrame
{
    [self refreshViewForNetworkChange];
    
    _netErrorView.frame     = _videoPlayer.bounds;
    _netCarrierView.frame   = _videoPlayer.bounds;
    
    _netErrorBigView.frame     = _videoPlayer.bounds;
    _netCarrierBigView.frame   = _videoPlayer.bounds;
    
    [self.view bringSubviewToFront:_favBtn];
}

- (void)retryBtnClicked
{
    // 如果状态不对， 改这个值
    _videoPlayer.playOrPauseBtn.selected = NO;
    [_videoPlayer PlayOrPause:_videoPlayer.playOrPauseBtn];
}

- (void)backBtnClicked
{
    [_videoPlayer fullScreenAction:_videoPlayer.fullScreenBtn];
}

- (void)continueBtnClicked
{
    [_netCarrierView removeFromSuperview];
    [_netErrorView removeFromSuperview];
    [_netCarrierBigView removeFromSuperview];
    [_netErrorBigView removeFromSuperview];
    
    [_videoPlayer.player play];
}

- (void)setWiFiBtnClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}

- (void)showNewVideoPlayer
{
    NSInteger yPos = 10;

    NSString *vStr = _infoDict[@"file_url"];

    NSInteger aWidth = ScreenWidth;
    NSInteger aHeight = ScreenWidth * (9.0/16.0);
    _videoPlayer = [[WMPlayer alloc]initWithFrame:CGRectMake(0, kNavbarHeight+kStatusbarHeight+yPos, aWidth, aHeight)
                                      videoURLStr:vStr];
    [_videoPlayer setVideoURLStr:vStr];
    _videoPlayer.closeBtn.hidden = YES;
    [self createNetTipView];
    [_videoPlayer.player pause];

    // 网络状态
    [self refreshViewForNetworkChange];
    
    playerFrame = _videoPlayer.frame;
    [self.view addSubview:_videoPlayer];
    
    // 添加收藏按钮
    if (_favBtn) {
        [_favBtn removeFromSuperview];
        _favBtn = nil;
    }
    _favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _favBtn.frame = CGRectMake(ScreenWidth-10-26, _videoPlayer.y + 5, 26, 25);
    [_favBtn setImage:[UIImage imageNamed:@"favourite"] forState:UIControlStateNormal];
    [_favBtn setImage:[UIImage imageNamed:@"yes_favourite"] forState:UIControlStateSelected];
    [_favBtn addTarget:self action:@selector(favBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_favBtn];
    
//    {
//        [_videoPlayer addSubview:_favBtn];
//    }
    
    _favBtn.selected = [_infoDict[@"is_collection"] boolValue];
}

- (void)favBtnClicked
{
    //	1. 添加 2 取消收藏
    NSString *typeStr = _favBtn.selected ? @"2" : @"1";
    
    _favBtn.selected = !_favBtn.selected;
    NSString *urlStr = ROOTZZS_URL;
    NSDictionary *params = @{
                             @"act"           : KDS_ADD_COLLECTION_ACT,
                             @"API_Token"     : API_Token,
                             @"shop_id"       : _shopIdStr,
                             @"file_id"       : _idStr,
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
             _favBtn.selected = !_favBtn.selected;

             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         _favBtn.selected = !_favBtn.selected;

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

- (void)createInfoView
{
    // info
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _videoPlayer.y + _videoPlayer.height, ScreenWidth, 40 + 10)];
        bgView.backgroundColor = HEXCOLOR(0xeeeeee);
        [self.view addSubview:bgView];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
        aView.backgroundColor = HEXCOLOR(0xfefefe);
        [bgView addSubview:aView];
        
        {
            UIImageView *aIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 14, 14)];
            aIV.image = [UIImage imageNamed:@"play_num"];
            [aView addSubview:aIV];
        }
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 20)];
            aLabel.textColor = infoTextColor;
            aLabel.font = [UIFont systemFontOfSize:13];
            aLabel.text = _infoDict[@"play_num"];
            [aView addSubview:aLabel];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [aBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            aBtn.frame = CGRectMake(ScreenWidth-10-40-40, 0, 40, 40-6);
            aBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            
            [aBtn setTitleColor:infoTextColor forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
            [aBtn setTitle:@"评论" forState:UIControlStateNormal];
            {
                UIImage *aImg = [aBtn imageForState:UIControlStateNormal];
                NSString *btnTitle = [aBtn titleForState:UIControlStateNormal];;
                UIFont *btnFont = aBtn.titleLabel.font;
                CGSize titleSize =  WE_TEXTSIZE(btnTitle, btnFont);
                [aBtn setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                                          0.0,
                                                          0.0,
                                                          -titleSize.width)];
                [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(26,
                                                          -aImg.size.width,
                                                          0.0,
                                                          0.0)];
            }
            [aView addSubview:aBtn];
        }
        
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-10-40-0.5, 10, 0.5, 20)];
            lineView.backgroundColor = HEXCOLOR(0xcbcbcb);
            [aView addSubview:lineView];
        }
        
        {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [aBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            //            aBtn.backgroundColor = DJLightGrayColor;
            aBtn.frame = CGRectMake(ScreenWidth-10-40, 0, 40, 40-6);
            aBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            
            [aBtn setTitleColor:infoTextColor forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            [aBtn setTitle:@"分享" forState:UIControlStateNormal];
            {
                UIImage *aImg = [aBtn imageForState:UIControlStateNormal];
                NSString *btnTitle = [aBtn titleForState:UIControlStateNormal];;
                UIFont *btnFont = aBtn.titleLabel.font;
                CGSize titleSize =  WE_TEXTSIZE(btnTitle, btnFont);
                [aBtn setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                                          0.0,
                                                          0.0,
                                                          -titleSize.width)];
                [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(26,
                                                          -aImg.size.width,
                                                          0.0,
                                                          0.0)];
            }
            [aView addSubview:aBtn];
        }
    }
}

- (UIView *)getTopHeaderView
{
    [self createVideoView];
    
    [self createInfoView];
    
    _topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    _topHeaderView.backgroundColor = HEXCOLOR(0xeeeeee);
    
    NSInteger yPos = 10;
    
    // title and subtitle
    {
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, ScreenWidth, 50)];
        aView.backgroundColor = HEXCOLOR(0xfefefe);
        [_topHeaderView addSubview:aView];
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, ScreenWidth-10*2, 18)];
            aLabel.textColor = HEXCOLOR(0x323232);
            aLabel.font = [UIFont boldSystemFontOfSize:15];
            aLabel.text = _infoDict[@"title"];
            [aView addSubview:aLabel];
        }
        {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+18, ScreenWidth-10*2, 15)];
            aLabel.textColor = HEXCOLOR(0x989898);
            aLabel.font = [UIFont systemFontOfSize:12];
            aLabel.text = _infoDict[@"desc"];
            [aView addSubview:aLabel];
        }
        
        yPos = aView.frame.origin.y + aView.frame.size.height + 10;
    }
    
    // series
    {
        NSInteger sCount = _seriesArr.count;
        if (sCount)
        {
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, ScreenWidth, 300)];
            aView.backgroundColor = HEXCOLOR(0xfefefe);
            [_topHeaderView addSubview:aView];
            
            UIImageView *aIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 15, 15)];
            aIV.image = [UIImage imageNamed:@"select_collect"];
            [aView addSubview:aIV];
            
            {
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 6, 50, 15)];
                aLabel.textColor = infoTextColor;
                aLabel.font = [UIFont systemFontOfSize:13];
                aLabel.text = @"选集";
                [aView addSubview:aLabel];
            }
            {
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-100-10, 6, 100, 15)];
                aLabel.textAlignment = NSTextAlignmentRight;
                aLabel.textColor = infoTextColor;
                aLabel.font = [UIFont systemFontOfSize:13];
                aLabel.text = [NSString stringWithFormat:@"更新至%ld期", (long)sCount];
                [aView addSubview:aLabel];
            }
            
            // lines
            {
                NSInteger aX = 0;
                NSInteger aY = 0;
                NSInteger aWidth = (ScreenWidth-2)/5;
                UIColor *lineColor = HEXCOLOR(0xefefef);
                //一行5个 不足空白
                NSInteger line, row;
                for (int i = 0; i < sCount; i++)
                {
                    line    = i / 5;
                    row     = i % 5;
                    
                    aX =  2 + aWidth * row;
                    aY = 25 + aWidth * line;
                    
                    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    aBtn.layer.borderWidth = 0.5;
                    aBtn.layer.borderColor = lineColor.CGColor;
                    aBtn.tag = 100 + i;
                    aBtn.frame = CGRectMake(aX, aY, aWidth+0.5, aWidth+0.5);
                    [aBtn addTarget:self action:@selector(aBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    aBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [aBtn setTitleColor:HEXCOLOR(0x323232) forState:UIControlStateNormal];
                    [aBtn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
                    [aView addSubview:aBtn];
                    
                    if ([_idStr isEqualToString:_seriesArr[i]])
                    {
                        [aBtn setImage:[UIImage imageNamed:@"play_select"] forState:UIControlStateNormal];
                        [aBtn setTitle:nil forState:UIControlStateNormal];
                    }
                }
                
                aView.frame = CGRectMake(0, yPos, ScreenWidth, aY + aWidth + 15);
            }
            
            yPos = aView.frame.origin.y + aView.frame.size.height + 10;
        }
    }

    // comment
    {
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, ScreenWidth, 30)];
        aView.backgroundColor = HEXCOLOR(0xfefefe);
        [_topHeaderView addSubview:aView];
        {
            _cmtCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, ScreenWidth-10*2, 18)];
            _cmtCountLabel.textColor = HEXCOLOR(0x989898);
            _cmtCountLabel.font = [UIFont systemFontOfSize:13];
            _cmtCountLabel.text = @"对该视频的评论:";
            [aView addSubview:_cmtCountLabel];
        }
        yPos = aView.frame.origin.y + aView.frame.size.height + 10;
    }
    
    _topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, yPos);

    return _topHeaderView;
}

#pragma mark - func

- (void)aBtnClicked:(UIButton *)aBtn
{
    NSInteger tagInt = aBtn.tag - 100;
    _idStr = _seriesArr[tagInt];

    [self requestKDSDetail];
}

- (void)commentBtnClicked
{
    [self createCommentView];
    
    _cmtBGView.hidden = NO;
    [_cmtTextView becomeFirstResponder];
}

- (void)shareBtnClicked
{
    YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
    VC.hidenBar = NO;
    VC.shareTitle = _infoDict[@"title"];
    VC.shareDesc  = _infoDict[@"desc"];
    VC.shareImg   = _infoDict[@"img"];
    VC.shareURL   = _infoDict[@"share_url"];
    VC.actType    = @"口袋说";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - request

// 请求详情列表
- (void)requestKDSDetail
{
    NSString *urlStr = ROOTZZS_URL;
    NSDictionary *params = @{
                             @"act"           : KDS_DETAIL_ACT,
                             @"API_Token"     : API_Token,
                             @"file_id"       : _idStr,
                             @"shop_id"       : _shopIdStr
                             };
    
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         NSDictionary *returnDict = (NSDictionary *)responseObject;
         returnDict = [returnDict dictionaryByReplacingNullsWithBlanks];
         
         if (returnDict[@"success"])
         {
             _infoDict  = returnDict[@"data"];
             self.title = _infoDict[@"title"];
             
             _seriesArr = returnDict[@"series"];
             
             _KDSTableView.tableHeaderView = [self getTopHeaderView];

              //request comment
             _pageInt = 1;
             [self requestKDSComment];
             
             [self removeEmptyView];
         }
         else
         {
             [self showEmptyView];
             
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self showEmptyView];

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

// 请求评论列表
- (void)requestKDSComment
{
    NSString *urlStr = ROOTZZS_URL;
    NSDictionary *params = @{
                             @"act"           : KDS_COMMENT_ACT,
                             @"API_Token"     : API_Token,
                             @"file_id"       : _idStr,
                             @"shop_id"       : _shopIdStr,
                             @"current_page"  : [NSString stringWithFormat:@"%d", _pageInt],
                             @"page_count"    : @"10"
                             };

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
             if (_pageInt == 1)
             {
                 [_dataDictArr removeAllObjects];
                 [_heightNumArr removeAllObjects];
             }
             
             if (addedArr)
             {
                 [_dataDictArr addObjectsFromArray:addedArr];
             }
             
             // 刷新高度
             for (int i = 0; i < _dataDictArr.count; i ++)
             {
                 NSDictionary *aDict = @{kCellHeightKey : [NSNumber numberWithInteger:0]};
                 [_heightNumArr addObject:aDict];
             }
             int totals = [returnDict[@"total"] integerValue];
             if (totals)
             {
                 _cmtCountLabel.text = [NSString stringWithFormat:@"对该视频的评论:(%@)", returnDict[@"total"]];
                 _cmtCountLabel.hidden = totals > 0 ? NO : YES;
             }

             if (_dataDictArr.count >= totals)
             {
                 [self refreshTableViewWithHasMore:NO];
             }
             else
             {
                 [self refreshTableViewWithHasMore:YES];
             }
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

#pragma mark - 

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [_videoPlayer removeFromSuperview];
    _videoPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        _videoPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        _videoPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    _videoPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _videoPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);

    [_videoPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    
    [_videoPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_videoPlayer).with.offset((-kScreenHeight/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_videoPlayer).with.offset(5);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_videoPlayer];
    _videoPlayer.fullScreenBtn.selected = YES;
    [_videoPlayer bringSubviewToFront:_videoPlayer.bottomView];
    
    [self refreshTipViewFrame];
}

-(void)toNormal
{
    [_videoPlayer removeFromSuperview];
    
    [UIView animateWithDuration:0.5f animations:^
    {
        _videoPlayer.transform = CGAffineTransformIdentity;
        _videoPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y,
                                       playerFrame.size.width, playerFrame.size.height);
        _videoPlayer.playerLayer.frame =  _videoPlayer.bounds;

        [self.view addSubview:_videoPlayer];
        
        [_videoPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_videoPlayer).with.offset(0);
            make.right.equalTo(_videoPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_videoPlayer).with.offset(0);
        }];
        [_videoPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_videoPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_videoPlayer).with.offset(5);
        }];
    }
                     completion:^(BOOL finished)
    {
        _videoPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _videoPlayer.fullScreenBtn.selected = NO;
        
        [self refreshTipViewFrame];
    }];
}

-(void)fullScreenBtnClick:(NSNotification *)notice
{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    
    [[UIApplication sharedApplication] setStatusBarHidden:fullScreenBtn.isSelected withAnimation:UIStatusBarAnimationFade];
    if (fullScreenBtn.isSelected)
    {
        //全屏显示
        _videoPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    else
    {
        [self toNormal];
    }
}

#pragma mark - 

- (void)refreshTableViewWithHasMore:(BOOL)hasMore
{
    if(!_KDSTableView)
    {
        NSInteger aHeight = ScreenWidth * (9.0/16.0) + 40 + 10;
        _KDSTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kStatusbarHeight + kNavbarHeight + 10 + aHeight,
                                                                                 ScreenWidth,
                                                                                 ScreenHeight - kStatusbarHeight - kNavbarHeight- 10 - aHeight)
                                                                style:UITableViewStylePlain];
        _KDSTableView.pullingDelegate = self;
        _KDSTableView.delegate = self;
        _KDSTableView.dataSource = self;
        _KDSTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.view addSubview:_KDSTableView];
    }
    
    [_KDSTableView tableViewDidFinishedLoading];
    _KDSTableView.reachedTheEnd = !hasMore;
    
    [_KDSTableView reloadData];
}

#pragma mark - PullingRefreshTableViewDelegate

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self requestKDSDetail];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    _pageInt = _pageInt + 1;
    [self requestKDSComment];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
    [_KDSTableView tableViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [_KDSTableView tableViewDidScroll:scrollView];
}

#pragma mark - UITableViewDataSourceDelegate & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger aHeight = 0;
    NSDictionary *heightDict = _heightNumArr[indexPath.row];
    NSNumber *hNum = heightDict[kCellHeightKey];
    if (hNum.intValue == 0)
    {
        KDSCommentCell *cell = [[KDSCommentCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:nil];
        NSDictionary *aDict = _dataDictArr[indexPath.row];
        cell.cellDict = aDict;
        aHeight = [cell getCellHeight];
        
        // 计算一次
        hNum = [NSNumber numberWithInteger:aHeight];
        [_heightNumArr replaceObjectAtIndex:indexPath.row withObject:@{kCellHeightKey : hNum}];
        
        // 尽快清空
        cell = nil;
    }
    
    aHeight = hNum.intValue;
    
    return aHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataDictArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KDSCommentCell";
    KDSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[KDSCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_dataDictArr count] > indexPath.row)
    {
        NSDictionary *aDict = _dataDictArr[indexPath.row];
        cell.cellDict = aDict;
        [cell showSubViews];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *aDict        = _dataDictArr[indexPath.row];
//    
//    KDSDetailViewController *ctl = [[KDSDetailViewController alloc] init];
//    ctl.idStr = aDict[@"id"];
//    ctl.shopIdStr = [YKLLocalUserDefInfo defModel].userID;
//    ctl.title = aDict[@"title"];
//    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - 

- (void)createCommentView
{
    // 显示一个界面
    if (!_cmtBGView)
    {
        _cmtBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _cmtBGView.backgroundColor = RHPopViewBGColor;
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(cmtBGViewTapped)];
        [_cmtBGView addGestureRecognizer:aTap];
        [[UIApplication sharedApplication].keyWindow addSubview:_cmtBGView];
        
        // 白色背景
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-10*2, 250)];
        aView.backgroundColor = [UIColor whiteColor];
        aView.clipsToBounds = YES;
        aView.layer.cornerRadius = 6.0;
        [_cmtBGView addSubview:aView];
        
        NSInteger aWidth    = aView.frame.size.width;
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake((aWidth-80)/2, 10, 80, 15)];
        aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.textColor = HEXCOLOR(0x939393);
        aLabel.font = [UIFont systemFontOfSize:15];
        aLabel.text = @"评论";
        [aView addSubview:aLabel];
        
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 31, aWidth, 0.5)];
            lineView.backgroundColor = HEXCOLOR(0x939393);
            [aView addSubview:lineView];
        }
        
        // 输入框
        {
            _cmtTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, aWidth-10*2, 170)];
            _cmtTextView.font = [UIFont systemFontOfSize:14];
            _cmtTextView.backgroundColor = [UIColor whiteColor];
            [aView addSubview:_cmtTextView];
        }
        
        // 取消
        {
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            cancelBtn.frame = CGRectMake(10, 205, 130, 41);
            cancelBtn.backgroundColor = HEXCOLOR(0xfe2020);
            cancelBtn.clipsToBounds = YES;
            cancelBtn.layer.cornerRadius = 3.0;
            [cancelBtn addTarget:self action:@selector(cmtBGViewTapped) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [aView addSubview:cancelBtn];
        }
        
        // 发布
        {
            _cmtBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _cmtBtn.frame = CGRectMake(10+130+20, 205, 130, 41);
            _cmtBtn.backgroundColor = HEXCOLOR(0x00d87f);
            _cmtBtn.clipsToBounds = YES;
            _cmtBtn.layer.cornerRadius = 3.0;
            [_cmtBtn addTarget:self action:@selector(cmtBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            _cmtBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_cmtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_cmtBtn setTitle:@"发布" forState:UIControlStateNormal];
            [aView addSubview:_cmtBtn];
        }
        
        _cmtBGView.hidden = YES;
    }
}

- (void)cmtBGViewTapped
{
    _cmtBGView.hidden = YES;
    [_cmtTextView resignFirstResponder];
    
    // 动画显示
    NSString *aniType = kCATransitionFade;
    CATransition *fadeAni = [CATransition animation];
    fadeAni.duration = 0.3f;
    fadeAni.type = aniType;
    fadeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[self.view layer] addAnimation:fadeAni forKey:nil];
}

- (void)cmtBtnClicked
{
    NSString *cmtStr = _cmtTextView.text;
    if (!cmtStr.length)
    {
        [UIAlertView showInfoMsg:@"请输入评论内容"];
        return;
    }
    if (cmtStr.length > 140)
    {
        [UIAlertView showInfoMsg:@"评论内容最多140字"];
        return;
    }
    
    NSString *urlStr = ROOTZZS_URL;
    NSDictionary *params = @{
                             @"act"           : KDS_ADD_COMMENT_ACT,
                             @"API_Token"     : API_Token,
                             @"shop_id"       : _shopIdStr,
                             @"file_id"       : _idStr,
                             @"content"       : cmtStr,
                             };
    
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         NSDictionary *returnDict = (NSDictionary *)responseObject;
         returnDict = [returnDict dictionaryByReplacingNullsWithBlanks];
         
         BOOL isSuccess = [returnDict[@"success"] boolValue];
         if (isSuccess)
         {
             _cmtTextView.text = @"";
             [self cmtBGViewTapped];
             
             // refresh
             [_KDSTableView setContentOffset:CGPointMake(0, 0) animated:NO];
             _pageInt = 1;
             [self requestKDSComment];
             
             // 延时调整, 不然会出现键盘弹出再消失的bug
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                            {
                                [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
                            });
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
