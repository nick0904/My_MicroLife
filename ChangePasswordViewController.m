//
//  ChangePasswordViewController.m
//  Setting
//
//  Created by Ideabus on 2016/8/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
@synthesize Password_cTextField;
@synthesize NewPasswordTextField;
@synthesize ComfirmNewPasswordTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changepasswordV];
    
    
    
    [self changepasswordnav];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)changepasswordnav{
    
    UIView *pnavview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)];
    pnavview.backgroundColor = [UIColor colorWithRed:0 green:61.0f/255.0f blue:165.0f/255.0f alpha:1.0];
    [self.view addSubview:pnavview];
    
    
    CGRect pnavFrame = CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height*0.1);
    UILabel *pnavLabel = [[UILabel alloc] initWithFrame:pnavFrame];
    [pnavLabel setTextColor:[UIColor whiteColor ]];
    pnavLabel.backgroundColor = [UIColor clearColor];
    pnavLabel.text = @"Change Password";
    pnavLabel.font = [UIFont systemFontOfSize:22];
    pnavLabel.alpha = 1.0;
    pnavLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:pnavLabel];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal ];
        navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    [navbackBtn addTarget:self action:@selector(gobackProfile) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navbackBtn];
    
    UIButton *navsaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navsaveBtn.frame = CGRectMake(self.view.frame.size.width*0.78, self.view.frame.size.height*0.02, self.view.frame.size.width/5, self.view.frame.size.height*0.07);
    [navsaveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [navsaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navsaveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    navsaveBtn.backgroundColor = [UIColor clearColor];
    navsaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //navbackBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [navsaveBtn addTarget:self action:@selector(gobackProfile) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navsaveBtn];
    
    
    
}

-(void)gobackProfile{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)changepasswordV{
    
    float changeH = 66;
    
    UIView *changebview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    changebview.backgroundColor = TABLE_BACKGROUND;
    [self.view addSubview:changebview];
    
    UIView *changeview = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.frame.size.height*0.09-1, self.view.frame.size.width+2, changeH*3+3)];
    changeview.backgroundColor = [UIColor whiteColor];
    changeview.layer.borderColor = LAYER_BORDERCOLOR;
    changeview.layer.borderWidth = 1;
    [self.view addSubview:changeview];
    
    // NSArray *ary_line = ["1","2","3","4"];
    
    for (int i=1; i<3; i++) {
        
        UIView *cline = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.09+changeH*i, self.view.frame.size.width*0.95, 1)];
        
        cline.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:215.0f/255.0f blue:217.0f/255.0f alpha:1.0];
        [self.view addSubview:cline];
    }
    
    
    
    // UITextField初始化
    Password_cTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05 , self.view.frame.size.height*0.09, self.view.frame.size.width, changeH)];
    // 設定預設文字內容
    Password_cTextField.placeholder = @"Password";
    //emailTextField.text = @"";
    NSString * str1 = Password_cTextField.text;
    Password_cTextField.secureTextEntry = YES;
    // 設定文字顏色
    Password_cTextField.textColor = [UIColor blackColor];
    // Delegate
    Password_cTextField.delegate = self;
    // 設定輸入框背景顏色
    Password_cTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    Password_cTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    Password_cTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    Password_cTextField.font = [UIFont systemFontOfSize:17];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    //设置编辑框中删除按钮的出现模式
    Password_cTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [Password_cTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    Password_cTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // UITextField初始化
    NewPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05 , self.view.frame.size.height*0.09+changeH+1, self.view.frame.size.width, changeH-1)];
    // 設定預設文字內容
    NewPasswordTextField.placeholder = @"NewPassword";
    //emailTextField.text = @"";
    NSString * str2 = Password_cTextField.text;
    NewPasswordTextField.secureTextEntry = YES;
    // 設定文字顏色
    NewPasswordTextField.textColor = [UIColor blackColor];
    // Delegate
    NewPasswordTextField.delegate = self;
    // 設定輸入框背景顏色
    NewPasswordTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    NewPasswordTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    NewPasswordTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    NewPasswordTextField.font = [UIFont systemFontOfSize:17];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    //设置编辑框中删除按钮的出现模式
    NewPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [NewPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    NewPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    
    // UITextField初始化
    ComfirmNewPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05 , self.view.frame.size.height*0.09+changeH*2+1, self.view.frame.size.width, changeH)];
    // 設定預設文字內容
    ComfirmNewPasswordTextField.placeholder = @"Confirm New Password";
    //emailTextField.text = @"";
    NSString * str3 = ComfirmNewPasswordTextField.text;
    ComfirmNewPasswordTextField.secureTextEntry = YES;
    // 設定文字顏色
    ComfirmNewPasswordTextField.textColor = [UIColor blackColor];
    // Delegate
    ComfirmNewPasswordTextField.delegate = self;
    // 設定輸入框背景顏色
    ComfirmNewPasswordTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    ComfirmNewPasswordTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    ComfirmNewPasswordTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    ComfirmNewPasswordTextField.font = [UIFont systemFontOfSize:17];
    //设置编辑框中删除按钮的出现模式
    ComfirmNewPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //設置鍵盤格式
    [ComfirmNewPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    //設置首字不大寫
    ComfirmNewPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // 判断textField是否处于编辑模式
    //    BOOL ret1 = passwordTextField.isEditing;
    //    passwordTextField.clearsOnBeginEditing = YES;
    
    //    BOOL ret2 = confirmPasswordTextField.isEditing;
    //    confirmPasswordTextField.clearsOnBeginEditing = YES;
    // 將TextField加入View
 
    [self.view addSubview:ComfirmNewPasswordTextField];
    [self.view addSubview:NewPasswordTextField];
    [self.view addSubview:Password_cTextField];
    
    
    NewPasswordTextField.delegate = self;
    Password_cTextField.delegate = self;
    ComfirmNewPasswordTextField.delegate = self;
    
    [NewPasswordTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [Password_cTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [ComfirmNewPasswordTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //    [UITextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];

    
}

//限制輸入字數
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (Password_cTextField == textField)//这个 if 判断是在多个输入框的时候,只限制一个输入框的时候用的,如果全部限制,则不加 if 判断即可,这里是只判断输入用户名的输入框
    {
        if ([aString length] > 12) {
            textField.text = [aString substringToIndex:12];
            
            return NO;
        }
    }
    
    if (NewPasswordTextField == textField) {
        if ([aString length] >12 ) {
            textField.text = [aString substringToIndex:12];
            return NO;
        }
    }

    
    if (ComfirmNewPasswordTextField == textField) {
        if ([aString length] >12 ) {
            textField.text = [aString substringToIndex:12];
            return NO;
        }
    }
    
    return YES;
}


// 設定delegate 為self後，可以自行增加delegate protocol
// 開始進入編輯狀態
- (void) textFieldDidBeginEditing:(UITextField*)textField {
    NSLog(@"textFieldDidBeginEditing:%@",textField.text);
}

// 可能進入結束編輯狀態
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldEndEditing:%@",textField.text);
    return true;
}

// 結束編輯狀態(意指完成輸入或離開焦點)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing:%@",textField.text);
    
    NSString *password =  NewPasswordTextField.text;
    NSString *confirmpassword = ComfirmNewPasswordTextField.text;
    
    if ( NewPasswordTextField.text.length > 0 && ComfirmNewPasswordTextField.text.length >0) {
        if (password != confirmpassword) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password is not the same." preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:resetAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            NSLog(@"密碼不同");
        }
    }
    
    
    
    
    
    
}

// 按下Return後會反應的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    [textField resignFirstResponder];
    NSLog(@"按下Return");
    
    
    
    return false;
}

-(void)textFieldChanged :(UITextField *) textField{
    
}



-(void)textFieldDone:(UITextField*)textField
{
    [textField resignFirstResponder];
}








@end
