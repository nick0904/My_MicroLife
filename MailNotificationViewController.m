//
//  MailNotificationViewController.m
//  Setting
//
//  Created by Ideabus on 2016/8/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "MailNotificationViewController.h"
#import "EditMailNotificationViewController.h"
#import "DeleteMailNoticationViewController.h"
#import "AddMailNotificationViewController.h"
#import "MViewController.h"

@interface MailNotificationViewController () <APIPostAndResponseDelegate> {
    
    NSMutableArray *MyMemberArray;
    
    APIPostAndResponse *apiClass;
    
    UITableView *m_tableView;
    
    DeleteMailNoticationViewController *deleteVC;
    
    UIActivityIndicatorView *indicatorView;
    
}

@end

@implementation MailNotificationViewController

-(id)initWithMailNotificationViewControllerFrame:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.frame = frame;
    
    return  self;
}


#pragma  mark - Normal Function  *********************
- (void)viewDidLoad {
    [super viewDidLoad];

    self.hidesBottomBarWhenPushed = YES;
    
    self.view.backgroundColor = TABLE_BACKGROUND;
    
    [self initWithNotificationVC];
    
    [self initParameter];
    
    [self initUIObjects];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //重新 get mail list
    [self getMailNotificationList];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initialization  ****************************
-(void)initWithNotificationVC {
    
    ///NavigationController title / background
    self.title = NSLocalizedString(@"Mail Notification", nil);
    
    //改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    //改變 statusBarStyle(字體變白色)
    //先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    ///rightBarButton
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Select", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selecAction)];
    [rightBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    ///leftBarButton
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    [leftBarBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(gobackSettingVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
}


-(void)initParameter{
    
    //API
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
    //MyMemberArray init
    MyMemberArray = [[NSMutableArray alloc] init];
    
    /**
    //test
    NSDictionary *dic01 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"AAA",@"name",
                           @"aa@gmail.com",@"email",nil];
    
    NSDictionary *dic02 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"BBB",@"name",
                           @"bb@gmail.com",@"email",nil];
    
    NSDictionary *dic03 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"CCC",@"name",
                           @"cc@gmail.com",@"email",nil];
    
    NSDictionary *dic04 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"DDD",@"name",
                           @"dd@gmail.com",@"email",nil];
    
    [MyMemberArray addObject:dic01];
    [MyMemberArray addObject:dic02];
    [MyMemberArray addObject:dic03];
    [MyMemberArray addObject:dic04];
    */
    
}

-(void)initUIObjects {
    
    //m_tableView init
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height , self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    
    
    //addMailBt init
    UIButton *addMailBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, self.view.frame.size.width/6)];
    addMailBt.center = CGPointMake(CGRectGetMaxX(self.view.frame) - addMailBt.frame.size.width, CGRectGetMaxY(self.view.frame) - addMailBt.frame.size.width - self.navigationController.navigationBar.frame.size.height - 3* [UIApplication sharedApplication].statusBarFrame.size.height);
    [addMailBt setImage:[UIImage imageNamed:@"overview_btn_a_add_s"] forState:UIControlStateNormal];
    [addMailBt addTarget:self action:@selector(addMailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMailBt];
    
}


#pragma mark - TableView Delegate & DataSource  *****************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return MyMemberArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"Mail_Notification_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[MyMemberArray[indexPath.row] objectForKey:@"name"]];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    return cell;
    
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EditMailNotificationViewController *editMailVC = [[EditMailNotificationViewController alloc] init];
    
    editMailVC.editNameStr = [NSString stringWithFormat:@"%@",[MyMemberArray[indexPath.row] objectForKey:@"name"]];
    
    editMailVC.editEmailStr = [NSString stringWithFormat:@"%@",[MyMemberArray[indexPath.row] objectForKey:@"email"]];
    
    editMailVC.mail_id = [NSNumber numberWithInt:[[MyMemberArray[indexPath.row] objectForKey:@"mail_id"] intValue]];
    
    NSLog(@"editMailVC.mail_id:%d",[editMailVC.mail_id intValue]);

    [self.navigationController pushViewController:editMailVC animated:YES];
    
    
}


#pragma mark - BtnAction  *****************
-(void)gobackSettingVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addMailAction {
    
    ///mail Notification 上限5組
    if (MyMemberArray.count >= 5) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil)  message:NSLocalizedString(@"Mail Notification 上限為五個", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }
    
    AddMailNotificationViewController *addMailVC = [[AddMailNotificationViewController alloc] init];
    
    [self.navigationController pushViewController:addMailVC animated:YES];
}


-(void)selecAction {
    
    if (MyMemberArray.count == 0) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"暫無資料可選", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }
    
    
    if (deleteVC == nil) {
        
        deleteVC = [[DeleteMailNoticationViewController alloc] initWithDeleteMailNoticationViewControllerFrame:self.view.frame];
    }
    
    [self.navigationController pushViewController:deleteVC animated:YES];
    
}


#pragma mark - POST API   *********************
-(void)getMailNotificationList {
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    
    [apiClass postGetMailNotificationList:tokenStr];
    
    [self showIndicatorView];
    
}

#pragma mark - API Delegate  *********************
-(void)processeGetMailNotificationList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    [self stopIndicatorView];
    
    if (jsonError) {
        
        NSLog(@"GetMailNotificationList jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"GetMailNotificationList:%@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            
            if (MyMemberArray.count > 0) {
                
                [MyMemberArray removeAllObjects];
            }
            
            MyMemberArray = [[resopnseData objectForKey:@"data"] mutableCopy];
        }
        
        [m_tableView reloadData];
    }
        
}


#pragma mark - indicator  *********************
-(void)showIndicatorView {
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    indicatorView.backgroundColor = [UIColor lightGrayColor];
    
    indicatorView.center = self.view.center;
    
    indicatorView.alpha = 0.38;
    
    [indicatorView startAnimating];
    
    [self.navigationController.view addSubview:indicatorView];
}

-(void)stopIndicatorView {
    
    if (indicatorView != nil) {
        
        [indicatorView stopAnimating];
        
        [indicatorView removeFromSuperview];
        
        indicatorView = nil;
    }
    
}


@end
