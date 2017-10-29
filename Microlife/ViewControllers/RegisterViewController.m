//
//  RegisterViewController.m
//  facebooklogin
//
//  Created by Ideabus on 2016/8/9.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController (){
    
    NSArray *countryArr;
    
    UITextField *m_emailTextField;
    UITextField *m_passwordTextField;
}

@end

@implementation RegisterViewController

@synthesize confirmPasswordTextField;
@synthesize agreeBtn;
@synthesize registerBtn;
@synthesize countryTF;
@synthesize birthdayTF;
@synthesize RegisterSV;
@synthesize countryTV;
@synthesize lastPath;


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    countryArr =  @[@" Albania",
    @" Antarctica",
    @" Algeria",
    @" American Samoa",
    @" Andorra",
    @" Angola",
    @" Antigua and Barbuda",
    @" Azerbaijan",
    @" Argentina",
    @" Australia",
    @" Austria",
    @" Bahamas",
    @" Bahrain",
    @" Bangladesh",
    @" Armenia",
    @" Barbados",
    @" Belgium",
    @" Bermuda",
    @" Bhutan",
    @" Bolivia",
    @" Bosnia and Herzegovina",
    @" Botswana",
    @" Bouvet Island",
    @" Brazil",
    @" Belize",
    @" British Indian Ocean Territory",
    @" Solomon Islands",
    @" Virgin Islands",
    @" Brunei Darussalam",
    @" Bulgaria",
    @" Myanmar",
    @" Burundi",
    @" Belarus",
    @" Cambodia",
    @" Cameroon",
    @" Canada",
    @" Cabo Verde",
    @" Cayman Islands",
    @" Central African Republic",
    @" Sri Lanka",
    @" Chad",
    @" Chile",
    @" China",
    @" Taiwan",
    @" Christmas Island",
    @" Cocos (Keeling) Islands",
    @" Colombia",
    @" Comoros",
    @" Mayotte",
    @" Republic of Congo",
    @" Democratic Republic of Congo",
    @" Cook Islands",
    @" Costa Rica",
    @" Croatia",
    @" Cuba",
    @" Cyprus",
    @" Czech Republic",
    @" Benin",
    @" Denmark",
    @" Dominica",
    @" Dominican Republic",
    @" Ecuador",
    @" El Salvador",
    @" Equatorial Guinea",
    @" Ethiopia",
    @" Eritrea",
    @" Estonia",
    @" Faroe Islands",
    @" Falkland Islands [Malvinas]",
    @" South Georgia and the South Sandwich Islands",
    @" Fiji",
    @" Finland",
    @" Åland Islands",
    @" France",
    @" French Guiana",
    @" French Polynesia",
    @" French Southern Territories",
    @" Djibouti",
    @" Gabon",
    @" Georgia",
    @" Gambia",
    @" Palestine",
    @" Germany",
    @" Ghana",
    @" Gibraltar",
    @" Kiribati",
    @" Greece",
    @" Greenland",
    @" Grenada",
    @" Guadeloupe",
    @" Guam",
    @" Guatemala",
    @" Guinea",
    @" Guyana",
    @" Haiti",
    @" Heard Island and McDonald Islands",
    @" Holy See",
    @" Honduras",
    @" Hong Kong",
    @" Hungary",
    @" Iceland",
    @" India",
    @" Indonesia",
    @" Iran (Islamic Republic of)",
    @" Iraq",
    @" Ireland",
    @" Israel",
    @" Italy",
    @" Côte d'Ivoire",
    @" Jamaica",
    @" Japan",
    @" Kazakhstan",
    @" Jordan",
    @" Kenya",
    @" Korea (the Democratic People's Republic of)",
    @" Korea (the Republic of)",
    @" Kuwait",
    @" Kyrgyzstan",
    @" Lao People's Democratic Republic",
    @" Lebanon",
    @" Lesotho",
    @" Latvia",
    @" Liberia",
    @" Libya",
    @" Liechtenstein",
    @" Lithuania",
    @" Luxembourg",
    @" Macao",
    @" Madagascar",
    @" Malawi",
    @" Malaysia",
    @" Maldives",
    @" Mali",
    @" Malta",
    @" Martinique",
    @" Mauritania",
    @" Mauritius",
    @" Mexico",
    @" Monaco",
    @" Mongolia",
    @" Moldova (the Republic of)",
    @" Montenegro",
    @" Montserrat",
    @" Morocco",
    @" Mozambique",
    @" Oman",
    @" Namibia",
    @" Nauru",
    @" Nepal",
    @" Netherlands",
    @" Curaço",
    @" Aruba",
    @" Sint Maarten (Dutch part)",
    @" Bonaire (Sint Eustatius and Saba)",
    @" New Caledonia",
    @" Vanuatu",
    @" New Zealand",
    @" Nicaragua",
    @" Niger",
    @" Nigeria",
    @" Niue",
    @" Norfolk Island",
    @" Norway",
    @" Northern Mariana Islands",
    @" United States Minor Outlying Islands",
    @" Micronesia (Federated States of)",
    @" Marshall Islands",
    @" Palau",
    @" Pakistan",
    @" Panama",
    @" Papua New Guinea",
    @" Paraguay",
    @" Peru",
    @" Philippines",
    @" Pitcairn",
    @" Poland",
    @" Portugal",
    @" Guinea-Bissau",
    @" Timor-Leste",
    @" Puerto Rico",
    @" Qatar",
    @" Réunion",
    @" Romania",
    @" Russian Federation",
    @" Rwanda",
    @" Saint Barthélemy",
    @" Saint Helena(Ascension and Tristan da Cunha)",
    @" Saint Kitts and Nevis",
    @" Anguilla",
    @" Saint Lucia",
    @" Saint Martin (French part)",
    @" Saint Pierre and Miquelon",
    @" Saint Vincent and the Grenadines",
    @" San Marino",
    @" Sao Tome and Principe",
    @" Saudi Arabia",
    @" Senegal",
    @" Serbia",
    @" Seychelles",
    @" Sierra Leone",
    @" Singapore",
    @" Slovakia",
    @" Viet Nam",
    @" Slovenia",
    @" Somalia",
    @" South Africa",
    @" Zimbabwe",
    @" Spain",
    @" South Sudan",
    @" Sudan",
    @" Western Sahara",
    @" Suriname",
    @" Svalbard and Jan Mayen",
    @" Swaziland",
    @" Sweden",
    @" Switzerland",
    @" Syrian Arab Republic",
    @" Tajikistan",
    @" Thailand",
    @" Togo",
    @" Tokelau",
    @" Tonga",
    @" Trinidad and Tobago",
    @" United Arab Emirates",
    @" Tunisia",
    @" Turkey",
    @" Turkmenistan",
    @" Turks and Caicos Islands",
    @" Tuvalu",
    @" Uganda",
    @" Ukraine",
    @" Macedonia (the former Yugoslav Republic of)",
    @" Egypt",
    @" United Kingdom of Great Britain and Northern Ireland",
    @" Guernsey",
    @" Jersey",
    @" Isle of Man",
    @" Tanzania(United Republic of)",
    @" United States of America",
    @" Virgin Islands (U.S.)",
    @" Burkina Faso",
    @" Uruguay",
    @" Uzbekistan",
    @" Venezuela (Bolivarian Republic of)",
    @" Wallis and Futuna",
    @" Samoa",
    @" Yemen",
    @" Zambia"];

    
    [self loginVC];
    
    [self nav];
    
    [self countrySelectView];
    
    
}

-(void)loginVC{
    
    
    RegisterSV.frame = self.view.bounds;
    RegisterSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.0, self.view.frame.size.width, self.view.frame.size.height)];
    RegisterSV.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    RegisterSV.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.0);
    RegisterSV.pagingEnabled = true;
    RegisterSV.delegate = self;
    RegisterSV.showsVerticalScrollIndicator = false;
    
    [self.view addSubview:RegisterSV];
    
    
    
    float emailY = self.view.frame.size.height*0.13;
    float textH = self.view.frame.size.height/13;
    
    
    UIView *loginline11 = [[UIView alloc] initWithFrame:CGRectMake(0, emailY-2.5, self.view.frame.size.width, 2.5)];
    [loginline11 setBackgroundColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.26]];
    
    [RegisterSV addSubview:loginline11];
    
    
    UIView *loginline21 = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH*5+10+0, self.view.frame.size.width, 2.5)];
    [loginline21 setBackgroundColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.26]];
    
    [RegisterSV addSubview:loginline21];
    
    
    
    //帳密
    UIView *emailview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY, self.view.frame.size.width*0.22, textH)];
    emailview.backgroundColor = [UIColor whiteColor];
    [RegisterSV addSubview:emailview];
    
    UIImageView *emailImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, emailY+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *emailImg= [UIImage imageNamed:@"all_icon_a_email"];
    emailImgV.image = emailImg;
    //emailImgV.contentMode =
    emailImgV.contentMode = UIViewContentModeScaleToFill;
    [RegisterSV addSubview :emailImgV];
    
    UIView *passwordview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH+2.5 , self.view.frame.size.width*0.22, textH)];
    passwordview.backgroundColor = [UIColor whiteColor];
    [RegisterSV addSubview:passwordview];
    
    UIImageView *passwordImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, emailY+textH+2.5+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *passwordImg= [UIImage imageNamed:@"all_icon_a_password"];
    passwordImgV.image = passwordImg;
    passwordImgV.contentMode =
    passwordImgV.contentMode = UIViewContentModeScaleToFill;
    [RegisterSV addSubview :passwordImgV];
    
    UIView *confirmpwview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH*2+5, self.view.frame.size.width*0.22, textH)];
    confirmpwview.backgroundColor = [UIColor whiteColor];
    [RegisterSV addSubview:confirmpwview];
    
    UIImageView *confirmpwImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, emailY+textH*2+5+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *confirmpwImg= [UIImage imageNamed:@"all_icon_a_password"];
    confirmpwImgV.image = confirmpwImg;
    confirmpwImgV.contentMode =
    confirmpwImgV.contentMode = UIViewContentModeScaleToFill;
    [RegisterSV addSubview :confirmpwImgV];
    
    UIView *birthdayview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH*3+7.5, self.view.frame.size.width*0.22, textH)];
    birthdayview.backgroundColor = [UIColor whiteColor];
    [RegisterSV addSubview:birthdayview];
    
    UIImageView *birthdayImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, emailY+textH*3+7.5+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *birthdayImg= [UIImage imageNamed:@"all_icon_a_bday"];
    birthdayImgV.image = birthdayImg;
    birthdayImgV.contentMode =
    birthdayImgV.contentMode = UIViewContentModeScaleToFill;
    [RegisterSV addSubview :birthdayImgV];
    
    
    UIView *countryview = [[UIView alloc] initWithFrame:CGRectMake(0, emailY+textH*4+10, self.view.frame.size.width*0.22, textH)];
    countryview.backgroundColor = [UIColor whiteColor];
    [RegisterSV addSubview:countryview];
    
    UIImageView *countryImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, emailY+textH*4+10+textH*0.2, textH*0.6, textH*0.6)];
    UIImage *countryImg= [UIImage imageNamed:@"all_icon_a_country"];
    countryImgV.image = countryImg;
    countryImgV.contentMode =
    countryImgV.contentMode = UIViewContentModeScaleToFill;
    [RegisterSV addSubview :countryImgV];
    
    
    
    // m_emailTextField init
    m_emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.22 , emailY, self.view.frame.size.width, self.view.frame.size.height/13)];
    // 設定預設文字內容
    m_emailTextField.placeholder = @"E-mail";
    //emailTextField.text = @"";
    NSString * str = m_emailTextField.text;
    // 設定文字顏色
    m_emailTextField.textColor = [UIColor blackColor];
    // Delegate
    m_emailTextField.delegate = self;
    // 設定輸入框背景顏色
    m_emailTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    m_emailTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    m_emailTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    m_emailTextField.font = [UIFont systemFontOfSize:22];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    //设置编辑框中删除按钮的出现模式
    m_emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_emailTextField setKeyboardType:UIKeyboardTypeEmailAddress] ;
    m_emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    
    
    
    // m_passwordTextField init
    m_passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.22 , emailY+textH+2.5, self.view.frame.size.width, self.view.frame.size.height/13)];
    // 設定預設文字內容
    m_passwordTextField.placeholder = @"Password";
    //emailTextField.text = @"";
    m_passwordTextField.secureTextEntry = YES;
    // 設定文字顏色
    m_passwordTextField.textColor = [UIColor blackColor];
    // Delegate
    m_passwordTextField.delegate = self;
    // 設定輸入框背景顏色
    m_passwordTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    m_passwordTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    m_passwordTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    m_passwordTextField.font = [UIFont systemFontOfSize:22];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    //设置编辑框中删除按钮的出现模式
    m_passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    m_passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // UITextField初始化
    confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.22 , emailY+textH*2+5, self.view.frame.size.width, self.view.frame.size.height/13)];
    // 設定預設文字內容
    confirmPasswordTextField.placeholder = @"Confirm password";
    //emailTextField.text = @"";
    confirmPasswordTextField.secureTextEntry = YES;
    // 設定文字顏色
    confirmPasswordTextField.textColor = [UIColor blackColor];
    // Delegate
    confirmPasswordTextField.delegate = self;
    // 設定輸入框背景顏色
    confirmPasswordTextField.backgroundColor = [UIColor whiteColor];
    //    设置背景图片
    //    textField.background=[UIImage imageNamed:@"test.png"];
    // 框線樣式
    confirmPasswordTextField.borderStyle =  UITextBorderStyleNone;
    //设置文本对齐方式
    confirmPasswordTextField.textAlignment = NSTextAlignmentJustified;
    //设置字体
    confirmPasswordTextField.font = [UIFont systemFontOfSize:22];
    //设置编辑框中删除按钮的出现模式
    confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //設置鍵盤格式
    [confirmPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    //設置首字不大寫
    confirmPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // 判断textField是否处于编辑模式
    //    BOOL ret1 = passwordTextField.isEditing;
    //    passwordTextField.clearsOnBeginEditing = YES;
    
    //    BOOL ret2 = confirmPasswordTextField.isEditing;
    //    confirmPasswordTextField.clearsOnBeginEditing = YES;
    // 將TextField加入View
    [RegisterSV addSubview:m_emailTextField];
    [RegisterSV addSubview:m_passwordTextField];
    [RegisterSV addSubview:confirmPasswordTextField];
    
    
    // 生日
    birthdayTF = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.22 , emailY+textH*3+7.5, self.view.frame.size.width, self.view.frame.size.height/13)];
    
    birthdayTF.placeholder = @"Birthday";
    //emailTextField.text = @"";
    NSString * bristr = birthdayTF.text;
    birthdayTF.secureTextEntry = NO;
    birthdayTF.textColor = [UIColor blackColor];
    birthdayTF.delegate = self;
    birthdayTF.backgroundColor = [UIColor whiteColor];
    //    textField.background=[UIImage imageNamed:@"test.png"];
    birthdayTF.borderStyle =  UITextBorderStyleNone;
    birthdayTF.textAlignment = NSTextAlignmentJustified;
    birthdayTF.font = [UIFont systemFontOfSize:22];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    birthdayTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [birthdayTF setKeyboardType:UIKeyboardTypeASCIICapable];
    birthdayTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    birthdayTF.delegate = self;
    [birthdayTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [RegisterSV addSubview:birthdayTF];
    
    // 國家
    countryTF = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.22 , emailY+textH*4+10, self.view.frame.size.width, self.view.frame.size.height/13)];
    
    countryTF.placeholder = @"Country";
    //emailTextField.text = @"";
    NSString * counstr = countryTF.text;
    countryTF.secureTextEntry = NO;
    countryTF.textColor = [UIColor blackColor];
    countryTF.delegate = self;
    countryTF.backgroundColor = [UIColor whiteColor];
    //    textField.background=[UIImage imageNamed:@"test.png"];
    countryTF.borderStyle =  UITextBorderStyleNone;
    countryTF.textAlignment = NSTextAlignmentJustified;
    countryTF.font = [UIFont systemFontOfSize:22];
    //emailTextField.font = [UIFont fontWithName:@"wawati sc" size:50];
    countryTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [countryTF setKeyboardType:UIKeyboardTypeASCIICapable];
    countryTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    countryTF.delegate = self;
    [countryTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [RegisterSV addSubview:countryTF];
    
    
    
    m_emailTextField.delegate = self;
    m_passwordTextField.delegate = self;
    confirmPasswordTextField.delegate = self;
    
    [m_emailTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [m_passwordTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //    [UITextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    UILabel *agreeL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.2, emailY+textH*5+16.5, self.view.frame.size.width*0.75, textH)];
    agreeL.textColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
    
    agreeL.font = [UIFont systemFontOfSize:13];
    agreeL.textAlignment = NSTextAlignmentLeft;
    //自動換行設置
    //    agreeL.lineBreakMode = NSLineBreakByCharWrapping;
    //    agreeL.numberOfLines = 0;
    //改變字母的間距自適應label的寬度
    agreeL.adjustsFontSizeToFitWidth = NO;
    
    agreeL.text = @"You agree to our Terms and Privacy Policy and to receive notice on event and services.";
    agreeL.numberOfLines = 2 ; //[agreeL.text length];
    agreeL.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotermofuse)];
    
    [agreeL addGestureRecognizer:labelTapGestureRecognizer];
    
    
    [RegisterSV addSubview:agreeL];
    
    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(textH*0.5, emailY+textH*5+16.5+textH*0.2, textH*0.6, textH*0.6);
    
    agreeBtn.backgroundColor = [UIColor clearColor];
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"all_frame"] forState:UIControlStateNormal];
    //    agreeBtn.layer.borderWidth = 2;
    //    agreeBtn.layer.borderColor = [UIColor colorWithRed:200/255 green:200/255 blue:200/255 alpha:0.2].CGColor;
    //    agreeBtn.layer.cornerRadius = 2.0;
    [agreeBtn setSelected:NO];//設置按鈕的狀態是否為選中(可在此根據具體情況來設置按鈕的初始狀態)
    
    [agreeBtn addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [RegisterSV addSubview:agreeBtn];
    
    
    
    //註冊
    registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.91, self.view.frame.size.width, self.view.frame.size.height*0.09);
    
    [registerBtn setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.9] forState:UIControlStateNormal];
    registerBtn.userInteractionEnabled = NO;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    
    registerBtn.backgroundColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
    
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [RegisterSV addSubview:registerBtn];
    
    
    UIButton *selectCountryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectCountryBtn.frame = CGRectMake(self.view.frame.size.width*0 , emailY+textH*4+10, self.view.frame.size.width, self.view.frame.size.height/13);

    selectCountryBtn.backgroundColor = [UIColor clearColor];
    
    [selectCountryBtn addTarget:self action:@selector(countryShow) forControlEvents:UIControlEventTouchUpInside];
    
    [RegisterSV addSubview:selectCountryBtn];
    
    
    NSLog(@"ok");
    
    
}

-(void)countryShow{
    
    countryView.hidden = false;
    
}


//國家選擇列表
-(void)countrySelectView{

    countryView = [UIButton buttonWithType:UIButtonTypeCustom];
    countryView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    countryView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self.view addSubview:countryView];
    countryView.hidden = true;
    
    countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.04, self.view.frame.size.width*0.9, self.view.frame.size.height*0.09)];
    countryLabel.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:255/255 alpha:1.0];
    countryLabel.font = [UIFont systemFontOfSize:22];
    countryLabel.textAlignment = NSTextAlignmentCenter;
    countryLabel.text = @"Select your country.";
    
    countryLabel.backgroundColor = [UIColor whiteColor];
    [countryView addSubview:countryLabel];
    
    
    self.countryTV = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.13, self.view.frame.size.width*0.9, self.view.frame.size.height*0.77)];
    
    self.countryTV.delegate = self;
    self.countryTV.dataSource = self;
    //countryTV.layer.borderWidth = 1;
    //countryTV.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    [countryView addSubview:self.countryTV];
    
    [self.countryTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"countrycell_ID"];
    
    countryOkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    countryOkBtn.frame = CGRectMake(self.view.frame.size.width*0.05 , self.view.frame.size.height*0.9, self.view.frame.size.width*0.9, self.view.frame.size.height*0.06);
    
    [countryOkBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [countryOkBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    countryOkBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    countryOkBtn.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
    
    [countryOkBtn addTarget:self action:@selector(confirmCountry) forControlEvents:UIControlEventTouchUpInside];
    
    [countryView addSubview:countryOkBtn];
    
    
}

//確認國籍
-(void)confirmCountry{
    
    countryView.hidden = true;
    countryTF.text = countryStr;
    
}



-(void)connectFacebookClick{
    [self connectFacebook];
    NSLog(@"fb");
}
-(void)loginGooglePlusClick{
    NSLog(@"google");
}


-(void)connectFacebookAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please agree Terms of Service and Privacy Policy before registration." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
}

-(void)loginGooglePlusAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please agree Terms of Service and Privacy Policy before registration." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
}

-(void)loginBtnClick{
    
    NSLog(@"loginBtn");
}


//註冊點選方法
-(void)registerBtnClick{
    
   
    if (m_emailTextField.text.length > 0) {
      
        [self validateEmail:m_emailTextField.text];
        
    }
    else if(m_passwordTextField.text.length < 6 || m_passwordTextField.text.length > 12) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error password! Please enter between 6-12 numbers or letters." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (!agreeBtn.selected){
        
        [self alertAgree];
    }
    else{
    
        NSLog(@"password ok");
    }
    
    //    //檢查e-mail是否符合這個格式xxx@xxx.xxx xxx@xxx.xxx.xxx
    //    //   NSString * emailToChecked = @"abc@gamil.com";
    //    //使用正規表達式去檢查
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@ [A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //    //emailTextField.text = emailRegex;
    //    NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    //    //下一個if去判斷 如果合法顯示isValid 不合法則顯示isInValid
    //    if([emailCheck evaluateWithObject:emailCheck]
    //
    //       ){
    //        NSLog(@"Email is valid");
    //    }else{
    //        NSLog(@"Email is Invalid");
    //    }
    
    
    
    NSLog(@"registerBtnClick");
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
        
       //<<<<<<<<<email格式正確後才會呼叫雲端確認email還沒被註冊>>>>>>>>
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        return YES;
    }
    else {
        [self errorEmailAlert];
        
               
        NSLog(@"email格式不正確");
        return NO;
        
    }
}


-(void)agreeClick{
    agreeBtn.selected = !agreeBtn.selected;
    //每次點擊都會改變按鈕的狀態
    
    if (agreeBtn.selected) {
        //在此實現打勾時的方法
        [agreeBtn setImage:[UIImage imageNamed:@"all_frame_tick"] forState:UIControlStateSelected];
        
        if (m_emailTextField.text.length != 0 && m_passwordTextField.text.length != 0 && confirmPasswordTextField.text.length !=0) {
            
            
            registerBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.625 alpha:1.0];
            registerBtn.userInteractionEnabled = YES;
            
        }
        
        
    }else{
        //在此實現不打勾時的方法
        [agreeBtn setImage:[UIImage imageNamed:@"all_frame"] forState:UIControlStateNormal];
        registerBtn.backgroundColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
        //registerBtn.userInteractionEnabled = NO;
        
    }
    
    
}

-(void)alertAgree{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please agree Terms of Service and Privacy Policy before registration." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//email已經存在的Alert
-(void)alertemial{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This Email has existed. Please enter new email to register again or  login." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void)errorEmailAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Error Email! Please enter again." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}


//限制輸入字數
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (m_passwordTextField == textField)//这个 if 判断是在多个输入框的时候,只限制一个输入框的时候用的,如果全部限制,则不加 if 判断即可,这里是只判断输入用户名的输入框
    {
        if ([aString length] > 12) {
            textField.text = [aString substringToIndex:12];
            
            return NO;
        }
    }
    
    if (confirmPasswordTextField == textField) {
        if ([aString length] >12 ) {
            textField.text = [aString substringToIndex:12];
            return NO;
        }
    }
    
    return YES;
}

-(void)registerBtnClickDisable{
    
    registerBtn.backgroundColor = [UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4];
    registerBtn.userInteractionEnabled = NO;
}

-(void)registerBtnClickEnable{
    registerBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.625 alpha:1.0];
    registerBtn.userInteractionEnabled = YES;
}

-(void)registerbtnable{
    if (m_emailTextField.text.length != 0 && m_passwordTextField.text.length != 0 && confirmPasswordTextField.text.length !=0) {
        
        
        if ((agreeBtn.selected == YES)){
            [self registerBtnClickEnable];
            
            NSLog(@"111");
        }
        
        else if (agreeBtn.selected == NO){
            [self registerBtnClickDisable];
            NSLog(@"222");
        }
        
    }else{
        [self registerBtnClickDisable];
        NSLog(@"333");
        return;
        
        
    }
    
}

-(void)birthdaypicker{
    
    
    // 建立 UIDatePicker
    birthdayPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.05, self.view.frame.size.width, self.view.frame.size.height*0.35)];
    
    birthdayPicker.backgroundColor = [UIColor whiteColor];
    
    // 時區的問題請再找其他協助 不是本篇重點
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    birthdayPicker.locale = datelocale;
    birthdayPicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    birthdayPicker.datePickerMode = UIDatePickerModeDate;
    // 以下這行是重點 (螢光筆畫兩行) 將 UITextField 的 inputView 設定成 UIDatePicker
    // 則原本會跳出鍵盤的地方 就改成選日期了
    birthdayTF.inputView = birthdayPicker;
    
    //    [birthdayView addSubview:birthdayPicker];
    
    
    
    // 建立 UIToolbar
    birtoolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.6, self.view.frame.size.width , self.view.frame.size.height*0.07)];
    birtoolBar.backgroundColor = [UIColor colorWithRed:168.0f/255.0f green:168.0f/255.0f blue:168.0f/255.0f alpha:1.0];
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    birthdayTF.inputAccessoryView = birtoolBar;
    
    UIButton *birthdayokBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    birthdayokBtn.backgroundColor = [UIColor clearColor];
    birthdayokBtn.frame = CGRectMake(self.view.frame.size.width*0.8 , self.view.frame.size.height*0, self.view.frame.size.width*0.2, self.view.frame.size.height*0.07);
    [birthdayokBtn setTitle:@"Save" forState:UIControlStateNormal];
    
    [birthdayokBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    birthdayokBtn.userInteractionEnabled = YES;
    birthdayokBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [birthdayokBtn addTarget:self action:@selector(okbirPicker) forControlEvents:UIControlEventTouchUpInside];
    
    [birtoolBar addSubview:birthdayokBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width*0 , self.view.frame.size.height*0, self.view.frame.size.width*0.2, self.view.frame.size.height*0.07);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.userInteractionEnabled = YES;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [cancelBtn addTarget:self action:@selector(cancelpicker) forControlEvents:UIControlEventTouchUpInside];
    
    [birtoolBar addSubview:cancelBtn];
    
}


// 按下完成鈕後的 method
-(void)okbirPicker{
    
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
        // 以下幾行是測試用 可以依照自己的需求增減屬性
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        // 將選取後的日期 填入 UITextField
        birthdayTF.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:birthdayPicker.date]];
        
    }
    
    
}

-(void)cancelpicker{
    
    [birthdayPicker removeFromSuperview];
    [birtoolBar removeFromSuperview];
}



-(void)textFieldChanged :(UITextField *) textField{
    
}

// 設定delegate 為self後，可以自行增加delegate protocol
// 開始進入編輯狀態
- (void) textFieldDidBeginEditing:(UITextField*)textField {
    NSLog(@"textFieldDidBeginEditing:%@",textField.text);
    
    //增加監聽，當鍵盤出現或改變時收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加監聽，當鍵盤退出時收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    if (birthdayTF == textField) {
        [self birthdaypicker];
    }
    
    
    
    
    // 建立 UIToolbar
    //    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.07)];
    //    toolBar.backgroundColor = [UIColor clearColor];
    //
    //    if (emailTextField == textField) {
    //        emailTextField.inputAccessoryView = toolBar;
    //         registerBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    //            [toolBar addSubview:registerBtn];
    //
    //    }else if (passwordTextField == textField){
    //        passwordTextField.inputAccessoryView = toolBar;
    //         registerBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    //            [toolBar addSubview:registerBtn];
    //    }else if (confirmPasswordTextField == textField){
    //        confirmPasswordTextField.inputAccessoryView = toolBar;
    //         registerBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    //            [toolBar addSubview:registerBtn];
    //
    //    }else{
    //         registerBtn.frame = CGRectMake(0 , self.view.frame.size.height*0.93, self.view.frame.size.width, self.view.frame.size.height*0.09);
    //        [self.view addSubview:registerBtn];
    //    }
    
    //    birthdayTF.inputAccessoryView = toolBar;
    //    countryTF.inputAccessoryView = toolBar;
    
}

// 可能進入結束編輯狀態
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldEndEditing:%@",textField.text);
    return true;
}

// 結束編輯狀態(意指完成輸入或離開焦點)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing:%@",textField.text);
    
    NSString *password =  m_passwordTextField.text;
    NSString *confirmpassword = confirmPasswordTextField.text;
    
    if ( m_passwordTextField.text.length > 0 && confirmPasswordTextField.text.length >0) {
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
    
    
    
    [self registerbtnable];
    
    
    
}

// 按下Return後會反應的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    [textField resignFirstResponder];
    NSLog(@"按下Return");
    
    [self registerbtnable];
    
    
    
    return false;
}

//當鍵盤出現或改變時調用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //獲取鍵盤的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardH = keyboardRect.size.height;
    
    RegisterSV.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.0+keyboardH);
    
    
    
}

//當键盤退出時調用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    RegisterSV.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.0);
}



-(void)textFieldDone:(UITextField*)textField
{
    [textField resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 代理方法  顯示選中行的單元格信息
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",countryArr[indexPath.row]);
    
    //先把點選的國家儲存在字串裡
    countryStr = countryArr[indexPath.row];
    
    NSInteger newRow = [indexPath row];
    
    NSInteger oldRow = (lastPath !=nil)?[lastPath row]:-1;
    
    if (newRow != oldRow) {
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastPath = indexPath;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
}

#pragma mark - 設置顯示分區數量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 數據源 每個分區對應的函數設置
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return countryArr.count;
}

#pragma mark - 數據源 每個單元格的內容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"countrycell_ID";
    UITableViewCell *CountryCell=[tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    NSInteger oldRow = [lastPath row];
    
    if (row == oldRow && lastPath!=nil) {
        
        //這個是系统中打勾的那種選擇框
        CountryCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        
        CountryCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    

    
    
    CountryCell.textLabel.text=countryArr[indexPath.row];
    
    CountryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    return CountryCell;
    
    //    static NSString *CellIdentifier = @"cellMember";
    //    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        //cell = [[TimerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MemberCell"owner:self options:nil];
    //        cell = [nib objectAtIndex:0];
    //
    //        cell.MemberL.text = self.person[indexPath.row];
    //        cell.checkboxBtn.tag = (int)indexPath.row;
    //       // [cell.checkboxBtn addTarget:self action:@selector(memberselect:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    }
    //
    //    return cell;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height*0.06 ;
}



-(void)nav{
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 ,0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:@"Register" forState:UIControlStateNormal];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.02, 0, 0, 0)];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    //[button setBackgroundColor:[UIColor blueColor]];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[gobackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[titleBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
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

//到使用條款頁面
-(void)gotermofuse{
    
    
    UIViewController *TermofUseVC = [[UIViewController alloc ]init];
    TermofUseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TermofUseVC"];
    TermofUseVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:TermofUseVC animated:true completion:nil];
    
    NSLog(@"goReg");
    
    
    
}


@end
