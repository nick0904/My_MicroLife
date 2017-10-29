//
//  SetAlarmViewController.m
//  Microlife
//
//  Created by Rex on 2016/9/5.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "SetAlarmViewController.h"
#import "AlarmDetailViewController.h"
#import "AlertConfigClass.h"
#import "ShareCommon.h"

@interface SetAlarmViewController ()<UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *settingTable;
    NSMutableDictionary *reminderDict;
    UIPickerView *timePicker;
    UISegmentedControl *cellSegment;
    NSMutableArray *hourArray;
    NSMutableArray *minArray;
    
    NSMutableArray *typeArray;
    NSMutableArray *weekArray;
    
    NSMutableDictionary *tempDict;
    NSMutableArray *reminderArray;
}

@end

@implementation SetAlarmViewController

static NSString *identifier = @"Cell";

@synthesize isCreate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameter];
    [self initInterface];
    
}

-(void)initParameter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustomStr:) name:@"customStr" object:nil];
    
    reminderArray = [[LocalData sharedInstance] getReminderData];
    hourArray = [NSMutableArray new];
    minArray = [NSMutableArray new];
    weekArray = [[NSMutableArray alloc] initWithCapacity:0];
    typeArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (isCreate) {
        [self initAlarmParameter];
    }else{
        
        tempDict = [reminderArray objectAtIndex:self.alarmIndex];
        
        [AppDelegate saveNSUserDefaults:[tempDict objectForKey:@"hour"] Key:@"hour"];
        [AppDelegate saveNSUserDefaults:[tempDict objectForKey:@"min"] Key:@"min"];
        [AppDelegate saveNSUserDefaults:[tempDict objectForKey:@"week"] Key:@"week"];
        [AppDelegate saveNSUserDefaults:[tempDict objectForKey:@"type"] Key:@"type"];
        [AppDelegate saveNSUserDefaults:[tempDict objectForKey:@"model"] Key:@"model"];

        weekArray = [tempDict objectForKey:@"week"];
        typeArray = [tempDict objectForKey:@"type"];
    }
    
}

-(void)initAlarmParameter{
    
    NSDate *currentDay = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm";
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:currentDay]);
    
    NSString *dateStr = [dateFormatter stringFromDate:currentDay];
    
    NSString *hourStr = [dateStr substringToIndex:2];
    
    NSString *minStr = [dateStr substringWithRange:NSMakeRange(3, 2)];
    
    NSLog(@"dateStr = %@, hourStr = %@, minStr = %@",dateStr,hourStr,minStr);
    
    NSArray *weekNameArray = [[NSArray alloc] initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    
    for (int i=0; i<weekNameArray.count; i++) {
        
        NSString *weekName = [NSString stringWithFormat:@"%@",[weekNameArray objectAtIndex:i]];
        
        NSMutableDictionary *weekDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:weekName,@"weekName",
                                         @"0",@"choose",nil];
        
        [weekArray addObject:weekDict];
        
    }
    
    NSArray *typeNameArray = [[NSArray alloc] initWithObjects:@"World Measure",@"Measure",@"Medicine",@"Doctor",@"Custom", nil];
    
    for (int i=0; i<typeNameArray.count; i++) {
        
        NSString *typeName = [NSString stringWithFormat:@"%@",[typeNameArray objectAtIndex:i]];
        
        NSNumber *chooseType;
        
        if (i==0) {
            chooseType = [NSNumber numberWithInt:1];
        }else{
            chooseType = [NSNumber numberWithInt:0];
        }
        
        NSMutableDictionary *typeDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:typeName,@"typeName",
                                         chooseType,@"choose",nil];
        
        [typeArray addObject:typeDict];
    }
    
    tempDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:hourStr,@"hour",
                           minStr,@"min",
                           weekArray,@"week",
                           typeArray,@"type",
                           @"0",@"model",
                           @"0",@"status",
                           nil];

}

-(void)initInterface{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backToReminderVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveReminder)];
    
    [saveButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (isCreate) {
        self.navigationItem.title = @"Add reminder";
    }else{
        self.navigationItem.title = @"Edit reminder";
    }
    
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.322)];
    timePicker.delegate = self;
    timePicker.dataSource = self;
    
    [self.view addSubview:timePicker];
    
    CGFloat ptime_w=timePicker.frame.size.width/5.0;
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(ptime_w*2.0, timePicker.frame.size.height/2-SCREEN_HEIGHT*0.06/2, ptime_w, SCREEN_HEIGHT*0.06)];
    hourLabel.text = @"hours";
    hourLabel.font = [UIFont systemFontOfSize:15];
    [timePicker addSubview:hourLabel];
    
    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(ptime_w*4.0, timePicker.frame.size.height/2-SCREEN_HEIGHT*0.06/2, SCREEN_WIDTH*0.126, SCREEN_HEIGHT*0.06)];
    minLabel.text = @"min";
    minLabel.font = [UIFont systemFontOfSize:15];
    [timePicker addSubview:minLabel];
    
    
    settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, timePicker.frame.origin.y+timePicker.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT*0.8) style:UITableViewStyleGrouped];
    
    settingTable.delegate = self;
    settingTable.dataSource = self;
    settingTable.scrollEnabled = NO;
    settingTable.backgroundColor = TABLE_BACKGROUND;
    
    [self.view addSubview:settingTable];
}

-(void)viewWillAppear:(BOOL)animated{
    
    int hourRow = [[tempDict objectForKey:@"hour"] intValue];
    int minRow = [[tempDict objectForKey:@"min"] intValue];
    
    NSLog(@"hourRow = %d, minRow = %d",hourRow,minRow);
    
    [timePicker selectRow:hourRow inComponent:0 animated:NO];
    [timePicker selectRow:minRow inComponent:1 animated:NO];
    
    [settingTable reloadData];
}

- (void)getCustomStr:(NSNotification*)notification
{
    [[typeArray objectAtIndex:4] setObject:notification.object forKey:@"typeName"];
    
}

-(void)saveReminder{
    
    int hourInt = [[hourArray objectAtIndex:[timePicker selectedRowInComponent:0]] intValue];
    
    int minInt = [[minArray objectAtIndex:[timePicker selectedRowInComponent:1]] intValue];
    
    NSString *hourStr = [NSString stringWithFormat:@"%02d",hourInt];
    
    NSString *minStr = [NSString stringWithFormat:@"%02d",minInt];
    
    NSString *modelStr = [NSString stringWithFormat:@"%ld",(long)cellSegment.selectedSegmentIndex];

    
    [tempDict setValue:hourStr forKey:@"hour"];
    [tempDict setValue:minStr forKey:@"min"];
    [tempDict setValue:weekArray forKey:@"week"];
    [tempDict setValue:typeArray forKey:@"type"];
    [tempDict setValue:modelStr forKey:@"model"];
    [tempDict setValue:@"1" forKey:@"status"];
    
    NSLog(@"tempDict:%@",tempDict);
    
    if (isCreate) {
        [reminderArray addObject:tempDict];
    }else{
        [reminderArray replaceObjectAtIndex:self.alarmIndex withObject:tempDict];
    }
    
    NSMutableArray *newRemind=[[LocalData sharedInstance] saveReminderData:reminderArray];
    
    
    //save to db..
    
    NSString *jsonRs=[ShareCommon DictionaryToJson:newRemind];
    
    NSLog(@"jsonRs:%@",jsonRs);
    
    AlertConfigClass *alertConfigClass=[[AlertConfigClass alloc]init];
    alertConfigClass.accountID=[LocalData sharedInstance].accountID;
    alertConfigClass.alertConfig=jsonRs;
    
    [alertConfigClass insertData];
    
    [alertConfigClass closeDatabase];
    
    NSMutableArray *thisRemind = [NSMutableArray arrayWithObjects:tempDict, nil];
    NSString *thisRemindJson = [ShareCommon DictionaryToJson:thisRemind];
    NSMutableArray *reminderArr = [ShareCommon JsonToDictionary:thisRemindJson];
    [appDelegate setLocalNoise:reminderArr];
    
    //AlertConfigClass *alertConfigClass2=[AlertConfigClass sharedInstance];
    
    //[alertConfigClass2 getUserAlertConfig:[LocalData sharedInstance].accountID];
    
    //NSLog(@"ALERT_ID:%d",alertConfigClass2.ALERT_ID);
    //NSLog(@"accountID:%d",alertConfigClass2.accountID);
    //NSLog(@"alertConfig:%@",alertConfigClass2.alertConfig);
    
    //NSMutableDictionary *dic=[self JsonToDictionary:jsonRs];
    
    //NSLog(@"dicRs:%@",dic);
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *cellTitle;
    
    NSArray *titleAry = [NSArray arrayWithObjects:@"Repeat",@"Type",@"Measure Model", nil];

    cellTitle = [titleAry objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellTitle;
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    UILabel *introLabel;

    
    if (introLabel == nil) {
        introLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-SCREEN_WIDTH*0.5-SCREEN_WIDTH*0.1, 0, SCREEN_WIDTH*0.5, 44)];
        
        [cell addSubview:introLabel];
    }
    
    introLabel.textAlignment = NSTextAlignmentRight;
    introLabel.textColor = TEXT_COLOR;
    introLabel.text = @"";
    
    UIImage *segmentBpImg = [self resizeImage:[UIImage imageNamed:@"reminder_btn_a_bp_0"]];
    UIImage *segmentWeImg = [self resizeImage:[UIImage imageNamed:@"reminder_btn_a_we_0"]];
    UIImage *segmentBtImg = [self resizeImage:[UIImage imageNamed:@"reminder_btn_a_bt_0"]];
    
    NSArray *itemArray = [NSArray arrayWithObjects:
                          segmentBpImg,
                          segmentWeImg,
                          segmentBtImg,
                          nil];
    
    [cellSegment removeFromSuperview];
    
    cellSegment = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    CGFloat sg_w=self.view.frame.size.width/2.0;
    CGFloat sg_h=SCREEN_HEIGHT*0.044;
    CGFloat sg_x=sg_w-5;
    CGFloat sg_y=cell.frame.size.height/2.0-SCREEN_HEIGHT*0.044/2.0;

    cellSegment.frame = CGRectMake(sg_x, sg_y, sg_w, sg_h);
    
    cellSegment.selectedSegmentIndex = [[tempDict objectForKey:@"model"] intValue];
    
    cellSegment.tintColor = STANDER_COLOR;
    
    
    for (int i=0; i<itemArray.count; i++) {
        [cellSegment setImage:[itemArray objectAtIndex:i] forSegmentAtIndex:i];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:{
            
            int repeatCount = 0;
            
            NSMutableArray *chooseWeek = [tempDict objectForKey:@"week"];
            NSString *weekStr = @"";
            
            for (int i=0; i<chooseWeek.count; i++) {
                
                if([[[chooseWeek objectAtIndex:i] objectForKey:@"choose"] boolValue]){
                    
                    repeatCount++;
                    
                    if([weekStr isEqualToString:@""]){
                        weekStr = [NSString stringWithFormat:@"%@",[[chooseWeek objectAtIndex:i] objectForKey:@"weekName"]];
                    }else{
                       weekStr = [weekStr stringByAppendingFormat:@", %@",[[chooseWeek objectAtIndex:i] objectForKey:@"weekName"]];
                    }
                    
                }
            }
            
            if (repeatCount == 0) {
                weekStr = @"Never";
            }
            
            if (repeatCount == 7) {
                weekStr = @"Everyday";
            }
            
            introLabel.text = weekStr;
            
         }
            break;
        
        case 1:{
            NSMutableArray *chooseType = [tempDict objectForKey:@"type"];
            NSString *typeStr;
            
            for (int i=0; i<chooseType.count; i++) {
                
                if([[[chooseType objectAtIndex:i] objectForKey:@"choose"] boolValue]){
                    typeStr = [[chooseType objectAtIndex:i] objectForKey:@"typeName"];
                }
            }
            
            introLabel.text = typeStr;
            
        }
            
            break;
        
        case 2:
            
            [cell addSubview:cellSegment];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        
            
        default:
            break;
    }
    
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlarmDetailViewController *detailVC = [[AlarmDetailViewController alloc] init];
    
    detailVC.listType = (int)indexPath.row;
    
    detailVC.reminderDict = tempDict;
    detailVC.alarmIndex = self.alarmIndex;
    
    if (indexPath.row != 2) {
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - Picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    NSInteger rowCount = 0;
    
    if(component == 0){
        rowCount =  24;
    }
    else if(component == 1){
        rowCount =  60;
    }
    
    return rowCount;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickTitle = (UILabel*)view;
    if (!pickTitle)
    {
        pickTitle = [[UILabel alloc] init];
        [pickTitle setFont:[UIFont fontWithName:@"Helvetica" size:35]];
        pickTitle.textAlignment = NSTextAlignmentCenter;
        pickTitle.numberOfLines = 1;
    }
    
    for (int i=0; i<24; i++) {
        
        NSNumber *hourNum = [NSNumber numberWithInt:i];
        
        [hourArray addObject:hourNum];
    }
    
    for (int i=0; i<60; i++) {
        
        NSNumber *minNum = [NSNumber numberWithInt:i];
        
        [minArray addObject:minNum];
    }
    
    NSString *rowTitle;
    
    if(component == 0){
        rowTitle = [NSString stringWithFormat:@"%02d",[[hourArray objectAtIndex:row] intValue]];
    }
    
    if(component == 1){
        rowTitle = [NSString stringWithFormat:@"%02d",[[minArray objectAtIndex:row] intValue]];
    }
    
    // Fill the label text here
    pickTitle.text = rowTitle;
    
    return pickTitle;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    //return SCREEN_WIDTH*0.16;
    return 120;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    //return SCREEN_HEIGHT*0.06;
    return 50;
}

#pragma mark - Navigation Delegate
-(void)backToReminderVC{
    
    BOOL checkingCreate = [self checkingCreate];
    
    if (isCreate || checkingCreate ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Reminder" message:@"Are you sure to leave this page? Please click Save button to save your information." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *updateAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self saveReminder];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:updateAlertAction];
        UIAlertAction *nextTimeAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:nextTimeAlertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)heightForRowAtIndexPath:(NSInteger)row {
    NSArray *titleAry = [NSArray arrayWithObjects:@"Repeat",@"Type",@"Measure Model", nil];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    CGRect rect = [[titleAry objectAtIndex:row]
                   boundingRectWithSize:cell.textLabel.frame.size//限制最大的宽度和高度
                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                   attributes:@{NSFontAttributeName:cell.textLabel.font}//传人的字体字典
                   context:nil];
    return (rect.size.height > 50)?rect.size.height:50;
}


/**
 檢查是否有做修改，沒有回傳yes。
 @return 否有做修改
 */
- (BOOL)checkingCreate {
    
    int hourInt = [[hourArray objectAtIndex:[timePicker selectedRowInComponent:0]] intValue];
    
    int minInt = [[minArray objectAtIndex:[timePicker selectedRowInComponent:1]] intValue];
    
    NSString *hourStr = [NSString stringWithFormat:@"%02d",hourInt];
    
    NSString *minStr = [NSString stringWithFormat:@"%02d",minInt];
    
    NSString *modelStr = [NSString stringWithFormat:@"%ld",(long)cellSegment.selectedSegmentIndex];
    
    BOOL checkingHour = [[AppDelegate readNSUserDefaults:@"hour"] isEqualToString:hourStr];
    BOOL checkingMin = [[AppDelegate readNSUserDefaults:@"min"] isEqualToString:minStr];
    BOOL checkingWeek = [[AppDelegate readNSUserDefaults:@"week"] isEqual:weekArray];
    BOOL checkingType = [[AppDelegate readNSUserDefaults:@"type"] isEqual:typeArray];
    BOOL checkingModel = [[AppDelegate readNSUserDefaults:@"model"] isEqualToString:modelStr];

    BOOL checkingCreate = (checkingHour && checkingMin && checkingWeek && checkingType && checkingModel);
    
    return checkingCreate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
