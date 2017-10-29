//
//  AppFeatureViewController.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/7/21.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "AppFeatureViewController.h"
#import "AppFIDetailViewController.h"

@interface AppFeatureViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation AppFeatureViewController {

    UITableView *m_tableView;
    NSMutableArray *ary_title;
    NSMutableArray *ary_img;
    NSMutableArray *ary_context;
    AppFIDetailViewController *appFIDetailVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithNavigationBar];
    [self initWithParameter];
    [self initWithUIobjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init  **********
-(void)initWithNavigationBar{
    self.navigationItem.title = NSLocalizedString(@"APPFIMainTitle", nil);
    //改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    //改變 statusBarStyle(字體變白色)
    //先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    //back鍵
    UIButton *left_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [left_btn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(backtoPreview) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_btn];
    
}

-(void)initWithParameter{
    
    //ary_title init
    ary_title = [[NSMutableArray alloc] initWithObjects:
                 NSLocalizedString(@"APPFI01_title", nil),
                 NSLocalizedString(@"APPFI02_title", nil),
                 NSLocalizedString(@"APPFI03_title", nil),
                 NSLocalizedString(@"APPFI04_title", nil),
                 NSLocalizedString(@"APPFI05_title", nil),
                 NSLocalizedString(@"APPFI06_title", nil),
                 NSLocalizedString(@"APPFI07_title", nil),
                 NSLocalizedString(@"APPFI08_title", nil),
                 NSLocalizedString(@"APPFI09_title", nil),
                 NSLocalizedString(@"APPFI10_title", nil),nil];
    
    //ary_img
    ary_img = [[NSMutableArray alloc] initWithObjects:
               @"FL009",
               @"FL001",
               @"FL002",
               @"FL003",
               @"FL004",
               @"FL005",
               @"FL006",
               @"FL007",
               @"FL008",
               @"FL010",nil];
    
    //ary_context
    ary_context = [[NSMutableArray alloc] initWithObjects:
                   NSLocalizedString(@"APPFI01", nil),
                   NSLocalizedString(@"APPFI02", nil),
                   NSLocalizedString(@"APPFL03", nil),
                   NSLocalizedString(@"APPFI04", nil),
                   NSLocalizedString(@"APPFI05", nil),
                   NSLocalizedString(@"APPFI06", nil),
                   NSLocalizedString(@"APPFI07", nil),
                   NSLocalizedString(@"APPFI08", nil),
                   NSLocalizedString(@"APPFI09", nil),
                   NSLocalizedString(@"APPFI10", nil),nil];
}

-(void)initWithUIobjects{
    
    CGFloat nav_height = self.navigationController.navigationBar.frame.size.height;
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, nav_height, self.view.frame.size.width, self.view.frame.size.height - nav_height)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
}



#pragma mark - btn function  ********
-(void)backtoPreview{
 
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - TableView Delegate & DataSource  ************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ary_title.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cell_id = @"cell_id_APPIntroduction";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = ary_title[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(appFIDetailVC == nil){
        appFIDetailVC = [[AppFIDetailViewController alloc] init];
    }
    
    appFIDetailVC.navTitleStr = ary_title[indexPath.row];
    appFIDetailVC.imgStr = ary_img[indexPath.row];
    appFIDetailVC.contextStr = ary_context[indexPath.row];
    
    [self.navigationController pushViewController:appFIDetailVC animated:YES];
}




@end
