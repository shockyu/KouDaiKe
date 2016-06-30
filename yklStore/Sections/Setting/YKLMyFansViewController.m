//
//  YKLMyFansViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/10/6.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLMyFansViewController.h"
#import "MUILoadMoreTableView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SJAvatarBrowser.h"

@interface YKLFanInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *callImageView;
@property (nonatomic, strong) YKLFanModel *fanModel;

- (void)updateWithFanModel:(YKLFanModel *)model;

@end

@implementation YKLFanInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor flatLightBlueColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor flatLightBlueColor];
        
        self.callImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_user_default.jpg"]];
        
        [self.contentView addSubview:self.callImageView];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateWithFanModel:(YKLFanModel *)model {
    
    self.textLabel.text = model.mobile;
    self.textLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.text = model.nickName;
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
    [self.callImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"Demo"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 8, self.width-self.callImageView.width, 18);
    self.detailTextLabel.frame = CGRectMake(15, 8+18, self.textLabel.width, 16);
    self.callImageView.center = CGPointMake(self.width-15-self.callImageView.width/2, self.height/2);
    self.callImageView.frame = CGRectMake(self.width-45-5, 5, 45, 40);
}

@end

@interface YKLMyFansViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *fans;
@property (nonatomic, strong) NSMutableArray *difFans;
@property (nonatomic, strong) NSMutableArray *allPeoples;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIWebView *callWebView;

@property (nonatomic, strong) UIView *actingNoneView;

@end

@implementation YKLMyFansViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"我的粉丝";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(manageBankCard)];

    }
    return self;
}

- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[YKLFanInfoCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    self.fans = [NSMutableArray array];
    self.difFans = [NSMutableArray array];
    self.allPeoples = [NSMutableArray array];
    
    [self createBgNoneView];
    [self requestMoreProduct];
    
    // 判断是否授权成功
    if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        
        // 授权成功直接返回
        return;
    }
    
    // 0.创建通讯录
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 1.请求用户授权
    // 第一个参数接收通讯录
    // 第二个参数是一个block, 无论授权成功还是失败都会调用
    ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
        // granted YES 代表用户授权成功 NO 代表用户授权失败
        if (granted) {
            NSLog(@"授权成功");
        }else
        {
            NSLog(@"授权失败");
        }
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    //为空则传本地userID
    if (ISNULLSTR(_shopID)) {
        _shopID = [YKLLocalUserDefInfo defModel].userID;
    }
    [YKLNetworkingConsumer requestFansListWithShopID:_shopID success:^(NSArray *fans) {
        self.title = [NSString stringWithFormat:@"我的粉丝(%ld)",(unsigned long)fans.count];
        
        if (fans.count == 0) {
            
            self.actingNoneView.hidden = NO;
            self.tableView.loadMoreEnable = NO;
            self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.fans addObjectsFromArray:fans];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.fans.count-fans.count end:self.fans.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endLoad];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.tableView endLoad];
        [UIAlertView showInfoMsg:error.domain];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }];
}

- (void)manageBankCard{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请注意哦" message:@"是否保存粉丝电话到手机通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"保存到通讯录");
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(saveFans) object:self];
        [thread start];
        
    }
}
- (void)saveFans{
    
    // 判断是否授权成功
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        [UIAlertView showInfoMsg:@"请在设置中允许口袋客访问您的通讯录，否则将无法保存粉丝！"];
        // 授权失败直接返回
        return;
    }
    
    // 1.创建通讯录对象
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 2.获取通讯录中得所有联系人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(book);
    
    CFIndex count = CFArrayGetCount(allPeople);
    
    // 3.将每一个联系人额信息进行比对
    for (int i = 0; i < count; i++) {
        // 联系人列表中的每一个人都是一个ABrecordRef
        ABRecordRef prople =  CFArrayGetValueAtIndex(allPeople, i);
        
        //取出当前联系人的的电话信息
        // 获取练习人得姓名
        CFStringRef lastName = ABRecordCopyValue(prople, kABPersonLastNameProperty);
        CFStringRef firstName = ABRecordCopyValue(prople, kABPersonFirstNameProperty);
        NSLog(@"%@ %@", firstName, lastName);
        
        // 获取联系人的电话
        // 从联系人中获取到得电话是所有的电话
        ABMultiValueRef phones =   ABRecordCopyValue(prople, kABPersonPhoneProperty);
        
        CFStringRef name = ABMultiValueCopyLabelAtIndex(phones, 0);
        // 从所有的电话中取出指定的电话
        CFStringRef value =  ABMultiValueCopyValueAtIndex(phones, 0);
        NSLog(@"name = %@ value = %@", name, value);
        if ((__bridge id)(value)) {
            [self.allPeoples addObject:(__bridge id)(value)];
        }
        
    }
    
    for (int i = 0; i < self.fans.count; i++) {
        
        YKLFanModel *model = self.fans[i];
        
        if ([self.allPeoples containsObject:model.mobile]) {
            NSLog(@"%@",model.mobile);
        }else{
            NSLog(@"%@<<<<",model.mobile);
            [self.difFans addObject:model];
        }
    }
    
    for (int i = 0; i < self.difFans.count; i++) {
        YKLFanModel *difModel = self.difFans[i];
        
        // 1.创建联系人
        ABRecordRef  people = ABPersonCreate();
        
        // 2.设置联系人信息
        ABRecordSetValue(people, kABPersonLastNameProperty,(__bridge CFTypeRef)([NSString stringWithFormat:@"口袋客-%@",difModel.nickName]), NULL);
        
        // 创建电话号码
        ABMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phones, CFBridgingRetain(difModel.mobile), kABPersonPhoneMobileLabel, NULL);
        
        ABRecordSetValue(people, kABPersonPhoneProperty, phones, NULL);
        
        // 3.拿到通讯录
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        
        // 4.将联系人添加到通讯录中
        ABAddressBookAddRecord(book, people, NULL);
        
        // 5.保存通讯录
        ABAddressBookSave(book, NULL);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.difFans.count == 0) {
            [UIAlertView showInfoMsg:@"粉丝信息已存在！"];
        }
        if (self.difFans.count < self.fans.count && self.difFans.count > 0) {
            [UIAlertView showInfoMsg:@"粉丝信息已更新！"];
        }
        if (self.difFans.count == self.fans.count){
            [UIAlertView showInfoMsg:@"全部保存成功！"];
        }
    });
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.difFans = [NSMutableArray array];//清空数组，保证每次数据的更新
    self.allPeoples = [NSMutableArray array];
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fans.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKLFanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    YKLFanModel *model = self.fans[indexPath.row];
    cell.callImageView.userInteractionEnabled= YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
    [cell.callImageView addGestureRecognizer:singleTap];
    
    [cell updateWithFanModel:model];
    
    return cell;
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    NSLog(@"xxxxx");
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKLFanModel *model = self.fans[indexPath.row];
    if (model.mobile.length > 0) {
        NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", model.mobile]];
        if (self.callWebView == nil) {
            self.callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [self.callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
    }
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
