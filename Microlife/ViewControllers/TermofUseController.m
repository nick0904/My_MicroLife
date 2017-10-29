//
//  TermofUseController.m
//  Microlife
//
//  Created by Ideabus on 2016/9/14.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "TermofUseController.h"

@interface TermofUseController ()

@end

@implementation TermofUseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self agreebtninuseV];
    
    [self nav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//條款的內容
-(void)conentV{
    
    UIScrollView *useconentSV;
    useconentSV.frame = self.view.bounds;
    useconentSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.0, self.view.frame.size.width, self.view.frame.size.height)];
    useconentSV.backgroundColor = [UIColor whiteColor];
    useconentSV.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.0);
    useconentSV.pagingEnabled = true;
    useconentSV.delegate = self;
    useconentSV.showsVerticalScrollIndicator = false;
    
    [self.view addSubview:useconentSV];
    
    
    
    
}


//同意按鈕
-(void)agreebtninuseV{
    
    UIView *agreeV = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.83, self.view.frame.size.width, self.view.frame.size.height*0.17)];
    
    agreeV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:agreeV];
    
    UILabel *agreeL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.2, self.view.frame.size.height*0.02, self.view.frame.size.width*0.75, self.view.frame.size.height*0.05)];
    agreeL.textColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
    
    agreeL.font = [UIFont systemFontOfSize:17];
    agreeL.textAlignment = NSTextAlignmentLeft;
    //自動換行設置
    //    agreeL.lineBreakMode = NSLineBreakByCharWrapping;
    //    agreeL.numberOfLines = 0;
    //改變字母的間距自適應label的寬度
    agreeL.adjustsFontSizeToFitWidth = NO;
    
    agreeL.text = @"我已閱讀，並同意條款內容";
    
    [agreeV addSubview:agreeL];
    
    agree1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    agree1Btn.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.02, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    
    agree1Btn.backgroundColor = [UIColor clearColor];
    [agree1Btn setBackgroundImage:[UIImage imageNamed:@"all_frame"] forState:UIControlStateNormal];
   
    [agree1Btn setSelected:NO];//設置按鈕的狀態是否為選中(可在此根據具體情況來設置按鈕的初始狀態)
    
    [agree1Btn addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [agreeV addSubview:agree1Btn];
    
    
    
    //註冊
    acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame = CGRectMake(self.view.frame.size.width*0.05 , self.view.frame.size.height*0.09, self.view.frame.size.width*0.9, self.view.frame.size.height*0.07);
    
    [acceptBtn setTitle:@"接受並繼續" forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.9] forState:UIControlStateNormal];
    acceptBtn.userInteractionEnabled = NO;
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    
    acceptBtn.backgroundColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
    
    [acceptBtn addTarget:self action:@selector(backregisterClick) forControlEvents:UIControlEventTouchUpInside];
    
    [agreeV addSubview:acceptBtn];
    
    
    
}

-(void)agreeClick{
    agree1Btn.selected = !agree1Btn.selected;
    //每次點擊都會改變按鈕的狀態
    
    if (agree1Btn.selected) {
        //在此實現打勾時的方法
        [agree1Btn setImage:[UIImage imageNamed:@"all_frame_tick"] forState:UIControlStateSelected];
        acceptBtn.userInteractionEnabled = YES;
        
        acceptBtn.backgroundColor = [UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1.0];
        
        
    }else{
        //在此實現不打勾時的方法
        [agree1Btn setImage:[UIImage imageNamed:@"all_frame"] forState:UIControlStateNormal];
        acceptBtn.backgroundColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
        
        acceptBtn.userInteractionEnabled = NO;
    }
    
    
}




-(void)nav{
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 ,0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:1 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    [titleBtn setTitle:@"Microlife服務使用條款" forState:UIControlStateNormal];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.02, 0, 0, 0)];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[titleBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.userInteractionEnabled = NO;
    [self.view addSubview:titleBtn];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_back_g"] forState:UIControlStateNormal ];
    navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [navbackBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navbackBtn];
    
    
    
}

-(void)gobackClick{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)backregisterClick{
    
    UIViewController *RegisterVC = [[UIViewController alloc ]init];
    RegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    RegisterVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:RegisterVC animated:true completion:nil];
    
}

@end
