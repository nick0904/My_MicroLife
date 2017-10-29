//
//  AppFIDetailViewController.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/7/22.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "AppFIDetailViewController.h"

@interface AppFIDetailViewController ()

@end

@implementation AppFIDetailViewController {
    
    UIScrollView *m_scrollView;
    UIImageView *m_imgView;
    UILabel *m_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self  initWithNavigationBar];
    [self initWithUIObject];
}


-(void)viewWillAppear:(BOOL)animated{
   
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init  **********
-(void)initWithNavigationBar{
    
    self.navigationItem.title = NSLocalizedString(self.navTitleStr, nil);
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

-(void)initWithUIObject{
    
    CGFloat nav_height = self.navigationController.navigationBar.frame.size.height + 5;
    
    //m_scrollView
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, nav_height, self.view.frame.size.width, self.view.frame.size.height - nav_height)];
    [self.view addSubview:m_scrollView];
    
    //m_imgView
    CGFloat img_width = m_scrollView.frame.size.width * 0.6;
    m_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img_width, img_width * 1.4)];
    m_imgView.center = CGPointMake(m_scrollView.frame.size.width/2, m_imgView.frame.size.height/2);
    [m_scrollView addSubview:m_imgView];
    
    //m_label
    m_label = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(m_imgView.frame) + 20, m_scrollView.frame.size.width - 40, 50)];
    m_label.numberOfLines = 0;
    [m_scrollView addSubview:m_label];
}


#pragma mark - refreshData  *******
-(void)refreshData{
    
    //title
    self.navigationItem.title = NSLocalizedString(self.navTitleStr, nil);
    
    //image
    m_imgView.image = [UIImage imageNamed:self.imgStr];
    m_imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    //context
    m_label.text = self.contextStr;
    m_label.numberOfLines = 0;
    [m_label sizeToFit];
    m_label.frame = CGRectMake(40, CGRectGetMaxY(m_imgView.frame), m_scrollView.frame.size.width - 40, m_label.frame.size.height);
    
    //m_scrollView
    m_scrollView.contentSize = CGSizeMake(m_scrollView.frame.size.width, CGRectGetMaxY(m_label.frame)+5 );
}


#pragma mark - btn Function  ********
-(void)backtoPreview{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
