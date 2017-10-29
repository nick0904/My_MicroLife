//
//  AppDelegate.m
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ShareCommon.h"
#import "MViewController.h"
#import "NavViewController.h"
#import "AlertView.h"

@interface AppDelegate ()<GIDSignInDelegate,SFSafariViewControllerDelegate,APIPostAndResponseDelegate>{
    
    int loginType;  //0 = FB  1 = Google;
    
    //取token用
    SFSafariViewController *webVC;
    APIPostAndResponse *apiClass;
    
}

@end

@implementation AppDelegate

#define MYWEBURL    @"https://service.microlifecloud.com/oauth/code?client_id=BkbnHiURrKvnFCzAJndMt21Cd25nSiYI&redirect_uri=com.CustomURLAPP.demo"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GIDSignIn sharedInstance].delegate = self;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFBNotification) name:@"FBLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGoogleNotification) name:@"GoogleLogin" object:nil];
    
    
    //推播 localNotification
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (locationNotification) {
        [self startNotifyAndChangeIconNumberWithReset:true];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    }
    
    
//    self.codeNum = [NSNumber numberWithInt:0];
    self.codeNum = [AppDelegate readNSUserDefaults:@"code"];

    
    [self cleanShowData];
    
    
    if(![CheckNetwork isExistenceNetwork]){
        NSLog(@"無網路");
    }
    else{
        //推播註冊
        [self registerToAPNsServer:application];
    }
    
    //推播註冊
    //[self registerToAPNsServer:application];
    
    
    //[self test];
    
    /**
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    
    //如果已登入過,直接進入OverView
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //先判斷路徑是否存在
    BOOL isExist = [manager fileExistsAtPath:ISPRIVACY_MODE];
    
    if (isExist == NO) {
        
        //跳到導覽頁
        
        [mainWindow setRootViewController:<#(UIViewController * _Nullable)#>];
    }
    else {
        
        if ([MViewController checkIsPrivacyModeOrMemberShip] == NO) {
            
            //NO - 會員模式
        }
        else {
            
            //YES - 隱私模式
            //跳到導覽頁
            
            
        }

    }
    
    
    [mainWindow makeKeyAndVisible];
    */
    
    return YES;
}

-(void)getFacebookStatus{
    
}

- (void)receiveFBNotification{
    
    loginType = 0;
}

- (void)receiveGoogleNotification{
    loginType = 1;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Local Notify
    //[self setLocalNoise];
    
}

//当本地通知触发后，需要在AppDelegate中进行接收并做相应处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSDictionary *user=notification.userInfo;
    
    NSLog(@"user:%@",user);
    
    if(user && notification.alertBody)
    {
        [ShareCommon showApplicationAlert:notification.alertBody Title:NSLocalizedString(@"Reminder", nil)];
    }
    
    
    [self startNotifyAndChangeIconNumberWithReset:true];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];  //記錄應用程式啟動
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**  改用 OAuth 取 token
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if (loginType == 0) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}
*/
 
 
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    
}

//當textField已經结束被編輯，會委托代理調用這個方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

//當keyBoard上return键被點擊，委托代理調用這個方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
//返回值YES，NO没區别,似乎是系统會獲得這個返回值

//當textField中文字發生改變，調用這個方法

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}



#pragma mark - local Notification
- (void)setLocalNoise:(NSMutableArray*)noiseData
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //[self startNotifyAndChangeIconNumberWithReset:true];
    
    NSLog(@"=========");
    NSLog(@"%@",noiseData);
    NSLog(@"=========");
    
    for(NSDictionary *dic in noiseData) {
        BOOL status = (BOOL)[dic objectForKey:@"status"];
        
        if(status) {
            //typeName
            NSString *typeName;
            NSArray *typeArr=[dic objectForKey:@"type"];
            for (NSDictionary *itemDic in typeArr) {
                int choose = [[itemDic objectForKey:@"choose"] intValue];
                if (choose==1) {
                    typeName=[itemDic objectForKey:@"typeName"];
                }
            }
            NSString *alertBody = typeName;
            
            //model
            NSString *model = [dic objectForKey:@"model"];
            
            //min hour
            int min = [[dic objectForKey:@"min"] intValue];
            int hour = [[dic objectForKey:@"hour"] intValue];
            int sec = 0;
            
            //weekName
            NSMutableArray *weekNameArr=[[NSMutableArray alloc]init];
            NSArray *weekArr = [dic objectForKey:@"week"];
            
            NSDate *now = [NSDate date];
            
            NSDate *startWeekDate = [ShareCommon getWeekStartForDate:now];
        
            
            int i = 0;
            for(NSDictionary *itemDic in weekArr) {
                int choose=[[itemDic objectForKey:@"choose"] intValue];
                if(i>0) {
                    startWeekDate=[startWeekDate dateByAddingTimeInterval:24*60*60];
                }
                if (choose==1) {
                    NSString *wname = [itemDic objectForKey:@"weekName"];
                    if (wname && wname.length>0) {
                        
                        [weekNameArr addObject:[itemDic objectForKey:@"weekName"]];
                        
                        NSString *cDate = [ShareCommon DateToStringByFormate:startWeekDate formate:@"yyyy/MM/dd"];
                        
                        cDate = [NSString stringWithFormat:@"%@ %02d:%02d:%02d",cDate,hour,min,sec];
                        
                        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
                        formatter.dateFormat        = @"yyyy/MM/dd HH:mm:ss";
                        NSDate *alertDate                = [formatter dateFromString:cDate];
                       
                        //建立定時本地推播。
                        [self addNoise:alertDate alertBody:alertBody repeat:YES];

                    }
                    
                }
                
                i++;
            }
            
            /* 單次提醒功能。
             觸發：不選擇Repeat，建立提醒。
             所以weekNameArr.count == 0
             判斷設定時間是否超過。超過設為隔日。
             */
            if (weekNameArr.count == 0) {
                NSString *cDate = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateTime = [dateFormatter stringFromDate:[NSDate date]];
                NSLog(@"現在時間  =%@",dateTime);
                
                NSArray *dateTimeArray =  [dateTime componentsSeparatedByString:@" "];
                
                NSString *lateDate = [NSString stringWithFormat:@"%@ %@",[dateTimeArray objectAtIndex:0],cDate];
                NSLog(@"任務時間  =%@", lateDate);
                
                [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                NSDate *alertDate = [dateFormatter dateFromString:lateDate];
                
                if ([[NSDate new] timeIntervalSinceDate:alertDate] < 0.0f) {
                    NSLog(@"今天執行");
                    //建立定時本地推播。
                    [self addNoise:alertDate alertBody:alertBody repeat:NO];
                } else {
                    NSLog(@"明天執行");
                    NSDate *tomorrowDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:alertDate];
                    [self addNoise:tomorrowDate alertBody:alertBody repeat:NO];

                }
                
            }
            
            NSLog(@"======");
            
            NSLog(@"typeName:%@",typeName);
            NSLog(@"model:%@",model);
            NSLog(@"hh:%d,min:%d,sec:%d",hour,min,sec);
            NSLog(@"Week:%@",weekNameArr);
            
            NSLog(@"======");
        }
        
    }
    
    

    
    //[self startNotifyAndChangeIconNumberWithReset:false];
    
}

- (void)startNotifyAndChangeIconNumberWithReset:(BOOL)isReset
{
    NSLog(@"startNotifyAndChangeIconNumberWithReset");
    
    if (isReset == true) {
        UIApplication *app = [UIApplication sharedApplication];
        app.applicationIconBadgeNumber = 0;
        
    }
    else
    {
        NSArray *notifLocalizations = [[UIApplication sharedApplication] scheduledLocalNotifications];
        int notifIndex = 1;
        for (UILocalNotification *local in notifLocalizations) {
            local.applicationIconBadgeNumber = notifIndex;
            local.userInfo = @{@"id":[NSString stringWithFormat:@"%li",(long)local.applicationIconBadgeNumber]};
            
            [[UIApplication sharedApplication] scheduleLocalNotification:local];
            notifIndex++;
        }
        
        
        notifLocalizations = nil;
    }
    
}
- (void)addNoise:(NSDate *)aDate alertBody:(NSString*)alertBody repeat:(BOOL)isReapeat {
    
    NSLog(@"addNoise:%@",[ShareCommon DateToStringByFormate:aDate formate:@"yyyy/MM/dd HH:mm:ss"]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [dateFormatter stringFromDate:aDate];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = aDate;
        //        notifyAlarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:];
        
        localNotification.timeZone = [NSTimeZone localTimeZone];
        if (isReapeat == true) {
            localNotification.repeatInterval = NSCalendarUnitWeekOfYear;
        }
        else{
            localNotification.repeatInterval = 0;
        }
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //        localNotification.alertTitle = @"DEPO Car Light";//DEPO Car Light
        localNotification.alertBody = [NSString stringWithFormat:@"%@\n%@",alertBody,dateTime];
        
        
        
        [[UIApplication sharedApplication]  scheduleLocalNotification:localNotification];
        NSLog(@"add.COUNT:%@",localNotification);
    }
}


-(void)test{
    /*
    NSDate *now=[NSDate date];
    
    NSDate *startWeekDate=[ShareCommon getWeekStartForDate:now];
    
    for(int i=0;i<7;i++)
    {
        if(i>0)
        {
            startWeekDate=[startWeekDate dateByAddingTimeInterval:24*60*60];
        }
        
        NSString *cDate=[ShareCommon DateToStringByFormate:startWeekDate formate:@"yyyy/MM/dd"];
        NSLog(@"startWeekDate:%@",cDate);
    }
    
    
    */
    
}



#pragma mark - 取 Token 用  *************************************
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //gixiphy
    NSLog(@"URL query: %@",[url query]);
    
    if ([url query] != nil) {
        
        NSString *responseStr = [url query];
        
        if (self.currentVC != nil) {
            
            NSArray *ary_code = [responseStr componentsSeparatedByString:@"="];
            responseStr = ary_code[1];
            NSLog(@"code======>%@",responseStr);
            
            //收到 code 後,post API 取 token
            apiClass = [[APIPostAndResponse alloc] initCloud];
            apiClass.delegate = self;
            [apiClass postOAuthToken:authorization_code code:responseStr refreshToken:@"" clientID:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" clientSecret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C" redirectURI:@"com.CustomURLAPP.demo"];
            
        }
    }
    
    [self registerToAPNsServer:application];
    
    return YES;
}



/**
-(void)connectWeb:(UIViewController *)currentVC {
    
    webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:MYWEBURL]];
    webVC.delegate = self;
    [currentVC presentViewController:webVC animated:YES completion:nil];
    
}
*/

-(void)backToMainVC:(UIViewController *)mainVC {
    
    [mainVC dismissViewControllerAnimated:YES completion:nil];
}


///API Delegate
-(void)processOAuthToken:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"OAuthToken jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"OAuthToken responseData:%@",responseData);
        
        self.codeNum = [responseData objectForKey:@"code"];
        
        [AppDelegate saveNSUserDefaults:self.codeNum Key:@"code"];
    
        /**
        //token 或 code 失效 ****************
        if ([codeNum intValue] == 5205 || [codeNum intValue] == 5206) {
            
            SFSafariViewController *webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:WEBVIEW_URL] entersReaderIfAvailable:YES];
         
            [self.currentVC presentViewController:webView animated:YES completion:nil];
        }
        
        
        if ([codeNum intValue] == 5207) {
            
            NSString *refresh_token_str = [NSString stringWithContentsOfFile:OAuth_Refreash_TOKEN encoding:NSUTF8StringEncoding error:nil];
        
            if (apiClass == nil) {
                
                apiClass = [[APIPostAndResponse alloc] initCloud];
                apiClass.delegate = self;
            }
            
            [apiClass postOAuthToken:refresh_token code:@"" refreshToken:refresh_token_str clientID:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" clientSecret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C" redirectURI:@"com.CustomURLAPP.demo"];
            
        }
        //token 或 code 失效 ****************
        */
        
        if ([self.codeNum intValue] == 10000) {
            
            NSString *access_token_str = [responseData objectForKey:@"access_token"];
            NSString *refresh_token_str = [responseData objectForKey:@"refresh_token"];
            
            [MViewController saveAccess_token:access_token_str];
            [MViewController saveRefresh_token:refresh_token_str];
            
            
            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
            NSString *refresh_tokenStr = [NSString stringWithContentsOfFile:OAuth_Refreash_TOKEN encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"tokenStr =====>>> %@",tokenStr);
            NSLog(@"refresh_tokenStr ====> %@",refresh_tokenStr);
            
            [MViewController setPrivacyModeOrMemberShip:NO];
            
        }
        
        [self backToMainVC:self.currentVC];
        
    }

}

+ (NSString *)getDataPathWithFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *dataPath = [documentsPath stringByAppendingPathComponent:fileName];
    
    return dataPath;
}

#pragma mark - NSUserDefaults存取類
#pragma mark 將變量存至NSUserDefaults
+ (void)saveNSUserDefaults:(id)value Key:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

#pragma mark 從NSUserDefaults讀取變量
+ (id)readNSUserDefaults:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:key]) {
        return [userDefaults objectForKey:key];
    }else {
        return @"";
    }
}


/**
 清除歷史資料設定
 */
- (void)cleanShowData {
    ///Allen
    NSString *viewTypeFileName = Is_ViewType;
    NSString *viewTypeInt = @"";
    
    [viewTypeInt writeToFile:viewTypeFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //-----------
    
    NSString *dataRangeFileName = Is_DataRange;
    NSString *dataRangeInt = @"";
    
    [dataRangeInt writeToFile:dataRangeFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //-----------
    
    NSString *dataCountFileName = Is_DataCount;
    NSString *dataCountInt = @"";
    
    [dataCountInt writeToFile:dataCountFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - APNs
-(void)registerToAPNsServer:(UIApplication *)application {
    // Add registration for remote notifications
    //注册推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else {
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
    
    application.applicationIconBadgeNumber = 0;
    
}
    
#pragma  mark - 获取device Token
    //获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
    NSUInteger rntypes = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    
    NSLog(@"rntypes:%ld",rntypes);
    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled"; //在应用图标上面显示角标
    NSString *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled"; //通过alert或者是banner展示内容
    NSString *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled"; //声音提醒
    
    // Get the users Device Model, Display Name, Unique ID, Token & Version Number
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    NSLog(@"deviceName:%@,deviceModel:%@,deviceSystemVersion:%@",deviceName,deviceModel,deviceSystemVersion);
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceToken= [[devToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"deviceToken:%@",deviceToken);
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    [apiClass postSys:tokenStr client_unique_id:[UIDevice currentDevice].identifierForVendor.UUIDString os:@"ios" machine_type:@"phone" push_unique_id:deviceToken model:dev.systemVersion company:@"apple" gps:@""];
    
}
    
- (void)processSys:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSLog(@"processSys:%@",resopnseData);
}
    
    //获取DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"[DeviceToken Error]:%@\n",error.description);
}
    
#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate
    //App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
        
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
}
    
    
    //App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。
        
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //2016-09-27 14:42:16.353978 UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
}
    
#pragma mark -iOS 10之前收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    //此处省略一万行需求代码。。。。。。
}

- (void)setMemberActionLogWithdevice_type:(int)device_type log_action:(int)log_action{
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    NSDateFormatter *dFormatter = [NSDateFormatter new];
    [dFormatter setLocale:[NSLocale currentLocale]];
    [dFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date =  [dFormatter stringFromDate:[NSDate date]];
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    [apiClass postAddMemberActionLog:tokenStr device_type:device_type log_action:log_action date:date];
}

//processAddMemberActionLog:
- (void)processAddMemberActionLog:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSLog(@"processAddMemberActionLog:%@",resopnseData);
}



@end
