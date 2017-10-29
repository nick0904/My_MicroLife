//
//  DeviceInstructionsViewController.m
//  Microlife
//
//  Created by WiFi@MBP on 2017/6/8.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "DeviceInstructionsViewController.h"

@interface DeviceInstructionsViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *about_tableView;
    
    NSArray *ary_title;
    
}


@end

@implementation DeviceInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initParameter];
    
    [self initWithObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialization  ***************
-(void)initParameter {
    
    ary_title = [[NSArray alloc] initWithObjects:
                 NSLocalizedString(@"Blood Pressure Monitor - A6 BT", nil),
                 NSLocalizedString(@"Forehead Thermometer - NC150 BT", nil),
                 NSLocalizedString(@"Body Composition Scale - WS200 BT", nil),nil];
    
}


-(void)initWithObject {
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:NSLocalizedString(@"Device Quick Start Guide", nil) forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.01, 0, -self.view.frame.size.height*0.01, 0)];
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(goback3Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleBtn];
    
    UIButton *gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [gobackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [gobackBtn addTarget:self action:@selector(goback3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobackBtn];
    
    
    //about_tableView
    about_tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleBtn.frame), CGRectGetMaxY(titleBtn.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(titleBtn.frame))];
    about_tableView.delegate = self;
    about_tableView.dataSource = self;
    about_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:about_tableView];
    
}

-(void)goback3Click{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - tableView DataSource & Delegate  *************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ary_title.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size.height/12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"device_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = ary_title[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ary_title:%@",ary_title[indexPath.row]);
    
    DeviceDataViewController *deviceDataView = [DeviceDataViewController new];
    deviceDataView.showContentType = indexPath.row;
    deviceDataView.title = ary_title[indexPath.row];
    [self presentViewController:deviceDataView animated:YES completion:nil];
}



@end
