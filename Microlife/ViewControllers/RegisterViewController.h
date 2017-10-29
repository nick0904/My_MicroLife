//
//  RegisterViewController.h
//  facebooklogin
//
//  Created by Ideabus on 2016/8/9.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookLoginViewController.h"
#import "ViewController.h"

@interface RegisterViewController : ViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    UITextField  *confirmPasswordTextField;
    UITextField  *birthdayTF;
    UITextField  *countryTF;
    UIScrollView *RegisterSV;
    
    UIButton *agreeBtn;
    UIButton *registerBtn;
    
    UIDatePicker *birthdayPicker;
    NSLocale *datelocale;
    CGRect dateframe;
    UIToolbar *birtoolBar ;
    
    UITableView *countryTV;
    UIButton *countryOkBtn;
    UILabel *countryLabel;
    UIButton *countryView;
    NSString *countryStr;
    
    
}

-(BOOL)validateEmail:(NSString*)email;
-(void)errorEmailAlert;


@property (nonatomic,retain)  UITextField  *confirmPasswordTextField;
@property (nonatomic,retain)  UITextField  *birthdayTF;
@property (nonatomic,retain)  UITextField  *countryTF;
@property (nonatomic,retain)  UIScrollView *RegisterSV;

@property (nonatomic,retain)  UIButton  *agreeBtn;
@property (nonatomic,retain)  UIButton  *registerBtn;
@property (nonatomic,retain)  UITableView *countryTV;
@property (nonatomic,strong)  NSIndexPath *lastPath;

@end
