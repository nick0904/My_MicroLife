//
//  ProfileViewController.m
//  Setting
//
//  Created by Ideabus on 2016/8/12.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ProfileViewController.h"
#import "MViewController.h"
#import "ProfileClass.h"
#import "MyHealthStore.h"
#import "NavViewController.h"

@interface ProfileViewController () <MyHealthStoreDelegate,APIPostAndResponseDelegate> {
    
    MViewController *mainVC; ///取 email 用
    UILabel *emailLabel; ///顯示 e-mail 的 label
    
    UIImageView *userImageView; ///user 大頭像
    UIButton *callCameraBtn; ///點擊觸發相簿或相機
    
    RiskFactorsViewController *riskVC; ///riskVC 頁面
    
    //係數設定
    float profileY1;
    float profileY2;
    float profileH;
    float profileX;
    float profileX1;
    float switch_x;
    float switch_w;
    float switch_h;
    
    
    //HealthKit
    MyHealthStore *healthStore;
    BOOL isSyncHeqlthKit;
    
    
    //API
    APIPostAndResponse *apiClass;
    
    
    UIActivityIndicatorView *indicatorView;
    
    
    
    //switchBt
    UISwitch *systolicswitch;
    UISwitch *diastolicswitch;
    UISwitch *goalWeightswitch;
    UISwitch *BMIswitch;
    UISwitch *Bodyswitch;
    UISwitch *thresholdswitch;
    
}

@end

@implementation ProfileViewController

#pragma mark - Normal Function *******************************
- (void)viewDidLoad {
    [super viewDidLoad];
 
    //init
    [self initWithArrayDataWithPickerView];
    [self initWithParam];
    [self initProfileScrollView];
    [self initProfileCustomNavBar];
    
    //從資料庫取Data
    [self getLocaldata];
    [self refreshData];
    
    //HealthKit
    healthStore = [[MyHealthStore alloc] initHealthStore];
    healthStore.delegate = self;
    healthStore.superVC = self;
    [self getBasicDataFromHealthStore];
    
    //API
    [self getMemberDataFromCloud];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.riskSubTitleBtn != nil){
        [self.riskSubTitleBtn setTitle:[self translateRiskFactorToGloableStr] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initialization  *******************************
//Coefficient init 係數初始化設定
-(void)initWithParam {
    
    profileY1 = self.view.frame.size.height*0.37;
    profileY2 = self.view.frame.size.height*1.1;
    profileH = self.view.frame.size.height/13;
    profileX = self.view.frame.size.width*0.48;
    profileX1 = self.view.frame.size.width*0.59;
    switch_x = self.view.frame.size.width*0.84;
    switch_w = profileH*1.5;
    switch_h = switch_w*31/51;
    
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
}


//PickerView Array Data init
-(void)initWithArrayDataWithPickerView {
    
    //ProFile PickerView Array Data
    //Height (cm) init
    ary_heightData = [[NSMutableArray alloc] init];
    for(int h=91; h<=242; h++) {
        
        [ary_heightData addObject:[NSString stringWithFormat:@"%d",h]];
    }
    
    //Height (ft) init
    ary_heigh_ftData = [[NSMutableArray alloc] init];
    for(int h=3; h<=7; h++) {
        
        [ary_heigh_ftData addObject:[NSString stringWithFormat:@"%d",h]];
    }
    
    //Height (inch) init
    ary_heigh_inchData = [[NSMutableArray alloc] init];
    for(float n=0.0; n<12.0; n = n+0.1 ) {
        
        [ary_heigh_inchData addObject:[NSString stringWithFormat:@"%.1f",n]];
    }
    
    //h_cm_unit init
    h_cm_unit = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"cm", nil), nil];
    
    //h_ft_unit init
    h_ft_unit = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"ft", nil), nil];
    
    //h_inch_unit init
    h_inch_unit = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"inch", nil), nil];
    
    
    //ary_cuffSizeData init
    ary_cuffSizeData = [[NSMutableArray alloc] initWithObjects:
    NSLocalizedString(@"S", nil),
    NSLocalizedString(@"M", nil),
    NSLocalizedString(@"M-L", nil),
    NSLocalizedString(@"L", nil),
    NSLocalizedString(@"L-X", nil),nil];

    
    //ary_measureArmData init
    ary_measureArmData = [[NSMutableArray alloc] initWithObjects:
    NSLocalizedString(@"Left", nil),
    NSLocalizedString(@"Right", nil),nil];
    
    

}


//ProfilePicture init  (user 頭像)
-(void)initProfilePicture {
    
    float ProfileimgRadius = self.view.frame.size.width *0.3;
    
    //userImageView init
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-ProfileimgRadius/2, self.view.frame.size.height*3/26, ProfileimgRadius, ProfileimgRadius)];
    userImageView.contentMode = UIViewContentModeScaleAspectFill;
    [userImageView.layer setMasksToBounds:YES];
    userImageView.layer.cornerRadius = ProfileimgRadius/2+2;
    userImageView.layer.borderColor = [UIColor colorWithRed:217.0f/255.0f green:215.0f/255.0f blue:208.0f/255.0f alpha:0.84].CGColor;
    userImageView.layer.borderWidth = 1;
    [profileScrollview addSubview:userImageView];
    
    UIImage *personImage;
    
    if ([self checkUserImagePathIsExistOrNot]) {
        //使用 user 自訂照片
        NSString *fileName = USER_IMAGE_FILEPATH;
        NSData *imageData = [NSData dataWithContentsOfFile:fileName];
        personImage = [UIImage imageWithData:imageData];
        
    }
    else {
        //使用預設相片
        personImage = [UIImage imageNamed:@"personal"];
    }
    userImageView.image = personImage;
    
    
    
    
    //callCameraBtn init
    callCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callCameraBtn.frame = CGRectMake(self.view.frame.size.width/2-ProfileimgRadius/2+ProfileimgRadius/1.412 , self.view.frame.size.height*3/26+ProfileimgRadius/1.412, ProfileimgRadius*1.1/4, ProfileimgRadius*1.1/4);
    callCameraBtn.backgroundColor = [UIColor clearColor];
    //callCameraBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //callCameraBtn.layer.borderWidth = 2;
    //callCameraBtn.layer.cornerRadius = ProfileimgRadius/8;
    //callCameraBtn.layer.masksToBounds = YES;
    [callCameraBtn setImage:[UIImage imageNamed:@"all_btn_a_camera"] forState:UIControlStateNormal];
    [callCameraBtn addTarget:self action:@selector(uploadProfilePicture) forControlEvents:UIControlEventTouchUpInside];
    [profileScrollview addSubview:callCameraBtn];

}

-(void)uploadProfilePicture{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Upload your profile picture", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //呼叫相機
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"From Camera", nil) style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        
        [self getImageFromDevice:0];
    }];
    
    [alertController addAction:cameraAction];
    
    
    //呼叫相簿
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Form Album", nil) style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        
        [self getImageFromDevice:1];
    }];
    
    [alertController addAction:albumAction];
    
    
    //取消
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:closeAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}




//ProfileNavBar init
-(void)initProfileCustomNavBar {
    
    //navBar_View
    UIView *navBar_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)];
    navBar_View.backgroundColor = [UIColor colorWithRed:0 green:61.0f/255.0f blue:165.0f/255.0f alpha:1.0];
    [self.view addSubview:navBar_View];

    
    //navBar_titleLabel
    CGRect navFrame = CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height*0.1);
    UILabel *navBar_titleLabel = [[UILabel alloc] initWithFrame: navFrame];
    [navBar_titleLabel setTextColor:[UIColor whiteColor ]];
    navBar_titleLabel.backgroundColor = [UIColor clearColor];
    navBar_titleLabel.text = NSLocalizedString(@"My Profile", nil);
    navBar_titleLabel.font = [UIFont systemFontOfSize:22];
    navBar_titleLabel.alpha = 1.0;
    navBar_titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:navBar_titleLabel];
    
    
    //navBar_backBt
    UIButton *navBar_backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    navBar_backBt.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navBar_backBt setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal ];
    navBar_backBt.backgroundColor = [UIColor clearColor];
    navBar_backBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [navBar_backBt addTarget:self action:@selector(gobackToSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar_backBt];
    
    
    //navBar_saveBt
    UIButton *navBar_saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
    navBar_saveBt.frame = CGRectMake(self.view.frame.size.width*0.78, self.view.frame.size.height*0.02, self.view.frame.size.width/5, self.view.frame.size.height*0.07);
    [navBar_saveBt setTitle:@"Save" forState:UIControlStateNormal];
    [navBar_saveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navBar_saveBt.titleLabel.font = [UIFont systemFontOfSize:17];
    navBar_saveBt.backgroundColor = [UIColor clearColor];
    navBar_saveBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navBar_saveBt addTarget:self action:@selector(saveProfileData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar_saveBt];
    
}



//Profile ScrollView init
-(void)initProfileScrollView {
    
    //profile ScrollView init
    profileScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    profileScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2.08);
    profileScrollview.showsVerticalScrollIndicator = NO;
    profileScrollview.backgroundColor = TABLE_BACKGROUND;
    profileScrollview.delegate = self;
    [self.view addSubview:profileScrollview];
    

    //date formatter init
    NSDate *currentDate = [NSDate date];
    dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *dateformatterStr = dateformatBool == YES ? @"MM/dd/YYYY" : @"YYYY/MM/dd";
    [dateformatter setDateFormat:dateformatterStr];
    currentDateString = [dateformatter stringFromDate:currentDate];
    birthDateString  = currentDateString;
   

    //大頭照 init
    [self initProfilePicture];
    
    //e-mail init
    [self initProfileEmail];
    
    
    //Title Labels init
    [self initWithProFileTitleLabel];
    [self initWithMyGoalTitleLabel];
    
    //show value objects init
    [self initWithProfileShowValueObjects];
    [self initWithMyGoalShowValueObjects];

    //物件增加手勢
    [self objectAddGesture];

    //SwitchBt init
    [self initWithSwitchBts];
    
    //threshold點擊次數(初始化設為0)
    thresholdCount = 0;
    
}


//ProfileEmail init
-(void)initProfileEmail {
    
    mainVC = [[MViewController alloc] init];///取 email 用
    
    CGRect emaillabelFrame = CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height*0.13+self.view.frame.size.width*0.3 , self.view.frame.size.width/2 , 22);
    
    
    emailLabel = [[UILabel alloc] initWithFrame:emaillabelFrame];
    [emailLabel setTextColor:[UIColor colorWithRed:115.0f/255.0f green:116.0f/255.0f blue:117.0f/255.0f alpha:1.0 ]];
    emailLabel.text = [mainVC getUserEmail];
    emailLabel.font = [UIFont systemFontOfSize:17];
    emailLabel.alpha = 0.9;
    emailLabel.adjustsFontSizeToFitWidth = YES;
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [profileScrollview addSubview:emailLabel];
    
}


//ProFile Title Labels init
-(void)initWithProFileTitleLabel {

    UIView *profileView;
    if (IS_IPAD) {
    
         profileView = [[UIView alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(emailLabel.frame), self.view.frame.size.width+2, profileH*9+9)];
    }
    else {
        
        profileView = [[UIView alloc] initWithFrame:CGRectMake(-1, profileY1, self.view.frame.size.width+2, profileH*9+9)];
    }
    profileView.backgroundColor = [UIColor whiteColor];
    profileView.layer.borderColor = LAYER_BORDERCOLOR;
    profileView.layer.borderWidth = 1;
    [profileScrollview addSubview:profileView];
    
    
    
    //頭像下面的分隔線
    UIView *userImgSperatorLine = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1, self.view.frame.size.width*0.95, 1)];
    userImgSperatorLine.backgroundColor = [UIColor clearColor];
    [profileScrollview addSubview:userImgSperatorLine];
    
    
    //小分隔線,共9條
    for (int i = 1; i < 9; i++) {
        
        UIView *pline = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*i, self.view.frame.size.width*0.95, 1)];
        
        pline.backgroundColor = CELL_SPERATORCOLOR;
        
        [profileScrollview addSubview:pline];
        
    }
    

    
    UILabel *nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1, self.view.frame.size.width/2, profileH)];
    [nameTitleLabel setTextColor:[UIColor blackColor ]];
    nameTitleLabel.backgroundColor = [UIColor clearColor];
    nameTitleLabel.text = NSLocalizedString(@"Name", nil);
    nameTitleLabel.font = [UIFont systemFontOfSize:17];
    nameTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:nameTitleLabel];
    
    /** webView做
    //ChangePassword Title Label init
    UILabel *changePasswordTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*1, self.view.frame.size.width/2, profileH)];
    [changePasswordTitleLabel setTextColor:[UIColor blackColor ]];
    changePasswordTitleLabel.backgroundColor = [UIColor clearColor];
    changePasswordTitleLabel.text = NSLocalizedString(@"Change Password", nil);
    changePasswordTitleLabel.font = [UIFont systemFontOfSize:17];
    changePasswordTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:changePasswordTitleLabel];
    */
    
    //Gender Title Label init
    UILabel *genderTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*1, self.view.frame.size.width/2, profileH)];
    [genderTitleLabel setTextColor:[UIColor blackColor ]];
    genderTitleLabel.backgroundColor = [UIColor clearColor];
    genderTitleLabel.text = NSLocalizedString(@"Gender", nil);
    genderTitleLabel.font = [UIFont systemFontOfSize:17];
    genderTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:genderTitleLabel];
    
    
    //BirthDay Title Label init
    UILabel *birthDayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*2, self.view.frame.size.width/2, profileH)];
    [birthDayTitleLabel setTextColor:[UIColor blackColor ]];
    birthDayTitleLabel.backgroundColor = [UIColor clearColor];
    birthDayTitleLabel.text = NSLocalizedString(@"Date of Birth", nil);
    birthDayTitleLabel.font = [UIFont systemFontOfSize:17];
    birthDayTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:birthDayTitleLabel];
    
    //Height Title Label init
    UILabel *heightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*3, self.view.frame.size.width/2, profileH)];
    [heightTitleLabel setTextColor:[UIColor blackColor ]];
    heightTitleLabel.backgroundColor = [UIColor clearColor];
    heightTitleLabel.text = @"Height";
    heightTitleLabel.font = [UIFont systemFontOfSize:17];
    heightTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:heightTitleLabel];
    
    
    //Weight Title Label init
    UILabel *weightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*4, self.view.frame.size.width/2, profileH)];
    [weightTitleLabel setTextColor:[UIColor blackColor ]];
    weightTitleLabel.backgroundColor = [UIColor clearColor];
    weightTitleLabel.text = @"Weight";
    weightTitleLabel.font = [UIFont systemFontOfSize:17];
    weightTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:weightTitleLabel];
    
    
    //Cuff Size Tittle Label init
    UILabel *cuffSizeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*5 , self.view.frame.size.width/2 , profileH)];
    [cuffSizeTitleLabel setTextColor:[UIColor blackColor]];
    cuffSizeTitleLabel.text = @"Cuff Size";
    cuffSizeTitleLabel.font = [UIFont systemFontOfSize:17];
    cuffSizeTitleLabel.alpha = 1.0;
    cuffSizeTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:cuffSizeTitleLabel];
    
    
    //Measure Arm Title Label init
    UILabel *measureArmTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*6, self.view.frame.size.width/2, profileH)];
    [measureArmTitleLabel setTextColor:[UIColor blackColor ]];
    measureArmTitleLabel.backgroundColor = [UIColor clearColor];
    measureArmTitleLabel.text = @"Measurement Arm";
    measureArmTitleLabel.font = [UIFont systemFontOfSize:17];
    measureArmTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:measureArmTitleLabel];
    
    
    //Tap the unit Title Label init
    UILabel *TapUnitTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*7, self.view.frame.size.width/2, profileH)];
    [TapUnitTitleLabel setTextColor:[UIColor blackColor ]];
    TapUnitTitleLabel.backgroundColor = [UIColor clearColor];
    TapUnitTitleLabel.text = @"Tap the unit";
    TapUnitTitleLabel.font = [UIFont systemFontOfSize:17];
    TapUnitTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:TapUnitTitleLabel];
    
    
    //Pressure unit Title Label init
    UILabel *pressureUnitTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY1+profileH*8, self.view.frame.size.width/2, profileH)];
    [pressureUnitTitleLabel setTextColor:[UIColor blackColor ]];
    pressureUnitTitleLabel.backgroundColor = [UIColor clearColor];
    pressureUnitTitleLabel.text = @"Pressure unit";
    pressureUnitTitleLabel.font = [UIFont systemFontOfSize:17];
    pressureUnitTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:pressureUnitTitleLabel];

}


//Profile objects which can show value
-(void)initWithProfileShowValueObjects {
    
    //Name TextField
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(profileX , profileY1+1, self.view.frame.size.width-profileX-10, profileH) ];
    nameTextField.placeholder = @"Name";
    nameTextField.textColor = [UIColor blackColor];
    nameTextField.delegate = self;
    nameTextField.backgroundColor = [UIColor clearColor];
    nameTextField.borderStyle =  UITextBorderStyleNone;
    nameTextField.textAlignment = NSTextAlignmentJustified;
    nameTextField.font = [UIFont systemFontOfSize:17];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameTextField setKeyboardType:UIKeyboardTypeDefault] ;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;///字首不大寫
    [nameTextField addTarget:self action:@selector(textFieldEditChanging:) forControlEvents:UIControlEventEditingChanged];
    [profileScrollview addSubview:nameTextField];
    
    /** webView 做
    //Change Password
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(0, profileY1+profileH+1, self.view.frame.size.width, profileH);
    changeBtn.backgroundColor = [UIColor clearColor];
    changeBtn.layer.cornerRadius = 0;
    [changeBtn addTarget:self action:@selector(gochangepasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [profileScrollview addSubview:changeBtn];
    
    
    //Change Password indicator imageView
    UIButton *gochangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gochangeBtn.frame = CGRectMake(self.view.frame.size.width-profileH*0.37-5, profileY1+profileH*1.315+1, profileH*0.37, profileH*0.37);
    [gochangeBtn setImage:[UIImage imageNamed:@"all_icon_a_arrow_r"] forState:UIControlStateNormal ];
    gochangeBtn.backgroundColor = [UIColor clearColor];
    gochangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [gochangeBtn addTarget:self action:@selector(gochangepasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [profileScrollview addSubview:gochangeBtn];
    */
    
    //Gender 性別選擇 init
    NSArray *sexitemArray = [NSArray arrayWithObjects: NSLocalizedString(@"Male", nil), NSLocalizedString(@"Female", nil), nil];
    sexSegmentControl = [[UISegmentedControl alloc] initWithItems:sexitemArray];
    sexSegmentControl.frame = CGRectMake(self.view.frame.size.width*0.37, (profileH-self.view.frame.size.height/22)/2+profileH*1+profileY1, self.view.frame.size.width*0.6, self.view.frame.size.height/22);
    [sexSegmentControl addTarget:self action:@selector(GenderSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    sexSegmentControl.backgroundColor = [UIColor whiteColor];
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [sexSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    sexSegmentControl.tintColor = STANDER_COLOR;
    sexSegmentControl.selectedSegmentIndex = 2;
    [profileScrollview addSubview:sexSegmentControl];
    
    
    
    //BirthDay Date
    birthdayLabel = [[UILabel alloc] initWithFrame: CGRectMake(profileX, profileY1+profileH*2 , self.view.frame.size.width*0.6 , profileH)];
    [birthdayLabel setTextColor:[UIColor blackColor]];
    birthdayLabel.text = birthDateString;
    birthdayLabel.font = [UIFont systemFontOfSize:17];
    birthdayLabel.alpha = 1.0;
    birthdayLabel.textAlignment = NSTextAlignmentLeft;
    birthdayLabel.userInteractionEnabled = YES;
    [profileScrollview addSubview:birthdayLabel];
    
    
    //身高單位
    //cm Label init
    cmLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY1+profileH*3 , self.view.frame.size.width/3 , profileH)];
    [cmLabel setTextColor:[UIColor grayColor]];
    cmLabel.text = @"cm";
    cmLabel.font = [UIFont systemFontOfSize:14];
    cmLabel.alpha = 1.0;
    cmLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:cmLabel];
    
    
    //ft Label init
    ftLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX+25, profileY1+profileH*3, self.view.frame.size.width/3, profileH)];
    [ftLabel setTextColor:[UIColor grayColor]];
    ftLabel.text = @"ft";
    ftLabel.font = [UIFont systemFontOfSize:14];
    ftLabel.alpha = 1.0;
    ftLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:ftLabel];
    
    //inch Label init
    inchLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX+85, profileY1+profileH*3, self.view.frame.size.width/3, profileH)];
    [inchLabel setTextColor:[UIColor grayColor]];
    inchLabel.text = @"inch";
    inchLabel.font = [UIFont systemFontOfSize:14];
    inchLabel.alpha = 1.0;
    inchLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:inchLabel];
    
    
    //height Label value (cm)
    heightLabel_cm_value = [[UILabel alloc] initWithFrame: CGRectMake(profileX, profileY1+profileH*3 ,profileX1-profileX , profileH)];
    [heightLabel_cm_value setTextColor:[UIColor blackColor]];
    //heightLabel_cm_value.text = @"175"; //預設 175 cm
    heightLabel_cm_value.font = [UIFont systemFontOfSize:17];
    heightLabel_cm_value.alpha = 1.0;
    heightLabel_cm_value.textAlignment = NSTextAlignmentLeft;
    heightLabel_cm_value.userInteractionEnabled = YES;
    [profileScrollview addSubview:heightLabel_cm_value];
    
    //height Label value (ft)
    heightLabel_ft_value = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY1+profileH*3, profileX1-profileX, profileH)];
    [heightLabel_ft_value setTextColor:[UIColor blackColor]];
    heightLabel_ft_value.text = ft_Str;
    heightLabel_ft_value.font = [UIFont systemFontOfSize:17];
    heightLabel_ft_value.alpha = 1.0;
    heightLabel_ft_value.textAlignment = NSTextAlignmentLeft;
    heightLabel_ft_value.userInteractionEnabled = YES;
    [profileScrollview addSubview:heightLabel_ft_value];
    
    
    //height Label value (inch)
    heightLabel_inch_value = [[UILabel alloc] initWithFrame:CGRectMake(profileX+50, profileY1+profileH*3, profileX1-profileX, profileH)];
    [heightLabel_inch_value setTextColor:[UIColor blackColor]];
    heightLabel_inch_value.text = inch_Str;
    heightLabel_inch_value.font = [UIFont systemFontOfSize:17];
    heightLabel_inch_value.alpha = 1.0;
    heightLabel_inch_value.textAlignment = NSTextAlignmentLeft;
    heightLabel_inch_value.userInteractionEnabled = YES;
    [profileScrollview addSubview:heightLabel_inch_value];
    
    
    
    //體重
    //kg Label init
    kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY1+profileH*4 , self.view.frame.size.width/3 , profileH)];
    [kgLabel setTextColor:[UIColor grayColor]];
    kgLabel.text = @"kg";
    kgLabel.font = [UIFont systemFontOfSize:14];
    kgLabel.alpha = 1.0;
    kgLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:kgLabel];
    
    //weight Label init
    weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY1+profileH*4 , profileX1-profileX , profileH)];
    [weightLabel setTextColor:[UIColor blackColor]];
    //weightLabel.text = @"75.0"; //預設值為 75 kg
    weightLabel.font = [UIFont systemFontOfSize:17];
    weightLabel.adjustsFontSizeToFitWidth = YES;
    weightLabel.alpha = 1.0;
    weightLabel.textAlignment = NSTextAlignmentLeft;
    weightLabel.userInteractionEnabled = YES;
    [profileScrollview addSubview:weightLabel];
    
    
    //Cuff Size Label init
    cuffSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY1+profileH*5 , self.view.frame.size.width*0.6 , profileH)];
    [cuffSizeLabel setTextColor:[UIColor blackColor]];
    //cuffSizeLabel.text = ary_cuffSizeData[cuffsize_row];
    cuffSizeLabel.font = [UIFont systemFontOfSize:17];
    cuffSizeLabel.alpha = 1.0;
    cuffSizeLabel.textAlignment = NSTextAlignmentLeft;
    cuffSizeLabel.userInteractionEnabled = YES;
    [profileScrollview addSubview:cuffSizeLabel];
    
    
    //Measure Arm Label init
    measureArmLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY1+profileH*6 , self.view.frame.size.width*0.6 , profileH)];
    [measureArmLabel setTextColor:[UIColor blackColor]];
    //measureArmLabel.text = ary_measureArmData[measureArm_row];
    measureArmLabel.font = [UIFont systemFontOfSize:17];
    measureArmLabel.alpha = 1.0;
    measureArmLabel.textAlignment = NSTextAlignmentLeft;
    measureArmLabel.userInteractionEnabled = YES;
    [profileScrollview addSubview:measureArmLabel];
    
    
    //Arm Label
    UILabel *ArmLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX+45, profileY1+profileH*6 , self.view.frame.size.width*0.6 , profileH)];
    [ArmLabel setTextColor:[UIColor blackColor]];
    ArmLabel.text = @"arm";
    ArmLabel.font = [UIFont systemFontOfSize:17];
    ArmLabel.alpha = 1.0;
    ArmLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:ArmLabel];
    
    
    //Metric <-> Imperial 公英制轉換選擇 init
    NSArray *unititemArray = [NSArray arrayWithObjects: NSLocalizedString(@"Metric", nil), NSLocalizedString(@"Imperial", nil), nil];
    unitSegmentControl = [[UISegmentedControl alloc] initWithItems:unititemArray];
    unitSegmentControl.frame = CGRectMake(self.view.frame.size.width*0.37, (profileH-self.view.frame.size.height/22)/2+profileH*7+profileY1, self.view.frame.size.width*0.6, self.view.frame.size.height/22);
    [unitSegmentControl addTarget:self action:@selector(unitSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    unitSegmentControl.backgroundColor = [UIColor whiteColor];
    UIFont *unitfont = [UIFont boldSystemFontOfSize:17.0f];
    NSDictionary *unitattributes = [NSDictionary dictionaryWithObject:unitfont forKey:NSFontAttributeName];
    [unitSegmentControl setTitleTextAttributes:unitattributes forState:UIControlStateNormal];
    unitSegmentControl.tintColor = STANDER_COLOR;
    unitSegmentControl.selectedSegmentIndex = 0; //unitBooL == 0 ? 0 : 1;
    [profileScrollview addSubview:unitSegmentControl];
    
    
    //mmHg <-> kpa  血壓單位轉換選擇 init
    NSArray *pressureitemArray = [NSArray arrayWithObjects: @"mmHg", @"kpa", nil];
    pressureSegmentControl = [[UISegmentedControl alloc] initWithItems:pressureitemArray];
    pressureSegmentControl.frame = CGRectMake(self.view.frame.size.width*0.37, (profileH-self.view.frame.size.height/22)/2+profileH*8+profileY1, self.view.frame.size.width*0.6, self.view.frame.size.height/22);
    [pressureSegmentControl addTarget:self action:@selector(pressureSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    pressureSegmentControl.backgroundColor = [UIColor whiteColor];
    UIFont *pressurefont = [UIFont boldSystemFontOfSize:17.0f];
    NSDictionary *pressureattributes = [NSDictionary dictionaryWithObject:pressurefont forKey:NSFontAttributeName];
    [pressureSegmentControl setTitleTextAttributes:pressureattributes forState:UIControlStateNormal];
    pressureSegmentControl.tintColor = STANDER_COLOR;
    pressureSegmentControl.selectedSegmentIndex = 0;//pressureBooL == 0 ? 0 : 1;
    [profileScrollview addSubview:pressureSegmentControl];
    

}



//MyGoal Title Labels init
-(void)initWithMyGoalTitleLabel {

    //UIView *goalview = [[UIView alloc] initWithFrame:CGRectMake(-1, profileY2+profileH+22, self.view.frame.size.width+2, profileH*5+5)];
    UIView *goalview = [[UIView alloc] initWithFrame:CGRectMake(-1, profileY2+profileH, self.view.frame.size.width+2, profileH*5+5)];
    goalview.backgroundColor = [UIColor whiteColor];
    goalview.layer.borderColor = LAYER_BORDERCOLOR;
    goalview.layer.borderWidth = 1;
    [profileScrollview addSubview:goalview];
    
    //小分隔線,共4條
    for (int j = 2; j < 6; j++) {
        
        UIView *gline = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*j, self.view.frame.size.width*0.95, 1)];
        gline.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:215.0f/255.0f blue:217.0f/255.0f alpha:1.0];
        [profileScrollview addSubview:gline];
    }
    
    
    //My Goals Label init
    //UILabel *myGoalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH-2 , self.view.frame.size.width , 22)];
    UILabel *myGoalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2 , self.view.frame.size.width , 22)];
    [myGoalLabel setTextColor:[UIColor colorWithRed:115.0f/255.0f green:116.0f/255.0f blue:117.0f/255.0f alpha:1.0 ]];
    myGoalLabel.text = NSLocalizedString(@"My Goals", nil);
    myGoalLabel.font = [UIFont systemFontOfSize:22];
    myGoalLabel.alpha = 1.0;
    myGoalLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:myGoalLabel];
    
    
    //Systolic Pressure Title Label init
    //UILabel *systolicPressureTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH+22, self.view.frame.size.width/2, profileH)];
     UILabel *systolicPressureTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH, self.view.frame.size.width/2, profileH)];
    [systolicPressureTitleLabel setTextColor:[UIColor blackColor ]];
    systolicPressureTitleLabel.backgroundColor = [UIColor clearColor];
    systolicPressureTitleLabel.text = NSLocalizedString(@"Systolic Pressure", nil);
    systolicPressureTitleLabel.font = [UIFont systemFontOfSize:17];
    systolicPressureTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:systolicPressureTitleLabel];
    
    
    //Diastolic Pressure Title Label init
    //UILabel *diastolicPressureTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*2+22, self.view.frame.size.width/2, profileH)];
    UILabel *diastolicPressureTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+2*profileH, self.view.frame.size.width/2, profileH)];
    [diastolicPressureTitleLabel setTextColor:[UIColor blackColor ]];
    diastolicPressureTitleLabel.backgroundColor = [UIColor clearColor];
    diastolicPressureTitleLabel.text = NSLocalizedString(@"Diastolic Pressure", nil);
    diastolicPressureTitleLabel.font = [UIFont systemFontOfSize:17];
    diastolicPressureTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:diastolicPressureTitleLabel];
    
    //MyGoal Weight Title Label init
   // UILabel *myGoalWeightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*3+22, self.view.frame.size.width/2, profileH)];
        UILabel *myGoalWeightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*3, self.view.frame.size.width/2, profileH)];
    [myGoalWeightTitleLabel setTextColor:[UIColor blackColor ]];
    myGoalWeightTitleLabel.backgroundColor = [UIColor clearColor];
    myGoalWeightTitleLabel.text = NSLocalizedString(@"Weight ", nil);
    myGoalWeightTitleLabel.font = [UIFont systemFontOfSize:17];
    myGoalWeightTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:myGoalWeightTitleLabel];
    
    
    //MyGoal BMI Title Label init
    //UILabel *myGoalBMITitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*4+22, self.view.frame.size.width/2, profileH)];
    UILabel *myGoalBMITitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*4, self.view.frame.size.width/2, profileH)];
    [myGoalBMITitleLabel setTextColor:[UIColor blackColor ]];
    myGoalBMITitleLabel.backgroundColor = [UIColor clearColor];
    myGoalBMITitleLabel.text = NSLocalizedString(@"BMI ", nil);
    myGoalBMITitleLabel.font = [UIFont systemFontOfSize:17];
    myGoalBMITitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:myGoalBMITitleLabel];
    
    
    //MyGoal Body Fat Title Label init
    //UILabel *myGoalBodyFatTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*5+22, self.view.frame.size.width/2, profileH)];
    UILabel *myGoalBodyFatTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, profileY2+profileH*5, self.view.frame.size.width/2, profileH)];
    [myGoalBodyFatTitleLabel setTextColor:[UIColor blackColor ]];
    myGoalBodyFatTitleLabel.backgroundColor = [UIColor clearColor];
    myGoalBodyFatTitleLabel.text = NSLocalizedString(@"Body  Fat", nil);
    myGoalBodyFatTitleLabel.font = [UIFont systemFontOfSize:17];
    myGoalBodyFatTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview  addSubview:myGoalBodyFatTitleLabel];
    
    
    //MyGoal systolic Pressure UnitLabel init
    //myGoal_systolicPressureUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+22+profileH*1 , self.view.frame.size.width/3 , profileH)];
     myGoal_systolicPressureUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+profileH , self.view.frame.size.width/3 , profileH)];
    [myGoal_systolicPressureUnitLabel setTextColor:[UIColor grayColor]];
    myGoal_systolicPressureUnitLabel.text = @"mmHg";
    myGoal_systolicPressureUnitLabel.font = [UIFont systemFontOfSize:14];
    myGoal_systolicPressureUnitLabel.alpha = 1.0;
    myGoal_systolicPressureUnitLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:myGoal_systolicPressureUnitLabel];
    
    
    //MyGoal diastolic Pressure Unit Label init
    //myGoal_diastolicPressureUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+22+profileH*2 , self.view.frame.size.width/3 , profileH)];
    myGoal_diastolicPressureUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+profileH*2 , self.view.frame.size.width/3 , profileH)];
    [myGoal_diastolicPressureUnitLabel setTextColor:[UIColor grayColor]];
    myGoal_diastolicPressureUnitLabel.text = @"mmHg";
    myGoal_diastolicPressureUnitLabel.font = [UIFont systemFontOfSize:14];
    myGoal_diastolicPressureUnitLabel.alpha = 1.0;
    myGoal_diastolicPressureUnitLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:myGoal_diastolicPressureUnitLabel];
    
    
    //MyGoal kg Label init
    //myGoal_kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+22+profileH*3 , self.view.frame.size.width/3 , profileH)];
     myGoal_kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+profileH*3 , self.view.frame.size.width/3 , profileH)];
    [myGoal_kgLabel setTextColor:[UIColor grayColor]];
    myGoal_kgLabel.text = @"kg";
    myGoal_kgLabel.font = [UIFont systemFontOfSize:14];
    myGoal_kgLabel.alpha = 1.0;
    myGoal_kgLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:myGoal_kgLabel];
    
    
    //MyGoal persent (%) Label init
   // UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+22+profileH*5 , self.view.frame.size.width/3 , profileH)];
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX1, profileY2+profileH*5 , self.view.frame.size.width/3 , profileH)];
    [percentLabel setTextColor:[UIColor grayColor]];
    percentLabel.text = @"%";
    percentLabel.font = [UIFont systemFontOfSize:14];
    percentLabel.alpha = 1.0;
    percentLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:percentLabel];
    
    
    //Threshold View init (底層)
   // UIView *thresholdView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.frame.size.height*1.69, self.view.frame.size.width+2, profileH)];
    UIView *thresholdView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.frame.size.height*1.6, self.view.frame.size.width+2, profileH)];
    thresholdView.backgroundColor = [UIColor whiteColor];
    thresholdView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0].CGColor;
    thresholdView.layer.borderWidth = 1;
    thresholdView.layer.cornerRadius = 0;
    [profileScrollview addSubview:thresholdView];
    
    //Threshold Title Label init
   // UILabel *thresholdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*1.69, self.view.frame.size.width, profileH)];
    UILabel *thresholdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*1.6, self.view.frame.size.width, profileH)];
    thresholdTitleLabel.text = NSLocalizedString(@"Threshold", nil);
    thresholdTitleLabel.textColor = [UIColor blackColor];
    thresholdTitleLabel.font = [UIFont systemFontOfSize:22];
    thresholdTitleLabel.backgroundColor = [UIColor clearColor];
    thresholdTitleLabel.textAlignment = NSTextAlignmentLeft;
    [profileScrollview addSubview:thresholdTitleLabel];
    
    
    //Risk Factor
    //Risk 底層
    UIButton *riskbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //riskbBtn.frame = CGRectMake(-1, self.view.frame.size.height*1.8, self.view.frame.size.width+2, profileH);
    riskbBtn.frame = CGRectMake(-1, self.view.frame.size.height*1.7, self.view.frame.size.width+2, profileH);
    riskbBtn.backgroundColor = [UIColor whiteColor];
    riskbBtn.layer.borderWidth = 1;
    riskbBtn.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0].CGColor;
    riskbBtn.layer.cornerRadius = 0;
    [riskbBtn addTarget:self action:@selector(goRFClick) forControlEvents:UIControlEventTouchUpInside];
    [profileScrollview addSubview:riskbBtn];
    
    //Risk Title
    UIButton *riskTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    riskTitleBtn.frame = CGRectMake(self.view.frame.size.width*0.05, 0, self.view.frame.size.width, profileH);
    [riskTitleBtn setTitle:NSLocalizedString(@"Risk Factors", nil) forState:UIControlStateNormal];
    [riskTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    riskTitleBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    riskTitleBtn.backgroundColor = [UIColor clearColor];
    riskTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [riskTitleBtn addTarget:self action:@selector(goRFClick) forControlEvents:UIControlEventTouchUpInside];
    [riskbBtn addSubview:riskTitleBtn];
    
    //Risk indicator
    UIButton *gotoRiskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoRiskBtn.frame = CGRectMake(self.view.frame.size.width*0.9, 0+profileH*0.315, profileH*0.37, profileH*0.37);
    [gotoRiskBtn setImage:[UIImage imageNamed:@"all_icon_a_arrow_r"] forState:UIControlStateNormal ];
    gotoRiskBtn.backgroundColor = [UIColor clearColor];
    gotoRiskBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [gotoRiskBtn addTarget:self action:@selector(goRFClick) forControlEvents:UIControlEventTouchUpInside];
    [riskbBtn addSubview:gotoRiskBtn];
    
    //Risk - Diabetes、Heart Faulure
    self.riskSubTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.riskSubTitleBtn.frame = CGRectMake(self.view.frame.size.width*0.53, 0, self.view.frame.size.width*0.35, profileH);
    [self.riskSubTitleBtn setTitle:@"" forState:UIControlStateNormal];
    [self.riskSubTitleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.riskSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.riskSubTitleBtn.backgroundColor = [UIColor clearColor];
    self.riskSubTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.riskSubTitleBtn addTarget:self action:@selector(goRFClick) forControlEvents:UIControlEventTouchUpInside];
    [riskbBtn addSubview:self.riskSubTitleBtn];
    
    
    //Select the date format
    //dateformatBtn (底層)
    UIButton *dateformatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //dateformatBtn.frame = CGRectMake(-1, self.view.frame.size.height*1.9, self.view.frame.size.width+2, profileH);
    dateformatBtn.frame = CGRectMake(-1, self.view.frame.size.height*1.8, self.view.frame.size.width+2, profileH);
    dateformatBtn.backgroundColor = [UIColor whiteColor];
    dateformatBtn.layer.borderWidth = 1;
    dateformatBtn.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0].CGColor;
    dateformatBtn.layer.cornerRadius = 0;
    [dateformatBtn addTarget:self action:@selector(changedateformat) forControlEvents:UIControlEventTouchUpInside];
    [profileScrollview addSubview:dateformatBtn];
    
    //dateformat Main Label init
    UILabel *dateformatMainLabel = [[UILabel alloc] init];
    dateformatMainLabel.frame = CGRectMake(self.view.frame.size.width*0.05, 2, self.view.frame.size.width, profileH/2);
    [dateformatMainLabel setTextColor:[UIColor blackColor]];
    dateformatMainLabel.text = NSLocalizedString(@"Select the date format", nil);
    dateformatMainLabel.font = [UIFont systemFontOfSize:20];
    dateformatMainLabel.alpha = 1.0;
    dateformatMainLabel.textAlignment = NSTextAlignmentLeft;
    [dateformatBtn addSubview:dateformatMainLabel];
    
    //selectdateFormat Label init
    selectdateFormatLabel = [[UILabel alloc] init];
    selectdateFormatLabel.frame = CGRectMake(self.view.frame.size.width*0.05, profileH/2, self.view.frame.size.width, profileH/2);
    [selectdateFormatLabel setTextColor:[UIColor blackColor]];
    selectdateFormatLabel.text = currentDateString;
    selectdateFormatLabel.font = [UIFont systemFontOfSize:15];
    selectdateFormatLabel.alpha = 1.0;
    selectdateFormatLabel.textAlignment = NSTextAlignmentLeft;
    [dateformatBtn addSubview:selectdateFormatLabel];
    
    
    //Delete Account
    UIButton *deleteAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //deleteAccountBtn.frame = CGRectMake(-1, self.view.frame.size.height*2, self.view.frame.size.width+2, profileH);
    deleteAccountBtn.frame = CGRectMake(-1, self.view.frame.size.height*1.9, self.view.frame.size.width+2, profileH);
    deleteAccountBtn.backgroundColor = [UIColor whiteColor];
    [deleteAccountBtn setTitle:NSLocalizedString(@"Delete Account", nil)  forState:UIControlStateNormal];
    [deleteAccountBtn setTitleColor:CIRCEL_RED forState:UIControlStateNormal];
    deleteAccountBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    deleteAccountBtn.layer.borderWidth = 1;
    deleteAccountBtn.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0].CGColor;
    deleteAccountBtn.layer.cornerRadius = 0;
    [deleteAccountBtn addTarget:self action:@selector(deleteAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [profileScrollview addSubview:deleteAccountBtn];
    profileScrollview.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(deleteAccountBtn.frame)+2);
    
}


//MyGoal objects which can show value
-(void)initWithMyGoalShowValueObjects {
    
    //MyGoal Systolic Pressure Label init
    //myGoal_systolicPressureLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+22+profileH , profileX1-profileX , profileH)];
     myGoal_systolicPressureLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+profileH , profileX1-profileX , profileH)];
    [myGoal_systolicPressureLabel setTextColor:[UIColor blackColor]];
    //Nick Fix
    //====> spStr <====
    myGoal_systolicPressureStr = [NSString stringWithFormat:@"%.0f",sys_pressure_value];
    //spStr = [NSString stringWithFormat:@"%.0f",sys_pressure_value];
    myGoal_systolicPressureLabel.text = myGoal_systolicPressureStr;
    myGoal_systolicPressureLabel.font = [UIFont systemFontOfSize:17];
    myGoal_systolicPressureLabel.alpha = 1.0;
    myGoal_systolicPressureLabel.textAlignment = NSTextAlignmentLeft;
    myGoal_systolicPressureLabel.userInteractionEnabled = sysActive;
    //myGoal_systolicPressureLabel.text = @"135"; //預設 135
    [profileScrollview addSubview:myGoal_systolicPressureLabel];
    
    
    
    //MyGoal Diastolic Pressurep Label init
    //myGoal_diastolicPressurepLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+22+profileH*2 , profileX1-profileX , profileH)];
    myGoal_diastolicPressurepLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+profileH*2 , profileX1-profileX , profileH)];
    [myGoal_diastolicPressurepLabel setTextColor:[UIColor blackColor]];
    //Nick Fix
    //====> dpStr <=====
    //dpStr = [NSString stringWithFormat:@"%.0f",dia_pressure_value];
    //myGoal_diastolicPressurepLabel.text = dpStr;
    myGoal_diastolicPressureStr = [NSString stringWithFormat:@"%.0f",dia_pressure_value];
    myGoal_diastolicPressurepLabel.text = myGoal_diastolicPressureStr;
    myGoal_diastolicPressurepLabel.font = [UIFont systemFontOfSize:17];
    myGoal_diastolicPressurepLabel.alpha = 1.0;
    myGoal_diastolicPressurepLabel.textAlignment = NSTextAlignmentLeft;
    myGoal_diastolicPressurepLabel.userInteractionEnabled = diaActive;
    //myGoal_diastolicPressurepLabel.text = @"85"; //預設 85
    [profileScrollview addSubview: myGoal_diastolicPressurepLabel];
    
    
    
    //MyGoal Weight Label init
    //myGoal_weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+22+profileH*3 , profileX1-profileX , profileH)];
    myGoal_weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+profileH*3 , profileX1-profileX , profileH)];
    [myGoal_weightLabel setTextColor:[UIColor blackColor]];

    [myGoal_weightLabel setTextColor:[UIColor blackColor]];
    //myGoal_weightLabel.text = @"75.0"; //預設 75.0
    myGoal_weightLabel.font = [UIFont systemFontOfSize:17];
    myGoal_weightLabel.adjustsFontSizeToFitWidth = YES;
    myGoal_weightLabel.alpha = 1.0;
    myGoal_weightLabel.textAlignment = NSTextAlignmentLeft;
    myGoal_weightLabel.userInteractionEnabled = goalWeightActive;
    [profileScrollview addSubview:myGoal_weightLabel];
    
    
    
    
    //MyGoal BMI Label init
    //myGoal_bmiLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+22+profileH*4 , self.view.frame.size.width/3 , profileH)];
    myGoal_bmiLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+profileH*4 , self.view.frame.size.width/3 , profileH)];
    [myGoal_bmiLabel setTextColor:[UIColor blackColor]];
    //myGoal_bmiLabel.text = @"23.0"; //預設 23.0
    myGoal_bmiLabel.font = [UIFont systemFontOfSize:17];
    myGoal_bmiLabel.alpha = 1.0;
    myGoal_bmiLabel.textAlignment = NSTextAlignmentLeft;
    myGoal_bmiLabel.userInteractionEnabled = BMIActive;
    [profileScrollview addSubview:myGoal_bmiLabel];
    
    
    
    //MyGoal Body Fat Label init
    //myGoal_bodyfatLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+22+profileH*5 , self.view.frame.size.width/3 , profileH)];
    myGoal_bodyfatLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY2+profileH*5 , self.view.frame.size.width/3 , profileH)];
    [myGoal_bodyfatLabel setTextColor:[UIColor blackColor]];
    myGoal_bodyfatLabel.text = @"20.0"; //預設 20.0
    myGoal_bodyfatLabel.font = [UIFont systemFontOfSize:17];
    myGoal_bodyfatLabel.alpha = 1.0;
    myGoal_bodyfatLabel.textAlignment = NSTextAlignmentLeft;
    myGoal_bodyfatLabel.userInteractionEnabled = bodyFatActive;
    [profileScrollview addSubview:myGoal_bodyfatLabel];
    
}


// SwitchBtns init
-(void)initWithSwitchBts {
    
    //MyGoal Systolic Pressure
    //UISwitch *systolicswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+profileH+22+(profileH-31)/2, switch_w, switch_h)];
    systolicswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+profileH+(profileH-31)/2, switch_w, switch_h)];
    [systolicswitch setOn:sysActive];
    [systolicswitch addTarget:self action:@selector(systolicswitchAction:) forControlEvents:UIControlEventValueChanged];
    [profileScrollview addSubview:systolicswitch];
    
    //MyGoal Diastolic Pressure
    //UISwitch *diastolicswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+22+profileH*2+(profileH-31)/2, switch_w, switch_h)];
    diastolicswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+profileH*2+(profileH-31)/2, switch_w, switch_h)];
    [diastolicswitch setOn:diaActive];
    myGoal_systolicPressureLabel.userInteractionEnabled = sysActive;
    [diastolicswitch addTarget:self action:@selector(diastolicswitchAction:) forControlEvents:UIControlEventValueChanged];
    [profileScrollview addSubview:diastolicswitch];
    
    //MyGoal Weight
    //UISwitch *goalWeightswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+22+profileH*3+(profileH-31)/2, switch_w, switch_h)];
    goalWeightswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+profileH*3+(profileH-31)/2, switch_w, switch_h)];
    [goalWeightswitch setOn:goalWeightActive];
    [goalWeightswitch addTarget:self action:@selector(goalWeightswitchAction:) forControlEvents:UIControlEventValueChanged];
    [profileScrollview addSubview:goalWeightswitch];
    
    //MyGoal BMI
    //UISwitch *BMIswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+22+profileH*4+(profileH-31)/2, switch_w, switch_h)];
    BMIswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+profileH*4+(profileH-31)/2, switch_w, switch_h)];
    [BMIswitch setOn:BMIActive];
    [BMIswitch addTarget:self action:@selector(BMIswitchAction:) forControlEvents:UIControlEventValueChanged];
    [profileScrollview addSubview:BMIswitch];
    
    //MyGoal Body Fat
    //UISwitch *Bodyswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+22+profileH*5+(profileH-31)/2, switch_w, switch_h)];
    Bodyswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, profileY2+profileH*5+(profileH-31)/2, switch_w, switch_h)];
    [Bodyswitch setOn:bodyFatActive];
    [Bodyswitch addTarget:self action:@selector(BodyswitchAction:) forControlEvents:UIControlEventValueChanged];
    [profileScrollview addSubview:Bodyswitch];
    
    //Threshold
    //UISwitch *thresholdswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, self.view.frame.size.height*1.69+(profileH-31)/2, switch_w, switch_h)];
    thresholdswitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, self.view.frame.size.height*1.6+(profileH-31)/2, switch_w, switch_h)];
    [thresholdswitch setOn:thresholdActive];
    [thresholdswitch addTarget:self action:@selector(thresholdswitchAction:) forControlEvents:UIControlEventValueChanged];
    [profileScrollview addSubview:thresholdswitch];

}


#pragma mark - UI 物件增加手勢  *******************************
-(void)objectAddGesture {
    
    //ProFile **************************
    //GestureRecognizer for birthdayLabel
    birtapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBirthdaySelection)];
    birtapGestureRecognizer.numberOfTapsRequired = 1;
    [birthdayLabel addGestureRecognizer:birtapGestureRecognizer];

    
    //GestureRecognizer for height Label (cm)
    UITapGestureRecognizer *heighttapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMetricHeightSelection)];
    heighttapGestureRecognizer.numberOfTapsRequired = 1;
    [heightLabel_cm_value addGestureRecognizer:heighttapGestureRecognizer];
    
    
    //GestureRecognizer for heightLabel_ft_value (ft)
    UITapGestureRecognizer *height1tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImperHeightSelection)];
    height1tapGestureRecognizer.numberOfTapsRequired = 1;
    [heightLabel_ft_value addGestureRecognizer:height1tapGestureRecognizer];
    
    
    //GestureRecognizer for height2 Label (inch)
    UITapGestureRecognizer *height2tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImperHeightSelection)];
    height2tapGestureRecognizer.numberOfTapsRequired = 1;
    [heightLabel_inch_value addGestureRecognizer:height2tapGestureRecognizer];
    
    
    //GestureRecognizer for weight Label
    UITapGestureRecognizer *weighttapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMetricWeightSelection)];
    weighttapGestureRecognizer.numberOfTapsRequired = 1;
    [weightLabel addGestureRecognizer:weighttapGestureRecognizer];
    
    
    //GestureRecognizer for cuff Size Label
    UITapGestureRecognizer *CuffSizetapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCuffSizeSelection)];
    CuffSizetapGestureRecognizer.numberOfTapsRequired = 1;
    [cuffSizeLabel addGestureRecognizer:CuffSizetapGestureRecognizer];
    
    
    //GestureRecognizer for Measure Arm Label
    UITapGestureRecognizer *MeaArmtapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMeaArmSelection)];
    MeaArmtapGestureRecognizer.numberOfTapsRequired = 1;
    [measureArmLabel addGestureRecognizer:MeaArmtapGestureRecognizer];
    
    
    //MyGoal **************************
    //GestureRecognizer for MyGoal systolic Pressure Label
    UITapGestureRecognizer *sptapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSystolicPressureSelection)];
    sptapGestureRecognizer.numberOfTapsRequired = 1;
    [myGoal_systolicPressureLabel addGestureRecognizer:sptapGestureRecognizer];
    
    
    //GestureRecognizer for MyGoal Diastolic Pressurep Label
    UITapGestureRecognizer *dptapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDiastolicPressureSelection)];
    dptapGestureRecognizer.numberOfTapsRequired = 1;
    [myGoal_diastolicPressurepLabel addGestureRecognizer:dptapGestureRecognizer];
    
    
    //GestureRecognizer for MyGoal weight Label
    UITapGestureRecognizer *wtapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMyGoalWeightSelection)];
    wtapGestureRecognizer.numberOfTapsRequired = 1;
    [myGoal_weightLabel addGestureRecognizer:wtapGestureRecognizer];
    
    
    //GestureRecognizer for MyGoal BMI Label
    UITapGestureRecognizer *bmitapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMyGoalBMISelection)];
    bmitapGestureRecognizer.numberOfTapsRequired = 1;
    [myGoal_bmiLabel addGestureRecognizer:bmitapGestureRecognizer];
    
    //
    UITapGestureRecognizer *btapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMyGoalBodyFatSelection)];
    btapGestureRecognizer.numberOfTapsRequired = 1;
    [myGoal_bodyfatLabel addGestureRecognizer:btapGestureRecognizer];
    
}



#pragma mark - 日期格式 *******************************
-(void)changedateformat {
    
    NSDate *currentDate=[NSDate date];
    NSDateFormatter *ymdformatter = [[NSDateFormatter alloc] init];
    [ymdformatter setDateStyle:NSDateFormatterShortStyle];
    [ymdformatter setTimeStyle:NSDateFormatterMediumStyle];
    [ymdformatter setDateFormat:@"YYYY/MM/dd"];
    NSString *ymdDateString = [ymdformatter stringFromDate:currentDate];
    
    NSDateFormatter *mdyformatter = [[NSDateFormatter alloc] init];
    [mdyformatter setDateStyle:NSDateFormatterShortStyle];
    [mdyformatter setTimeStyle:NSDateFormatterMediumStyle];
    [mdyformatter setDateFormat:@"MM/dd/YYYY"];
    NSString *mdyDateString = [mdyformatter stringFromDate:currentDate];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Select the Date Format" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yyyymmddAction = [UIAlertAction actionWithTitle:ymdDateString style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        
        if (dateformatBool == 1) {
            
            [self setDateFormatToYYYYMMdd];
            dateformatBool = 0;
            
        }
        else if (dateformatBool == 0){
            
            dateformatBool = 0;
        }
        
    }];
    
    [alertController addAction:yyyymmddAction];
    
    
    UIAlertAction *mmddyyyyAction = [UIAlertAction actionWithTitle:mdyDateString style:UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        
        if (dateformatBool == 1) {
            
            dateformatBool = 1;
        }
        else if (dateformatBool == 0){
            
            [self setDateFormatToMMddYYYY];
            dateformatBool = 1;
        }
        
    }];
    
    [alertController addAction:mmddyyyyAction];
    
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:closeAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}


//日期格式: YYYY-MM-dd
-(void)setDateFormatToYYYYMMdd {
    
    NSDate *currentDate=[NSDate date];
    //取得生日label字串並轉成日期
    NSDateFormatter *birdateFormatter = [[NSDateFormatter alloc] init];
    [birdateFormatter setDateFormat:@"MM/dd/YYYY"];
    //NSDate *birthDate=[birdateFormatter dateFromString:birthdayLabel.text];
    
    if (birthday_date != nil) {
        
         birthday_date = [birdateFormatter dateFromString:birthdayDate];
    }
    else {
        birthday_date = [birdateFormatter dateFromString:birthdayLabel.text];
    }
    
        
    NSDateFormatter *ymdformatter = [[NSDateFormatter alloc] init];
    [ymdformatter setDateStyle:NSDateFormatterShortStyle];
    [ymdformatter setTimeStyle:NSDateFormatterMediumStyle];
    [ymdformatter setDateFormat:@"YYYY/MM/dd"];
    NSString  *birthString = [ymdformatter stringFromDate:birthday_date];
    
    
    currentDateString = [ymdformatter stringFromDate:currentDate];
    NSLog(@"birth_Date === %@",birthday_date);
    NSLog(@"birthDateString === %@",birthString);
    NSLog(@"currentDateString === %@",currentDateString);
    NSLog(@"birthdaydate === %@",birthdayDate);
    
    
    selectdateFormatLabel.text = currentDateString;
    birthdayLabel.text = birthString;
    
#warning Test
    NSLog(@"(YYYYMMdd)selectdateFormatLabel.text:%@ (YYYYMMdd)birthdayLabel.text:%@",selectdateFormatLabel.text,birthdayLabel.text);
    
}


//日期格式: MM-dd-YYYY
-(void)setDateFormatToMMddYYYY {
    
    NSDate *currentDate=[NSDate date];
    
    //取得生日label字串並轉成日期
    NSDateFormatter *birdateFormatter = [[NSDateFormatter alloc] init];
    [birdateFormatter setDateFormat:@"YYYY/MM/dd"];
    //NSDate *birthDate=[birdateFormatter dateFromString:birthdayLabel.text];
    

    if (birthday_date != nil) {
        birthday_date = [birdateFormatter dateFromString:birthdayDate];
    }
    else {
        birthday_date = [birdateFormatter dateFromString:birthdayLabel.text];
    }
    
    
    NSDateFormatter *mdyformatter = [[NSDateFormatter alloc] init];
    [mdyformatter setDateStyle:NSDateFormatterShortStyle];
    [mdyformatter setTimeStyle:NSDateFormatterMediumStyle];
    [mdyformatter setDateFormat:@"MM/dd/YYYY"];
    
    //日期再轉成格式為MM/dd/YYYY的生日字串
    NSString *birthString = [mdyformatter stringFromDate:birthday_date];
    
    currentDateString = [mdyformatter stringFromDate:currentDate];
    
    NSLog(@"birth_Date === %@",birthday_date);
    NSLog(@"birthDateString === %@",birthString);
    NSLog(@"currentDateString === %@",currentDateString);
    NSLog(@"birthdaydate === %@",birthdayDate);
    
    selectdateFormatLabel.text = currentDateString;
    birthdayLabel.text = birthString;
    
#warning Test
    NSLog(@"(MMddYYYY)selectdateFormatLabel.text:%@ (MMddYYYY)birthdayLabel.text:%@",selectdateFormatLabel.text,birthdayLabel.text);
}


#pragma mark - switch Action  *******************************

//Systolic Pressure
-(void)systolicswitchAction:(id)sender{
    
    UISwitch *systolicswitch = (UISwitch*)sender;
    
    BOOL isButtonOn = [systolicswitch isOn];
    
    if (isButtonOn) {
        
        myGoal_systolicPressureLabel.userInteractionEnabled = YES;
        
        sysActive = YES;
        
        NSLog(@"systolic on");
    }
    else {
        
        myGoal_systolicPressureLabel.userInteractionEnabled = NO;
        
        sysActive = NO;
        
        NSLog(@"systolic off");
    }
    
    NSLog(@"myGoal_systolicPressureLabel.isUserInteractionEnabled = %d",myGoal_systolicPressureLabel.isUserInteractionEnabled);
    
    
}


//Diastolic Pressure
-(void)diastolicswitchAction:(id)sender{
    UISwitch *diastolicswitch = (UISwitch*)sender;
    BOOL isButtonOn = [diastolicswitch isOn];
    if (isButtonOn) {
        
        myGoal_diastolicPressurepLabel.userInteractionEnabled = YES;
        
        diaActive = YES;
        //showSwitchValue.text = @"是";
        NSLog(@"diastolic on");
    }
    else {
        //showSwitchValue.text = @"否";
        diaActive = NO;
        myGoal_diastolicPressurepLabel.userInteractionEnabled = NO;
        NSLog(@"diastolic off");
    }
}


//My Goal Weight
-(void)goalWeightswitchAction:(id)sender{
    UISwitch *goalWeightswitch = (UISwitch*)sender;
    BOOL isButtonOn = [goalWeightswitch isOn];
    if (isButtonOn) {
        
        
        myGoal_weightLabel.userInteractionEnabled = YES;
        
        goalWeightActive = YES;
        //showSwitchValue.text = @"是";
        NSLog(@"goalWeight on");
    }
    else {
        goalWeightActive = NO;
        myGoal_weightLabel.userInteractionEnabled = NO;
        //showSwitchValue.text = @"否";
        NSLog(@"goalWeight off");
    }
}


//My Goal BMI
-(void)BMIswitchAction:(id)sender{
    UISwitch *BMIswitch = (UISwitch*)sender;
    BOOL isButtonOn = [BMIswitch isOn];
    if (isButtonOn) {
        
         myGoal_bmiLabel.userInteractionEnabled = YES;
        
        BMIActive = YES;
        
        //showSwitchValue.text = @"是";
        NSLog(@"BMI on");
    }else {
        //showSwitchValue.text = @"否";
        BMIActive = NO;
        myGoal_bmiLabel.userInteractionEnabled = NO;
        NSLog(@"BMI off");
    }
}


//My Goal Body Fat
-(void)BodyswitchAction:(id)sender{
    
    UISwitch *Bodyswitch = (UISwitch*)sender;
    
    BOOL isButtonOn = [Bodyswitch isOn];
    
    if (isButtonOn) {
        
        //讓label可點擊產生事件
//        UITapGestureRecognizer *btapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMyGoalBodyFatSelection)];
//        btapGestureRecognizer.numberOfTapsRequired = 1;
//        [myGoal_bodyfatLabel addGestureRecognizer:btapGestureRecognizer];
        myGoal_bodyfatLabel.userInteractionEnabled = YES;
        bodyFatActive = YES;
        NSLog(@"Body on");
    }
    else {
        
        bodyFatActive = NO;
        myGoal_bodyfatLabel.userInteractionEnabled = NO;
        NSLog(@"Body off");
    }
}


//Thres hold
-(void)thresholdswitchAction:(id)sender{
    UISwitch *thresholdswitch = (UISwitch*)sender;
    BOOL isButtonOn = [thresholdswitch isOn];
    thresholdCount ++;
    
    
    if (isButtonOn) {
        //showSwitchValue.text = @"是";
        
        if (thresholdCount < 2) {
            
            NSString *alertTitle = NSLocalizedString(@"OPEN the Threshold & Target value displayed on the graph.", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil)  style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:confirmAction];
            
            thresholdActive = YES;
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        NSLog(@"threshold on");
    }
    else {
        //showSwitchValue.text = @"否";
        thresholdActive = NO;
        
        NSLog(@"threshold off");
    }
    
    NSLog(@"%d",thresholdCount);
    
}



#pragma mark - 刪除帳號資料  *******************************
-(void)deleteAccountAction{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"Are you sure to delete your account and all records in APP ?", nil)  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDestructive handler: ^(UIAlertAction * _Nonnull action) {
        
        NavViewController *nav = [[NavViewController alloc] init];
        [self presentViewController:nav animated:YES completion:nil];
        
        
        /**
        UIViewController *LoginVC = [[UIViewController alloc ]init];
        
        LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        
        LoginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:LoginVC animated:true completion:nil];
         */
        
    }];
    
    [alertController addAction:resetAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    

    
    
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - PickerView Delegate  *******************************
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (pickerView == heightPickerView_cm || pickerView == weightPickerView  || pickerView == heightPickerView_ft || pickerView == heightPickerView_inch) {
        
        return 2;
    }
    else{
        
        return 1;
    }

}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ( thePickerView == heightPickerView_cm ) {
        
        switch (component) {
            case 0:
                return ary_heightData.count;
                break;
            case 1:
                return  h_cm_unit.count;
                break;
            default:
                return 0;
                break;
        }
    
    }
    else if( thePickerView == weightPickerView ){
        
        switch (component) {
            case 0:
                return ary_weightData.count;
                break;
            case 1:
                return  w_unit.count;
                break;
            default:
                return 0;
                break;
        }
    }
    else if( thePickerView == heightPickerView_ft ){
        
        switch (component) {
            case 0:
                return ary_heigh_ftData.count;
                break;
            case 1:
                return h_ft_unit.count;
                break;
            default:
                return 0;
                break;
        }
        
    }
    else if( thePickerView == heightPickerView_inch ){
        
        switch (component) {
            case 0:
                return ary_heigh_inchData.count;
                break;
            case 1:
                return h_inch_unit.count;
                break;
            default:
                return 0;
                break;
        }
        
    }
    else if( thePickerView == myGoal_sysPickerView ){
        NSLog(@"sys");
        switch (component) {
            case 0:
                return ary_myGoal_sysData.count;
                break;
            case 1:
                return 0;
                break;
            default:
                return 0;
                break;
        }
    }
    else if( thePickerView == myGoal_diaPickerView ){
        NSLog(@"dia");
        switch (component) {
            case 0:
                return ary_myGoal_diaData.count;
            case 1:
                return 0;
                break;
            default:
                return 0;
                break;
        }
        
    }
    else if( thePickerView == myGoal_weightPickerView ){
        
        return ary_myGoal_weightData.count;
        
    }
    else if( thePickerView == myGoal_bmiPickerView ){
        
        
        return ary_myGoal_bmiData.count;
        
    }
    else if( thePickerView == myGoal_bodyfatPickerView ){
        
        
        return ary_myGoal_bodyfatData.count;
        
        
    }
    else if( thePickerView == cuffSizwPickerView){
        
        return ary_cuffSizeData.count;
        
    }
    else if ( thePickerView == measureArmPickerView){
        
        return ary_measureArmData.count;
    }
    else{
        
        return 0;
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if ( thePickerView == heightPickerView_cm ){
        switch (component) {
            case 0:
                return[ary_heightData objectAtIndex:row];
                break;
            case 1:
                return[h_cm_unit objectAtIndex:row];
                break;
            default:
                return 0;
                break;
        }
    }
    else if( thePickerView == weightPickerView ){
        
        switch (component) {
            case 0:
                return [ary_weightData objectAtIndex:row];
                break;
            case 1:
                return[w_unit objectAtIndex:row];
                break;
            default:
                return 0;
                break;
        }
    }
    else if ( thePickerView == heightPickerView_ft ){
        
        switch (component) {
            case 0:
                return [ary_heigh_ftData objectAtIndex:row];
                break;
            case 1:
                return [h_ft_unit objectAtIndex:row] ;
                break;
            default:
                return 0;
                break;
        }
        
    }
    else if ( thePickerView == heightPickerView_inch ){
        
        switch (component){
            case 0:
                return [ary_heigh_inchData objectAtIndex:row];
                break;
            case 1:
                return [h_inch_unit objectAtIndex:row];
                break;
            default:
                return 0;
                break;
        }
        
    }
    else if ( thePickerView == myGoal_sysPickerView ){
        
        switch (component){
            case 0:
                return [ary_myGoal_sysData objectAtIndex:row];
                break;
            case 1:
                return 0 ;
                break;
            default:
                return 0;
                break;
        }
    }
    else if ( thePickerView == myGoal_diaPickerView ){
        
        switch (component){
            case 0:
                return [ary_myGoal_diaData objectAtIndex:row];
                break;
            case 1:
                return 0 ;
                break;
            default:
                return 0;
                break;
        }
    }
    else if ( thePickerView == myGoal_weightPickerView ){
        
        NSLog(@"wPickerView =========>>>>>");
        return [ary_myGoal_weightData objectAtIndex:row];
        
    }
    else if ( thePickerView == myGoal_bmiPickerView ){
        
        return [ary_myGoal_bmiData objectAtIndex:row];
        
    }
    else if ( thePickerView == myGoal_bodyfatPickerView ){
        
        return [ary_myGoal_bodyfatData objectAtIndex:row];
        
    }
    else if ( thePickerView == cuffSizwPickerView ){
        
        return [ary_cuffSizeData objectAtIndex:row];
        
    }
    else if ( thePickerView == measureArmPickerView ){
        
        return [ary_measureArmData objectAtIndex:row];
        
    }
    else{
        return 0;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if ( pickerView == heightPickerView_cm ){
        
        switch (component) {
            case 0:
                heightStr_cm  = [ary_heightData objectAtIndex:row];
                break;
            case 1:
                cmLabel.text = [h_cm_unit objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    else if( pickerView == weightPickerView ){
        
        switch (component) {
            case 0:
                weightStr = [ary_weightData objectAtIndex:row];
                break;
            case 1:
                kgLabel.text = [w_unit objectAtIndex:row];
                break;
            default:
                break;
            
        }
    }
    else if( pickerView == myGoal_sysPickerView ){
        
        switch (component) {
            case 0:
                myGoal_systolicPressureStr = [ary_myGoal_sysData objectAtIndex:row];
                break;
            case 1:
                break;
            default:
                break;
        }
        
    }
    else if( pickerView == myGoal_diaPickerView ){
        switch (component) {
            case 0:
                myGoal_diastolicPressureStr = [ary_myGoal_diaData objectAtIndex:row];
                break;
            case 1:
                break;
            default:
                break;
        
        }
    }
    else if( pickerView == heightPickerView_ft ){
        
        switch (component) {
            case 0:
                heightStr_ft = [ary_heigh_ftData objectAtIndex:row];
                break;
            case 1:
                break;
            default:
                break;
        }
        
        
    }
    else if( pickerView == heightPickerView_inch ){
        
        switch (component) {
            case 0:
                heightStr_inch = [ary_heigh_inchData objectAtIndex:row];
                break;
            case 1:
                break;
            default:
                break;
        }
        
    }
    else if( pickerView == myGoal_weightPickerView ){
        
        mtGoal_weightStr = [ary_myGoal_weightData objectAtIndex:row];
        
    }
    else if( pickerView == myGoal_bmiPickerView ){
        
        myGoal_BMIStr = [ary_myGoal_bmiData objectAtIndex:row];
        
    }
    else if( pickerView == myGoal_bodyfatPickerView ){
        
        myGoal_bodyFatStr = [ary_myGoal_bodyfatData objectAtIndex:row];
        
    }
    else if ( pickerView == cuffSizwPickerView ){
        
        cuffSizeStr = [ary_cuffSizeData objectAtIndex:row];
        cuffsize_row = row;
        
    }
    else if ( pickerView == measureArmPickerView ){
        
        measureArmStr = [ary_measureArmData objectAtIndex:row];
        measureArm_row = row;
        
    }
    else{
        
        NSLog(@"nothing");
    }
    
}


//設置每一列的寬度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0.0f;
    
    switch (component) {
        case 0:
            width = 70;
            break;
        case 1:
            width = 60;
            break;
        case 2:
            width = 70;
            break;
        case 3:
            width = 60;
            break;
        default:
            break;
    }
    
    return width;
}


#pragma mark - Show Profile PickerView   *******************************
//All PickerView 顯示前置作業
-(void)forAllPickerViewToShow {
    
    //coverView
    if (coverView == nil) {
        
        coverView = [UIButton buttonWithType:UIButtonTypeCustom];
        coverView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        coverView.hidden = YES;
        [self.view addSubview:coverView];
    }
    
    coverView.hidden = NO;

    allPickerView_BG = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.66, self.view.frame.size.width, self.view.frame.size.height)];
    allPickerView_BG.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [self.view addSubview:allPickerView_BG];
    
    //allPickerView.hidden = true;
    
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.66, self.view.frame.size.width, self.view.frame.size.height/17)];
    topView.backgroundColor = TABLE_BACKGROUND;
    [self.view addSubview:topView];
    
    //topView.hidden = true;
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [closeBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [closeBtn addTarget:self action:@selector(cancelpickerClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:closeBtn];
    
}

//Birthday
-(void)showBirthdaySelection {
    
    [self forAllPickerViewToShow];
    
    //日期選擇器
    birDatepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.66+33, self.view.frame.size.width, self.view.frame.size.height*0.3)];
    birDatepicker.hidden = NO;
    //NSDate *date = [[NSDate alloc] initWithString:@""];
    // birDatepicker.date = [NSDate date];  // 設置初始時間
    
    birDatepicker.datePickerMode = UIDatePickerModeDate;  //設置日期樣式
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if (dateformatBool == 0) {
        
        [dateFormat setDateFormat:@"YYYY/MM/dd"];
        NSDate *anyDate = [dateFormat dateFromString:birthdayLabel.text];
        [birDatepicker setDate:anyDate];
    }
    else if (dateformatBool == 1) {
        
        [dateFormat setDateFormat:@"MM/dd/YYYY"];
        NSDate *anyDate = [dateFormat dateFromString:birthdayLabel.text];
        [birDatepicker setDate:anyDate];
    }
    
    [birDatepicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    //NSString *datepicker = [dateFormat stringFromDate:birDatepicker.date];
    [self.view addSubview:birDatepicker]; // 添加到View上
    
    
    //birDatepicker 禁止輸入未來日期
    birDatepicker.maximumDate = [NSDate date];
    
    
    CGRect blabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *bLabel = [[UILabel alloc] initWithFrame:blabelFrame];
    [bLabel setTextColor:[UIColor blackColor]];
    bLabel.text = @"Birthday";
    bLabel
    .font = [UIFont systemFontOfSize:22];
    bLabel.alpha = 1.0;
    bLabel.textAlignment = NSTextAlignmentCenter;
    
    [topView addSubview:bLabel];
    
    UIButton *savebirBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savebirBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savebirBtn setTitle: NSLocalizedString(@"Save", nil)  forState:UIControlStateNormal];
    [savebirBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savebirBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savebirBtn addTarget:self action:@selector(birthdaySaveAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:savebirBtn];
    
}

-(void)dateChanged:(id)sender{
    
    NSDate *select = [sender date]; // 獲取被選中的時間
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    if (dateformatBool == 0) {
        selectDateFormatter.dateFormat = @"YYYY/MM/dd"; // 設置時間和日期的格式
    }else if (dateformatBool == 1){
        selectDateFormatter.dateFormat = @"MM/dd/YYYY"; // 設置時間和日期的格式
    }
    
    
    birthdayDate = [selectDateFormatter stringFromDate:select]; // 把date類型轉為設置好格式的string類型
    
    //透過UIDatePicker的date屬性取得使用者選取的日期, 並透過NSDateFormatter轉換成字串
    //    NSString *date = [NSDateFormatter stringFromDate:picker.date];
    
    //設定標籤的文字為選取日期的文字
    
    
    NSLog(@"生日為 =====> %@",birthdayDate);
    
    NSLog(@"%@",[sender date]);
    
}


//Metric Height
-(void)showMetricHeightSelection {
    
    [self forAllPickerViewToShow];
    
    heightPickerView_cm = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.3,30, self.view.frame.size.width*0.4, self.view.frame.size.height*0.3)];
    
    //初始化数据
    


    //设置pickerView的代理和数据源
    heightPickerView_cm.dataSource = self;
    heightPickerView_cm.delegate = self;
    
    
    int hvalue = [heightLabel_cm_value.text intValue];
    
    
    [heightPickerView_cm selectRow:hvalue-91 inComponent:0 animated:NO];
    

    CGRect hlabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *hLabel = [[UILabel alloc] initWithFrame:hlabelFrame];
    [hLabel setTextColor:[UIColor blackColor]];
    hLabel.text = @"Height";
    hLabel.font = [UIFont systemFontOfSize:22];
    hLabel.alpha = 1.0;
    hLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [allPickerView_BG addSubview:heightPickerView_cm];
    
    
    [topView addSubview:hLabel];
    
  
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(saveheightClick) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:savehBtn];
    
}

-(void)saveheightClick{
    [self closePickerviewfunc];
    
    if (heightStr_cm != nil) {
        
        heightLabel_cm_value.text = heightStr_cm;
        height_value = [heightStr_cm floatValue];
    }
}

//Imperial height
-(void)showImperHeightSelection{
    
    [self forAllPickerViewToShow];
    //  [self pickertopView];
    
    
    heightPickerView_ft = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1,30, self.view.frame.size.width*0.4, self.view.frame.size.height*0.3)];
    
    heightPickerView_inch = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5,30, self.view.frame.size.width*0.4, self.view.frame.size.height*0.3)];
    
    //初始化数据
    
    //身高
    
   
    
    //设置pickerView的代理和数据源
    heightPickerView_ft.dataSource = self;
    heightPickerView_ft.delegate = self;
    
    heightPickerView_inch.dataSource = self;
    heightPickerView_inch.delegate = self;
    
    
    int hvalue = [heightLabel_ft_value.text intValue];
    //double h1value = [height2Label.text doubleValue];
    
    [heightPickerView_ft selectRow:hvalue-3 inComponent:0 animated:NO];
    
    for (int i=0; i<ary_heigh_inchData.count; i++) {
        NSString *HinchStr = [NSString stringWithFormat:@"%@",[ary_heigh_inchData objectAtIndex:i]];
        
        if ([heightLabel_inch_value.text isEqualToString:HinchStr]) {
            NSLog(@"HinchStr===%@",HinchStr);
            NSLog(@"inch === %@",heightLabel_inch_value.text);
            [heightPickerView_inch selectRow:i inComponent:0 animated:NO];
            NSLog(@"pickerview i:%d",i);
        }
        
    }
    
    
    //3 3.37
    //7 2.61
    
    
    
    
    NSLog(@"ary_heigh_inchData.count === %lu",(unsigned long)ary_heigh_inchData.count);
    
    
    
    CGRect hlabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *hLabel = [[UILabel alloc] initWithFrame:hlabelFrame];
    [hLabel setTextColor:[UIColor blackColor]];
    hLabel.text = @"Height";
    hLabel.font = [UIFont systemFontOfSize:22];
    hLabel.alpha = 1.0;
    hLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [allPickerView_BG addSubview:heightPickerView_ft];
    [allPickerView_BG addSubview:heightPickerView_inch];
    
    [topView addSubview:hLabel];
    
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(metricHeightSaveAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:savehBtn];
    
}


//Metric Weight || Imperial Weight
-(void)showMetricWeightSelection{
    
    [self forAllPickerViewToShow];
    // [self pickertopView];
    
    weightPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.3,30, self.view.frame.size.width*0.4, self.view.frame.size.height*0.3)];
    
    //設置pickerView的代理和数据源
    weightPickerView.dataSource = self;
    weightPickerView.delegate = self;
    
    int wvalue = [weightLabel.text intValue];
    
    
    //ary_weightData & w_unit
    if (ary_weightData == nil) {
        
        ary_weightData = [[NSMutableArray alloc] init];
    }
    [ary_weightData removeAllObjects];
    
    
    if (w_unit == nil) {
        
        w_unit = [[NSMutableArray alloc] init];
    }
    [w_unit removeAllObjects];
    
    if (unitSegmentControl.selectedSegmentIndex == 0) {
        
        for(float w=5.0 ; w <= 150.0; w+=0.1) {
            
            [ary_weightData addObject:[NSString stringWithFormat:@"%.1f",w]];
        }
        
        [weightPickerView selectRow:wvalue-5 inComponent:0 animated:NO];
        
        [w_unit addObject:NSLocalizedString(@"kg", nil)];
        
        for (int i = 0; i<ary_weightData.count; i++) {
            
            NSString *wwStr = [NSString stringWithFormat:@"%@",[ary_weightData objectAtIndex:i]];
            
            if ([weightLabel.text isEqualToString:wwStr]) {
                NSLog(@" wwStr == %@",wwStr);
                
                [weightPickerView selectRow:i inComponent:0 animated:NO];
            }
            
        }
        
        
    }
    else if (unitSegmentControl.selectedSegmentIndex == 1){
        
        for(float w=11.0 ; w <= 331.0; w+=0.1) {
            
            [ary_weightData addObject:[NSString stringWithFormat:@"%.1f",w]];
        }
        
        for (int i=0; i<ary_weightData.count; i++) {
            NSString *wStr = [NSString stringWithFormat:@"%@",[ary_weightData objectAtIndex:i]];
            
            if ([weightLabel.text isEqualToString:wStr]) {
                [weightPickerView selectRow:i inComponent:0 animated:NO];
            }
            
        }
        
        [w_unit addObject:NSLocalizedString(@"lb", nil)];
    }
    
    
    
    CGRect weilabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *weiLabel = [[UILabel alloc] initWithFrame:weilabelFrame];
    [weiLabel setTextColor:[UIColor blackColor]];
    weiLabel.text = @"Weight";
    weiLabel.font = [UIFont systemFontOfSize:22];
    weiLabel
    .alpha = 1.0;
    weiLabel.textAlignment = NSTextAlignmentCenter;
    
    [allPickerView_BG addSubview:weightPickerView];
    
    [topView addSubview:weiLabel];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [saveBtn addTarget:self action:@selector(metricWeightSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:saveBtn];
}


//Cuff Size
-(void)showCuffSizeSelection{
    
    [self forAllPickerViewToShow];
    
    cuffSizwPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35,30, self.view.frame.size.width*0.33, self.view.frame.size.height*0.3)];
    //设置pickerView的代理和數據源
    cuffSizwPickerView.dataSource = self;
    cuffSizwPickerView.delegate = self;
    [allPickerView_BG addSubview: cuffSizwPickerView];
    
    if ([cuffSizeLabel.text  isEqual: @"S"] ) {
        
        [cuffSizwPickerView selectRow:0 inComponent:0 animated:NO];
    }
    else if ([cuffSizeLabel.text  isEqual: @"M-L"]) {
        
        [cuffSizwPickerView selectRow:2 inComponent:0 animated:NO];
    }
    else if ([cuffSizeLabel.text  isEqual: @"L"]) {
        
        [cuffSizwPickerView selectRow:3 inComponent:0 animated:NO];
    }
    else if ([cuffSizeLabel.text  isEqual: @"L-X"]) {
        
        [cuffSizwPickerView selectRow:4 inComponent:0 animated:NO];
    }
    else{
        
        [cuffSizwPickerView selectRow:1 inComponent:0 animated:NO];
    }
    
    
    
    
    CGRect clabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *cLabel = [[UILabel alloc] initWithFrame:clabelFrame];
    [cLabel setTextColor:[UIColor blackColor]];
    cLabel.text = @"Cuff Size";
    cLabel.font = [UIFont systemFontOfSize:22];
    cLabel.alpha = 1.0;
    cLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:cLabel];
    
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(cuffSizeSaveAction) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:savehBtn];
    
    
}


//Measure Arm
-(void)showMeaArmSelection {
    
    
    [self forAllPickerViewToShow];
    
    measureArmPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.3,30, self.view.frame.size.width*0.4, self.view.frame.size.height*0.3)];
    //设置pickerView的代理和数据源
    measureArmPickerView.dataSource = self;
    measureArmPickerView.delegate = self;
    [allPickerView_BG addSubview:measureArmPickerView];
    
    if ([measureArmLabel.text isEqual:@"Right"]) {
        [measureArmPickerView selectRow:1 inComponent:0 animated:NO];
    }else{
        [measureArmPickerView selectRow:0 inComponent:0 animated:NO];
    }
    
    
    
    CGRect clabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *cLabel = [[UILabel alloc] initWithFrame:clabelFrame];
    [cLabel setTextColor:[UIColor blackColor]];
    cLabel.text = @"Measurement Arm";
    cLabel.font = [UIFont systemFontOfSize:22];
    cLabel.alpha = 1.0;
    cLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:cLabel];
    
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(measureArmSaveAction) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:savehBtn];
    
    
}



#pragma mark - Show My Goals PickerView  *******************************
//MyGoal Systolic Pressure
-(void)showSystolicPressureSelection{
    [self forAllPickerViewToShow];
    
    myGoal_sysPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35,30, self.view.frame.size.width*0.33, self.view.frame.size.height*0.3)];
    
    //初始化数据
    
    //血壓
    
    if (ary_myGoal_sysData == nil) {
        
        ary_myGoal_sysData = [[NSMutableArray alloc] init];
    }
    
    [ary_myGoal_sysData removeAllObjects];
    
    //设置pickerView的代理和数据源
    myGoal_sysPickerView.dataSource = self;
    myGoal_sysPickerView.delegate = self;
    
    double sysvalue = [myGoal_systolicPressureLabel.text doubleValue];
    
    if (pressureSegmentControl.selectedSegmentIndex == 0) {
        
        for(int s=20 ; s <= 280; s++) {
            
            [ary_myGoal_sysData addObject:[NSString stringWithFormat:@"%d",s]];
        }
        
        [myGoal_sysPickerView selectRow:sysvalue-20 inComponent:0 animated:NO];
        
    }
    else if (pressureSegmentControl.selectedSegmentIndex == 1) {
        
        for (double s=2.6; s<=37.3; s = s+0.1 ) {
            
            [ary_myGoal_sysData addObject:[NSString stringWithFormat:@"%.1f",s]];
        }
        
        for (int i=0; i<ary_myGoal_sysData.count; i++) {
            
            NSString *SysStr = [NSString stringWithFormat:@"%@",[ary_myGoal_sysData objectAtIndex:i]];
            
            if ([myGoal_systolicPressureLabel.text isEqualToString:SysStr]) {
                
                [myGoal_sysPickerView selectRow:i inComponent:0 animated:NO];
            }
            
        }
        
        
    }
    
    
    
    CGRect slabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *sLabel = [[UILabel alloc] initWithFrame:slabelFrame];
    [sLabel setTextColor:[UIColor blackColor]];
    sLabel.text = @"Systolic Pressure";
    sLabel.font = [UIFont systemFontOfSize:22];
    sLabel.alpha = 1.0;
    sLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [allPickerView_BG addSubview:myGoal_sysPickerView];
    
    
    [topView addSubview:sLabel];
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(saveMyGoalSysAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:savehBtn];
    
    
}


//MyGoal Diastolic Pressure
-(void)showDiastolicPressureSelection {
    [self forAllPickerViewToShow];
    
    myGoal_diaPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35,30, self.view.frame.size.width*0.33, self.view.frame.size.height*0.3)];
    
    //初始化数据
    //血壓
    
    if (ary_myGoal_diaData == nil) {
        
        ary_myGoal_diaData = [[NSMutableArray alloc] init];
    }
    
    [ary_myGoal_diaData removeAllObjects];
    
    //设置pickerView的代理和数据源
    myGoal_diaPickerView.dataSource = self;
    myGoal_diaPickerView.delegate = self;
    
    
    double diavalue = [myGoal_diastolicPressurepLabel.text doubleValue];
    
    if (pressureSegmentControl.selectedSegmentIndex == 0) {
        
        for(double d = 20 ; d <= 280; d++) {
            
            [ary_myGoal_diaData addObject:[NSString stringWithFormat:@"%.0f",d]];
        }
        
        [myGoal_diaPickerView selectRow:diavalue-20 inComponent:0 animated:NO];
        
    }else if (pressureSegmentControl.selectedSegmentIndex == 1){
        
        for(double d = 2.6 ; d <= 37.3; d = d+0.1 ){
            
            [ary_myGoal_diaData addObject:[NSString stringWithFormat:@"%.1f",d]];
        }
        
        for (int i=0; i < ary_myGoal_diaData.count; i++) {
            
            NSString *DiaStr = [NSString stringWithFormat:@"%@",[ary_myGoal_diaData objectAtIndex:i]];
            
            if ([myGoal_diastolicPressurepLabel.text isEqualToString:DiaStr]) {
                
                NSLog(@"DiaStr = %@",DiaStr);
                
                [myGoal_diaPickerView selectRow:i inComponent:0 animated:NO];
            }
        }
        
        
        //[diaPickerView selectRow:(diavalue-2.6)*10 inComponent:0 animated:NO];
        
    }
    
    
    
    [allPickerView_BG addSubview:myGoal_diaPickerView];
    
    CGRect dlabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *dLabel = [[UILabel alloc] initWithFrame:dlabelFrame];
    [dLabel setTextColor:[UIColor blackColor]];
    dLabel.text = @"Diastolic Pressure";
    dLabel.font = [UIFont systemFontOfSize:22];
    dLabel.alpha = 1.0;
    dLabel.textAlignment = NSTextAlignmentCenter;
    
    [topView addSubview:dLabel];
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(saveMyGoalDiaAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:savehBtn];
}



//MyGoal Weight
-(void)showMyGoalWeightSelection {
    [self forAllPickerViewToShow];
    
    myGoal_weightPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35,30, self.view.frame.size.width*0.33, self.view.frame.size.height*0.3)];
    
    //初始化数据
    
    //體重
    if (ary_myGoal_weightData == nil) {
        
        ary_myGoal_weightData = [[NSMutableArray alloc] init];
    }
    
    [ary_myGoal_weightData removeAllObjects];
    
    //设置pickerView的代理和数据源
    myGoal_weightPickerView.dataSource = self;
    myGoal_weightPickerView.delegate = self;
    
    //double wwvalue = [wLabel.text doubleValue];
    
    if (unitSegmentControl.selectedSegmentIndex == 0) {
        
        for(double w=5.0 ; w <= 150.0; w+=0.1) {
            
            [ary_myGoal_weightData addObject:[NSString stringWithFormat:@"%.1f",w]];
        }
        
        for (int i = 0; i<ary_myGoal_weightData.count; i++) {
            NSString *wwStr = [NSString stringWithFormat:@"%@",[ary_myGoal_weightData objectAtIndex:i]];
            
            if ([myGoal_weightLabel.text isEqualToString:wwStr]) {
                NSLog(@" wwStr == %@",wwStr);
                
                [myGoal_weightPickerView selectRow:i inComponent:0 animated:NO];
            }
            
        }
        
        
        
    }else if (unitSegmentControl.selectedSegmentIndex == 1){
        
        for(double w=11.0 ; w <= 331.0; w+=0.1) {
            
            [ary_myGoal_weightData addObject:[NSString stringWithFormat:@"%.1f",w]];
        }
        
        for (int i = 0; i<ary_myGoal_weightData.count; i++) {
            
            NSString *wwStr = [NSString stringWithFormat:@"%@",[ary_myGoal_weightData objectAtIndex:i]];
            
            if ([myGoal_weightLabel.text isEqualToString:wwStr]) {
                NSLog(@" wwStr == %@",wwStr);
                
                [myGoal_weightPickerView selectRow:i inComponent:0 animated:NO];
            }
            
        }
        
        
    }
    
    
    
    CGRect slabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *sLabel = [[UILabel alloc] initWithFrame:slabelFrame];
    [sLabel setTextColor:[UIColor blackColor]];
    sLabel.text = @"Weight";
    sLabel.font = [UIFont systemFontOfSize:22];
    sLabel.alpha = 1.0;
    sLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [allPickerView_BG addSubview:myGoal_weightPickerView];
    
    
    [topView addSubview:sLabel];
    
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(saveMyGoalWeiAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:savehBtn];
}



//MyGoal BMI
-(void)showMyGoalBMISelection{
    
    [self forAllPickerViewToShow];
    
    myGoal_bmiPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35,30, self.view.frame.size.width*0.33, self.view.frame.size.height*0.3)];
    
    //初始化数据
    
    //BMI
    if (ary_myGoal_bmiData == nil) {
        
        ary_myGoal_bmiData = [[NSMutableArray alloc] init];
    }
    
    [ary_myGoal_bmiData removeAllObjects];
    
    //设置pickerView的代理和数据源
    myGoal_bmiPickerView.dataSource = self;
    myGoal_bmiPickerView.delegate = self;
    
    
    for(float s=10.0 ; s <= 90.0; s+=0.1) {
        
        [ary_myGoal_bmiData addObject:[NSString stringWithFormat:@"%.1f",s]];
        //NSLog(@"%d",i);
    }
    
    
    for (int i = 0; i < ary_myGoal_bmiData.count; i++) {
        
        NSString *bmiStr = [NSString stringWithFormat:@"%@",[ary_myGoal_bmiData objectAtIndex:i]];
        
        if ([myGoal_bmiLabel.text isEqualToString:bmiStr]) {
            NSLog(@" bmiStr == %@",bmiStr);
            
            [myGoal_bmiPickerView selectRow:i inComponent:0 animated:NO];
        }
        
    }
    
    
    //    float bmivalue = [bmiLabel.text floatValue];
    //    [bmiPickerView selectRow:(bmivalue-10.0)*10 inComponent:0 animated:NO];
    
    
    CGRect slabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *sLabel = [[UILabel alloc] initWithFrame:slabelFrame];
    [sLabel setTextColor:[UIColor blackColor]];
    sLabel.text = NSLocalizedString(@"BMI", nil);
    sLabel.font = [UIFont systemFontOfSize:22];
    sLabel.alpha = 1.0;
    sLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    [allPickerView_BG addSubview:myGoal_bmiPickerView];
    
    [topView addSubview:sLabel];
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(saveMyGoalBMIAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topView addSubview:savehBtn];
    
}



//MyGoal Body Fat
-(void)showMyGoalBodyFatSelection {
    
    [self forAllPickerViewToShow];
    
    myGoal_bodyfatPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35,30, self.view.frame.size.width*0.33, self.view.frame.size.height*0.3)];
    
    //初始化数据
    
    //體脂
    if (ary_myGoal_bodyfatData == nil) {
        
        ary_myGoal_bodyfatData = [[NSMutableArray alloc] init];
    }
    
    [ary_myGoal_bodyfatData removeAllObjects];
    
    //设置pickerView的代理和数据源
    myGoal_bodyfatPickerView.dataSource = self;
    myGoal_bodyfatPickerView.delegate = self;
    
    for(float s=5.0 ; s <= 60.0; s+=0.1) {
        
        [ary_myGoal_bodyfatData addObject:[NSString stringWithFormat:@"%.1f",s]];
    }
    
    for (int i = 0; i < ary_myGoal_bodyfatData.count; i++) {
        NSString *bfStr = [NSString stringWithFormat:@"%@",[ary_myGoal_bodyfatData objectAtIndex:i]];
        
        if ([myGoal_bodyfatLabel.text isEqualToString:bfStr]) {
            NSLog(@" bfStr == %@",bfStr);
            
            [myGoal_bodyfatPickerView selectRow:i inComponent:0 animated:NO];
        }
        
    }
    
    
    float bfvalue = [myGoal_bodyfatLabel.text floatValue];
    [myGoal_bodyfatPickerView selectRow:(bfvalue-5.0)*10 inComponent:0 animated:NO];
    
    
    
    CGRect slabelFrame = CGRectMake(self.view.frame.size.width/4, 0 , self.view.frame.size.width/2 , self.view.frame.size.height/17);
    UILabel *sLabel = [[UILabel alloc] initWithFrame:slabelFrame];
    [sLabel setTextColor:[UIColor blackColor]];
    sLabel.text = @"Body Fat";
    sLabel.font = [UIFont systemFontOfSize:22];
    sLabel.alpha = 1.0;
    sLabel.textAlignment = NSTextAlignmentCenter;
    
    [allPickerView_BG addSubview: myGoal_bodyfatPickerView];
    [topView addSubview:sLabel];
    
    
    
    UIButton *savehBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savehBtn.frame = CGRectMake(self.view.frame.size.width*0.8, 0, self.view.frame.size.width*0.2, self.view.frame.size.height/17);
    [savehBtn setTitle:@"Save" forState:UIControlStateNormal];
    [savehBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    savehBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [savehBtn addTarget:self action:@selector(saveMyGoalBodyFatAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:savehBtn];
    
}


#pragma mark - ProFile PickerView Save Action *******************************
//Birthday Save Action
-(void)birthdaySaveAction{
    
    if (birthdayDate != nil) {
        [birthdayLabel setText:birthdayDate];
    }
    
    [self closePickerviewfunc];
    
}


//Metric Height || Imperial Height
-(void)metricHeightSaveAction {
    
    [self closePickerviewfunc];
    
    [self saveAsFT];
    [self saveAsInch];
    
    if (heightStr_ft != nil && heightStr_inch != nil) {
        
        double hei1value = [heightStr_ft doubleValue];
        double hei2value = [heightStr_inch doubleValue];
        NSString *im_to_me_heiStr = [NSString stringWithFormat:@"%.0f",((hei1value+hei2value/12)/cmTransformToft)];
        height_value = [im_to_me_heiStr intValue];

    }
    else if (heightStr_ft != nil && heightStr_inch == nil){
        
        double hei1value = [heightStr_ft doubleValue];
        double hei2value = [heightLabel_inch_value.text doubleValue];
        NSString *im_to_me_heiStr = [NSString stringWithFormat:@"%.0f",((hei1value+hei2value/12)/cmTransformToft)];
        height_value = [im_to_me_heiStr intValue];
    }
    else if (heightStr_ft == nil && heightStr_inch != nil){
        
        double hei1value = [heightLabel_ft_value.text doubleValue];
        double hei2value = [heightStr_inch doubleValue];
        NSString *im_to_me_heiStr = [NSString stringWithFormat:@"%.0f",((hei1value+hei2value/12)/cmTransformToft)];
        height_value = [im_to_me_heiStr intValue];
        
    }
    else{
        
        double hei1value = [heightLabel_ft_value.text doubleValue];
        double hei2value = [heightLabel_inch_value.text doubleValue];
        NSString *im_to_me_heiStr = [NSString stringWithFormat:@"%.0f",((hei1value+hei2value/12)/cmTransformToft)];
        height_value = [im_to_me_heiStr intValue];
        
    }
    
    
    NSLog(@"英制儲存身高的時候轉公制%d",height_value);
    
}





//save ft
-(void)saveAsFT {
    
    if (heightStr_ft != nil) {
        
        heightLabel_ft_value.text = heightStr_ft;
    }

}

//save inch
-(void)saveAsInch{
    
    if (heightStr_inch!=nil) {
        
        heightLabel_inch_value.text = heightStr_inch;
    }
}

//Metric Weight || Imperial Weight
-(void)metricWeightSaveAction{
    
    [self closePickerviewfunc];
    
    if (weightStr != nil) {
        
        weightLabel.text = weightStr;
        
        //判斷公英制
        if (unitBooL == 0) {
            
            weight_value = [weightStr floatValue];
        }
        else if (unitBooL == 1){
            double wei1value = [weightStr doubleValue];
            NSString *saveWeiStr = [NSString stringWithFormat:@"%.1f",wei1value/kgTransformTolb];
            weight_value = [saveWeiStr floatValue];
            
        }
        
    }
    NSLog(@"weight_value:%f",weight_value);
}


//Cuff Size
-(void)cuffSizeSaveAction{
    
    [self closePickerviewfunc];
    
    if (cuffSizeStr != nil) {
        
        cuffSizeLabel.text = cuffSizeStr;
    }
    
}


//Measure Arm
-(void)measureArmSaveAction{
    
    [self closePickerviewfunc];
    
    if (measureArmStr != nil) {
        
        measureArmLabel.text = measureArmStr;
    }
    
    
}





#pragma mark - MyGoals PickerView Save Action  *******************************
//MyGoal Systolic Pressure
-(void)saveMyGoalSysAction{
    
    [self closePickerviewfunc];
    
    if (myGoal_systolicPressureStr != nil) {
        
        myGoal_systolicPressureLabel.text = myGoal_systolicPressureStr;
        
        if (pressureBooL == 0) {
            
            sys_pressure_value = [myGoal_systolicPressureStr floatValue];
        }
        else if (pressureBooL == 1) {
            
            double sp1value = [myGoal_systolicPressureStr doubleValue];
            NSString *savesysStr = [NSString stringWithFormat:@"%.0f",sp1value/mmHgTransformTokPa];
            sys_pressure_value = [savesysStr floatValue];

        }
        
        
    }
    
}


//MyGoal Diastolic Pressure
-(void)saveMyGoalDiaAction{
    
    [self closePickerviewfunc];
    
    if (myGoal_diastolicPressureStr != nil) {
        
        myGoal_diastolicPressurepLabel.text = myGoal_diastolicPressureStr;
        
        if (pressureBooL == 0) {
            
            dia_pressure_value = [myGoal_diastolicPressureStr floatValue];
            
        }
        else if (pressureBooL == 1){
            
            double dp1value = [myGoal_diastolicPressureStr doubleValue];
            NSString *diaString = [NSString stringWithFormat:@"%.0f",dp1value/mmHgTransformTokPa];
            dia_pressure_value = [diaString floatValue];
            
        }
        
        
    }
    
    
}


//MyGoal Weight
-(void)saveMyGoalWeiAction {
    
    [self closePickerviewfunc];
    
    if (mtGoal_weightStr != nil) {
        
        myGoal_weightLabel.text = mtGoal_weightStr;
        
        if (unitBooL == 0) {
            goalweight_value = [mtGoal_weightStr floatValue];
            NSLog(@"儲存的公制目標體重%.1f",goalweight_value);
            
        }
        else if (unitBooL == 1){
            
            double goalwei1value = [mtGoal_weightStr doubleValue];
            NSString *im_to_me_goalweiStr = [NSString stringWithFormat:@"%.1f",goalwei1value/kgTransformTolb];
            goalweight_value = [im_to_me_goalweiStr floatValue];
            NSLog(@"儲存的英制轉公制目標體重%.1f",goalweight_value);
            
        }
        
        
    }
    
    NSLog(@"mtGoal_weightStr:%@",mtGoal_weightStr);
    
}


//MyGoal BMI
-(void)saveMyGoalBMIAction {
    
    [self closePickerviewfunc];
    
    if (myGoal_BMIStr != nil) {
        
        myGoal_bmiLabel.text = myGoal_BMIStr;
    }
    
    
}


//MyGoal Body Fat
-(void)saveMyGoalBodyFatAction {
    
    [self closePickerviewfunc];
    
    if ( myGoal_bodyFatStr != nil) {
        
        myGoal_bodyfatLabel.text = myGoal_bodyFatStr;
    }
    
}


#pragma mark - All PickerView Cancel Action  *******************************
-(void)cancelpickerClick{
    
    //[heightPickerView removeFromSuperview];
    [birDatepicker removeFromSuperview];
    [self closePickerviewfunc];

}


-(void)closePickerviewfunc {
    
//    allPickerView.hidden = true;
//    topView.hidden = true;
    
    [allPickerView_BG removeFromSuperview];
    [topView removeFromSuperview];
    birDatepicker.hidden = YES;
    coverView.hidden = YES;
    
}



#pragma mark - Segment Control Action  *******************************
//Gender
- (void)GenderSegmentControlAction:(UISegmentedControl *)segment {
    
    genderBooL = segment.selectedSegmentIndex == 0 ? 0 : 1;
}

//unit
-(void)unitSegmentControlAction:(UISegmentedControl *)segment{
    
    BOOL tapUnit = [self IntValueTransformToBool:segment.selectedSegmentIndex];
    
    [self checkTapUnit:tapUnit];
    
}


//pressure unit
-(void)pressureSegmentControlAction:(UISegmentedControl *)segment{
    
    BOOL pressureUnit =  [self IntValueTransformToBool:segment.selectedSegmentIndex];
    
    [self checkPressureUnit:pressureUnit];
}


#pragma mark - TextField  Delegate  *******************************
//限制輸入字數
/**
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        return YES;
    }
    
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (nameTextField == textField) {
        //这个 if 判断是在多个输入框的时候,只限制一个输入框的时候用的,如果全部限制,则不加 if 判断即可,这里是只判断输入用户名的输入框
        if ([aString length] > 50) {
            textField.text = [aString substringToIndex:50];
            
            return NO;
        }
    }
    
    return YES;
}
*/

// 按下Return後會反應的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    [textField resignFirstResponder];
    NSLog(@"按下Return");
    return false;
}

//按下Done
-(void)textFieldDone:(UITextField*)textField {
    
    [textField resignFirstResponder];
}

//自定義 字數上限
-(void)textFieldEditChanging:(UITextField *)textField {
    
    if (textField == nameTextField) {
        
        NSUInteger textLength = [MViewController getStringLength:textField.text];
        
        if (textLength > 50) {
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 50)];
            
            [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"The string length is limited to 50 characters", nil) buttonTitle:NSLocalizedString(@"OK", nil)];
        }

    }
    
    
}




#pragma mark - 呼叫相簿或相機事件 & ImagePickerController Delegate
-(void)getImageFromDevice:(int)pickerType { //type -> 0:相機, 1:相簿
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    
    if (pickerType == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imgPicker.allowsEditing = YES;
        }

    }
    else {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
      
            imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.allowsEditing = YES;
        }
        
    }

    [self presentViewController:imgPicker animated:YES completion:nil];
}


//ImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    userImageView.image = newImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//save image into device
-(void)saveImage:(UIImage *)newImage {
    
    NSString *filePath = USER_IMAGE_FILEPATH;
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0);
    
    [imageData writeToFile:filePath atomically:YES];
    
}

//判斷大頭照路徑是否存在
-(BOOL)checkUserImagePathIsExistOrNot {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isExist = [manager fileExistsAtPath:USER_IMAGE_FILEPATH];
    
    return isExist;
}


#pragma mark - 跳到別的頁面  *******************************
//Setting 頁面
-(void)gobackToSettingVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//Risk Factors 頁面
-(void)goRFClick {
    
    if (riskVC == nil) {
        
        riskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RiskFactors"];
        riskVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
    }
    
    riskVC.m_superVC = self;
    
    [self presentViewController:riskVC animated:YES completion:nil];

}

/**  webView做
//Change Password 頁面
-(void)gochangepasswordClick {
    
    UIViewController *ChangePassword = [[UIViewController alloc ]init];
    ChangePassword = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
    
    ChangePassword.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:ChangePassword animated:true completion:nil];
    
}
*/

#pragma mark - refreshData  *******************************
-(void)refreshData {
    
    //Profile ************************************
    //Name
    nameTextField.text = userName;
    
    //Gender
    sexSegmentControl.selectedSegmentIndex = genderBooL;
    NSLog(@"sexSegmentControl.selectedSegmentIndex ===> %d",sexSegmentControl.selectedSegmentIndex);
    
    //Birthday
    birthdayLabel.text = birthDateString;
    
    //height
    heightLabel_cm_value.text = heightStr_cm;
    
    //weight
    weightLabel.text = weightStr;
    
    
    //Cuff Size
    cuffSizeLabel.text = ary_cuffSizeData[cuffsize_row];
    
    //Measurement Arm
    measureArmLabel.text = ary_measureArmData[measureArm_row];
    
    //unit selector
    unitSegmentControl.selectedSegmentIndex = unitBooL;
    
    //pressure unit selector
    pressureSegmentControl.selectedSegmentIndex = pressureBooL;
    
    
    //MyGoals ************************************
    //Systolic Pressure
    myGoal_systolicPressureLabel.text =  myGoal_systolicPressureStr;
    myGoal_systolicPressureLabel.userInteractionEnabled = sysActive;
    [systolicswitch setOn:sysActive];
    
    //Diastolic Pressure
    myGoal_diastolicPressurepLabel.text = myGoal_diastolicPressureStr;
    myGoal_diastolicPressurepLabel.userInteractionEnabled = diaActive;
    [diastolicswitch setOn:diaActive];
    
    //MyGoal Weight
    myGoal_weightLabel.text = mtGoal_weightStr;
    myGoal_weightLabel.userInteractionEnabled = goalWeightActive;
    [goalWeightswitch setOn:goalWeightActive];
    
    //BMI
    myGoal_bmiLabel.text = myGoal_BMIStr;
    myGoal_bmiLabel.userInteractionEnabled = BMIActive;
    [BMIswitch setOn:BMIActive];
    
    //Body Fat
    myGoal_bodyfatLabel.text = myGoal_bodyFatStr;
    myGoal_bodyfatLabel.userInteractionEnabled = bodyFatActive;
    [Bodyswitch setOn:bodyFatActive];
    
    //thresholdswitch
    [thresholdswitch setOn:thresholdActive];
    
    
    ///判斷單位
    NSLog(@"unitBooL ========>>>>> %d",unitBooL);
    [self checkTapUnit:unitBooL];
    NSLog(@"pressureBooL ========>>>>> %d",pressureBooL);
    [self checkPressureUnit:pressureBooL];
}


#pragma mark - get Basic Data from HealyhKit - MyHealthStoreDelegate (生日-血型-身高-體重) *******************************

-(void)getBasicDataFromHealthStore {
    
    isSyncHeqlthKit = [MViewController checkIsSyncWithHealthKit];
    
    if (isSyncHeqlthKit) {
        
        [healthStore readDataFromHealthStore];
    }
    
}

///BirthDay
-(void)birthdayData:(NSString *)birthDayStrFormHealthKit {
    
    if (birthDayStrFormHealthKit != nil) {
        
        birthDateString = birthDayStrFormHealthKit;
        birthdayLabel.text = birthDateString;
        NSLog(@"birthDateString:%@",birthDateString);
    }

}


///Gender
-(void)genderData:(NSString *)genderStrFormHealthKit {
    
    if (genderStrFormHealthKit != nil) {
        
        int genderInt = [genderStrFormHealthKit intValue];
        genderBooL = genderInt;
        NSLog(@"genderInt_genderBooL:%d",genderBooL);
    }

}

///Height
-(void)heightData:(NSString *)heightStrFormHealthKit {
    
    if (heightStrFormHealthKit != nil) {
        
        heightStr_cm = heightStrFormHealthKit;
        heightLabel_cm_value.text = heightStr_cm;
        NSLog(@"heightStr_cm:%@",heightStr_cm);
    }
    
}


///Weight
-(void)weightData:(NSString *)weightStrFormHealthKit {
    
    if (weightStrFormHealthKit != nil) {
        
        weightStr = weightStrFormHealthKit;
        weightLabel.text = weightStr;
        NSLog(@"weightStr:%@",weightStr);
    }

}



#pragma mark - get Local Data (從資料庫取Data)  *******************************
-(void)getLocaldata {
    
    
    //Profile ************************************
    //name
    userName = [LocalData sharedInstance].name;
    nameTextField.text = [LocalData sharedInstance].name;
    NSLog(@"LocalData name = %@",[LocalData sharedInstance].name);
    
    ///userName = [proFileDic objectForKey:@"name"];
    
    //gender 性別
    genderBooL = [LocalData sharedInstance].UserGender;
    NSLog(@"LocalData Gender:%d",[LocalData sharedInstance].UserGender);
    
    
    //birthday
    birthDateString = [LocalData sharedInstance].birthday;
    NSLog(@"LocalData birthday:%@",[LocalData sharedInstance].birthday);

    
    
    //user Height
    height_value = [LocalData sharedInstance].UserHeight;
    NSLog(@"LocalData height_value:%f",[LocalData sharedInstance].UserHeight);
    
    ///height_value = [(NSString *)[proFileDic objectForKey:@"userHeight"] intValue];
    NSLog(@"height_value <===> %d",height_value);
    
    //user Weight
    weight_value = [LocalData sharedInstance].UserWeight;
    NSLog(@"LocalData weight_value:%f",[LocalData sharedInstance].UserWeight);
    
    
    //cuffsize
    cuffsize_row = [LocalData sharedInstance].cuff_size;
    NSLog(@"LocalData cuffsize_row:%d",[LocalData sharedInstance].cuff_size);
    
    //measure Arm
    measureArm_row = [LocalData sharedInstance].bp_measurement_arm;
    NSLog(@"LocalData measureArm_row:%d",[LocalData sharedInstance].bp_measurement_arm);
    
    //unit selector
    unitBooL = [self IntValueTransformToBool:[LocalData sharedInstance].metric];
    NSLog(@"LocalData unitBooL:%d",[LocalData sharedInstance].metric);
    
    //pressure unit selector
    pressureBooL = [self IntValueTransformToBool:[LocalData sharedInstance].BPUnit];
    NSLog(@"LocalData pressureBooL:%d",[LocalData sharedInstance].BPUnit);
    
    //MyGoal ************************************
    //sys
    sys_pressure_value = [LocalData sharedInstance].targetSYS;
    sysActive = [self IntValueTransformToBool:[LocalData sharedInstance].showTargetSYS];
    NSLog(@"LocalData sys_pressure_value:%d",[LocalData sharedInstance].targetSYS);
    NSLog(@"LocalData sysActive:%d",[LocalData sharedInstance].showTargetSYS);
    
    
    //dia
    dia_pressure_value = [LocalData sharedInstance].targetDIA;
    diaActive = [self IntValueTransformToBool:[LocalData sharedInstance].showTargetDIA];
    NSLog(@"LocalData dia_pressure_value:%d",[LocalData sharedInstance].targetDIA);
    NSLog(@"LocalData diaActive:%d",[LocalData sharedInstance].showTargetDIA);
    
    
    
    //Weight
    goalweight_value = [LocalData sharedInstance].targetWeight;
    goalWeightActive = [self IntValueTransformToBool:[LocalData sharedInstance].showTargetWeight];
    NSLog(@"LocalData goalweight_value:%f",[LocalData sharedInstance].targetWeight);
    NSLog(@"LocalData goalWeightActive:%d",[LocalData sharedInstance].showTargetWeight);
    
    
    
    //BMI
    BMI_value = [LocalData sharedInstance].targetBMI;
    BMIActive = [self IntValueTransformToBool:[LocalData sharedInstance].showTargetBMI];
    NSLog(@"LocalData BMI_value:%f",[LocalData sharedInstance].targetBMI);
    NSLog(@"LocalData BMIActive:%d",[LocalData sharedInstance].showTargetBMI);
    
    
    
    //Body Fat
    BF_value = [LocalData sharedInstance].targetFat;
    bodyFatActive = [self IntValueTransformToBool:[LocalData sharedInstance].showTargetFat];
    NSLog(@"LocalData BF_value:%f",[LocalData sharedInstance].targetFat);
    NSLog(@"LocalData bodyFatActive:%d",[LocalData sharedInstance].showTargetFat);
    
    
    //date format Active
    dateformatBool = [self IntValueTransformToBool:[LocalData sharedInstance].date_format];
    NSLog(@"LocalData dateformatBool:%d",[LocalData sharedInstance].date_format);
    
    //threshold Active
    thresholdActive = [self IntValueTransformToBool:[LocalData sharedInstance].threshold];
    NSLog(@"LocalData thresholdActive:%d",[LocalData sharedInstance].threshold);
    
    
    //Risk Factors ************************************
    //isHypertension
    self.isHypertension = [LocalData sharedInstance].isHypertension;
    
    //isAtrialFibrillation
    self.isAtrialFibrillation = [LocalData sharedInstance].isAtrialFibrillation;
    
    //isDiabetes
    self.isDiabetes = [LocalData sharedInstance].isDiabetes;
    
    //isCardiovascular
    self.isCardiovascular = [LocalData sharedInstance].isCardiovascular;
    
    //isChronicKindey
    self.isChronicKindey = [LocalData sharedInstance].isChronicKindey;
    
    //isTransientIschemicAttact
    self.isTransientIschemicAttact = [LocalData sharedInstance].isTransientIschemicAttact;
    
    //isDyslipidemia
    self.isDyslipidemia = [LocalData sharedInstance].isDyslipidemia;
    
    //isSnoringOrSleepAponea
    self.isSnoringOrSleepAponea = [LocalData sharedInstance].isSnoringOrSleepAponea;
    
    //isUseOralContraception
    self.isUseOralContraception = [LocalData sharedInstance].isUseOralContraception;
    
    //isUseAntiHypertensive
    self.isUseAntiHypertensive = [LocalData sharedInstance].isUseAntiHypertensive;
    
    //isPregenancy_normoal
    self.isPregenancy_normoal = [LocalData sharedInstance].isPregenancy_normoal;
    
    //isPregenancy_preEclampsia
    self.isPregenancy_preEclampsia = [LocalData sharedInstance].isPregenancy_preEclampsia;
    
    //isSmoking
    self.isSmoking = [LocalData sharedInstance].isSmoking;
    
    //isAlcoholIntake
    self.isAlcoholIntake = [LocalData sharedInstance].isAlcoholIntake;
    
    [self checkDataBaseValue];
    
    
    
    //birthdayLabel.text = [LocalData sharedInstance].birthday;
    
    
    /*
     if (height_value == 0) {
     
     height_value = 175;
     
     }
     if (weight_value == 0) {
     
     weight_value = 75.0;
     
     }
     
     if (goalweight_value == 0) {
     
     goalweight_value = 75.0;
     
     }
     if (sys_pressure_value == 0) {
     
     sys_pressure_value = 120;
     
     }
     
     if (dia_pressure_value == 0) {
     dia_pressure_value = 80;
     
     }
     if (BMI_value == 0) {
     BMI_value = 25.0;
     
     }
     if (BF_value == 0) {
     BF_value = 25.0;
     
     }
     //
     
     if (cuffsize_row == -1) {
     cuffsize_row = 1;
     }
     if (measureArm_row == -1) {
     measureArm_row = 0;
     }
     //從資料庫取得日期格式設定
     //    if () {
     dateformatBool = 0;
     //    }
     //判斷資料庫的公英制設定
     */
    
    if (unitBooL == 1) {
        
        //身高轉字串
        //double hei2value = [heiStr doubleValue];
        
        //公分轉英呎
        NSString *ft_1Str = [NSString stringWithFormat:@"%.2f", height_value*cmTransformToft];
        
        ft_Str = [ft_1Str substringWithRange:NSMakeRange(0, 1)];
        
        //公分轉英呎
        NSString *hei2222str = [NSString stringWithFormat:@"%f",height_value*cmTransformToft];
        
        int ft_value = [ft_Str intValue];
        
        double hei2222value = [hei2222str doubleValue];
        

        //英呎扣掉整數位後剩餘部分轉英吋
        inch_Str = [NSString stringWithFormat:@"%.1f",(hei2222value-ft_value)*12];
    }
    
    //判斷資料庫中血壓單位的設定
}

#pragma check dataBaseValue
/**
 有些值不可為 0
 */
-(void)checkDataBaseValue {
    
    //user Name
    userName = userName == nil ? @"User Name" : userName;
    
    //user Height
    heightStr_cm = height_value == 0 ? @"175" : [NSString stringWithFormat:@"%d",height_value];
    
    //usr Weight
    weightStr = weight_value == 0 ? @"75.0" : [NSString stringWithFormat:@"%.1f",weight_value];
    
    //myGoal Systolic Pressure
    myGoal_systolicPressureStr = sys_pressure_value == 0 ? @"135" : [NSString stringWithFormat:@"%.0f",sys_pressure_value];
    
    //myGoal Diastolic Pressure
    myGoal_diastolicPressureStr = dia_pressure_value == 0 ? @"85" : [NSString stringWithFormat:@"%.0f",dia_pressure_value];
    
    //myGoal Weight
    mtGoal_weightStr = goalweight_value == 0 ? @"75.0" : [NSString stringWithFormat:@"%.1f",goalweight_value];
    
    //myGoal BMI
    myGoal_BMIStr = BMI_value == 0 ? @"23.0" : [NSString stringWithFormat:@"%.1f",BMI_value];
    
    //myGoal BodyFat
    myGoal_bodyFatStr = BF_value == 0 ? @"20.0" : [NSString stringWithFormat:@"%.1f",BF_value];
}


#pragma mark - save Profile Data (儲存資料)  *******************************
-(void)saveProfileData{
    
    NSLog(@"weight_value:%f,goalweight_value:%f",weight_value,goalweight_value);
    
    //Profile ************************************
    //user Name
    [ProfileClass sharedInstance].name = nameTextField.text;
    
    //gender 性別
    int userGender_intValue = genderBooL; //[self BoolTransformToInt:genderBooL];
    [ProfileClass sharedInstance].userGender = userGender_intValue;
    
    //birthday
    NSLog(@"%@",birthdayDate);
    [ProfileClass sharedInstance].birthday = birthdayLabel.text;
    
    //user Height
    [ProfileClass sharedInstance].userHeight = [heightLabel_cm_value.text floatValue];
    NSLog(@"heightLabel_cm_value.text ===> %.0f",[heightLabel_cm_value.text floatValue]);
    
    //user Weight
    [ProfileClass sharedInstance].userWeight = weight_value;
    NSLog(@"weight_value =====> %.1f",weight_value);
//    [ProfileClass sharedInstance].userWeight = [weightLabel.text floatValue];
//    NSLog(@"weightLabel.text =====> %.1f",[weightLabel.text floatValue]);
    
    //cuff_size
    NSNumber *cuffsize_row_numValue = [NSNumber numberWithInteger:cuffsize_row];
    int cuffsize_row_intValue = [cuffsize_row_numValue intValue];
    [ProfileClass sharedInstance].cuff_size = cuffsize_row_intValue;
    
    //measurement_arm
    NSNumber *measureArm_row_numValue = [NSNumber numberWithInteger:measureArm_row];
    int measureArm_row_intValue = [measureArm_row_numValue intValue];
    [ProfileClass sharedInstance].bp_measurement_arm = measureArm_row_intValue;
    
    //unit_type
    int unit_type_intValue = [self BoolTransformToInt:unitBooL];
    [ProfileClass sharedInstance].unit_type = unit_type_intValue;
    NSLog(@"unitBooL ==>> %d",unitBooL);
    NSLog(@"unit_type_intValue ==>> %d",unit_type_intValue);

    
    
    //pressure unit type
    int sys_unit_intValue = [self BoolTransformToInt:pressureBooL];
    [ProfileClass sharedInstance].sys_unit = sys_unit_intValue;
    NSLog(@"pressureBooL ==> %d",pressureBooL);
    NSLog(@"sys_unit_intValue ==> %d",sys_unit_intValue);
    
    //MyGoal ************************************
    //Sys
    [ProfileClass sharedInstance].sys = [myGoal_systolicPressureLabel.text intValue];
    [ProfileClass sharedInstance].sys_activity = [self BoolTransformToInt:sysActive];
    
    //Dia
    [ProfileClass sharedInstance].dia = [myGoal_diastolicPressurepLabel.text intValue];
    [ProfileClass sharedInstance].dia_activity = [self BoolTransformToInt:diaActive];
    
    //goal_weight
//    [ProfileClass sharedInstance].goal_weight = [myGoal_weightLabel.text floatValue];
    [ProfileClass sharedInstance].goal_weight = goalweight_value;
    [ProfileClass sharedInstance].weight_activity = [self BoolTransformToInt:goalWeightActive];

    //BMI
    [ProfileClass sharedInstance].bmi = [myGoal_bmiLabel.text floatValue];
    [ProfileClass sharedInstance].bmi_activity = [self BoolTransformToInt:BMIActive];
    
    //Body Fat
    [ProfileClass sharedInstance].body_fat = [myGoal_bodyfatLabel.text floatValue];
    [ProfileClass sharedInstance].body_fat_activity = [self BoolTransformToInt:bodyFatActive];

    
    //date format
    [ProfileClass sharedInstance].date_format = [self BoolTransformToInt:dateformatBool];
    
    //threshold Active
    [ProfileClass sharedInstance].threshold = [self BoolTransformToInt:thresholdActive];

    
    
    //Risk Factors ************************************
    [ProfileClass sharedInstance].isHypertension = self.isHypertension;
    
    [ProfileClass sharedInstance].isAtrialFibrillation = self.isAtrialFibrillation;
    
    [ProfileClass sharedInstance].isDiabetes = self.isDiabetes;
    
    [ProfileClass sharedInstance].isCardiovascular = self.isCardiovascular;
    
    [ProfileClass sharedInstance].isChronicKindey = self.isChronicKindey;
    
    [ProfileClass sharedInstance].isTransientIschemicAttact = self.isTransientIschemicAttact;
    
    [ProfileClass sharedInstance].isDyslipidemia = self.isDyslipidemia;
    
    [ProfileClass sharedInstance].isSnoringOrSleepAponea = self.isSnoringOrSleepAponea;
    
    [ProfileClass sharedInstance].isUseOralContraception = self.isUseOralContraception;
    
    [ProfileClass sharedInstance].isUseAntiHypertensive = self.isUseAntiHypertensive;
    
    [ProfileClass sharedInstance].isPregenancy_normoal = self.isPregenancy_normoal;
    
    [ProfileClass sharedInstance].isPregenancy_preEclampsia = self.isPregenancy_preEclampsia;
    
    [ProfileClass sharedInstance].isSmoking = self.isSmoking;
    
    [ProfileClass sharedInstance].isAlcoholIntake = self.isAlcoholIntake;
    
    
    //更新資料庫 ************************************
    [[ProfileClass sharedInstance] updateData];
    [[LocalData sharedInstance] checkDefaultProfileData];
    
    
    //儲存大頭照
    [self saveImage:userImageView.image];
    
    //儲存使用者姓名
    [MViewController saveUserName:nameTextField.text];

    
    //BMI_value = [bmiLabel.text floatValue];     //BMI
    //BF_value =  [bfLabel.text floatValue];    //體脂
    
    
    //cuffsize_row;          //袖口尺寸
    //measureArm_row;        //手臂尺寸
    
    
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self saveDataToCloud];
        
    });
    
    if ([MViewController checkIsPrivacyModeOrMemberShip]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


-(void)saveDataToCloud {
    
    
    if ([MViewController checkIsPrivacyModeOrMemberShip]) {
        
        //return;
    }
    else {
        
        [self showIndicatorView];
        
        
        //post API
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        
        NSNumber *cuffsize_row_numValue = [NSNumber numberWithInteger:cuffsize_row];
        int cuffsize_row_intValue = [cuffsize_row_numValue intValue];
        
        NSNumber *measureArm_row_numValue = [NSNumber numberWithInteger:measureArm_row];
        int measureArm_row_intValue = [measureArm_row_numValue intValue];
        
        NSString *conditionStr = [self translateRiskFactorToString];
        
        //取image
        NSString *fileName = USER_IMAGE_FILEPATH;
        NSData *imageData = [NSData dataWithContentsOfFile:fileName];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [apiClass postModifyMember:tokenStr client_id:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" client_secret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C" name:nameTextField.text birthday:birthdayLabel.text gender:genderBooL height:[heightLabel_cm_value.text intValue] weight:weight_value unit_type:[self BoolTransformToInt:unitBooL] sys_unit:[self BoolTransformToInt:pressureBooL] sys:sys_pressure_value dia:dia_pressure_value goal_weight:goalweight_value body_fat:[myGoal_bodyfatLabel.text floatValue] bmi:[myGoal_bmiLabel.text floatValue] sys_activity:[self BoolTransformToInt:sysActive] dia_activity:[self BoolTransformToInt:diaActive] weight_activity:[self BoolTransformToInt:goalWeightActive] body_fat_activity:[self BoolTransformToInt:bodyFatActive] bmi_activity:[self BoolTransformToInt:BMIActive] threshold:[self BoolTransformToInt:thresholdActive] cuff_size:cuffsize_row_intValue bp_measurement_arm:measureArm_row_intValue date_format:[self BoolTransformToInt:dateformatBool] conditions:conditionStr photo:image];

    
    }

    
}

#pragma mark - Bool & Int 轉換  *******************************
-(int)BoolTransformToInt:(BOOL)theBoolValue {
    
    if (theBoolValue) {
        
        return 1;
    }
    else {
        
        return 0;
    }
    
}

-(BOOL)IntValueTransformToBool:(int)intValue {
    
    if (intValue == 0) {
        
        return NO;
    }
    else {
        
        return YES;
    }
    
}


#pragma mark - 檢察單位 ***************************************
-(void)checkTapUnit:(BOOL)tapUnit {
    
    if (tapUnit == NO) {
        
        //公制
        heightLabel_cm_value.hidden = NO;
        heightLabel_ft_value.hidden = YES;
        heightLabel_inch_value.hidden = YES;
        cmLabel.hidden = NO;
        ftLabel.hidden = YES;
        inchLabel.hidden = YES;
        
        unitBooL = 0;
        
        kgLabel.text = @"kg";
        myGoal_kgLabel.text = @"kg";
        
        
        if (heightStr_cm != nil) {
            
            heightLabel_cm_value.text = [NSString stringWithFormat:@"%d",height_value];
            
        }
        else{
            
            double hei1value = [heightLabel_ft_value.text doubleValue];
            double hei2value = [heightLabel_inch_value.text doubleValue];
            NSString *im_to_me_heiStr = [NSString stringWithFormat:@"%.0f",((hei1value+hei2value/12)/cmTransformToft)];
            heightLabel_cm_value.text = im_to_me_heiStr;
            heightStr_cm = im_to_me_heiStr;
            
        }
        
        
        if (weightStr != nil) {
            
            weightLabel.text = [NSString stringWithFormat:@"%.1f",weight_value];
        }
        else {
            
            double wei1value = [ weightLabel.text doubleValue];
            NSString *im_to_me_weiStr = [NSString stringWithFormat:@"%.1f",wei1value/kgTransformTolb];
            weightLabel.text = im_to_me_weiStr;
            weightStr = im_to_me_weiStr;
        }
        
        
        if (mtGoal_weightStr !=nil ) {
            
            myGoal_weightLabel.text = [NSString stringWithFormat:@"%.1f",goalweight_value];
        }
        else{
            
            double goalwei1value = [myGoal_weightLabel.text doubleValue];
            NSString *im_to_me_goalweiStr = [NSString stringWithFormat:@"%.1f",goalwei1value/kgTransformTolb];
            myGoal_weightLabel.text = im_to_me_goalweiStr;
            mtGoal_weightStr = im_to_me_goalweiStr;
        }
        
    }
    else{
        
        //英制
        heightLabel_cm_value.hidden = YES;
        heightLabel_ft_value.hidden = NO;
        heightLabel_inch_value.hidden = NO;
        cmLabel.hidden = YES;
        ftLabel.hidden = NO;
        inchLabel.hidden = NO;
        
        unitBooL = 1;
        
        kgLabel.text = @"lb";
        myGoal_kgLabel.text = @"lb";
        
        
        
        //身高轉字串
        //        double hei2value = [heiStr doubleValue];
        //公分轉英呎
        NSString *ft_1Str = [NSString stringWithFormat:@"%.2f", height_value * cmTransformToft];
        NSString *ft_2Str = [ft_1Str substringWithRange:NSMakeRange(0, 1)];
        //公分轉英呎
        NSString *hei2222str = [NSString stringWithFormat:@"%f",height_value * cmTransformToft];
        int ft_value = [ft_2Str intValue];
        double hei2222value = [hei2222str doubleValue];
        
        
        
        //英呎扣掉整數位後剩餘部分轉英吋
        NSString *inch_1Str = [NSString stringWithFormat:@"%.1f",(hei2222value-ft_value)*12];
        
        NSLog(@"ft====== %@",ft_2Str);
        NSLog(@"ft====== %@",ft_1Str);
        NSLog(@"inch=====%@",hei2222str);
        
        heightLabel_ft_value.text = ft_2Str;     //英呎
        heightLabel_inch_value.text = inch_1Str;    //英吋
        
        
        
        //double wei2value = [weiStr doubleValue];
        NSString *me_to_im_weiStr = [NSString stringWithFormat:@"%.1f",weight_value*kgTransformTolb];
        weightLabel.text = me_to_im_weiStr;
        
        //double goalwei2value = [goalweiStr doubleValue];
        NSString *me_to_im_goalweiStr = [NSString stringWithFormat:@"%.1f",goalweight_value*kgTransformTolb];
        myGoal_weightLabel.text = me_to_im_goalweiStr;
        
        
    }

    
}

-(void)checkPressureUnit:(BOOL)pressureUnit {
    
    //Nick Fix
    //spStr = myGoal_systolicPressureLabel.text;
    //dpStr = myGoal_diastolicPressurepLabel.text;
    myGoal_systolicPressureStr = myGoal_systolicPressureLabel.text;
    myGoal_diastolicPressureStr = myGoal_diastolicPressurepLabel.text;
    
    
    if (pressureUnit == NO) {
        myGoal_systolicPressureUnitLabel.text = @"mmHg";
        myGoal_diastolicPressureUnitLabel.text = @"mmHg";
        
        pressureBooL = 0;
        
        if (myGoal_systolicPressureStr != nil) {
            
            myGoal_systolicPressureLabel.text = [NSString stringWithFormat:@"%.0f",sys_pressure_value];
        }
        else{
            
            //Nick Fix
            double sp1value = [myGoal_systolicPressureStr doubleValue];
            //double sp1value = [spStr doubleValue];
            
            NSString *syspreStr = [NSString stringWithFormat:@"%.0f",sp1value/mmHgTransformTokPa];
            myGoal_systolicPressureLabel.text = syspreStr;
        }
        
        if (myGoal_diastolicPressureStr != nil) {
            
            myGoal_diastolicPressurepLabel.text = [NSString stringWithFormat:@"%.0f",dia_pressure_value];
        }
        else{
            
            //Nick Fix
            //double dp1value = [dpStr doubleValue];
            //dpStr = [NSString stringWithFormat:@"%.0f",dp1value/mmHgTransformTokPa];
            //myGoal_diastolicPressurepLabel.text = dpStr;
            
            double dp1value = [myGoal_diastolicPressureStr doubleValue];
            myGoal_diastolicPressureStr = [NSString stringWithFormat:@"%.0f",dp1value/mmHgTransformTokPa];
            myGoal_diastolicPressurepLabel.text = myGoal_diastolicPressureStr;
        }
        
    }
    else{
        myGoal_systolicPressureUnitLabel.text = @"kpa";
        myGoal_diastolicPressureUnitLabel.text = @"kpa";
        pressureBooL = 1;
        
        //Nick Fix
        //double sp2value = [spStr doubleValue];
        //spStr = [NSString stringWithFormat:@"%.1f",sp2value*mmHgTransformTokPa];
        //myGoal_systolicPressureLabel.text = spStr;
        
        //double dp2value = [dpStr doubleValue];
        //dpStr = [NSString stringWithFormat:@"%.1f",dp2value*mmHgTransformTokPa];
        //myGoal_diastolicPressurepLabel.text = dpStr;
        
        
        double sp2value = [myGoal_systolicPressureStr doubleValue];
        myGoal_systolicPressureStr = [NSString stringWithFormat:@"%.1f",sys_pressure_value*mmHgTransformTokPa];
        myGoal_systolicPressureLabel.text = myGoal_systolicPressureStr;
        
        double dp2value = [myGoal_diastolicPressureStr doubleValue];
        myGoal_diastolicPressureStr = [NSString stringWithFormat:@"%.1f",dia_pressure_value*mmHgTransformTokPa];
        myGoal_diastolicPressurepLabel.text = myGoal_diastolicPressureStr;
        
    }
    
    
}



#pragma mark - post API
-(void)getMemberDataFromCloud {
    
    if ([MViewController checkIsPrivacyModeOrMemberShip]) {
        
        return;
    }
    else {
        
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        [apiClass postGetMemberData:tokenStr client_id:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" client_secret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C"];
        [self showIndicatorView];
    }

}



#pragma mark - API Delegate  *****************
-(void)processModifyMemberData:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    [self stopIndicatorView];
    
    if (jsonError) {
        
        NSLog(@"ModifyMemberData jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"ModifyMemberData responseData:%@",responseData);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


-(void)processGetMemberData:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"GetMemberData jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"GetMemberData responseData:%@",responseData);
        
        if ([[responseData objectForKey:@"code"] intValue] == 10000) {
            
            NSLog(@"GetMemberData:%@",[responseData objectForKey:@"data"]);
            
            userName = nameTextField.text = [NSString stringWithFormat:@"%@",[[responseData objectForKey:@"data"] objectForKey:@"name"]];
            
            [MViewController saveUserName:nameTextField.text];
            
            birthDateString = [[responseData objectForKey:@"data"] objectForKey:@"birthday"];
            
            genderBooL = [[[responseData objectForKey:@"data"] objectForKey:@"gender"] intValue];
            
            height_value = [[[responseData objectForKey:@"data"] objectForKey:@"height"] intValue];
            
            weight_value = [[[responseData objectForKey:@"data"] objectForKey:@"weight"] floatValue];
            
            cuffsize_row = [[[responseData objectForKey:@"data"] objectForKey:@"cuff_size"] intValue];
            
            measureArm_row = [[[responseData objectForKey:@"data"] objectForKey:@"bp_measurement_arm"] intValue];
            
            unitBooL = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"unit_type"] intValue]];
            
            pressureBooL = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"sys_unit"] intValue]];
            
            sys_pressure_value = [[[responseData objectForKey:@"data"] objectForKey:@"sys"] floatValue];
            sysActive = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"sys_activity"] intValue]];
            
            dia_pressure_value = [[[responseData objectForKey:@"data"] objectForKey:@"dia"] floatValue];
            diaActive = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"dia_activity"] intValue]];
            
            goalweight_value = [[[responseData objectForKey:@"data"] objectForKey:@"goal_weight"] floatValue];
            goalWeightActive = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"weight_activity"] intValue]];
            
            BMI_value = [[[responseData objectForKey:@"data"] objectForKey:@"bmi"] floatValue];
            BMIActive = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"bmi_activity"] intValue]];
            
            BF_value = [[[responseData objectForKey:@"data"] objectForKey:@"body_fat"] floatValue];
            bodyFatActive = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"body_fat_activity"] intValue]];
            
            thresholdActive = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"threshold"] intValue]];
            
            dateformatBool = [self IntValueTransformToBool:[[[responseData objectForKey:@"data"] objectForKey:@"date_format"] intValue]];
            
            //Risk Factors ---------------
            NSString *conditions;
            
            if ([[[responseData objectForKey:@"data"] objectForKey:@"conditions"] isKindOfClass:[NSNumber class]]) {
                
                conditions = [NSString stringWithFormat:@"%d", [[[responseData objectForKey:@"data"] objectForKey:@"conditions"] intValue]] ;
                
                NSLog(@"only one");
            }
            else{
                conditions =  [[responseData objectForKey:@"data"] objectForKey:@"conditions"];
            }
            
            
            NSLog(@"conditions ====>>>> %@",conditions);
            
            NSArray *conditionAry = [conditions componentsSeparatedByString:@","];
            
            if (conditionAry.count > 0) {
                
                for (int i = 0; i < conditionAry.count; i++) {
                    
                    int num = [conditionAry[i] intValue];
                    
                    [self checkRiskFactors:num];
                }
                
            }

            
            //photo  ---------------
            [apiClass getImgDataFromURL:[[responseData objectForKey:@"data"] objectForKey:@"photot"]];
            
            
            [self refreshData];
            
            [self stopIndicatorView];
            
        }
        
    }

}


-(void)processGetImage:(NSData *)imgData {
    
    userImageView.image = [UIImage imageWithData:imgData];
}




-(void)checkRiskFactors:(int)num {
    
    self.isHypertension = 0;
    self.isAtrialFibrillation = 0;
    self.isDiabetes = 0;
    self.isCardiovascular = 0;
    self.isChronicKindey = 0;
    self.isTransientIschemicAttact = 0;
    self.isDyslipidemia = 0;
    self.isSnoringOrSleepAponea = 0;
    self.isUseOralContraception = 0;
    self.isUseAntiHypertensive = 0;
    self.isPregenancy_normoal = 0;
    self.isPregenancy_preEclampsia = 0;
    self.isSmoking = 0;
    self.isAlcoholIntake = 0;
    
    
    switch (num) {
        case 0:
            self.isHypertension = 1;
            break;
        case 1:
            self.isAtrialFibrillation = 1;
            break;
        case 2:
            self.isDiabetes = 1;
            break;
        case 3:
            self.isCardiovascular = 1;
            break;
        case 4:
            self.isChronicKindey = 1;
            break;
        case 5:
            self.isTransientIschemicAttact = 1;
            break;
        case 6:
            self.isDyslipidemia = 1;
            break;
        case 7:
            self.isSnoringOrSleepAponea = 1;
            break;
        case 8:
            self.isUseOralContraception = 1;
            break;
        case 9:
            self.isUseAntiHypertensive = 1;
            break;
        case 10:
            self.isPregenancy_normoal = 1;
            break;
        case 11:
            self.isPregenancy_preEclampsia = 1;
            break;
        case 12:
            self.isSmoking = 1;
            break;
        case 13:
            self.isAlcoholIntake = 1;
            break;
        default:
            break;
    
    }
    
}


-(NSString *)translateRiskFactorToString {
    
    NSMutableArray *checkAry = [[NSMutableArray alloc] init];
    for (int i = 0; i < 14; i++) {
        
        [checkAry addObject:@"0"];
    }
    
    checkAry[0] = self.isHypertension == 1 ? @"1" : @"0";
    checkAry[1] = self.isAtrialFibrillation == 1 ? @"1" : @"0";
    checkAry[2] = self.isDiabetes == 1 ? @"1" : @"0";
    checkAry[3] = self.isCardiovascular == 1 ? @"1" : @"0";
    checkAry[4] = self.isChronicKindey == 1 ? @"1" : @"0";
    checkAry[5] = self.isTransientIschemicAttact == 1 ? @"1" : @"0";
    checkAry[6] = self.isDyslipidemia == 1 ? @"1" : @"0";
    checkAry[7] = self.isSnoringOrSleepAponea == 1 ? @"1" : @"0";
    checkAry[8] = self.isUseOralContraception == 1 ? @"1" : @"0";
    checkAry[9] = self.isUseAntiHypertensive == 1 ? @"1" : @"0";
    checkAry[10] = self.isPregenancy_normoal == 1 ? @"1" : @"0";
    checkAry[11] = self.isPregenancy_preEclampsia == 1 ? @"1" : @"0";
    checkAry[12] = self.isSmoking == 1 ? @"1" : @"0";
    checkAry[13] = self.isAlcoholIntake == 1 ? @"1" : @"0";
    
    NSMutableString *riskFactorStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < checkAry.count; i++) {
        
        if ([checkAry[i] isEqualToString:@"1"]) {
            
            [riskFactorStr appendFormat:@"%d,",i];
        }
    }
   
    if (riskFactorStr.length > 1) {
        
        [riskFactorStr deleteCharactersInRange:NSMakeRange(riskFactorStr.length - 1, 1)];
    }
    
    
    NSLog(@"riskFactorStr =======>>>>> %@",riskFactorStr);
    
    return riskFactorStr;
}


-(NSString *)translateRiskFactorToGloableStr{
    
    NSMutableArray *checkAry = [[NSMutableArray alloc] init];
    for (int i = 0; i < 14; i++) {
        [checkAry addObject:@"0"];
    }
    checkAry[0] = self.isHypertension == 1 ? @"1" : @"0";
    checkAry[1] = self.isAtrialFibrillation == 1 ? @"1" : @"0";
    checkAry[2] = self.isDiabetes == 1 ? @"1" : @"0";
    checkAry[3] = self.isCardiovascular == 1 ? @"1" : @"0";
    checkAry[4] = self.isChronicKindey == 1 ? @"1" : @"0";
    checkAry[5] = self.isTransientIschemicAttact == 1 ? @"1" : @"0";
    checkAry[6] = self.isDyslipidemia == 1 ? @"1" : @"0";
    checkAry[7] = self.isSnoringOrSleepAponea == 1 ? @"1" : @"0";
    checkAry[8] = self.isUseOralContraception == 1 ? @"1" : @"0";
    checkAry[9] = self.isUseAntiHypertensive == 1 ? @"1" : @"0";
    checkAry[10] = self.isPregenancy_normoal == 1 ? @"1" : @"0";
    checkAry[11] = self.isPregenancy_preEclampsia == 1 ? @"1" : @"0";
    checkAry[12] = self.isSmoking == 1 ? @"1" : @"0";
    checkAry[13] = self.isAlcoholIntake == 1 ? @"1" : @"0";
    
    NSMutableString *riskFactorStr = [[NSMutableString alloc] init];
    for (int i = 0; i < checkAry.count; i++) {
        
        if ([checkAry[i] isEqualToString:@"1"]) {
            
            NSString *risk;
            
            switch (i) {
                case 0:
                    risk = NSLocalizedString(@"Personal History of Atrial FibrillationHypertension", nil);
                    break;
                case 1:
                     risk = NSLocalizedString(@"Personal History of Atrial Fibrillation", nil);
                    break;
                case 2:
                     risk = NSLocalizedString(@"Personal History of Diabetes", nil);
                    break;
                case 3:
                     risk = NSLocalizedString(@"Personal History of Cardiovascular diseases (CVD)", nil);
                    break;
                case 4:
                     risk = NSLocalizedString(@"Personal History of Chronic Kidney Disease (CKD)", nil);
                    break;
                case 5:
                     risk = NSLocalizedString(@"Personal History of Stroke/Transient Ischemic Attack (TIA)", nil);
                    break;
                case 6:
                     risk = NSLocalizedString(@"Personal History of Dyslipidemia", nil);
                    break;
                case  7:
                     risk = NSLocalizedString(@"Personal History of Snoring & Sleep Aponea", nil);
                    break;
                case 8:
                     risk = NSLocalizedString(@"Drug Use–Oral Contraception", nil);
                    break;
                case  9:
                     risk = NSLocalizedString(@"Drug Use–Anti-Hypertensive Drugs", nil);
                    break;
                case 10:
                     risk = NSLocalizedString(@"Pregenancy - Normal", nil);
                    break;
                case 11:
                     risk = NSLocalizedString(@"Pregnancy–Pre-Eclampsia", nil);
                    break;
                case 12:
                     risk = NSLocalizedString(@"Smoking", nil);
                    break;
                case 13:
                     risk = NSLocalizedString(@"Alcohol Intake", nil);
                    break;
                default:
                    break;
            }
            
            [riskFactorStr appendFormat:@"%@,",risk];
        }
    }

    if (riskFactorStr.length > 1) {
        
        [riskFactorStr deleteCharactersInRange:NSMakeRange(riskFactorStr.length - 1, 1)];
    }
    
    return riskFactorStr;
}




#pragma mark - indicator  *********************
-(void)showIndicatorView {
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    indicatorView.backgroundColor = [UIColor lightGrayColor];
    
    indicatorView.center = self.view.center;
    
    indicatorView.alpha = 0.5;
    
    [indicatorView startAnimating];
    
    [self.view addSubview:indicatorView];
    
    [self.view bringSubviewToFront:indicatorView];
}

-(void)stopIndicatorView {
    
    if (indicatorView != nil) {
        
        [indicatorView stopAnimating];
        
        [indicatorView removeFromSuperview];
        
        indicatorView = nil;
    }
    
}


@end

/** initialization value
 -------------------------------------
 LocalData name = (null) (default: User Name)
 -------------------------------------
 Gender:0 (default: 0)  /Male
 -------------------------------------
 birthday:(null) (default: Today)
 -------------------------------------
 height_value:0.000000 (default: 175 cm)
 -------------------------------------
 weight_value:0.000000 (default: 75 kg)
 -------------------------------------
 cuffsize_row:0 (default: 0)  /s
 -------------------------------------
 measureArm_row:0 (default: 0)  /left
 -------------------------------------
 unitBooL:0  /Metric
 -------------------------------------
 pressureBooL:0  /mmHg
 -------------------------------------
 sys_pressure_value:0 (default: 135 mmHg)
 -------------------------------------
 sysActive:0
 -------------------------------------
 dia_pressure_value:0 (default: 85 mmHg)
 -------------------------------------
 diaActive:0
 -------------------------------------
 goalweight_value:0.000000 (default: 75 kg)
 -------------------------------------
 goalWeightActive:0
 -------------------------------------
 BMI_value:0.000000 (default: 23)
 -------------------------------------
 BMIActive:0
 -------------------------------------
 bodyFatActive:0
 -------------------------------------
 BF_value:0.000000 (default: 20)
 -------------------------------------
 thresholdActive:0
 -------------------------------------
 dateformatBool:0
 -------------------------------------
 */


