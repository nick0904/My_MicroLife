//
//  NotificationViewController.m
//  MicroLifeApp
//
//  Created by Ideabus on 2016/8/11.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController () <UITableViewDelegate,UITableViewDataSource,APIPostAndResponseDelegate,SFSafariViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *sideBarNotifivation_tableView;

@end

@implementation NotificationViewController {
    
    APIPostAndResponse *apiClass;
    
    int totalNum;
    
    NSMutableArray *ary_data;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUIObjects];
 
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self postAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initilization  *****************
-(void)initWithParameter {
    
    ary_data = [[NSMutableArray alloc] init];
    
    totalNum = 0;
}

-(void)initWithUIObjects {
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:@"Notification" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.01, 0, -self.view.frame.size.height*0.01, 0)];
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(goback2Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleBtn];
    
    UIButton *gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    
    
    [gobackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [gobackBtn addTarget:self action:@selector(goback2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobackBtn];
    

    ///sideBarNotifivation_tableView
    self.sideBarNotifivation_tableView.frame = CGRectMake(0, CGRectGetMaxY(titleBtn.frame), self.sideBarNotifivation_tableView.frame.size.width, self.view.frame.size.height - titleBtn.frame.size.height);
    self.sideBarNotifivation_tableView.delegate = self;
    self.sideBarNotifivation_tableView.dataSource = self;
    
    
    ///API
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
}


-(void)goback2Click{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TableView Delegate & DataSource  ***************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return totalNum;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"SideBarNotificationVC_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *titleLabel = [cell.contentView viewWithTag:11];
    titleLabel.text = [ary_data[indexPath.row] objectForKey:@"title"];
    
    
    UILabel *detailLabel = [cell.contentView viewWithTag:12];
    detailLabel.text = [ary_data[indexPath.row]objectForKey:@"content"];
    
    
    UILabel *dateLabel = [cell.contentView viewWithTag:13];
    NSString *dateStr = [ary_data[indexPath.row] objectForKey:@"start_time"];
    dateLabel.text = [self parseDate:dateStr];
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *urlStr = [ary_data[indexPath.row] objectForKey:@"link_url"];
    
    if (urlStr.length > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
            webVC.delegate = self;
            [self presentViewController:webVC animated:YES completion:nil];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
            vc.URL = urlStr;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
    
}



#pragma mark - postAPI  & API Delegate  ***************
-(void)postAPI {
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    
    [apiClass postGetPushHistoryList:tokenStr];
    
}


-(void)processGetPushHistoryList:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    if (jsonError != nil) {
        
        NSLog(@"GetMailNotificationList Error:%@",jsonError);
    }
    else {
        
        NSLog(@"GetMailNotificationList: %@",responseData);
        
        if ([[responseData objectForKey:@"code"] intValue] == 10000) {
            
            
            //總筆數
            totalNum = [[responseData objectForKey:@"total_num"] intValue];
            
            
            //資料訊息
            if (ary_data.count > 0) {
                
                [ary_data removeAllObjects];
            }
            
            ary_data = [[responseData objectForKey:@"data"] mutableCopy];
            
            
            //reload data
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.sideBarNotifivation_tableView reloadData];
                
            });
            
        }
        
    }

    
}



#pragma mark - parseDate  ************
-(NSString *)parseDate:(NSString *)originDate {
    
    //EX:2017-04-21 18:38:37
    NSArray *ary_date = [originDate componentsSeparatedByString:@" "];
    
    return ary_date[0];
    
}

@end
