//
//  AboutViewController.m
//  MicroLifeApp
//
//  Created by Ideabus on 2016/8/11.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "AboutViewController.h"
#import <SafariServices/SafariServices.h>
#import "AppFeatureViewController.h"

@interface AboutViewController () <UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate> {
    
    UITableView *about_tableView;
    
    NSArray *ary_title;
    NSArray *ary_webURL;
    
    SFSafariViewController *webVC;
    
}

@end

@implementation AboutViewController

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
                 NSLocalizedString(@"Microlife Website", nil),
                 NSLocalizedString(@"Terms of Service", nil),
                 NSLocalizedString(@"Privacy Policy", nil),
                 NSLocalizedString(@"APP Feature Introduction", nil),
                 NSLocalizedString(@"Device Instructions", nil),
                 NSLocalizedString(@"Copyright", nil),
                 NSLocalizedString(@"Version", nil),nil];
    
    ary_webURL = [[NSArray alloc] initWithObjects:
                  @"http://www.microlife.com",
                  @"http://www.microlife.com/terms-of-use",
                  @"http://www.microlife.com/privacy-policy",
                  @"",
                  @"",
                  @"",
                  @"",nil];
    
}


-(void)initWithObject {
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:NSLocalizedString(@"About", nil) forState:UIControlStateNormal];
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
    about_tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleBtn.frame), CGRectGetMaxY(titleBtn.frame)+5, self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(titleBtn.frame))];
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
    
    NSString *cell_id = @"about_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
   
    if (indexPath.row == 5 || indexPath.row == 6) {
     
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        
        switch (indexPath.row) {
            case 5:
                cell.detailTextLabel.text = NSLocalizedString(@"Microlife Corporation", nil);
                break;
            case 6:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                break;
            default:
                break;
        }
        
    }
    else {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = ary_title[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        NSLog(@"Device Instructions");
        DeviceInstructionsViewController *deviceInstructionsView = [DeviceInstructionsViewController new];
        [self presentViewController:deviceInstructionsView animated:YES completion:nil];
    }
    else if (indexPath.row == 3){
     
        AppFeatureViewController *appFeatureVC = [[AppFeatureViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:appFeatureVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        [self connectWeb:ary_webURL[indexPath.row]];
    }
}





@end
