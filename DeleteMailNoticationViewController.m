//
//  DeleteMailNoticationViewController.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/17.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "DeleteMailNoticationViewController.h"
#import "DeleteMailCell.h"
#import "MViewController.h"

@interface DeleteMailNoticationViewController () <UITableViewDelegate, UITableViewDataSource, APIPostAndResponseDelegate> {
    
    UITableView *m_tableView;
    
    NSMutableArray *ary_selected;
    
    NSMutableArray *tempAry;
    
    APIPostAndResponse *apiClass;
    
    UIActivityIndicatorView *indicatorView;
    
}

@end

@implementation DeleteMailNoticationViewController

#pragma mark - Normal Function  ******************
-(id)initWithDeleteMailNoticationViewControllerFrame:(CGRect)frame {
    
    self = [super init];

    if (!self) return nil;

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.frame = frame;
    
    [self initWithNavgationBar];
    
    [self initParam];
    
    [self initUIObjs];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [self getMailNotificationData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initilization  ********************
-(void)initWithNavgationBar {
    
    self.title = NSLocalizedString(@"Edit", nil);
    
    ///改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    ///改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    ///改變 statusBarStyle(字體變白色)
    ///先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
 
    //rightBarButton
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
    [rightBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    //leftBarButton
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    [leftBarBtn setImage:[UIImage imageNamed:@"all_btn_a_cancel"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
}


-(void)initParam {
    
    //ary_data init
    self.ary_data = [[NSMutableArray alloc] init];
    
    //ary_selected init
    ary_selected = [[NSMutableArray alloc] init];

    
    //tempAry init
    tempAry = [[NSMutableArray alloc] init];
    
    
    //apiClass init
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
}

-(void)initUIObjs {
    
    //m_tableView init
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height , self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    
}


-(void)refreshSelectedData {
    
    if (ary_selected.count > 0) {
        
        [ary_selected removeAllObjects];
    }
    
    for (int i = 0; i < self.ary_data.count; i++) {
        
        [ary_selected addObject:@"0"];
    }
    
    [m_tableView reloadData];
    
}


#pragma mark - BtnActions  *********************
-(void)deleteAction {
    
    ///判斷有無網路
    if (![CheckNetwork isExistenceNetwork]) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please check your wifi", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }

    BOOL hasSelected = NO;
    
    ///判斷有無選擇要先除的事件
    for ( int i = 0 ; i < ary_selected.count; i++) {
        
        if ([ary_selected[i] isEqualToString:@"1"]) {
            
            hasSelected = YES;
            
            break;
        }
    }
    
    if (hasSelected == NO) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"請先選擇一筆資料再刪除", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }
    
   
    if (tempAry.count > 0) {
        
        [tempAry removeAllObjects];
    }
    
    
    NSMutableArray *ary_selectNum = [[NSMutableArray alloc] init];
    
    NSString *checkEmail;
    
    for (int i = 0; i < ary_selected.count; i++) {
        
        if ([ary_selected[i] isEqualToString:@"1"]){
            
            //[tempAry addObject:[self.ary_data[i] mutableCopy]];
            
            NSLog(@"%d",[[self.ary_data[i] objectForKey:@"mail_id"] intValue]);
            
            int selectedNum = [[self.ary_data[i] objectForKey:@"mail_id"] intValue];
            
            [ary_selectNum addObject:[NSNumber numberWithInt:selectedNum]];
            
            checkEmail = [NSString stringWithFormat:@"%@",[self.ary_data[i] objectForKey:@"email"]];
        }
    }
    
    
    [self showIndicatorView];
    
    //post API
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    //刪除會檢查mail格式,所以至少要給一筆email
    [apiClass postEditMailNotification:tokenStr mail_id:ary_selectNum name:@" " email:checkEmail delete:1];
}


-(void)goBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkSelectMark {
    
    for (int i = 0; i < ary_selected.count; i++) {
        
        if ([ary_selected[i] isEqualToString:@"1"]) {
            
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - TableView Delegate & DataSource  *********************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.ary_data.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"Delete_Mail_cell_id";
    
    DeleteMailCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[DeleteMailCell alloc] initWithDeleteMailCellFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.mailTitle = [NSString stringWithFormat:@"%@",[self.ary_data[indexPath.row] objectForKey:@"name"]];
    
    cell.selectedStr = ary_selected[indexPath.row];
    
    [cell refreshData];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ary_selected[indexPath.row] = [ary_selected[indexPath.row] isEqualToString:@"0"] ? @"1" : @"0";
    
    [m_tableView reloadData];
}



#pragma mark - getMailNotificationData  *******************
-(void)getMailNotificationData {

    [self showIndicatorView];
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postGetMailNotificationList:tokenStr];

}



#pragma mark - API Delegate  ****************
-(void)processeGetMailNotificationList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    [self stopIndicatorView];
    
    if (jsonError) {
        
        NSLog(@"GetMailNotificationList jsonError: %@",jsonError);
    }
    else {
        
        NSLog(@"GetMailNotificationList resopnseData: %@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            if (self.ary_data.count > 0) {
                
                [self.ary_data removeAllObjects];
            }
            
            self.ary_data = [[resopnseData objectForKey:@"data"] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self refreshSelectedData];
                
            });
            
        }
        
    }
    
}




-(void)processeEditMailNotification:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    [self stopIndicatorView];
    
    if (jsonError) {
        
        NSLog(@"Edit Mail Notification jsonError: %@",jsonError);
    }
    else {
        
        NSLog(@"Edit Mail Notification responseData: %@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            [self getMailNotificationData];
            
        }
        
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
