//
//  ViewController.m
//  facebooklogin
//
//  Created by Ideabus on 2016/8/4.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <AccountKit/AccountKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface ViewController () <GIDSignInUIDelegate> {
    
    NSString *userEmail;//記錄 user e-mail
}

@end

@implementation ViewController

@synthesize  passwordTextField;
@synthesize  connectFacebookBtn;
@synthesize  emailTextField;
@synthesize  loginBtn;
@synthesize  loginGooglePlusBtn;


#pragma mark - Normal Functions ****************************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    NSLog(@"[GIDSignIn sharedInstance].clientID = %@",[GIDSignIn sharedInstance].clientID);
    
    [self loginVC];
    [self nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loginVC {
    
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*1.0)];
    [loginView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:242/255.0 blue:245/255.0 alpha:0.95]];
    [self.navigationController.view addSubview:loginView];
    
    
    
    float btnwidth = self.view.frame.size.width*0.41;
    float btnheight = btnwidth*100/298 ;
    
    //臉書
    connectFacebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connectFacebookBtn.frame = CGRectMake(self.view.frame.size.width*0.08 , self.view.frame.size.height/7, btnwidth, btnheight);
    connectFacebookBtn.backgroundColor = [UIColor clearColor];
    
    [connectFacebookBtn setImage:[UIImage imageNamed:@"all_btn_a_fb"] forState:UIControlStateNormal];
    [connectFacebookBtn addTarget:self action:@selector(connectFacebookClick) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:connectFacebookBtn];
    
    
    //google
    loginGooglePlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginGooglePlusBtn.frame = CGRectMake(self.view.frame.size.width*0.92-btnwidth , self.view.frame.size.height/7, btnwidth, btnheight);
    loginGooglePlusBtn.backgroundColor = [UIColor clearColor];
    
    [loginGooglePlusBtn setImage:[UIImage imageNamed:@"all_btn_a_gp"] forState:UIControlStateNormal];
    [loginGooglePlusBtn addTarget:self action:@selector(loginGooglePlusClick) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:loginGooglePlusBtn];
    
    //分隔線
    UIView *loginline1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.28, self.view.frame.size.height*0.25, self.view.frame.size.width*0.17, 2.6)];
    [loginline1 setBackgroundColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0]];
    
    [loginView addSubview:loginline1];
    
    UIView *loginline2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.55, self.view.frame.size.height*0.25, self.view.frame.size.width*0.17, 2.6)];
    [loginline2 setBackgroundColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0]];
    
    [loginView addSubview:loginline2];
    
    
    //or
    UILabel *orl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.45, self.view.frame.size.height*0.22, self.view.frame.size.width*0.1, self.view.frame.size.width*0.1)];
    orl.textColor = [UIColor blackColor];
    orl.alpha = 0.9;
    orl.font = [UIFont systemFontOfSize:17];
    orl.textAlignment = NSTextAlignmentCenter;
    orl.text = @"Or";
    [loginView addSubview:orl];
    
    
    //loginBtn
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.46, self.view.frame.size.width, self.view.frame.size.height*0.084);
    loginBtn.backgroundColor = BUTTONCOLOR_GRAY;
    [loginBtn setTitle:@"Log in" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    loginBtn.userInteractionEnabled = NO;
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginBtn];
    
    
    //到註冊頁面
    UIButton *goRegBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goRegBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.555, self.view.frame.size.width, self.view.frame.size.height*0.084);
    goRegBtn.backgroundColor = STANDER_COLOR;
    [goRegBtn setTitle:@"Register" forState:UIControlStateNormal];
    [goRegBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goRegBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    goRegBtn.userInteractionEnabled = YES;
    [goRegBtn addTarget:self action:@selector(goRegBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:goRegBtn];
    

    
    //忘記密碼
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.63, self.view.frame.size.width, btnheight);
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:forgetBtn];
    
    
    
    float emailY = self.view.frame.size.height*0.3;
    float textH = self.view.frame.size.height/13;
    
    UIView *emailview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY, self.view.frame.size.width*0.2, textH)];
    emailview.backgroundColor = [UIColor whiteColor];
    [loginView addSubview:emailview];
    
    UIImageView *emailImgV = [[UIImageView alloc] initWithFrame:CGRectMake(textH*0.2, emailY+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *emailImg= [UIImage imageNamed:@"all_icon_a_email"];
    emailImgV.image = emailImg;
    
    emailImgV.contentMode = UIViewContentModeScaleToFill;
    [loginView addSubview :emailImgV];
    
    UIView *passwordview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH+2.5 , self.view.frame.size.width*0.2, textH)];
    passwordview.backgroundColor = [UIColor whiteColor];
    [loginView addSubview:passwordview];
    
    UIImageView *passwordImgV = [[UIImageView alloc] initWithFrame:CGRectMake(textH*0.2, emailY+textH+2.5+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *passwordImg= [UIImage imageNamed:@"all_icon_a_password"];
    passwordImgV.image = passwordImg;
    
    passwordImgV.contentMode = UIViewContentModeScaleToFill;
    [loginView addSubview :passwordImgV];
    
    
    //emailTextField init
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.2 , emailY, self.view.frame.size.width, self.view.frame.size.height/13)];
    emailTextField.placeholder = @"E-mail";
    emailTextField.textColor = [UIColor blackColor];
    emailTextField.backgroundColor = [UIColor whiteColor];
    emailTextField.borderStyle =  UITextBorderStyleNone;
    emailTextField.textAlignment = NSTextAlignmentJustified;
    emailTextField.font = [UIFont systemFontOfSize:22];
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTextField.delegate = self;
    [emailTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [loginView addSubview:emailTextField];
    
    
    
    //passwordTextField init
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.2 , emailY+textH+2.5, self.view.frame.size.width, self.view.frame.size.height/13)];
    passwordTextField.placeholder = @"Password";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.borderStyle =  UITextBorderStyleNone;
    passwordTextField.textAlignment = NSTextAlignmentJustified;
    passwordTextField.font = [UIFont systemFontOfSize:22];
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.delegate = self;
    //[UITextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [loginView addSubview:passwordTextField];
    
}


-(void)connectFacebookClick{
    
    NSLog(@"fb");
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    [self connectFacebook];
    
}
-(void)loginGooglePlusClick{
    
    NSLog(@"google");
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleLogin" object:nil];
    
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
    
    
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    userEmail = user.profile.email;
    [self saveUserEmail];
    
    
    NSLog(@"google -- userId = %@",userId);
    NSLog(@"google -- idToken = %@",idToken);
    NSLog(@"google -- fullName = %@",fullName);
    NSLog(@"google -- givenName = %@",givenName);
    NSLog(@"google -- familyName = %@",familyName);
    NSLog(@"google -- email = %@",email);
    
    [LocalData sharedInstance].accountID = [userId intValue];
    
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText":
                                     [NSString stringWithFormat:@"Signed in user: %@",
                                      fullName]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    // [END_EXCLUDE]
    
    
    //[cloudClass postDataSync:sendParam APIName:kAPI_commlogin EventId:CloudAPIEvent_commlogin];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


-(void)loginBtnAction{
    
    [self validateEmail:emailTextField.text];
    
    if(passwordTextField.text.length < 6 || passwordTextField.text.length > 12) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Error password! Please enter between 6-12 numbers or letters." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        
        NSLog(@"password ok");
    }


}

-(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy] ;
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
        NSLog(@"sucess");
        return YES;
    }
    else {
        [self errorEmailAlert:0];
        NSLog(@"email格式不正確");
        return NO;
        
    }
}






-(void)forgetBtnClick{
    UIViewController *ForgotPasswordVC = [[UIViewController alloc ]init];
    ForgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    ForgotPasswordVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:ForgotPasswordVC animated:true completion:nil];
    
    NSLog(@"forgetBtn");
}


#pragma mark - TextField Delegate *****************************
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (passwordTextField == textField)//这个 if 判断是在多个输入框的时候,只限制一个输入框的时候用的,如果全部限制,则不加 if 判断即可,这里是只判断输入用户名的输入框
    {
        if ([aString length] > 12) {
            textField.text = [aString substringToIndex:12];
            
            
            return NO;
        }
    }
    return YES;
}


-(void)textFieldChanged :(UITextField *) textField{
    
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
    
    /**
    if (emailTextField.text.length != 0 && passwordTextField.text.length != 0) {
        
        loginBtn.backgroundColor = [UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1.0];
        
        loginBtn.userInteractionEnabled = YES;
        
    }
     */
    
    [self checkAccountAndPasswordIsEmpty];

}

//利用此方式讓按下Return後會Toogle 鍵盤讓它消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    NSLog(@"按下Return");
    return false;
}



-(void)textFieldDone:(UITextField*)textField {
    
    [self checkAccountAndPasswordIsEmpty];
    
    [textField resignFirstResponder];
}



-(void)nav{
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 ,0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:@"Log in" forState:UIControlStateNormal];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.02, 0, 0, 0)];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[titleBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.userInteractionEnabled = NO;
    [self.navigationController.view addSubview:titleBtn];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal ];
    navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [navbackBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationController.view addSubview:navbackBtn];
    
    
    
}

-(void)gobackClick{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)goRegBtnClicked{
    
    UIViewController *RegisterVC = [[UIViewController alloc ]init];
    RegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    RegisterVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:RegisterVC animated:true completion:nil];
    
    
}


#pragma mark - show Alert  **************************
//Normal
-(void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

//Email Error
-(void)errorEmailAlert:(int)errorType {
    
    NSString *message;
    
    if (errorType == 0) {
        
        message = NSLocalizedString(@"Error Email! Please enter again.", nil);
    }
    else {
        
        message = NSLocalizedString(@"Error password! Please enter between 6-12 numbers or letters.", nil);
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel" , nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



#pragma mark - save User E-mail *****************************
-(void)saveUserEmail {
    
    NSString *filePath = USER_EMAIL_FILEPATH;
    
    if (userEmail != nil) {
        
        [userEmail writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}


#pragma mark - checkAccountAndPasswordIsEmpty *************************
-(void)checkAccountAndPasswordIsEmpty {
    
    BOOL isEmpty = YES;
    
    if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        
        isEmpty = YES;
    }
    else {
        
        isEmpty = NO;
    }
    
    
    //如果欄位是空值
    if (isEmpty) {
        
        loginBtn.userInteractionEnabled = NO;
        loginBtn.backgroundColor = BUTTONCOLOR_GRAY;
    }
    else {
        
        loginBtn.userInteractionEnabled = YES;
        loginBtn.backgroundColor = STANDER_COLOR;
    }
    
    
}


@end
