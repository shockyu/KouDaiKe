//
//  YKLShopBuyerListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopBuyerListViewController.h"
#import "MUILoadMoreTableView.h"
#import "SJAvatarBrowser.h"

@interface YKLShopBuyerListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *callImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *numLabel;
@end

@implementation YKLShopBuyerListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
   
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.callImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_user_default.jpg"]];
        self.callImageView.frame = CGRectMake(10, 8, 42, 42);
        self.callImageView.layer.cornerRadius = 21;
        self.callImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.callImageView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.callImageView.right+10, 0, 150, 30)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, 150, 15)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.timeLabel];
        
        self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right, 0, 90, 30)];
        self.numLabel.font = [UIFont systemFontOfSize:14];
        self.numLabel.textColor = [UIColor flatLightRedColor];
        self.numLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.numLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.nameLabel.left, 57, self.width-self.nameLabel.left, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end

@interface YKLShopBuyerListViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *buyers;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLShopBuyerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联采店家";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 65, self.view.width, self.view.height-65) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLShopBuyerListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    self.buyers = [NSMutableArray array];
    
    [self createBgNoneView];
    [self requestMoreProduct];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
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
    [self.tableView startLoad];
    [YKLNetWorkingShop getPayShopWithGoodID:_goodsID Success:^(NSArray *shopList) {
      
        if (shopList.count == 0) {
            
            self.actingNoneView.hidden = NO;
            self.tableView.loadMoreEnable = NO;
            self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.buyers addObjectsFromArray:shopList];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.buyers.count-shopList.count end:self.buyers.count] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    return self.buyers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YKLShopBuyerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    YKLPayShopListModel *model = self.buyers[indexPath.row];
    cell.callImageView.userInteractionEnabled= YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
    [cell.callImageView addGestureRecognizer:singleTap];
    
    [cell.callImageView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"Demo"]];
    cell.nameLabel.text = model.buyerName;
    cell.timeLabel.text = [NSString stringWithFormat:@"[ %@ ]",model.addTime];
    cell.numLabel.text = [NSString stringWithFormat:@"%@%@",model.goodsNum,model.units];
    
    return cell;
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    NSLog(@"xxxxx");
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreProduct];
}

- (void)createBgNoneView{
    
    self.actingNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255,  225)];
    self.actingNoneView.centerX = self.view.width/2;
    self.actingNoneView.backgroundColor = [UIColor clearColor];
    self.actingNoneView.hidden = YES;
    [self.tableView addSubview:self.actingNoneView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [self.actingNoneView addSubview:imageView];
    
}


@end
