//
//  HealthEducationViewController.m
//  MicroLifeApp
//
//  Created by Ideabus on 2016/8/11.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "HealthEducationViewController.h"

@interface HealthEducationViewController () <UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate> {
    
    UITableView *about_tableView;
    
    NSArray *ary_title;
    NSArray *ary_sedTitle;
    
    NSArray *ary_webURL;
    
    SFSafariViewController *webVC;
    
    BOOL showTwoData;
    UIButton *titleBtn;
}


@end

@implementation HealthEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
                 NSLocalizedString(@"Health Information", nil),
                 NSLocalizedString(@"Microlife Technologies", nil),
                 NSLocalizedString(@"Microlife Products", nil),nil];
    
    showTwoData = NO;
    
}

- (void)initSedParameter:(NSUInteger)type {
    switch (type) {
        case 0:
            ary_sedTitle = [[NSArray alloc] initWithObjects:
                            NSLocalizedString(@"Blood Pressure", nil),
                            NSLocalizedString(@"Fever", nil),
                            NSLocalizedString(@"Body Composition", nil),
                            NSLocalizedString(@"Respiratory Care", nil),
                            NSLocalizedString(@"Flexible Heating", nil),nil];
            ary_webURL = [[NSArray alloc] initWithObjects:
                          @"https://www.microlife.com/magazine?cat=87#overview",
                          @"https://www.microlife.com/magazine?cat=88#overview",
                          @"",
                          @"https://www.microlife.com/magazine?cat=89#overview",
                          @"https://www.microlife.com/magazine?cat=107#overview",nil];
            break;
        case 1:
            ary_sedTitle = [[NSArray alloc] initWithObjects:
                            NSLocalizedString(@"Blood Pressure", nil),
                            NSLocalizedString(@"Fever", nil),nil];
            ary_webURL = [[NSArray alloc] initWithObjects:
                          @"https://www.microlife.com/technologies/blood-pressure?cat=37#overview",
                          @"https://www.microlife.com/technologies/8-fever-technologies-you-should-know",nil];
            break;
        case 2:
            ary_sedTitle = [[NSArray alloc] initWithObjects:
                            NSLocalizedString(@"A6 BT", nil),
                            NSLocalizedString(@"NC150 BT", nil),
                            NSLocalizedString(@"BFS800", nil),nil];
            ary_webURL = [[NSArray alloc] initWithObjects:
                          @"https://www.microlife.com/consumer-products/blood-pressure/upper-arm-automatic/bp-a6-bt",
                          @"",
                          @"",nil];
            break;
        default:
            break;
    }
}


-(void)initWithObject {
    
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:NSLocalizedString(@"Information", nil) forState:UIControlStateNormal];
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
    [self.view addSubview:about_tableView];
    
}

#pragma mark - Btn Actions  *****************
-(void)connectWeb:(NSString *)URL {
    
    if (![URL isEqualToString:@""]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            if (webVC != nil) {
                
                webVC = nil;
            }
            webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:URL]];
            webVC.delegate = self;
            [self presentViewController:webVC animated:YES completion:nil];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
            vc.URL = URL;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}

-(void)goback3Click{
    if (showTwoData) {
        showTwoData = NO;
        [self initParameter];
        [titleBtn setTitle:NSLocalizedString(@"Information", nil) forState:UIControlStateNormal];
        [about_tableView reloadData];
    }else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - tableView DataSource & Delegate  *************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (showTwoData) {
        return ary_sedTitle.count;
    }else {
        return ary_title.count;
    }
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
    if (showTwoData) {
        cell.textLabel.text = ary_sedTitle[indexPath.row];
    }
    else {
        cell.textLabel.text = ary_title[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (showTwoData) {
        [self connectWeb:ary_webURL[indexPath.row]];
    }
    else {
        showTwoData = YES;
        [titleBtn setTitle:ary_title[indexPath.row] forState:UIControlStateNormal];
        [self initSedParameter:indexPath.row];
        [about_tableView reloadData];
    }
}
@end
