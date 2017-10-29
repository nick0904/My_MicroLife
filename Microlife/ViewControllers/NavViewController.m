//
//  NavViewController.m
//  Microlife
//
//  Created by 點睛 on 2016/9/21.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "NavViewController.h"
#import "ViewController.h"


@implementation NavViewController {
    
    UIPageControl *pageControl;
    UIScrollView *navScrollView;
    ViewController *loginVC;
    UIView *logoView;
    APIPostAndResponse *apiClass;
    
    int m_accountID;
    
}
@synthesize navImageArray,navTextArray;

#define PRIVACY_MODE_MESSAGE @"Microlife Connected Health+ offers a Privacy Mode for users who choose not to synchronize their data to Microlife Cloud. You do not need a Microlife Account to use Privacy Mode, and all your data are stored locally on your smart phone. Please Note that in Privacy Mode your data are not back up on cloud storage, and you will not receive any service-related and promotional information from Microlife."


#pragma mark - Normal Function  ***************************
-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentVC = self;
    
    //API init
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
    [self showLogoView];
}



-(void)viewWillAppear:(BOOL)animated {
    
    if ([appDelegate.codeNum intValue] == 10000)  {
        
        [self checkResponseCodeForToken:appDelegate.codeNum beContinue:NO];
        
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        [apiClass postGetMemberBaseData:tokenStr client_id:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" client_secret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C"];

    }
    else {
        
        [self checkResponseCodeForToken:appDelegate.codeNum beContinue:YES];
    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [self performSelector:@selector(showNavView) withObject:nil afterDelay:3.0];
    
}


#pragma mark - initilization  ***************************
-(void)showNavView {
    
    [logoView removeFromSuperview];
    
    [self initParameter];
    [self initInterface];
}



-(void)initParameter {
    
    navImageArray=[[NSMutableArray alloc]init];
    navTextArray=[[NSMutableArray alloc]init];
    
    //儲存5張圖片名稱
    for (int i=0; i<5; i++)
    {
        [navImageArray addObject:[NSString stringWithFormat:@"walkthrough_%d",i+1]];
    }
    
    //儲存5張圖片說明
    [navTextArray addObject:NSLocalizedString(@"At microlife, we are deeply committed to empower you and your loved ones to live healthier lives.", nil)];
    [navTextArray addObject:NSLocalizedString(@"Our mission is to bring innovative medical technologies to your home to make health management easier, smarter, and more accurate.", nil)];
    [navTextArray addObject:NSLocalizedString(@"Use Microlife Connect Health + for simple overview and safekeeping of your readings. Stay on top of your health with ease, anytime, anywhere.", nil)];
    [navTextArray addObject:NSLocalizedString(@"Set goals and reminders to establish healthy routines and monitor progresses for you and your loved ones.", nil)];
    [navTextArray addObject:NSLocalizedString(@"Your partner for better health management.", nil)];
}

-(void)initInterface {
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*1175/1334, SCREEN_WIDTH, SCREEN_HEIGHT*0.02)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[self resizeImage:[UIImage imageNamed:@"walkthrough_page_1"]]];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[self resizeImage:[UIImage imageNamed:@"walkthrough_page_0"]]];
    
    
    navScrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    navScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*navImageArray.count, SCREEN_HEIGHT);
    navScrollView.pagingEnabled=YES;
    navScrollView.bounces=NO;
    navScrollView.delegate=self;
    
    for (int i=0; i<navImageArray.count; i++)
    {
        
        UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        UILabel *navTextlabel=[[UILabel alloc]initWithFrame:CGRectMake(40, SCREEN_HEIGHT*920/1334, SCREEN_WIDTH-80,50)];
        [navTextlabel setNumberOfLines:0];
        [navTextlabel setLineBreakMode:NSLineBreakByWordWrapping];
        [navTextlabel setText:[navTextArray objectAtIndex:i]];
        CGSize size = [navTextlabel sizeThatFits:CGSizeMake(navTextlabel.frame.size.width, MAXFLOAT)];
        [navTextlabel setFrame:CGRectMake(40, SCREEN_HEIGHT*920/1334, SCREEN_WIDTH-80,size.height)];
        [navTextlabel setTextColor:[UIColor whiteColor]];
        [navTextlabel setTextAlignment:NSTextAlignmentCenter];
        
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backImageView.image=[self resizeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[navImageArray objectAtIndex:i]]]];
        
        [navView addSubview:backImageView];
        [navView addSubview:navTextlabel];
        
        //最後一頁
        if (i==navTextArray.count-1)
        {
            UIButton *privacyBtn=[[UIButton alloc]init];
            [privacyBtn setBackgroundImage:[UIImage imageNamed:@"walkthrough_btn_privacy"] forState:UIControlStateNormal];
            [privacyBtn setTitle:NSLocalizedString(@"Privacy Mode", nil) forState:UIControlStateNormal];
            [privacyBtn setTintColor:[UIColor whiteColor]];
            [privacyBtn setFrame:CGRectMake(SCREEN_WIDTH*220/750, SCREEN_HEIGHT*1030/1334, 300*SCREEN_WIDTH/750, 100*SCREEN_HEIGHT/1334)];
            [privacyBtn addTarget:self action:@selector(clickPrivacyBtn) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*165/750, SCREEN_HEIGHT*800/1334, 400*SCREEN_WIDTH/750, 100*SCREEN_HEIGHT/1334)];
            
            [logoImage setImage:[UIImage imageNamed:@"walkthrough_logo"]];
            
            UIButton *nextPageBtn=[[UIButton alloc]init];
            [nextPageBtn setFrame:CGRectMake(0, SCREEN_HEIGHT-100*SCREEN_HEIGHT/1334, SCREEN_WIDTH, 100*SCREEN_HEIGHT/1334)];
            [nextPageBtn setBackgroundColor:STANDER_COLOR];
            [nextPageBtn setTitle:NSLocalizedString(@"NextPage", nil) forState:UIControlStateNormal];
            [nextPageBtn setTintColor:[UIColor whiteColor]];
            [nextPageBtn addTarget:self action:@selector(clickNextPageBtn) forControlEvents:UIControlEventTouchUpInside];
            [navView addSubview:privacyBtn];
            [navView addSubview:logoImage];
            [navView addSubview:nextPageBtn];
        }
        
        [navScrollView addSubview:navView];
    }
    
    [self.view addSubview:navScrollView];
    [self.view addSubview:pageControl];
}



-(void)showLogoView {
    
    logoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [logoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:logoView];
    
    //add logo image
    CGFloat logo_w=SCREEN_WIDTH*0.8;
    CGFloat logo_h=SCREEN_HEIGHT*0.6;
    CGFloat logo_x=(SCREEN_WIDTH/2.0)-(logo_w/2.0);
    CGFloat logo_y=(SCREEN_HEIGHT/3.0);//-(logo_h/2.0);
    
    UIImage *logoImage=[UIImage imageNamed:@"ml_logo"];
    UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(logo_x, logo_y, logo_w, logo_h)];
    [logoImageView setImage:logoImage];
    [logoView addSubview:logoImageView];
    
}



#pragma mark - scrollView delegate  ***************************
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == navScrollView)
    {
        CGFloat width = scrollView.frame.size.width;
        NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
        [pageControl setCurrentPage:currentPage];
    }
}




#pragma mark - Btn Aciton  ***************************
-(void)clickPrivacyBtn {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(PRIVACY_MODE_MESSAGE, nil) preferredStyle:UIAlertControllerStyleAlert];
    
    //confirm
    UIAlertAction *confirmBt = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        
        [LocalData sharedInstance].accountID = -1;
        
        [MViewController setPrivacyModeOrMemberShip:YES];//NO:會員制 / YES:隱私模式
        
        [self presentViewController:vc animated:YES completion:nil];

        
    }];
    [alert addAction:confirmBt];
    
    //cancel
    UIAlertAction *cancelBt = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelBt];
    
    [self presentViewController:alert animated:YES completion:nil];
   }



-(void)clickNextPageBtn {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
//    
//    [self presentViewController:vc animated:YES completion:nil];
    
    /** 改成用 webView 取 token
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    [self presentViewController:vc animated:YES completion:nil];
     */
    
//    if (loginVC == nil) {
//        
//        loginVC = (ViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
//    }
    
    //[appDelegate.window setRootViewController:vc];
    
    //[appDelegate.window makeKeyAndVisible];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//        SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:WEBVIEW_URL] entersReaderIfAvailable:YES];
//        [self presentViewController:webVC animated:YES completion:nil];
//    }else {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBVIEW_URL]]];
//    }
    
    [self webViewWhithURL:WEBVIEW_URL];
    
    [appDelegate setMemberActionLogWithdevice_type:0 log_action:1];
}

#pragma mark - check token  ************************************
-(void)checkResponseCodeForToken:(NSNumber *)code beContinue:(BOOL)beContinue {
    
    code = [NSNumber numberWithInt:[appDelegate.codeNum intValue]];
    
    NSString *getTokenSuccessful = NSLocalizedString(@"驗證成功", nil);
    NSString *expired_authorization_code = NSLocalizedString(@"驗證碼失效", nil);
    NSString *tokenExpired_refresh_token = NSLocalizedString(@"驗證失敗", nil);
    NSString *tokenExpired_access_token = NSLocalizedString(@"原驗證碼失效", nil);
    
    
    if ([code intValue] == 10000 && beContinue == YES) {
        
        //非隱私模式
        [MViewController setPrivacyModeOrMemberShip:NO];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:getTokenSuccessful message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
            //刪除Database，最後下載雲端資料存到Database
            [self getAllData:[LocalData sharedInstance].accountID];

            
            //登入時,先判斷帳號 -1 有無資料,有則跳出Alert,詢問是否要同步於雲端
            if ([self checkTotalData] == NO) {
                
                //跳至Overview頁面
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                
                NSLog(@"m_accountID = %d",m_accountID);
                
                [LocalData sharedInstance].accountID = m_accountID;

                [MViewController setPrivacyModeOrMemberShip:NO];//NO:會員制 / YES:隱私模式
                
                [self presentViewController:vc animated:YES completion:nil];
                
            }
            else {
                
                UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Do you want to upload Data to Cloud ? If you choose to cancel, the existing record will be deleted", nil) preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    ///先將資料同步雲端,再刪除Database,最後下載雲端資料存到Database,跳至Overview頁面
                    //先將資料同步雲端
                    
                    //再刪除Database
                    
                    //最後下載雲端資料存到Database

                    
                    
                    //跳至Overview頁面
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                    
                    //[LocalData sharedInstance].accountID = -1;
                    
                    [MViewController setPrivacyModeOrMemberShip:NO];//NO:會員制 / YES:隱私模式
                    
                    [self presentViewController:vc animated:YES completion:nil];
                    
                    
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    ///不要將現有資料上傳至雲端,先刪除本機資料再跳至OverView
                    //刪除本機資料
                    [self deleteAllDataFromDataBase:[LocalData sharedInstance].accountID];
                    
                    //跳至OverView
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                    
                    //[LocalData sharedInstance].accountID = -1;
                    
                    [MViewController setPrivacyModeOrMemberShip:NO];//NO:會員制 / YES:隱私模式
                    
                    [self presentViewController:vc animated:YES completion:nil];
                    
                }];
                
                [saveAlert addAction:confirmAction];
                [saveAlert addAction:cancelAction];
                
                [self presentViewController:saveAlert animated:YES completion:nil];
            }
            
        }];

        [alert addAction:confirmAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if ([code intValue] == 5205) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:expired_authorization_code preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Authorization again", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:WEBVIEW_URL] entersReaderIfAvailable:YES];
//            
//            [self presentViewController:webVC animated:YES completion:nil];
            
            [self webViewWhithURL:WEBVIEW_URL];

            
        }];
        
        [alert addAction:confirmAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if ([code integerValue] == 5206) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:tokenExpired_refresh_token preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Authorization again", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:WEBVIEW_URL] entersReaderIfAvailable:YES];
//            
//            [self presentViewController:webVC animated:YES completion:nil];
            
            [self webViewWhithURL:WEBVIEW_URL];

            
        }];

        [alert addAction:confirmAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else if ([code intValue] == 5207) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:tokenExpired_access_token preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Authorization again", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *refresh_token_str = [NSString stringWithContentsOfFile:OAuth_Refreash_TOKEN encoding:NSUTF8StringEncoding error:nil];
            
            [apiClass postOAuthToken:refresh_token code:@"" refreshToken:refresh_token_str clientID:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" clientSecret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C" redirectURI:@"com.CustomURLAPP.demo"];
            
        }];
        
        [alert addAction:confirmAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else {
        
        NSLog(@"其他錯誤");
    }

}



#pragma mark - API Delegate
-(void)processOAuthToken:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    appDelegate.codeNum = [responseData objectForKey:@"code"];
    [AppDelegate saveNSUserDefaults:appDelegate.codeNum Key:@"code"];
    
    if ([appDelegate.codeNum intValue] == 10000) {
        
        NSString *access_token_str = [responseData objectForKey:@"access_token"];
        NSString *refresh_token_str = [responseData objectForKey:@"refresh_token"];
        
        [MViewController saveAccess_token:access_token_str];
        [MViewController saveRefresh_token:refresh_token_str];
        
        
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        NSString *refresh_tokenStr = [NSString stringWithContentsOfFile:OAuth_Refreash_TOKEN encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"tokenStr =====>>> %@",tokenStr);
        NSLog(@"refresh_tokenStr ====> %@",refresh_tokenStr);
        
        //取得這個帳號的 Base Data
        [apiClass postGetMemberBaseData:tokenStr client_id:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" client_secret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C"];
        
    }
    
    [self checkResponseCodeForToken:appDelegate.codeNum beContinue:NO];
    
}


-(void)processGetMemberBaseData:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"Get Member Base Data jsonError: %@",jsonError);
        
    }
    else {
        
        NSLog(@"Get Member Base Data responseData: %@",responseData);
        
        if ([[responseData objectForKey:@"code"] intValue] == 10000) {
            
            m_accountID = [[responseData objectForKey:@"account_id"] intValue];
            
            [LocalData sharedInstance].accountID = [[responseData objectForKey:@"account_id"] intValue];
            
            [LocalData sharedInstance].name = [[responseData objectForKey:@"data"] objectForKey:@"name"];
            
            NSString *emailStr = [[responseData objectForKey:@"data"] objectForKey:@"email"];
            
            [emailStr writeToFile:USER_EMAIL_FILEPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSLog(@"name: %@",[[responseData objectForKey:@"data"] objectForKey:@"name"]);
            
            NSLog(@"email: %@",[[responseData objectForKey:@"data"] objectForKey:@"email"]);
            
            [self checkResponseCodeForToken:[NSNumber numberWithInt:10000] beContinue:YES];
        }
        
    }
    
}




#pragma mark - check BPM - BF - BT Data  ***********************
-(BOOL)checkTotalData {
    
    NSLog(@"accountID: %d",[LocalData sharedInstance].accountID);
 
    
    //[BPMClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    //[WeightClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    //[BTClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    
    int existData = 0;
    
    NSLog(@"血壓有資料: %@",[[BPMClass sharedInstance] selectAllData]);
    
    if ([[BPMClass sharedInstance] selectAllData].count > 1) {
        
        existData += 1;
    }
    
    if ([[WeightClass sharedInstance] selectAllData].count > 1) {
        
        existData += 1;
    }
    
    NSLog(@"體重有資料: %@",[[WeightClass sharedInstance] selectAllData]);
    
    if ([[BTClass sharedInstance] selectAllData].count > 1) {
        
        existData += 1;
    }
    
    NSLog(@"體溫有資料: %@",[[BTClass sharedInstance] selectAllData]);
    
    NSLog(@"existData:%d",existData);
    
    return existData == 0 ? NO : YES;
}


///check BPM
-(void)checkBPMData:(BOOL)uploadToCloud {
    
    
}

///check BF
-(void)checkBFData:(BOOL)uplaodToCloud {
    
    
}


///check BT
-(void)checkBTData:(BOOL)uploadToCloud {
    
    
}

///delete All data From dataBase
-(void)deleteAllDataFromDataBase:(int)accountID {
    
    //BMP
    [BPMClass sharedInstance].accountID = accountID;
    [[BPMClass sharedInstance] deleteData];
    
    //Weight
    [WeightClass sharedInstance].accountID = accountID;
    [[WeightClass sharedInstance] deleteData];
    
    //BT
    [BTClass sharedInstance].accountID = accountID;
    [[BTClass sharedInstance] deleteData];
    
    //Event
    [EventClass sharedInstance].accountID = accountID;
    [[EventClass sharedInstance] deleteAllEventData];
    
    
    //AlertConfig
    AlertConfigClass *alertConfigClass = [[AlertConfigClass alloc] init];
    alertConfigClass.accountID = accountID;
    [alertConfigClass deletData];
    
    //ProFile
    
}


#pragma - mark 判斷iOS版本，使用SFSafariViewController OR WKWebView
- (void)webViewWhithURL:(NSString *)url {

    url = [NSString stringWithFormat:@"%@&lang=%@",url,NSLocalizedString(@"lang", nil)];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:YES];
        [self presentViewController:webVC animated:YES completion:nil];
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        self.webURLTextField.text = url;
    }
}

- (UIView *)webUIView {
    if (!_webUIView) {
        self.webUIView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.webUIView];
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, 40)];
        self.webUIView.backgroundColor = self.toolbar.backgroundColor;
        [self.webUIView addSubview:self.toolbar];
        self.toolbar.items = @[self.backButton];
    }
    return _webUIView;
}

- (UITextField *)webURLTextField {
    if (!_webURLTextField) {
        self.webURLTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2, 25, self.view.frame.size.width*0.75, 30)];
        self.webURLTextField.enabled = NO;
        self.webURLTextField.textColor = [UIColor grayColor];
        self.webURLTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.webUIView addSubview:self.webURLTextField];
    }
    return _webURLTextField;
}

- (UIButton *)backButton {
    if (!_backButton) {
//        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(blackAction)];
//        [self.backButton setFrame:CGRectMake(0, 25, self.view.frame.size.width*0.2, 30)];
//        [self.backButton setTitle:@"Done" forState:UIControlStateNormal];
//        [self.backButton addTarget:self action:@selector(blackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)blackAction {
    [self.webUIView removeFromSuperview];
    self.webUIView = nil;
    self.backButton = nil;
    self.webURLTextField = nil;
    self.webView = nil;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        // 添加自适应屏幕宽度js调用的方法
        [wkWebConfig.userContentController addUserScript:wkUserScript];
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) configuration:wkWebConfig];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.backgroundColor = [UIColor whiteColor];
        [self.webUIView addSubview:self.webView];
    }
    return _webView;
}

#pragma mark -- WKNavigationDelegate
//页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"页面开始加载时调用,%@",self.webView.URL);
    NSString *webURL = [NSString stringWithFormat:@"%@",self.webView.URL];
    if ([webURL hasPrefix:@"com.customurlapp.demo://"]) {
        NSString *responseStr = [self.webView.URL query];
        NSLog(@"responseStr======>%@",responseStr);

        NSArray *ary_code = [responseStr componentsSeparatedByString:@"="];
        responseStr = ary_code[1];
        NSLog(@"code======>%@",responseStr);
        
        //收到 code 後,post API 取 token
        apiClass = [[APIPostAndResponse alloc] initCloud];
        apiClass.delegate = self;
        [apiClass postOAuthToken:authorization_code code:responseStr refreshToken:@"" clientID:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" clientSecret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C" redirectURI:@"com.CustomURLAPP.demo"];
        
        [self blackAction];

    }

}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"当内容开始返回时调用,%@",self.webView.URL);

}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"页面加载完成时调用,%@",self.webView.URL);

}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载失败时调用,%@",self.webView.URL);
}

//发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if (!webView.isLoading) {
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark
- (void)getAllData:(int)accountID {
    
    //BMP
    [BPMClass sharedInstance].accountID = accountID;
    [[BPMClass sharedInstance] deleteData];
    
    //Weight
    [WeightClass sharedInstance].accountID = accountID;
    [[WeightClass sharedInstance] deleteData];
    
    //Event
    [EventClass sharedInstance].accountID = accountID;
    [[EventClass sharedInstance] deleteAllEventData];
    
    //BT
    [BTClass sharedInstance].accountID = accountID;
    [[BTClass sharedInstance] deleteData];
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postGetBTEventList:tokenStr];
    [apiClass postGetBPMHistoryData:tokenStr];
    [apiClass postGetWeightHistoryData:tokenStr];
}

- (void)processGetBTEventList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    for (NSDictionary *event in [resopnseData objectForKey:@"data"]) {
        //儲存至資料庫
        [EventClass sharedInstance].event = [event objectForKey:@"event"];
        [EventClass sharedInstance].type = [event objectForKey:@"type"];
        [EventClass sharedInstance].eventTime = [event objectForKey:@"event_time"];
        [EventClass sharedInstance].eventID = [[event objectForKey:@"event_code"] intValue];
        [EventClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
        [[EventClass sharedInstance] deletData];
        [[EventClass sharedInstance] insertData];
        [apiClass postGetBTHistoryData:tokenStr event_code:[[event objectForKey:@"event_code"] intValue]];
    }
}

- (void)processeGetBTHistoryData:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSLog(@"processeGetBTHistoryData:%@",resopnseData);
    NSArray *array = [resopnseData objectForKey:@"data"];
    for (NSDictionary *bt in array) {
        //儲存至資料庫
        [BTClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
        
        [BTClass sharedInstance].eventID = [[bt objectForKey:@"event_code"] intValue];
        
        [BTClass sharedInstance].date = [bt objectForKey:@"date"];
        
        [BTClass sharedInstance].bodyTemp = [bt objectForKey:@"body_temp"];
        [BTClass sharedInstance].roomTmep = [bt objectForKey:@"room_temp"];
        [BTClass sharedInstance].BT_PhotoPath = [bt objectForKey:@"photo"];
        [BTClass sharedInstance].BT_Note = [bt objectForKey:@"note"];
        [BTClass sharedInstance].BT_RecordingPath = [bt objectForKey:@"recording"];
        [[BTClass sharedInstance] insertData];
        if ([bt isEqual:[array firstObject]]) {
            NSLog(@"firstObject:%@",bt);
            NSDictionary *latestTemp = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [BTClass sharedInstance].bodyTemp,@"bodyTemp",
                                        [BTClass sharedInstance].roomTmep,@"roomTemp",
                                        [BTClass sharedInstance].date,@"date",
                                        nil];
            [[LocalData sharedInstance] saveLatestMeasureValue:latestTemp];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveTempDataOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveALLData" object:nil];
}

- (void)processgetBpmHistoryData:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSArray *array = [resopnseData objectForKey:@"data"];
    for (NSDictionary *bmp in array) {
        //儲存至資料庫
        [BPMClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
        [BPMClass sharedInstance].SYS = [[bmp objectForKey:@"sys"] intValue];
        [BPMClass sharedInstance].DIA = [[bmp objectForKey:@"dia"] intValue];
        [BPMClass sharedInstance].PUL = [[bmp objectForKey:@"pul"] intValue];
        //目前裝置無法支援PAD量測
        [BPMClass sharedInstance].PAD = [[bmp objectForKey:@"pad"] intValue];
        [BPMClass sharedInstance].AFIB = [[bmp objectForKey:@"afib"] intValue];//curMdata.arr;
        [BPMClass sharedInstance].date = [bmp objectForKey:@"date"];
        [BPMClass sharedInstance].BPM_PhotoPath = [bmp objectForKey:@"photo"];
        [BPMClass sharedInstance].BPM_Note = [bmp objectForKey:@"note"];
        [BPMClass sharedInstance].BPM_RecordingPath = [bmp objectForKey:@"recording"];
        [BPMClass sharedInstance].MAM = [[bmp objectForKey:@"man"] intValue];//curMdata.MAM;
        [[BPMClass sharedInstance] insertData];
        if ([bmp isEqual:[array firstObject]]) {
            NSLog(@"firstObject:%@",bmp);
            NSDictionary *latestBP = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d",[BPMClass sharedInstance].SYS],@"SYS",
                                      [NSString stringWithFormat:@"%d",[BPMClass sharedInstance].DIA],@"DIA",
                                      [NSString stringWithFormat:@"%d",[BPMClass sharedInstance].PUL],@"PUL",
                                      [BPMClass sharedInstance].date,@"date",
                                      [NSString stringWithFormat:@"%d",[BPMClass sharedInstance].AFIB],@"Arr",
                                      [NSString stringWithFormat:@"%d",[BPMClass sharedInstance].MAM],@"MAM",
                                      nil];
            [[LocalData sharedInstance] saveLatestMeasureValue:latestBP];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveBPMDataOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveALLData" object:nil];
}

- (void)processGetWeightHistoryData:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSArray *array = [resopnseData objectForKey:@"data"];
    for (NSDictionary *Weight in array) {
        //儲存至資料庫
        [WeightClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
        [WeightClass sharedInstance].weight = [[Weight objectForKey:@"weight"]floatValue];
        [WeightClass sharedInstance].date = [Weight objectForKey:@"date"];
        [WeightClass sharedInstance].water = [[Weight objectForKey:@"water"]intValue];
        [WeightClass sharedInstance].bodyFat = [[Weight objectForKey:@"body_fat"] floatValue];
        [WeightClass sharedInstance].muscle = [[Weight objectForKey:@"muscle"]intValue];
        [WeightClass sharedInstance].skeleton = [[Weight objectForKey:@"skeleton"]intValue];
        [WeightClass sharedInstance].BMI = [[Weight objectForKey:@"bmi"]floatValue];
        [WeightClass sharedInstance].BMR = [[Weight objectForKey:@"bmr"] intValue];
        [WeightClass sharedInstance].organFat = [[Weight objectForKey:@"organ_fat"]intValue];
        [WeightClass sharedInstance].weight_PhotoPath = [Weight objectForKey:@"photo"];
        [WeightClass sharedInstance].weight_Note = [Weight objectForKey:@"note"];
        [WeightClass sharedInstance].weight_RecordingPath = [Weight objectForKey:@"recording"];
        [[WeightClass sharedInstance] insertData];
        if ([Weight isEqual:[array firstObject]]) {
            NSLog(@"Weight'firstObject:%@",Weight);
            NSDictionary *latestWeight = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%.1f",[WeightClass sharedInstance].weight],@"weight",
                                          [NSString stringWithFormat:@"%.1f",[WeightClass sharedInstance].bodyFat],@"bodyFat",
                                          [NSString stringWithFormat:@"%.1f",[WeightClass sharedInstance].BMI],@"BMI",
                                          [WeightClass sharedInstance].date,@"date",
                                          nil];
            [[LocalData sharedInstance] saveLatestMeasureValue:latestWeight];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveWeightDataOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveALLData" object:nil];
}

@end
