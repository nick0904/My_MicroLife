//
//  MViewController.m
//  FuelSation
//
//  Created by Tom on 2016/4/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"
#import "HealthEducationViewController.h"
#import "NotificationViewController.h"
#import "AboutViewController.h"
#import "LogoutViewController.h"
#import "NavViewController.h"

@interface MViewController ()


@end

@implementation MViewController

@synthesize imgScale,appDelegate;
@synthesize sidebarcloseBtn;
@synthesize circleview;
#pragma mark - System default

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(IS_IPHONE_5){
        imgScale = 2.2;
    }else if(IS_IPHONE_6){
        imgScale = 2;
    }else if(IS_IPHONE_6P){
        imgScale = 1.75;
    }else{
        imgScale = 2.5;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    //改變 statusBarStyle(字體變白色)
    //先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}


//螢幕快照
-(UIImage *)snapShotView:(UIView *)inputView{
    
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Screen Rotation

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    //return NO;
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - left menu
-(void)SidebarBtn{
    
    
    int BtnRedius = self.view.frame.size.height/10;
    
    circle2view = [[UIView alloc] initWithFrame:CGRectMake(-BtnRedius*10, -BtnRedius*10, BtnRedius*20, BtnRedius*20)];
    [circle2view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:0.84]];
    circle2view.layer.cornerRadius = BtnRedius*10;
    [[circle2view layer] setMasksToBounds:YES];
    circle2view.hidden = YES;
    
    [self.tabBarController.view addSubview:circle2view];
    
    
    circleview = [[UIView alloc] initWithFrame:CGRectMake(-BtnRedius, -BtnRedius, BtnRedius*2, BtnRedius*2)];
    [circleview setBackgroundColor:[UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:0.84]];
    circleview.layer.cornerRadius = BtnRedius;
    [[self.circleview layer] setMasksToBounds:YES];
    self.circleview.userInteractionEnabled = YES;
    
    
    sidebarcloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [sidebarcloseBtn setBackgroundColor:[UIColor clearColor]];
    [sidebarcloseBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica"size:36]];
    //[sidebarcloseBtn setTitle:@"close" forState:UIControlStateNormal];
    sidebarcloseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    sidebarcloseBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [sidebarcloseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sidebarcloseBtn addTarget:self action:@selector(sidebarClose) forControlEvents:UIControlEventTouchUpInside];
    
    // [self.view addSubview:circleview];
    [self.tabBarController.view addSubview:circleview];
    // [self.view addSubview:sidebarcloseBtn];
    [self.tabBarController.view addSubview:sidebarcloseBtn];
    
    
    
    circleview.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:0.6];
    //圖片放大X倍
    circleview.transform = CGAffineTransformMakeScale(20.0f, 20.0f);
    /* Commit the animation */
    [UIView commitAnimations];
    
    /**
    float imageRadius = 10.0f;
    UIImageView *personalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, imageRadius, imageRadius)];
    UIImage *personImage;
    personalImageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    
    personalImageView.image = personImage;
    NSLog(@"personalImageView.x = %f",personalImageView.frame.origin.x);
    
    [personalImageView.layer setMasksToBounds:YES];
    personalImageView.layer.cornerRadius = imageRadius/2;
    
    
    [self.sidebarcloseBtn addSubview:personalImageView];
    */
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
//    /* 圖片置中 */
//    //self.personalImageView.center = self.view.center;
//    //設置轉換標誌
//    personalImageView.transform = CGAffineTransformIdentity;
//    /* 動畫開始 */
//    [UIView beginAnimations:nil context:NULL];
//    /* 動畫時間*/
//    [UIView setAnimationDelay:0.1];
//    [UIView setAnimationDuration:0.2];
//    //圖片放大X倍
//    //[personalImageView layer].anchorPoint = CGPointMake(0.0f, 0.0f);
//    personalImageView.transform = CGAffineTransformMakeScale(10.0f, 10.0f);
//    /* Commit the animation */
//    [UIView commitAnimations];
    
    
    
    [self ImageExpand];
    [self Icon1];
    [self Icon2];
    [self Icon3];
    [self Icon4];
    [self PersonLabel];
    [self ImformationButton];
    [self setBackgroundColor];
    
 
    
}

-(void) sidebarClose{
    
    [circleview removeFromSuperview];
    
    circle2view.hidden = NO;
    
    //[sidebarcloseBtn removeFromSuperview];
    circle2view.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:0.4];
    // 圖片放大X倍
    circle2view.transform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
    // Commit the animation
    
    [UIView commitAnimations];
    
    //[sidebarcloseBtn removeFromSuperview];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sidebarcloseBtnClose) userInfo:nil repeats:NO];
    
    [self setBackgroundColor];
    

    
}


-(void)sidebarcloseBtnClose{
    
    [sidebarcloseBtn removeFromSuperview];
}

-(void) ImageExpand{
    
    float imageRadius = 10.0f;
    
    UIImageView *personalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, imageRadius, imageRadius)];
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
    
    personalImageView.image = personImage;
    personalImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSLog(@"personalImageView.x = %f",personalImageView.frame.origin.x);
    
    
    [personalImageView.layer setMasksToBounds:YES];
    personalImageView.layer.cornerRadius = imageRadius/2;
    
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.sidebarcloseBtn addSubview:personalImageView];
    
    /* 圖片置中 */
    //self.personalImageView.center = self.view.center;
    //設置轉換標誌
    personalImageView.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationDuration:0.2];
    //圖片放大X倍
    //[personalImageView layer].anchorPoint = CGPointMake(0.0f, 0.0f);
    personalImageView.transform = CGAffineTransformMakeScale(10.0f, 10.0f);
    /* Commit the animation */
    [UIView commitAnimations];
    
}

-(void) PersonLabel{
    
    NSString *userName;
    
    if ([MViewController checkUserNamePath] == NO) {
        //Fix 未登入時不顯示名字
        userName = @"";
    }
    else {
        
        userName = [NSString stringWithContentsOfFile:USER_NAME_FILEPATH encoding:NSUTF8StringEncoding error:nil];
    }
    
    int labelHeight = 20;
    int labelwidth = 90;
    CGRect namelabelFrame = CGRectMake(80.0f/2, 160+20 , labelwidth+30 , (labelHeight+6));
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:namelabelFrame];
    [nameLabel setTextColor:[UIColor whiteColor]];
    nameLabel.alpha = 1;
    nameLabel.text = userName;
    nameLabel.font = [UIFont systemFontOfSize:22];
    [nameLabel sizeToFit];
    [self.sidebarcloseBtn addSubview:nameLabel];
    
    
    nameLabel.transform = CGAffineTransformIdentity;
    [nameLabel layer].anchorPoint = CGPointMake(0.5, 1);  //錨點
    [UIView animateKeyframesWithDuration:0.4 delay:0.1 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.0 animations: ^{
            
            nameLabel.transform = CGAffineTransformMakeScale(1.0, 0.001);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations: ^{
            
            nameLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
    
    CGRect emaillabelFrame = CGRectMake(80.0f/2, 160+20+labelHeight+15 , 4*labelwidth , labelHeight);
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:emaillabelFrame];
    [emailLabel setTextColor:[UIColor whiteColor]];
    emailLabel.text = [self getUserEmail];
    emailLabel.font = [UIFont systemFontOfSize:17];
    [emailLabel sizeToFit];
    emailLabel.alpha = 1.0;
    [self.sidebarcloseBtn addSubview:emailLabel];
    
    emailLabel.transform = CGAffineTransformIdentity;
    [emailLabel layer].anchorPoint = CGPointMake(0.5, 1);  //錨點
    [UIView animateKeyframesWithDuration:0.4 delay:0.1 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.0 animations: ^{
            
            emailLabel.transform = CGAffineTransformMakeScale(1.0, 0.001);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations: ^{
            
            emailLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
    
}

-(void) ImformationButton{
    int bx = 122;
    int by = 265;
    int imbuttonHeight = 30;
    int imbuttonwidth = 140;
    
    CGRect buttonIB1Frame = CGRectMake( bx, by, imbuttonwidth, imbuttonHeight );
    UIButton *buttonIB1 = [[UIButton alloc] initWithFrame: buttonIB1Frame];
    [buttonIB1 setTitle:NSLocalizedString(@"HealthEducation", nil) forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor blueColor]];
    [buttonIB1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonIB1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonIB1.alpha = 0.0;
    
    [self.sidebarcloseBtn addSubview:buttonIB1];
    [UIView animateWithDuration:0.05 delay:0.2 options:0 animations:^{
        buttonIB1.alpha = 1.0;
    } completion:^(BOOL finished) {
        //NSLog(@"動畫完成了");
    }];
    [buttonIB1 addTarget:self action:@selector(onClickButtonIB1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect buttonIB2Frame = CGRectMake( bx, by+60, imbuttonwidth, imbuttonHeight );
    UIButton *buttonIB2 = [[UIButton alloc] initWithFrame: buttonIB2Frame];
    [buttonIB2 setTitle:NSLocalizedString(@"Notification", nil) forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor blueColor]];
    [buttonIB2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonIB2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonIB2.alpha = 0.0;
    
    [self.sidebarcloseBtn addSubview:buttonIB2];
    
    [UIView animateWithDuration:0.05 delay:0.35 options:0 animations:^{
        buttonIB2.alpha = 1.0;
    } completion:^(BOOL finished) {
        //NSLog(@"動畫完成了2");
    }];
    [buttonIB2 addTarget:self action:@selector(onClickButtonIB2:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect buttonIB3Frame = CGRectMake( bx, by+120, imbuttonwidth, imbuttonHeight );
    UIButton *buttonIB3 = [[UIButton alloc] initWithFrame: buttonIB3Frame];
    [buttonIB3 setTitle:NSLocalizedString(@"About", nil) forState:UIControlStateNormal];
    buttonIB3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[button setBackgroundColor:[UIColor blueColor]];
    [buttonIB3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonIB3.alpha = 0.0;
    
    [self.sidebarcloseBtn addSubview:buttonIB3];
    [UIView animateWithDuration:0.05 delay:0.5 options:0 animations:^{
        buttonIB3.alpha = 1.0;
    } completion:^(BOOL finished) {
        //NSLog(@"動畫完成了3");
    }];
    [buttonIB3 addTarget:self action:@selector(onClickButtonIB3:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect buttonIB4Frame = CGRectMake( bx, by+180, imbuttonwidth, imbuttonHeight );
    UIButton *buttonIB4 = [[UIButton alloc] initWithFrame: buttonIB4Frame];
    [buttonIB4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonIB4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonIB4.alpha = 0.0;
    
    if([NSString stringWithContentsOfFile:USER_EMAIL_FILEPATH encoding:NSUTF8StringEncoding error:nil] != nil){
        [buttonIB4 setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    }
    else{
        if([NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil] != nil){
            [buttonIB4 setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        }
        else{
            [buttonIB4 setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
        }
    }
    
    
    [self.sidebarcloseBtn addSubview:buttonIB4];
    [UIView animateWithDuration:0.05 delay:0.65 options:0 animations:^{
        buttonIB4.alpha = 1.0;
    } completion:^(BOOL finished) {
        // NSLog(@"動畫完成了4");
    }];
    [buttonIB4 addTarget:self action:@selector(onClickButtonIB4:) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - 跳至 HealthEducationVC
-(IBAction)onClickButtonIB1:(UIButton *)sender{
    
    NSLog(@"HealthEducationVC");

    HealthEducationViewController *HealthEducationVC = [HealthEducationViewController new];
    
    [self presentViewController:HealthEducationVC animated:YES completion:nil];
    
    HealthEducationVC.view.backgroundColor = [UIColor whiteColor];
    HealthEducationVC.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    self.definesPresentationContext = YES;

}


#pragma mark - 跳至 NotificationVC
-(IBAction)onClickButtonIB2:(UIButton *)sender{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *notificationVC = [storyboard instantiateViewControllerWithIdentifier:@"SideBarNotificationVC"];
    [self presentViewController:notificationVC animated:YES completion:nil];

    
    /**
    NotificationViewController  *NotificationVC = [NotificationViewController new];
    
    [self presentViewController:NotificationVC animated:YES completion:nil];
    
    NotificationVC.view.backgroundColor = [UIColor whiteColor];
    NotificationVC.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    self.definesPresentationContext = YES;
     */
}

#pragma mark - 跳至 AboutVC
-(IBAction)onClickButtonIB3:(UIButton *)sender{
    
    
    NSLog(@"AboutVC");
    AboutViewController *AboutVC = [AboutViewController new];
    
    [self presentViewController:AboutVC animated:YES completion:nil];
    
    AboutVC.view.backgroundColor = [UIColor whiteColor];
    AboutVC.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    self.definesPresentationContext = YES;
    
}


#pragma mark - 跳至 LogoutVC
-(IBAction)onClickButtonIB4:(UIButton *)sender{
    
    NSLog(@"Logout");
   
    ///登出時變成隱私模式
    [MViewController setPrivacyModeOrMemberShip:YES];
    
    //清除驗證資訊
    appDelegate.codeNum = 0;
    [AppDelegate saveNSUserDefaults:appDelegate.codeNum Key:@"code"];
    
    ///直接做登出的動作,並且回到導覽頁
    NavViewController *nav = [[NavViewController alloc] init];
    [self presentViewController:nav animated:YES completion:nil];
    
    [self clearedUserData];
    
}

/**
 登出清除使用者資訊
 */
- (void)clearedUserData {
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:USER_IMAGE_FILEPATH error:nil];
    [manager removeItemAtPath:USER_EMAIL_FILEPATH error:nil];
    [manager removeItemAtPath:ISSYNC_HEALTHKIT error:nil];
    [manager removeItemAtPath:USER_NAME_FILEPATH error:nil];
    [manager removeItemAtPath:ConnectingDevie_NamePath error:nil];
}

-(void) Icon1{
    
    UIImageView *iconImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(60-15, 265-15, 0.01, 30)];
    UIImage *iconImg1 = [UIImage imageNamed:@"menu_icon_a_health"];
    iconImgV1.image = iconImg1;
    iconImgV1.contentMode = UIViewContentModeScaleToFill;
    [self.sidebarcloseBtn addSubview :iconImgV1];
    
    
    //設置轉換標誌
    iconImgV1.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationDuration:0.1];
    //圖片放大X倍
    [iconImgV1 layer].anchorPoint = CGPointMake(0.0f, 0.0f);
    iconImgV1.transform = CGAffineTransformMakeScale(3000.0f, 1.0f);
    
    /* Commit the animation */
    [UIView commitAnimations];
    
}

-(void) Icon2{
    
    UIImageView *iconImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(60-15, 325-15, 0.01, 30)];
    UIImage *iconImg2 = [UIImage imageNamed:@"menu_icon_a_notification"];
    iconImgV2.image = iconImg2;
    iconImgV2.contentMode = UIViewContentModeScaleToFill;
    [self.sidebarcloseBtn addSubview :iconImgV2];
    
    
    //設置轉換標誌
    iconImgV2.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.35];
    [UIView setAnimationDuration:0.1];
    //圖片放大X倍
    [iconImgV2 layer].anchorPoint = CGPointMake(0.0f, 0.0f);
    iconImgV2.transform = CGAffineTransformMakeScale(3000.0f, 1.0f);
    
    /* Commit the animation */
    [UIView commitAnimations];
    
}

-(void) Icon3{
    
    UIImageView *iconImgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(60-15, 385-15, 0.01, 30)];
    UIImage *iconImg3 = [UIImage imageNamed:@"menu_icon_a_about"];
    iconImgV3.image = iconImg3;
    iconImgV3.contentMode = UIViewContentModeScaleToFill;
    [self.sidebarcloseBtn addSubview :iconImgV3];
    
    
    //設置轉換標誌
    iconImgV3.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:0.1];
    //圖片放大X倍
    [iconImgV3 layer].anchorPoint = CGPointMake(0.0f, 0.0f);
    iconImgV3.transform = CGAffineTransformMakeScale(3000.0f, 1.0f);
    
    /* Commit the animation */
    [UIView commitAnimations];
    
}

-(void) Icon4{
    
    UIImageView *iconImgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(60-15, 445-15, 0.01, 30)];
    UIImage *iconImg4 = [UIImage imageNamed:@"menu_icon_a_logout"];
    iconImgV4.image = iconImg4;
    iconImgV4.contentMode = UIViewContentModeScaleToFill;
    [self.sidebarcloseBtn addSubview :iconImgV4];
    
    
    //設置轉換標誌
    iconImgV4.transform = CGAffineTransformIdentity;
    /* 動畫開始 */
    [UIView beginAnimations:nil context:NULL];
    /* 動畫時間*/
    [UIView setAnimationDelay:0.65];
    [UIView setAnimationDuration:0.1];
    //圖片放大X倍
    [iconImgV4 layer].anchorPoint = CGPointMake(0.0f, 0.0f);
    iconImgV4.transform = CGAffineTransformMakeScale(3000.0f, 1.0f);
    
    /* Commit the animation */
    [UIView commitAnimations];
    
}


-(void) setBackgroundColor {
    self.view.backgroundColor = [UIColor whiteColor];
}

-(UIImage *)resizeImage:(UIImage *)image{
    
    UIImage *originalImage = image;
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:(originalImage.scale * self.imgScale)
                  orientation:(originalImage.imageOrientation)];
    
    return scaledImage;
}



#pragma mark - get User Email Account
-(NSString *)getUserEmail {
    
    NSString *email;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isExist = [manager fileExistsAtPath:USER_EMAIL_FILEPATH];
    
    if (isExist) {
        
        email = [NSString stringWithContentsOfFile:USER_EMAIL_FILEPATH encoding:NSUTF8StringEncoding error:nil];
    }
    else {
        
        //Fix 未登入時不顯示mail
        email = @"";
    }
    
    return email;
}


#pragma mark - Class Functions
//取得字串長度
+(NSUInteger)getStringLength:(NSString *)text {
    
    return text.length;
}

//警告提示
+(void)showAlert:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles: nil];
    [alertView show];
    alertView = nil;
}



#pragma mark -  檢查是 privacy 或 會員模式  ********************
+(BOOL)checkIsPrivacyModeOrMemberShip {
    
    BOOL isPrivacy = YES; //NO:會員制 / YES:隱私模式
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //先判斷路徑是否存在
    BOOL isExist = [manager fileExistsAtPath:ISPRIVACY_MODE];
    
    if (isExist) {
        
        NSString *fileName = ISPRIVACY_MODE;
        NSString *valueStr = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        isPrivacy = [valueStr isEqualToString:@"YES"] ? YES : NO;
        
    }
    else {
        
        isPrivacy = YES;
    }

    return isPrivacy;
}

//設定是會員模式還是privacy
+(void)setPrivacyModeOrMemberShip:(BOOL)isPrivacy {

    NSString *fileName = ISPRIVACY_MODE;
    NSString *valueStr = isPrivacy == YES ? @"YES" : @"NO"; //NO:會員制 / YES:隱私模式
    [valueStr writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
 
}



#pragma mark - 判斷大頭照路徑是否存在  ********************
-(BOOL)checkUserImagePathIsExistOrNot {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isExist = [manager fileExistsAtPath:USER_IMAGE_FILEPATH];
    
    return isExist;
}




#pragma mark -  檢查是否與 HealthKit 同步  ********************
+(BOOL)checkIsSyncWithHealthKit {
    
    BOOL isSync = NO; //預設不同步
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //先判斷路徑是否存在
    BOOL isExist = [manager fileExistsAtPath:ISSYNC_HEALTHKIT];
    
    if (isExist) {
        
        NSString *fileName = ISSYNC_HEALTHKIT;
        NSString *valueStr = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        isSync = [valueStr isEqualToString:@"YES"] ? YES : NO;
    }
    else {
        
        isSync = NO;
    }
    
    return isSync;
}

//設定是否與 HealthKit 同步
+(void)setSyncWithHealthKit:(BOOL)isSyncHealthKit {
    
    NSString *fileName = ISSYNC_HEALTHKIT;
    NSString *valueStr = isSyncHealthKit == YES ? @"YES" : @"NO";
    [valueStr writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


#pragma mark - token  ****************************
+(void)saveAccess_token:(NSString *)access_tokenStr {
    
    NSString *fileName = OAuth_TOKEN;
    //NSString *valueStr = [NSString stringWithContentsOfFile:access_tokenStr encoding:NSUTF8StringEncoding error:nil];
    BOOL save = [access_tokenStr writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}



#pragma mark - refresh token  ****************************
+(void)saveRefresh_token:(NSString *)refresh_tokenStr {
    
    NSString *fileName = OAuth_Refreash_TOKEN;
    //NSString *valueStr = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    BOOL save = [refresh_tokenStr writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


#pragma mark -  User Name

+(BOOL)checkUserNamePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isExist = [manager fileExistsAtPath:USER_NAME_FILEPATH];
    
    return isExist;

}


+(void)saveUserName:(NSString *)userName {
    
    NSString *fileName = USER_NAME_FILEPATH;
    
    [userName writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}



//Connecting Device Name
+(BOOL)checkConnectingDeviceNamePath {
    
    NSFileManager *mangager = [NSFileManager defaultManager];
    
    BOOL isExist = [mangager fileExistsAtPath:ConnectingDevie_NamePath];
    
    return isExist;
}

+(void)saveConnectingDeviceName:(NSString *)deviceName {
    
    NSString *fileName = ConnectingDevie_NamePath;
    
    [deviceName writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


//transformMacAddress
+(NSString *)transformMacAddress:(NSString *)originMacAddress {
    
    NSMutableString *macAddressString = [[NSMutableString alloc] init];
    
    for (int i = 0 ; i < originMacAddress.length; i+=2) {
        
        [macAddressString appendString:[NSString stringWithFormat:@"%@:",[originMacAddress substringWithRange:NSMakeRange(i, 2)]]];
    }
    
    [macAddressString deleteCharactersInRange:NSMakeRange(macAddressString.length - 1, 1)];
    
    NSString *finalStr = (NSString *)macAddressString;
    
    return finalStr;
}




@end
