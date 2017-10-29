//
//  OverViewEditEventViewController.m
//  Microlife
//
//  Created by Rex on 2016/10/27.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "OverViewEditEventViewController.h"
#import "OverViewAddEventControllerViewController.h"
#import "OverViewEditEventInsidePageViewController.h"


@interface OverViewEditEventViewController ()<UITableViewDelegate, UITableViewDataSource, APIPostAndResponseDelegate>{
    
    UITableView *eventTable;
    NSMutableArray *eventArray;
    UIBarButtonItem *rightBarButton;
    BOOL editing;
    OverViewAddEventControllerViewController *addEventVC;
    OverViewEditEventInsidePageViewController *insidePageVC;
    
    //API
    APIPostAndResponse *apiClass;

}

@end

@implementation OverViewEditEventViewController

@synthesize cellImgAry;

#define ADD_EVENT_IMAGE  [UIImage imageNamed:@"overview_btn_a_add_m"]

#pragma mark - Normal Functions  ****************************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self initParameter];
    [self initWithUIObjects];
    
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self initParameter];
    self.tabBarController.tabBar.hidden = YES;
    [eventTable reloadData];
}


-(void)viewWillDisappear:(BOOL)animated {
    
    if (eventArray != nil) {
        
        [eventArray removeAllObjects];
        eventArray = nil;
    }
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initalization  ******************************
-(void)initParameter{
    
    [self reloadDataFromDataBase];
    
    editing = NO;
    
}


-(void)reloadDataFromDataBase {
    
    if (eventArray == nil) {
        
        eventArray = [[NSMutableArray alloc] init];
    }
    
    [eventArray removeAllObjects];
    
    eventArray = [[EventClass sharedInstance] selectAllData];

}

-(void)initWithUIObjects{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backToOverviewVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
//    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnAction)];
//    
//    [rightBarButton setTintColor:[UIColor whiteColor]];
    
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"Event Management";
    
    //eventTableView
    eventTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    eventTable.delegate = self;
    eventTable.dataSource = self;
    
    [self.view addSubview:eventTable];
    
    if(_eventCount >= 5){
        
    }
    
    
    //add_EventBt
    UIButton *add_EventBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/8, self.view.frame.size.width/8)];
    add_EventBt.center = CGPointMake(CGRectGetMaxX(self.view.frame) - add_EventBt.frame.size.width, CGRectGetMaxY(self.view.frame) - add_EventBt.frame.size.width - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    [add_EventBt setImage:ADD_EVENT_IMAGE forState:UIControlStateNormal];
    [add_EventBt addTarget:self action:@selector(gotoOverViewAddEventVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add_EventBt];
    
    
    //API

}




#pragma mark - Tableview DataBase & Delegate  **************************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return eventArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1.0f;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!editing) {
        
        cell.imageView.image = [cellImgAry objectAtIndex:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *celltitle = [[eventArray objectAtIndex:indexPath.row] objectForKey:@"event"];
    
    cell.textLabel.text = celltitle;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPAD) {
        
         return (self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height) * 1.5;
    }
    else {
        
         return (self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
}


//cell 是否可向左滑動
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//cell 向左滑動顯示的RowAction

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Detail
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@" Edit ", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
        if (insidePageVC == nil) {
            
            insidePageVC = [[OverViewEditEventInsidePageViewController alloc] initWithEventInsidePageFrame:self.view.frame];
        }
        
        insidePageVC.insidePageIndex = indexPath.row;
        
        [self.navigationController pushViewController:insidePageVC animated:YES];
        
    }];
    
    editAction.backgroundColor = [UIColor darkGrayColor];
    
    
    //Delete
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [cellImgAry removeObjectAtIndex:indexPath.row];
        
        EventClass *eventObj = [[EventClass alloc] init];
        eventObj.accountID = [[eventArray[indexPath.row] objectForKey:@"accountID"] intValue];
        eventObj.eventID = [[eventArray[indexPath.row] objectForKey:@"eventID"] intValue];
        
        NSLog(@"accountID:%d",eventObj.accountID);
        NSLog(@"eventID:%d",eventObj.eventID);
        
        
        //API
        if (![CheckNetwork isExistenceNetwork]) {
            
            [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
            
            return;
        }
        else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
                NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
                
                [apiClass postEditBTEvent:tokenStr event_code:eventObj.eventID event:nil type:nil event_time:nil delete:1];
                
            });

        }
        
        
        //移除資料庫的資料
        [eventObj deletData];
        
        
        //eventArray移除資料
        [eventArray removeObjectAtIndex:indexPath.row];

    
        
        NSLog(@"%lu", (unsigned long)[[EventClass sharedInstance]selectAllData].count);
        
        //重新撈資料
        [tableView reloadData];
        
    }];
    
    deleteAction.backgroundColor = CIRCEL_RED;
    
    
    return @[deleteAction,editAction];
}




#pragma mark - 跳至其他頁面  **************************
//連結到 add Event 頁面
-(void)pushToAddEventVC:(BOOL)editing{
    
    OverViewAddEventControllerViewController *addEventVC = [[OverViewAddEventControllerViewController alloc]initWithAddEventViewController:self.view.frame];
    
    if (editing) {
        
    }
    
    [self.navigationController pushViewController:addEventVC animated:YES];
    
}

//跳至 OverView - 溫度頁面
-(void)backToOverviewVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//跳至 OverView Add Event ViewController
-(void)gotoOverViewAddEventVC {
    
    if (eventArray.count >= 5) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"You can only add up to five events", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
    }
    else {
        
        if (addEventVC == nil) {
            
            addEventVC = [[OverViewAddEventControllerViewController alloc] initWithAddEventViewController:self.view.frame];
        }
        
        [self.navigationController pushViewController:addEventVC animated:YES];
        
    }
    

}



#pragma mark - Btn Actions  ************************
//NavigationBar 右邊按鈕方法
-(void)rightBarBtnAction{
    
    if (editing) {
        [rightBarButton setTitle:@"Delete"];
        self.navigationItem.title = @"Edit Event";
    }
    else{
        [rightBarButton setTitle:@"Select"];
        self.navigationItem.title = @"Event Management";
    }
    
    editing = !editing;
}

#pragma mark - API Delegate  ************************
-(void)processeEditBTEvent:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"EditBTEvent error:%@",jsonError);
    }
    else {
        
        NSLog(@"EditBTEvent response:%@",resopnseData);
    }
    
}


@end
