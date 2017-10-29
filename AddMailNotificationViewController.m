//
//  AddMailNotificationViewController.m
//  Setting
//
//  Created by Ideabus on 2016/8/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "AddMailNotificationViewController.h"
#import "MViewController.h"


@interface AddMailNotificationViewController () <APIPostAndResponseDelegate> {
    
    APIPostAndResponse *apiClass;
    
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation AddMailNotificationViewController
@synthesize addEmailTextField;
@synthesize addNameTextField;
@synthesize nameString,emailString;

#pragma mark - Normal Functions  ******************
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initParam];
    [self initWithNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - initialization  ***********************
-(void)initWithNavigationBar {
    
    ///NavigationController title / background
    self.title = NSLocalizedString(@"Add Mail Notification", nil);
    
    //改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    //改變 statusBarStyle(字體變白色)
    //先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
    ///rightBarButton
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    [rightBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    ///leftBarButton
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    [leftBarBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(gobackMailNotification) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    

    
    
    /*
    UIView *pnavview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)];
    pnavview.backgroundColor = [UIColor colorWithRed:0 green:61.0f/255.0f blue:165.0f/255.0f alpha:1.0];
    [self.view addSubview:pnavview];
    
    
    CGRect pnavFrame = CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height*0.1);
    UILabel *pnavLabel = [[UILabel alloc] initWithFrame:pnavFrame];
    [pnavLabel setTextColor:[UIColor whiteColor ]];
    pnavLabel.backgroundColor = [UIColor clearColor];
    pnavLabel.text = @"Add Mail Notification";
    pnavLabel.font = [UIFont systemFontOfSize:22];
    pnavLabel.alpha = 1.0;
    pnavLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:pnavLabel];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_cancel"] forState:UIControlStateNormal ];
    
    navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    [navbackBtn addTarget:self action:@selector(gobackMailNotification) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navbackBtn];
    
    UIButton *navsaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navsaveBtn.frame = CGRectMake(self.view.frame.size.width*0.78, self.view.frame.size.height*0.02, self.view.frame.size.width/5, self.view.frame.size.height*0.07);
    [navsaveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [navsaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navsaveBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    navsaveBtn.backgroundColor = [UIColor clearColor];
    navsaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //navbackBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [navsaveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:navsaveBtn];
     */
}


-(void)initParam {
    
    float addH = self.view.frame.size.height*0.09;
    float addY = 40;
    
    self.view.backgroundColor = TABLE_BACKGROUND;
    
    
    UIView *addview = [[UIView alloc]initWithFrame:CGRectMake(-1, addY, self.view.frame.size.width+2, addH*2+1)];
    addview.backgroundColor = [UIColor whiteColor];
    addview.layer.borderWidth = 1;
    addview.layer.borderColor = [UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1.0].CGColor;
    [self.view addSubview:addview];
    
    UIView *aline = [[UIView alloc]initWithFrame:CGRectMake(0, addY+addH, self.view.frame.size.width, 1)];
    
    aline.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1];
    [self.view addSubview:aline];
    
    //name Title Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, addY+1, self.view.frame.size.width*0.25, addH-1)];
    [nameLabel setTextColor:[UIColor blackColor ]];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"Name";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.alpha = 1.0;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameLabel];
    
    //email Title Label
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, addY+addH+1, self.view.frame.size.width*0.25, addH-1)];
    [emailLabel setTextColor:[UIColor blackColor ]];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"Email";
    emailLabel.font = [UIFont systemFontOfSize:16];
    emailLabel.alpha = 1.0;
    emailLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:emailLabel];
    
    
    // addNameTextField 初始化
    CGFloat textField_Width = self.view.frame.size.width - CGRectGetMaxX(nameLabel.frame);
    //addNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.245 , addY+1, self.view.frame.size.width, addH-1)];
    addNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), addY+1, textField_Width, addH-1)];
    
    // 設定預設文字內容
    addNameTextField.placeholder = @"";
    //emailTextField.text = @"";
    
    addNameTextField.secureTextEntry = NO;
    // 設定文字顏色
    addNameTextField.textColor = [UIColor blackColor];
    // Delegate
    addNameTextField.delegate = self;
    // 設定輸入框背景顏色
    addNameTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    addNameTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    addNameTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    addNameTextField.font = [UIFont systemFontOfSize:16];
    //设置编辑框中删除按钮的出现模式
    addNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    //設置鍵盤格式
    [addNameTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    //設置首字不大寫
    addNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [addNameTextField addTarget:self action:@selector(textFieldEditChanging:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:addNameTextField];
    
    
    
    
    // addEmailTextField 初始化
    addEmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emailLabel.frame) , addY+addH+1, textField_Width, addH-1)];
    // 設定預設文字內容
    addEmailTextField.placeholder = @"";
    //emailTextField.text = @"";
    addEmailTextField.secureTextEntry = NO;
    // 設定文字顏色
    addEmailTextField.textColor = [UIColor blackColor];
    // Delegate
    addEmailTextField.delegate = self;
    // 設定輸入框背景顏色
    addEmailTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    addEmailTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    addEmailTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    addEmailTextField.font = [UIFont systemFontOfSize:16];
    //设置编辑框中删除按钮的出现模式
    addEmailTextField.clearButtonMode = UITextFieldViewModeAlways;
    //設置鍵盤格式
    [addEmailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    //設置首字不大寫
    addEmailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self.view addSubview:addEmailTextField];
    
    
    //API init
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
    
}


/**
//限制輸入字數
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (addNameTextField == textField)//这个 if 判断是在多个输入框的时候,只限制一个输入框的时候用的,如果全部限制,则不加 if 判断即可,这里是只判断输入用户名的输入框
    {
        if ([aString length] > 50) {
            textField.text = [aString substringToIndex:50];
            
            return NO;
        }
    }
    
    
    return YES;
}
*/

#pragma mark - TextField Delegate  ************************
// 可能進入結束編輯狀態
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldEndEditing:%@",textField.text);
    return true;
}

// 結束編輯狀態(意指完成輸入或離開焦點)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing:%@",textField.text);
    
    nameString = addNameTextField.text;
    emailString = addEmailTextField.text;
    
    NSLog(@"did endemailString = %@",addEmailTextField.text);
    
}

// 按下Return後會反應的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    [textField resignFirstResponder];
    NSLog(@"按下Return");
    nameString = addNameTextField.text;
    emailString = addEmailTextField.text;
    
    NSLog(@"should emailString = %@",addEmailTextField.text);
    return false;
}


-(void)textFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
}


//字數上限 (自定義)
-(void)textFieldEditChanging:(UITextField *)textField {
    
    if (textField == addNameTextField) {
        
        NSUInteger textLength = [MViewController getStringLength:textField.text];
        
        if (textLength > 50) {
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 50)];
            
            [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"The string length is limited to 50 characters", nil) buttonTitle:NSLocalizedString(@"OK", nil)];
        }
        
    }
    
    
}



#pragma mark - 自定義 Functions  *************************
//saveAction
-(void)saveAction{
    
    //    RegisterViewController *reVC = [[RegisterViewController alloc] init];
    //    [reVC validateEmail:addEmailTextField.text];
    
    if (addNameTextField.text.length < 1 || addEmailTextField.text.length < 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"The name can not be null! " message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ConfirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:ConfirmAction];
        
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:closeAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }else if (addNameTextField.text.length > 0 && addEmailTextField.text.length > 0){
        
        
        [self validateEmail:addEmailTextField.text];
        
    }
    
    
}


-(void)saveDataToCloudAction {
    
    /**
    //Fix 不存本機
    NSLog(@"emailString = %@",emailString);
    //Save
    NSDictionary *memberDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                addNameTextField.text,@"name",
                                addEmailTextField.text,@"email",nil];
    
    //[[LocalData sharedInstance] saveMemberProfile:memberDict];
    */
    
    
    [self postAddNotificationAPIRequset];
    
}


-(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) && (0 != [email rangeOfString:@"."].length)) {
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy] ;
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /**
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
        
        [self saveDataToCloudAction];
        
        return YES;
    }
    else {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil)  message:NSLocalizedString(@"Error Email! Please enter again.", nil)  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
        
    }
}


//回上一頁
-(void)gobackMailNotification{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [addNameTextField resignFirstResponder];
    [addEmailTextField resignFirstResponder];
}


-(void)postAddNotificationAPIRequset {
    
    [self showIndicatorView];
    
    //post API
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postAddMailNotification:tokenStr name:addNameTextField.text email:addEmailTextField.text];
    
}



#pragma mark - API Delegate  ***********************
-(void)processeAddMailNotification:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    [self stopIndicatorView];
    
    if (jsonError) {
        
        NSLog(@"Add Mail Notification json error: %@",jsonError);
    }
    else {
        
        NSLog(@"Add Mail Notification resopnseData: %@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }

}


#pragma mark - indicator  *********************
-(void)showIndicatorView {
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    indicatorView.backgroundColor = [UIColor lightGrayColor];
    
    indicatorView.center = self.view.center;
    
    indicatorView.alpha = 0.38;
    
    [indicatorView startAnimating];
    
    [self.navigationController.view addSubview:indicatorView];
}

-(void)stopIndicatorView {
    
    if (indicatorView != nil) {
        
        [indicatorView stopAnimating];
        
        [indicatorView removeFromSuperview];
        
        indicatorView = nil;
    }
    
}


@end
