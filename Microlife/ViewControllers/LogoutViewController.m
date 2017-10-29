//
//  LogoutViewController.m
//  MicroLifeApp
//
//  Created by Ideabus on 2016/8/11.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "LogoutViewController.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self goback4Btn];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback4Btn{
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:@"Logout" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(goback4Click) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.01, 0, -self.view.frame.size.height*0.01, 0)];
    [self.view addSubview:titleBtn];
    
    UIButton *gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    
    
    [gobackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [gobackBtn addTarget:self action:@selector(goback4Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:gobackBtn];
    
}

-(void)goback4Click{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
