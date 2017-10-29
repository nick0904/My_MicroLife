//
//  MainSettingViewController.m
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MainSettingViewController.h"
#import "CustomTableViewCellNormal.h"
#import "CustomTableViewCellMyDevice.h"
#import "CustomTableViewCellSwitch.h"
#import "MailNotificationViewController.h"


@interface MainSettingViewController () <APIPostAndResponseDelegate> {
    
    UITableView *settingView_tableView;//settingView 列表
    NSMutableArray *ary_section; //存放 section title
    NSMutableArray *ary_cell; //存放 cell
    NSMutableArray *ary_MyDeviceCell; // 存放MyDeviceCell
    NSMutableArray *ary_Sync; //存放 Health kit title and subTitle
    CGFloat cellHeight; //統一每個cell 或 section 的高度
    
    //API
    APIPostAndResponse *apiClass;
    
    //Device 相關
    int total_device_num;

    
    
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation MainSettingViewController

#pragma mark - Normal function ========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initParamWithNavigationBar];
    
    [self initParam];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [self getDeviceListFromCloud];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init Param With NavigationBar ========================================
-(void)initParamWithNavigationBar {
    
    //改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    //改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    
    //改變 statusBarStyle(字體變白色)
    //記得先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    //設定leftBarButtonItem(profileBt)
    UIButton *leftItemBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    [leftItemBt setImage:[UIImage imageNamed:@"all_btn_a_menu"] forState:UIControlStateNormal];
    [leftItemBt addTarget:self action:@selector(profileBtAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemBt];
    
    
    //設定 titleView
    UIView *theTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width/3, self.navigationController.navigationBar.frame.size.height)];
    theTitleView.backgroundColor = [UIColor clearColor];
    self.title = NSLocalizedString(@"Setting", nil);
    
}



#pragma mark - initParam  ======================================
-(void)initParam {
    
    //設定 cellHeight
    cellHeight = self.view.frame.size.height/12;
    
    //settingView_tableView init
    settingView_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
    settingView_tableView.delegate = self;
    settingView_tableView.dataSource = self;
    settingView_tableView.backgroundColor = SECTION_BACKGROUNDCOLOR;
    [self.view addSubview:settingView_tableView];
    
    //ary_section init
    ary_section = [[NSMutableArray alloc] init];
    [ary_section addObject:NSLocalizedString(@"Account", nil)];
    [ary_section addObject:NSLocalizedString(@"My Device", nil)];
    [ary_section addObject:NSLocalizedString(@"Sync", nil)];
    [ary_section addObject:@" "];
    [ary_section addObject:@" "];
    
    //ary_MyDeviceCell init (此陣列會變動)
    ary_MyDeviceCell = [[NSMutableArray alloc] init];
    /** 測試用
    [ary_MyDeviceCell addObject:NSLocalizedString(@"Microlife 001", nil)];
    [ary_MyDeviceCell addObject:NSLocalizedString(@"Microlife 002", nil)];
    [ary_MyDeviceCell addObject:NSLocalizedString(@"Microlife 003", nil)];
    [ary_MyDeviceCell addObject:NSLocalizedString(@"Microlife 004", nil)];
    */
    
    //ary_Sync
    ary_Sync = [[NSMutableArray alloc] init];
    [ary_Sync addObject:NSLocalizedString(@"Health Kit", nil)];
    [ary_Sync addObject:NSLocalizedString(@"Sync Health Kit infomation with Microlife automatically.", nil)];
    
    
    //ary_cell init
    ary_cell = [[NSMutableArray alloc] init];
    [ary_cell addObject:NSLocalizedString(@"My Profile", nil)];
    [ary_cell addObject:ary_MyDeviceCell];
    [ary_cell addObject:ary_Sync];
    [ary_cell addObject:NSLocalizedString(@"Mail Notification management", nil)];
    [ary_cell addObject:NSLocalizedString(@"Delete BPM Device Datas", nil)];
    
    
    //API init
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
    //Device 總數 init
    total_device_num = 1;

    
}


#pragma mark - TableView Delegate & DataSource ======================
//TableView Section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return ary_section.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //section 底圖
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cellHeight)];
    sectionView.backgroundColor = SECTION_BACKGROUNDCOLOR;
    
    //section 文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 10, cellHeight)];
    titleLabel.text = ary_section[section];
    titleLabel.textColor = TEXT_COLOR;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:cellHeight * 0.35];
    [sectionView addSubview:titleLabel];
    
    return sectionView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 3 || section == 4) {
        
        return cellHeight/2;
    }
    
    return cellHeight;
}


//TableView Cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return total_device_num == 0 ? 1 : total_device_num;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        return cellHeight * 1.25;
    
    }
    else {
        
        return cellHeight;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //settingView_tableView 共 4 種型態的 Cell
    //1.Normal Cell
    NSString *normalCellID = @"CELL_NORMAL";
    CustomTableViewCellNormal *normalCell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
    if (normalCell == nil) {
        
        normalCell = [[CustomTableViewCellNormal alloc] initWithFrameCustomCellNormal:CGRectMake(0, 0, self.view.frame.size.width, cellHeight)];
        
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    //2.My Device Cell
    NSString *myDeviceCellID = @"CELL_MYDEVICE";
    CustomTableViewCellMyDevice *myDeviceCell = [tableView dequeueReusableCellWithIdentifier:myDeviceCellID];
    if (myDeviceCell == nil) {
        
        myDeviceCell = [[CustomTableViewCellMyDevice alloc] initWithFrameCustomCellMyDevice:CGRectMake(0, 0, self.view.frame.size.width, cellHeight)];
        
        myDeviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    //3.switchWithSubtitle Cell
    NSString *cellWithSwitchID = @"CEll_SWITCH_SUBTITlE";
    CustomTableViewCellSwitch *switchCell = [tableView dequeueReusableCellWithIdentifier:cellWithSwitchID];
    if (switchCell == nil) {
        
        switchCell = [[CustomTableViewCellSwitch alloc] initWithFrameCustomCellMyDevice:CGRectMake(0, 0, self.view.frame.size.width, cellHeight*1.25) withSubTitle:YES];
        
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    //4.switchNoSubtitle Cell
    NSString *cellNoSwitchID = @"CEll_SWITCH_NOSUBTITlE";
    CustomTableViewCellSwitch *noSubTitleCell = [tableView dequeueReusableCellWithIdentifier:cellNoSwitchID];
    if (noSubTitleCell == nil) {
        
        noSubTitleCell = [[CustomTableViewCellSwitch alloc] initWithFrameCustomCellMyDevice:CGRectMake(0, 0, self.view.frame.size.width, cellHeight) withSubTitle:NO];
        
        noSubTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    switch (indexPath.section) {
            
        case 0:
            //Account
            normalCell.textLabel.text = ary_cell[indexPath.section];
            normalCell.textLabel.font = [UIFont systemFontOfSize:20];
            normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [normalCell refreshMessage];
            return normalCell;
            break;
        case 1:
            //MyDevice
            if (ary_MyDeviceCell.count != 0) {
                
                myDeviceCell.titleStr = [ary_cell[indexPath.section][indexPath.row] objectForKey:@"device_model"];
                [myDeviceCell refreshMessage];
                return myDeviceCell;
            }
            break;
        case 2:
            //Sync
            switchCell.titleStr = ary_cell[indexPath.section][0];
            switchCell.subTitleStr = ary_cell[indexPath.section][1];
            switchCell.switchOn = [MViewController checkIsSyncWithHealthKit];
            [switchCell refreshMessage:YES];
            [switchCell.cell_switch addTarget:self action:@selector(healthswitchAction:) forControlEvents:UIControlEventValueChanged];
            return switchCell;
            break;
        case 3:
            //Mail Notification
            normalCell.textLabel.text = ary_cell[indexPath.section];
            normalCell.textLabel.font = [UIFont systemFontOfSize:20];
            normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [normalCell refreshMessage];
            return normalCell;
            break;
        case 4:
            //Delete BPM Device Datas
            noSubTitleCell.titleStr = ary_cell[indexPath.section];
            [noSubTitleCell refreshMessage:NO];
            noSubTitleCell.switchOn = NO;
            [noSubTitleCell.cell_switch addTarget:self action:@selector(deleteBPMDataAction:) forControlEvents:UIControlEventValueChanged];
            return noSubTitleCell;
            break;
        default:
            break;
            
    }
    
    return normalCell;
    
}


//cell 是否可向左滑動
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return UITableViewCellEditingStyleDelete;
    }
    else {
        
        return UITableViewCellEditingStyleNone;
    }
    
}

//cell 向左滑動顯示的 RowAction
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //Detail
    UITableViewRowAction *detailAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Detail", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        MyDeviceController *detailV = [[MyDeviceController alloc]init];
        detailV = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDeviceController"];
        detailV.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //detailV.deviceLabel.text = Devicearray[indexPath.row];
        //detailV.deviceStr=Devicearray[indexPath.row];
        
        detailV.deviceName = [NSString stringWithFormat:@"%@", [ary_MyDeviceCell[indexPath.row] objectForKey:@"device_model"]];
        detailV.deviceNum = [NSString stringWithFormat:@"%@",[ary_MyDeviceCell[indexPath.row] objectForKey:@"mac_address"]];
        detailV.useCountStr = @"0";
        detailV.theErrorDic = [[NSMutableDictionary alloc] initWithDictionary:[ary_MyDeviceCell[indexPath.row] objectForKey:@"error_code"]];
        
        NSLog(@"detailV.theErrorDic:%@",detailV.theErrorDic);
        
        [self presentViewController:detailV animated:true completion:nil];
        
    }];
    
    detailAction.backgroundColor = STANDER_COLOR;
    
    
    
    //Delete
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
        //1.移除 ary_MyDeviceCell 資料
        [ary_MyDeviceCell removeObjectAtIndex:indexPath.row];
        
        //2.將新的 ary_MyDeviceCell 放回 ary_cell
        [ary_cell replaceObjectAtIndex:1 withObject:ary_MyDeviceCell];
        
        //3.移除 cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        //API delete device
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        
        //[apiClass postDeleteDeviceData:tokenStr mac_address:(NSString *)];
        
        [tableView reloadData];
        
    }];
    
    deleteAction.backgroundColor = CIRCEL_RED;
    
    
    return @[deleteAction,detailAction];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        
        case 0:
            //Account - Profile
            [self gotoProfileVCAction];
            break;
        case 3:
            //Mail Notification
            [self gotoMailNotificationVC];
            break;
        default:
            break;
    
    }

}



#pragma mark - Btns Action ================================
//導覽列左邊按鍵方法
-(void)profileBtAction {
    
    [self SidebarBtn];
}


//health Switch Action
-(void)healthswitchAction:(id)sender {
    
    UISwitch *healthswitch = (UISwitch*)sender;
    
    BOOL isButtonOn = healthswitch.isOn;
    
    [MViewController setSyncWithHealthKit:isButtonOn];
    
    //先跳出詢問視窗是否開啟或關閉同步HealthKit
    NSString *titleStr = NSLocalizedString(@"Alert", nil);
    NSString *messageStr = isButtonOn == NO ? NSLocalizedString(@"You have turned off syncing HealthKit", nil) : NSLocalizedString(@"You have turned on syncing HealthKit", nil);
    NSString *confirmStr = NSLocalizedString(@"Confirm", nil);
    
    [MViewController showAlert:titleStr message:messageStr buttonTitle:confirmStr];
    
}

//delete BPMData Action
-(void)deleteBPMDataAction:(id)sender {
    
    UISwitch *deleteBPMSwitch = (UISwitch *)sender;
    
    BOOL isButtonOn = deleteBPMSwitch.isOn;
    
    if (isButtonOn) {
        //showSwitchValue.text = @"是";
        NSLog(@"DeleteBPMData on");
    }
    else {
        //showSwitchValue.text = @"否";
        NSLog(@"DeleteBPMData off");
    }

}




#pragma mark - 跳至其他頁面 ================================
//Mail Notification 頁面
-(void)gotoMailNotificationVC {
    

    if ([MViewController checkIsPrivacyModeOrMemberShip]) {
        //privacy mode can not use MailNotification
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"You can not use MailNotification in Pravicy Mode", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
    }
    else {
        
        MailNotificationViewController *mailNotifiVC = [[MailNotificationViewController alloc] initWithMailNotificationViewControllerFrame:self.view.frame];
        
        [self.navigationController pushViewController:mailNotifiVC animated:YES];
    }

    /*
    //UIViewController *MailNotification = [[UIViewController alloc ]init];
   // MailNotificationViewController *MailNotification = [self.storyboard instantiateViewControllerWithIdentifier:@"MailNotificationVC"];
    //MailNotification.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    MailNotificationViewController *mailNotifiVC = [[MailNotificationViewController alloc] initWithMailNotificationViewControllerFrame:self.view.frame];
    
    [self.navigationController pushViewController:mailNotifiVC animated:YES];
     */

}


//Profile 頁面
-(void)gotoProfileVCAction {
    
    UIViewController *ProfileV = [[UIViewController alloc ] init];
    ProfileV = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileV"];
    //ProfileV.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    ProfileV.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:ProfileV animated:true completion:nil];
}



#pragma mark - post API
-(void)getDeviceListFromCloud {
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postGetDeviceList:tokenStr];
    
    [self showIndicatorView];
    
}



#pragma mark - API Delegate  *******************
-(void)processeGetDeviceList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"GetDeviceList jsonError : %@",jsonError);
    }
    else {
        
        NSLog(@"GetDeviceList resopnseData: %@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            //Device 總數
            total_device_num  = [[resopnseData objectForKey:@"total_num"] intValue];
            
            if (ary_MyDeviceCell.count != 0) {
                
                [ary_MyDeviceCell removeAllObjects];
            }
            
            
            //血壓計
            NSArray *ary_bpmList = [[NSArray alloc] initWithArray:[resopnseData objectForKey:@"bpm"]];
            if (ary_bpmList.count > 0) {
                
                for (int i = 0; i < ary_bpmList.count; i ++) {
                    
                    [ary_MyDeviceCell addObject:[ary_bpmList[i] mutableCopy]];
                }
                
            }
            
            
            //體重計
            NSArray *ary_weightList = [[NSArray alloc] initWithArray:[resopnseData objectForKey:@"weight"]];
            if (ary_weightList.count > 0) {
                
                for (int i = 0; i < ary_weightList.count; i++) {
                    
                    [ary_MyDeviceCell addObject:[ary_weightList[i] mutableCopy]];
                }
            }
            
        
            //額溫槍
            NSArray *ary_btList = [[NSArray alloc] initWithArray:[resopnseData objectForKey:@"bt"]];
            if (ary_btList.count > 0) {
                
                for (int i = 0; i < ary_btList.count; i++) {
                    
                    [ary_MyDeviceCell addObject:[ary_btList[i] mutableCopy]];
                }
                
            }
            
        }
        
    }
    
    [self stopIndicatorView];
    
    [ary_cell replaceObjectAtIndex:1 withObject:ary_MyDeviceCell];
    
    [settingView_tableView reloadData];
    
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
