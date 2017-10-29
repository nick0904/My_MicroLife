//
//  AlarmDetailViewController.m
//  Microlife
//
//  Created by Rex on 2016/9/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "AlarmDetailViewController.h"
#import "EditOptionViewController.h"

@interface AlarmDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UILabel *customText;
    
}

@end

@implementation AlarmDetailViewController

@synthesize weekArray,typeArray,customStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameter];
    [self initInterface];
}

-(void)initParameter{
    
    weekArray = [self.reminderDict objectForKey:@"week"];
    typeArray = [self.reminderDict objectForKey:@"type"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustomStr:) name:@"customStr" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    

}

-(void)initInterface{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *navTitle;
    
    switch (self.listType) {
        case 0:
            navTitle = @"Repeat";
            break;
        
        case 1:
            navTitle = @"Type";
            break;
            
        default:
            break;
    }
    
    
    self.navigationItem.title = navTitle;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backToSetAlarmVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UITableView *optionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    optionTable.delegate = self;
    optionTable.dataSource = self;
    optionTable.scrollEnabled = NO;
    optionTable.backgroundColor = TABLE_BACKGROUND;
    [self.view addSubview:optionTable];
    
    if(self.listType == 1){
        
//        NSMutableArray *alarmArray = [[LocalData sharedInstance] getReminderData];
//        
//        if (alarmArray.count != 0) {
//            customStr = [NSString stringWithFormat:@"%@",[[alarmArray objectAtIndex:self.alarmIndex] objectForKey:@"custom"]];
//        }else{
//            customStr = @"Measure";
//        }
        
        if ([[[typeArray objectAtIndex:4] objectForKey:@"choose"] boolValue]) {
            customStr = [[typeArray objectAtIndex:4] objectForKey:@"typeName"];
        }else{
            customStr = @"Measure";
        }
        
        UIView *customTxtBase = [[UIView alloc] initWithFrame:CGRectMake(0, [self heightForRowAtIndexPath:4]*5, SCREEN_WIDTH, 22)];
        
        customTxtBase.backgroundColor = [UIColor whiteColor];
        
        customText = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.135, 0, SCREEN_WIDTH, customTxtBase.frame.size.height/2)];
        
        customText.text = customStr;
        customText.textColor = TEXT_COLOR;
        customText.font = [UIFont systemFontOfSize:12.0];
        customText.backgroundColor = [UIColor clearColor];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,customTxtBase.frame.size.height-1, SCREEN_WIDTH, 1)];
        
        bottomLine.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        
        [optionTable addSubview:customTxtBase];
        [customTxtBase addSubview:customText];
        [customTxtBase addSubview:bottomLine];
    }
}

- (void)getCustomStr:(NSNotification*)notification
{
    customStr = notification.object;
    customText.text = notification.object;
    
}

-(void)backToSetAlarmVC{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CGFloat rowHeight = 44;
    
//    if (self.listType == 1 && indexPath.row == 4) {
//        rowHeight = 66;
//    }
    
    return [self heightForRowAtIndexPath:indexPath.row];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    
    if (self.listType == 0) {
        row = 7;
    }else{
        row = 5;
    }
    
    return row;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    //section height 不得小於1，否則無法顯示
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (self.listType) {
            
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[weekArray objectAtIndex:indexPath.row] objectForKey:@"weekName"]];
            
            BOOL choose = [[[weekArray objectAtIndex:indexPath.row] objectForKey:@"choose"] boolValue];
            
            if (choose) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            break;
        case 1:{
            
            NSArray *typeNameAry = [[NSArray alloc] initWithObjects:@"World Measure",@"Measure",@"Mdeicine",@"Doctor",@"Custom", nil];
            
            cell.textLabel.text = [typeNameAry objectAtIndex:indexPath.row];
            
            customText.text = customStr;
            
            BOOL choose = [[[typeArray objectAtIndex:indexPath.row] objectForKey:@"choose"] boolValue];
            
            UIImage *typeChooseImg;
            if (choose) {
                typeChooseImg = [self resizeImage:[UIImage imageNamed:@"all_select_a_1"]];
            }else{
                typeChooseImg = [self resizeImage:[UIImage imageNamed:@"all_select_a_0"]];
            }
            
            cell.imageView.image = typeChooseImg;
            
            break;
        }
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL choose;
    
    switch (self.listType) {
            
        case 0:
            choose = [[[weekArray objectAtIndex:indexPath.row] objectForKey:@"choose"] boolValue];
            
            if (!choose) {
                
                [[weekArray objectAtIndex:indexPath.row] setObject:@"1" forKey:@"choose"];
            }else{
                [[weekArray objectAtIndex:indexPath.row] setObject:@"0" forKey:@"choose"];
            }
            
            break;
        
        case 1:
            
            [[typeArray objectAtIndex:indexPath.row] setObject:@"1" forKey:@"choose"];
            
            for (int i=0; i<typeArray.count; i++) {
                
                if (i != indexPath.row) {
                    [[typeArray objectAtIndex:i] setObject:@"0" forKey:@"choose"];
                }
            }
            
            if (indexPath.row == 4) {
                
                EditOptionViewController *editOptionVC = [[EditOptionViewController alloc] init];
                
                editOptionVC.alarmIndex = self.alarmIndex;
                editOptionVC.customStr = customStr;
                
                [self.navigationController pushViewController:editOptionVC animated:YES];
            }
            
            break;
            
        default:
            break;
    }
    
    [tableView reloadData];
    
}

- (CGFloat)heightForRowAtIndexPath:(NSInteger)row {
    
    NSString *title;
    switch (self.listType) {
        case 0:
            title = [[weekArray objectAtIndex:row] objectForKey:@"weekName"];
            break;
        case 1:{
            NSArray *titleAry = [[NSArray alloc] initWithObjects:@"World Measure",@"Measure",@"Mdeicine",@"Doctor",@"Custom", nil];
            title = [titleAry objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    CGRect rect = [title
                   boundingRectWithSize:cell.textLabel.frame.size//限制最大的宽度和高度
                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                   attributes:@{NSFontAttributeName:cell.textLabel.font}//传人的字体字典
                   context:nil];
    return (rect.size.height > 44)?rect.size.height:44;
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
