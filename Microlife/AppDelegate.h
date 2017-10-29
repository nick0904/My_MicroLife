//
//  AppDelegate.h
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import <UserNotifications/UserNotifications.h> //ios10推播
#import "CurrentAndMData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)getFacebookStatus;

- (void)setLocalNoise:(NSMutableArray*)noiseData;


//取token用  ******************
@property (strong, nonatomic) UIViewController *currentVC;

@property (strong, nonatomic) NSNumber *codeNum;

-(void)connectWeb:(UIViewController *)currentVC;


/**
 串接檔案路徑

 @param fileName 檔案名
 @return 檔案路徑
 */
+ (NSString *)getDataPathWithFileName:(NSString *)fileName;
//Privacy Health Kit
//多語系
//PDF


#pragma mark - NSUserDefaults存取類
/**
 *  將變量存至NSUserDefaults
 *
 *  @param value 儲存變量
 *  @param key   儲存變量名
 */
+ (void)saveNSUserDefaults:(id)value Key:(NSString *)key;


/**
 *  從NSUserDefaults讀取變量
 *
 *  @param key 讀取變量名
 *
 *  @return 讀取變量
 */
+ (id)readNSUserDefaults:(NSString *)key;


/**
 會員操作紀錄

 @param device_type Device類型：[0] 會員管理，【1】血壓機，【2】體重機，【3】額溫槍機
 @param log_action 會員操作碼：https://docs.google.com/spreadsheets/d/1HlZV850T7q-T8lqjnRMYaNFUW_uEJUx7q4mlTAl3gWM/edit#gid=0
 */
- (void)setMemberActionLogWithdevice_type:(int)device_type log_action:(int)log_action;

@end

