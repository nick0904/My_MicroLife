//
//  GlobalDefine.h

//
//  Created by Tom on 2015/10/18.
//  Copyright © 2015年 Tom. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

//stroy board ID Name


//Db Name
#define kDBNameSQLite @"MicrolifeDB.sqlite"


//Data Formate
#define kDistanceFormat         @"%2.1f"
#define kCaloriesFormat         @"%d"
#define kHeartRateFormat        @"%d"
#define kTimeRemainingFormat    @"%2d:%02d"
#define kRPMFormat              @"%d"
#define kLevelFormat            @"%d"
#define kWattsFormat            @"%d"
#define kInclineLevelFormat     @"%d"
#define kLapsFormat             @"%2.1f"
#define kSpeedFormat            @"%2.1f"

#define kAverageHRFormat          @"%d bpm"
#define kAverageSpeedFormat       @"%2.1f mph"
#define kAverageRPMFormat         @"%d"
#define kAverageWattFormat        @"%d"
#define kAverageMETFormat         @"%2.1f"
#define kAverageResistanceFormat  @"%i"

//Google
#define kClientID @"1075601993941-b70ihq5e0gqmpp0eelfsbaup1nqcsjv2.apps.googleusercontent.com"

//Rex
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define TEXT_COLOR ([UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1])

#define STANDER_COLOR ([UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1])

#define CIRCEL_RED ([UIColor colorWithRed:231.0/255.0 green:26.0/255.0 blue:15.0/255.0 alpha:1])

#define DARKTEXT_COLOR ([UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1])

#define TABLE_BACKGROUND ([UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1])

#define SECTION_BACKGROUNDCOLOR ([UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0])

#define CELL_SPERATORCOLOR ([UIColor colorWithRed:208.0f/255.0f green:215.0f/255.0f blue:217.0f/255.0f alpha:1.0])

#define LAYER_BORDERCOLOR ([UIColor colorWithRed:208.0f/255.0f green:215.0f/255.0f  blue:217.0f/255.0f  alpha:0.9].CGColor)

#define BUTTONCOLOR_GRAY ([UIColor colorWithRed:168/255 green:168/255 blue:165/255 alpha:0.4])


//==================

///Images History
#define IMAGE_BPM [UIImage imageNamed:@"history_icon_a_list_bpm"];
#define IMAGE_BPM_RED [UIImage imageNamed:@"history_icon_a_list_bpm_r"];
#define IMAGE_PAD [UIImage imageNamed:@"history_icon_a_list_pad"];
#define IMAGE_PAD_RED [UIImage imageNamed:@"history_icon_a_list_pad_r"];
#define IMAGE_AFIB_RED [UIImage imageNamed:@"history_icon_a_list_afib_r"];
#define IMAGE_WEIGHT [UIImage imageNamed:@"history_icon_a_list_ws"];
#define IMAGE_WEIGHT_RED [UIImage imageNamed:@"history_icon_a_list_ws_r"];
#define IMAGE_TEMP_NORMAL [UIImage imageNamed:@"history_icon_a_list_ncfr"];
#define IMAGE_FEVER [UIImage imageNamed:@"history_icon_a_list_ncfr_r"];
#define IMAGE_AFIB [UIImage imageNamed:@"history_icon_a_list_afib"];



///Images OverView
#define IMAGE_NORMAL_BP [UIImage imageNamed:@"overview_icon_a_bpm"]
#define IMAGE_NORMAL_WEIGHT [UIImage imageNamed:@"overview_icon_a_ws_b"]
#define IMAGE_OVERWEIGHT [UIImage imageNamed:@"overview_icon_a_ws_r"]
#define IMAGE_NORMAL_TEMP [UIImage imageNamed:@"overview_icon_a_ncfr_b"]
#define IMAGE_HIGH_BP [UIImage imageNamed:@"overview_icon_a_bpm_r"]
#define IMAGE_AFIB_OVERVIEW [UIImage imageNamed:@"overview_icon_a_afib"]
#define IMAGE_PAD_OVERVIEW [UIImage imageNamed:@"overview_icon_a_pad"]
#define IMAGE_FEVER_OVERVIEW [UIImage imageNamed:@"overview_icon_a_ncfr_r"]


///check NetWork
#define NETWORK_TITLE    NSLocalizedString(@"Alert", nil)
#define NETWORK_MESSAGE  NSLocalizedString(@"Please check your wifi", nil)
#define NETWORK_CONFIRM  NSLocalizedString(@"Confirm", nil)



///路徑
#define USER_IMAGE_FILEPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/userImage"]
#define USER_EMAIL_FILEPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/userEmail"]
#define ISPRIVACY_MODE [NSHomeDirectory() stringByAppendingString:@"/Documents/isPrivacyMode"]
#define ISSYNC_HEALTHKIT [NSHomeDirectory() stringByAppendingString:@"/Documents/isSyncHealthKit"]
#define USER_NAME_FILEPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/userName"]
#define ConnectingDevie_NamePath [NSHomeDirectory() stringByAppendingString:@"/Documents/connectingDeviceName"]


///TOKEN 路徑
#define OAuth_TOKEN [NSHomeDirectory() stringByAppendingString:@"/Documents/oAuth_token"]
#define OAuth_Refreash_TOKEN [NSHomeDirectory() stringByAppendingString:@"/Documents/oAuth_refreash_token"]



///Allen HistoryPageListData
#define Is_ViewType [NSHomeDirectory() stringByAppendingString:@"/Documents/viewType"]
#define Is_DataRange [NSHomeDirectory() stringByAppendingString:@"/Documents/dataRange"]
#define Is_DataCount [NSHomeDirectory() stringByAppendingString:@"/Documents/dataCount"]


///單位轉換
#define mmHgTransformTokPa 0.13332237 
#define kgTransformTolb 2.20462
#define cmTransformToft 0.03306878

///百略 webView url
#define WEBVIEW_URL     @"https://service.microlifecloud.com/oauth/code?client_id=BkbnHiURrKvnFCzAJndMt21Cd25nSiYI&redirect_uri=com.CustomURLAPP.demo"

/******************/
//Type Define

 //頁面
 typedef enum
 {
     
     MainLoginPage,         //登入頁
     MainOverwatchPage,     //量測頁
     MainReminderPage,      //鬧鐘頁
     MainHistoryPage,       //歷史頁
     MainSettingPage,       //設定頁
     MainProfilePage        //個資頁
    
     
 }UIPageName;
 


#endif /* Global_Define_h */
