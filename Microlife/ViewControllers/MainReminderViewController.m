//
//  MainReminderViewController.m
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MainReminderViewController.h"
#import "CustomAlarmCell.h"
#import "SetAlarmViewController.h"
#import "AlertConfigClass.h"
#import "ShareCommon.h"

@interface MainReminderViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *alarmTable;
    NSMutableArray *reminderArray;
}

@end

static NSString *identifier = @"AlarmCell";

@implementation MainReminderViewController

#pragma mark - Normal Functions *******************
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameter];
    [self initInterface];
    
    //[appDelegate setLocalNoise];
    

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //get from db..
    reminderArray = [[LocalData sharedInstance] getReminderData];
    
    
    if(alarmTable == nil){
        alarmTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    }
    
    
    alarmTable.delegate = self;
    alarmTable.dataSource = self;
    alarmTable.backgroundColor = TABLE_BACKGROUND;
    
    [self.view addSubview:alarmTable];
    
    if (reminderArray.count == 0) {
        alarmTable.hidden = YES;
    }else{
        alarmTable.hidden = NO;
    }
    
    [alarmTable reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initialization **********************
-(void)initParameter{
    
    
}


-(void)initInterface{
    
    self.navigationItem.title = NSLocalizedString(@"Reminder", nil);
    
    //設定leftBarButtonItem(profileBt)
    UIButton *leftItemBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    
    [leftItemBt setImage:[UIImage imageNamed:@"all_btn_a_menu"] forState:UIControlStateNormal];
    
    [leftItemBt addTarget:self action:@selector(profileBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemBt];
    
    float clockImgWidth = 303/self.imgScale;
    float clockImgHeight = 316/self.imgScale;
    
    UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-clockImgWidth/2, self.view.frame.size.height*0.123, clockImgWidth, clockImgHeight)];
    
    clockImage.image = [UIImage imageNamed:@"reminder_pic"];
    
    [self.view addSubview:clockImage];
    

    UILabel *reminderIntro = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width*0.78/2, clockImage.frame.origin.y+clockImage.frame.size.height+SCREEN_HEIGHT*0.029, self.view.frame.size.width*0.78, self.view.frame.size.height*0.187)];
    
    UIFont *font = [UIFont systemFontOfSize:18.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineSpacing: 10.0];
    
    NSDictionary *attributes = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Set the time to remind you of doing\nnecessary things you may forget.\nJust tap add button to\ncreate new alarm.", nil) attributes:attributes];
    
    [reminderIntro setAttributedText: attributedString];
    
    reminderIntro.textAlignment = NSTextAlignmentCenter;
    
    reminderIntro.numberOfLines = 0;
    
    [self.view addSubview:reminderIntro];
    
    float addAlarmBtnSize = 142/self.imgScale;
    
    UIButton *addAlarmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-SCREEN_WIDTH*0.2/2, reminderIntro.frame.origin.y+reminderIntro.frame.size.height+SCREEN_HEIGHT*0.029, addAlarmBtnSize, addAlarmBtnSize)];

    [addAlarmBtn setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_add_m"] forState:UIControlStateNormal];
    
    [addAlarmBtn addTarget:self action:@selector(addAlarmAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addAlarmBtn];
    
    
    UIButton *navAddButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [navAddButton setBackgroundImage:[UIImage imageNamed:@"reminder_icon_a_add"] forState:UIControlStateNormal];
    
    [navAddButton addTarget:self action:@selector(addAlarmAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navAddButton];
}


#pragma mark - TableView Delegate & DataSource ***********************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return reminderArray.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    //section height 不得小於1，否則無法顯示
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //custom cell 需要給 height 才能顯示
    //return SCREEN_HEIGHT*0.176;
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomAlarmCell *alarmCell;
    
    if (alarmCell == nil) {
        alarmCell = [[CustomAlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    int model = [[[reminderArray objectAtIndex:indexPath.row] objectForKey:@"model"] intValue];
    
    UIImage *modelImg;
    NSString *typeText;
    
    switch (model) {
        case 0:
            modelImg = [UIImage imageNamed:@"reminder_icon_a_bp"];
            typeText = @"BP";
            break;
            
        case 1:
            modelImg = [UIImage imageNamed:@"reminder_icon_a_we"];
            typeText = @"Weight";
            break;
            
        case 2:
            modelImg = [UIImage imageNamed:@"reminder_icon_a_bt"];
            typeText = @"Body Temp.";
            break;
            
        default:
            break;
    }
    
    //NSLog(@"cell init reminderArray=%@",reminderArray);
    
    NSDictionary *dict = [reminderArray objectAtIndex:indexPath.row];
    
    NSString *alarmHour = [NSString stringWithFormat:@"%@",[dict objectForKey:@"hour"]];
    
    NSString *alarmMin = [NSString stringWithFormat:@"%@",[dict objectForKey:@"min"]];
    
    NSMutableArray *chooseWeek = [dict objectForKey:@"week"];
    
    NSString *weekStr = @"";
    
    for (int i=0; i<chooseWeek.count; i++) {
        
        if([[[chooseWeek objectAtIndex:i] objectForKey:@"choose"] boolValue]){
            weekStr = [weekStr stringByAppendingFormat:@"%@",[[chooseWeek objectAtIndex:i] objectForKey:@"weekName"]];
            NSLog(@"VC weekStr = %@",weekStr);
            
        }
    }

    alarmCell.cellIndex = indexPath.row;
    
    NSMutableArray *chooseType = [dict objectForKey:@"type"];
    
    NSString *typeStr;
    
    for (int i=0; i<chooseType.count; i++) {
        
        if([[[chooseType objectAtIndex:i] objectForKey:@"choose"] boolValue]){
            typeStr = [[chooseType objectAtIndex:i] objectForKey:@"typeName"];
            
        }
    }
    
    BOOL switchOn = [[dict objectForKey:@"status"] boolValue];
    
    alarmCell.iconImage.image = modelImg;
    alarmCell.typeTitle.text = typeText;
    alarmCell.timeLabel.text = [NSString stringWithFormat:@"%@:%@",alarmHour,alarmMin];
    
    if ([weekStr isEqualToString:@""]) {
        alarmCell.measureWeek.text = [NSString stringWithFormat:@"%@%@",typeStr,weekStr];
    }else{
       alarmCell.measureWeek.text = [NSString stringWithFormat:@"%@, %@",typeStr,weekStr];
    }
    
    if(switchOn){
        alarmCell.alarmSwitch.on = YES;
    }else{
        alarmCell.alarmSwitch.on = NO;
    }
    
    return alarmCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SetAlarmViewController *setAlarmVC = [[SetAlarmViewController alloc] init];
    
    setAlarmVC.isCreate = NO;
    setAlarmVC.alarmIndex = indexPath.row;

    
    [self.navigationController pushViewController:setAlarmVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        [reminderArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [[LocalData sharedInstance] saveReminderData:reminderArray];
    
        NSLog(@"Delete reminderArray %@",reminderArray);
        
        //Save To db
        
        NSString *jsonRs=[ShareCommon DictionaryToJson:reminderArray];
        
        NSLog(@"jsonRs:%@",jsonRs);
        
        AlertConfigClass *alertConfigClass=[[AlertConfigClass alloc]init];
        alertConfigClass.accountID=[LocalData sharedInstance].accountID;
        alertConfigClass.alertConfig=jsonRs;
        
        [alertConfigClass insertData];
        
        [alertConfigClass closeDatabase];
        
        [alertConfigClass PushLoacaleMessage:reminderArray];
        
        
        if(reminderArray.count == 0){
            alarmTable.hidden = YES;
        }
        
        /*
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure you want to delete the data?" , nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            

        }];
        
        [deleteAlert addAction:cancel];
        [deleteAlert addAction:okAction];
        */
    }
    
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.25];
    
}

-(void)reloadTableView{
    [alarmTable reloadData];
}


#pragma mark - Navigation Action  **************************
-(void)backToReminderVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addAlarmAction{
    
    SetAlarmViewController *addReminderVC = [[SetAlarmViewController alloc] init];
    
    addReminderVC.isCreate = YES;
    addReminderVC.alarmIndex = reminderArray.count+1;
    
    [self.navigationController pushViewController:addReminderVC animated:YES];
    
}

#pragma mark - profileBtAction (導覽列左邊按鍵方法)
-(void)profileBtAction {
    
    [alarmTable reloadData];
    
    NSLog(@"getReminderData %@",[[LocalData sharedInstance] getReminderData]);
    //NSLog(@"reminderArray %@",reminderArray);
    [self SidebarBtn];
    
}



@end
