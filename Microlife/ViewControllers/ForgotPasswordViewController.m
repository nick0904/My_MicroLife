//
//  ForgotPasswordViewController.m
//  facebooklogin
//
//  Created by Ideabus on 2016/8/11.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ViewController.h"
#import "RegisterViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize sendBtn;
@synthesize femailTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self forgotPasswordVC];
    
    [self nav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)forgotPasswordVC{
    float textH = self.view.frame.size.height/11;
    float emailY = self.view.frame.size.height*0.22;
    UIView *forgotpasswordV = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height)];
    forgotpasswordV.backgroundColor = TABLE_BACKGROUND;
    // [UIColor lightGrayColor];
    [self.view addSubview:forgotpasswordV];
    
    
    UILabel *attentionL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.12, self.view.frame.size.width*0.9, textH)];
    attentionL.textColor = [UIColor blackColor];
    
    attentionL.font = [UIFont systemFontOfSize:17];
    attentionL.textAlignment = NSTextAlignmentLeft;
    //自動換行設置
    //    agreeL.lineBreakMode = NSLineBreakByCharWrapping;
    //    agreeL.numberOfLines = 0;
    //改變字母的間距自適應label的寬度
    attentionL.adjustsFontSizeToFitWidth = NO;
    
    attentionL.text = @"Please enter the email address,\nthen reset your password and login again.";
    attentionL.numberOfLines = 2 ; //[agreeL.text length];
    [self.view addSubview:attentionL];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, emailY, self.view.frame.size.width, 2)];
    line1.backgroundColor = [UIColor lightGrayColor];
    line1.alpha = 0.4;
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH, self.view.frame.size.width, 2)];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.4;
    [self.view addSubview:line2];
    
    
    UIView *emailV = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+1 , self.view.frame.size.width, textH)];
    emailV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emailV];
    
    UIImageView *emailImgV = [[UIImageView alloc] initWithFrame:CGRectMake(textH*0.2, emailY+textH*0.25, textH*0.5, textH*0.5)];
    UIImage *emailImg= [UIImage imageNamed:@"all_icon_a_email"];
    emailImgV.image = emailImg;
    
    emailImgV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview :emailImgV];
    
    
    // UITextField初始化
    femailTextField = [[UITextField alloc] initWithFrame:CGRectMake(textH, emailY+1, self.view.frame.size.width, textH)];
    // 設定預設文字內容
    femailTextField.placeholder = @"E-mail";
    //emailTextField.text = @"";
    NSString * str = femailTextField.text;
    // 設定文字顏色
    femailTextField.textColor = [UIColor blackColor];
    // Delegate
    femailTextField.delegate = self;
    // 設定輸入框背景顏色
    femailTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    femailTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    femailTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    femailTextField.font = [UIFont systemFontOfSize:26];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    //设置编辑框中删除按钮的出现模式
    femailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [femailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    femailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    femailTextField.delegate = self;
    [self.view addSubview:femailTextField];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.4, self.view.frame.size.width, self.view.frame.size.height/11);
    sendBtn.backgroundColor = [UIColor colorWithRed:165.0f/255.0f green:165.0f/255.0f blue:165.0f/255.0f alpha:1.0];
    
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.9] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:26];
    sendBtn.userInteractionEnabled = NO;
    
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendBtn];
    
    
}
-(void)sendBtnClick{
    
    [self validateEmail:femailTextField.text];
    
    
}

-(void)sendBtnEnable{
    
    sendBtn.backgroundColor = [UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1.0];
    sendBtn.userInteractionEnabled = YES;
    NSLog(@"send sucess");
    
}

-(void)sendBtnDisable{
    
    sendBtn.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    sendBtn.userInteractionEnabled = NO;
    
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
    
    
    
    if ( femailTextField.text.length > 0 ) {
        [self sendBtnEnable];
        
    }else{
        [self sendBtnDisable];
    }
}
// 按下Return後會反應的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    [textField resignFirstResponder];
    NSLog(@"按下Return");
    
    
    if ( femailTextField.text.length > 0 ) {
        [self sendBtnEnable];
        
    }else{
        [self sendBtnDisable];
    }
    
    
    return false;
}


-(void)errorEmailAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Error Email! Please enter again." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet *tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet *tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy] ;
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /*
         *使用compare option 来设定比较规则，如
         *NSCaseInsensitiveSearch是不区分大小写
         *NSLiteralSearch 进行完全比较,区分大小写
         *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
         */
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                
                
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                
                
                return NO;
            
        }
        NSLog(@"email ok");
        return YES;
    }
    else {
        [self errorEmailAlert];
        
        return NO;
        
    }
}

-(void)nav{
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 ,0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:@"Forgot password" forState:UIControlStateNormal];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.02, 0, 0, 0)];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    titleBtn.userInteractionEnabled = NO;
    
    [self.view addSubview:titleBtn];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal ];
    navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [navbackBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navbackBtn];
    
    
    
}

-(void)gobackClick{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
