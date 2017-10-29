//
//  APIPostAndResponse.h
//  MicroLifeAPITest
//
//  Created by 曾偉亮 on 2017/2/17.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MicroLifeCloudClass.h"

/**
 
有些參數為非必要,非必要時填 @"" 空字串,不可填 nil  \切記/

*/
typedef enum {
    
    authorization_code,
    refresh_token
    
}GrantType;

@protocol APIPostAndResponseDelegate <NSObject>

@optional

-(void)processOAuthToken:(NSDictionary *)responseData Error:(NSError *)jsonError;
-(void)processSys:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processForgetPW:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processAddMemberActionLog:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processgetBpmHistoryData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processAddBPM:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processEditBPM:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processGetWeightHistoryData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processAddWeightData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processEditWeightData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processGetBTEventList:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processAddBTEvent:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeEditBTEvent:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeGetBTHistoryData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeAddBTData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeEditBTData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeAddNoteData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeDeleteRecordData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeGetMailNotificationList:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeAddMailNotification:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeEditMailNotification:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeGetDeviceList:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeAddDevice:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processeDeleteDeviceData:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processDownloadBPMPDF:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processDownloadBTPDF:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processDownloadWeightPDF:(NSDictionary *)resopnseData Error:(NSError *)jsonError;
-(void)processGetMemberBaseData:(NSDictionary *)responseData Error:(NSError *)jsonError;
-(void)processGetMemberData:(NSDictionary *)responseData Error:(NSError *)jsonError;
-(void)processModifyMemberData:(NSDictionary *)responseData Error:(NSError *)jsonError;
-(void)processGetPushHistoryList:(NSDictionary *)responseData Error:(NSError *)jsonError;


//get image
-(void)processGetImage:(NSData *)imgData;


@end


@interface APIPostAndResponse : NSObject <MicroLifeCloudDelegate>

///init
-(id)initCloud;

///postOAuthToken (0:authorization_code , 1:refresh_token)
-(void)postOAuthToken:(GrantType)grant_type code:(NSString *)code refreshToken:(NSString *)refresh_token clientID:(NSString *)client_id clientSecret:(NSString *)client_secret redirectURI:(NSString *)redirect_uri;

///postSys
-(void)postSys:(NSString *)token client_unique_id:(NSString *)client_unique_id os:(NSString *)os machine_type:(NSString *)machine_type push_unique_id:(NSString *)push_unique_id model:(NSString *)model company:(NSString *)company gps:(NSString *)gps;

///postForgetPassword
-(void)postForgetPassword:(NSString *)account client_id:(NSString *)client_id client_secret:(NSString *)client_secret;

///postAddMemberActionLog
-(void)postAddMemberActionLog:(NSString *)access_token device_type:(int)device_type log_action:(int)log_action date:(NSString *)date;

///postGetBPMHistoryData
-(void)postGetBPMHistoryData:(NSString *)access_token;


///postAddBPM
-(void)postAddBPM:(NSString *)access_token user_id:(NSString *)user_id sys:(int)sys dia:(int)dia pul:(int)pul  bpm_id:(NSString *)bpm_id afib:(int)afib  pad:(int)pad man:(int)man date:(NSString *)date mac_address:(NSString *)mac_address  ;


///postEditBPM
-(void)postEditBPM:(NSString *)access_token bpm_id:(NSString *)bpm_id sys:(int)sys dia:(int)dia pul:(int)pul date:(NSString *)date;


///postGetWeightHistoryData
-(void)postGetWeightHistoryData:(NSString *)access_token;


///postAddWeightData
-(void)postAddWeightData:(NSString *)access_token weight_id:(NSString *)weight_id weight:(float)weight bmi:(float)bmi body_fat:(float)body_fat water:(int)water skeleton:(float)skeleton muscle:(int)muscle bmr:(int)bmr organ_fat:(float)organ_fat date:(NSString *)date mac_address:(NSString *)mac_address;


///postEditWeightData
-(void)postEditWeightData:(NSString *)access_token weight_id:(NSString *)weight_id weight:(float)weight bmi:(float)bmi body_fat:(float)body_fat date:(NSString *)date;


///posGetBTEventList
-(void)postGetBTEventList:(NSString *)access_token;


///postAddBTEvent
-(void)postAddBTEvent:(NSString *)access_token event_code:(int)event_code event:(NSString *)event type:(NSString *)type event_time:(NSString *)event_time;


///postEditBTEvent
-(void)postEditBTEvent:(NSString *)access_token event_code:(int)event_cod event:(NSString *)event type:(NSString *)type event_time:(NSString *)event_time delete:(int)editOrDelete;


///postGetBTHistoryData
-(void)postGetBTHistoryData:(NSString *)access_token event_code:(int)event_code;


///postAddBTData
-(void)postAddBTData:(NSString *)access_token event_code:(int)event_code bt_id:(NSString *)bt_id body_temp:(float)body_temp room_temp:(float)room_temp date:(NSString *)date mac_address:(NSString *)mac_address;


///postEditBTData
-(void)postEditBTData:(NSString *)access_token event_code:(int)event_code bt_id:(NSString *)bt_id body_temp:(float)body_temp room_temp:(float)room_temp date:(NSString *)date;


///postAddNoteData
-(void)postAddNoteData:(NSString *)access_token type_id:(NSString *)type_id note_type:(int)note_type note:(NSString *)note photo:(UIImage *)photo recording:(NSData *)recording recording_time:(NSString *)recording_time;


///postDeleteRecordData
-(void)postDeleteRecordData:(NSString *)access_token type_id:(NSString *)type_id note_type:(int)note_type;


///postGetMailNotificationList
-(void)postGetMailNotificationList:(NSString *)access_token;


///postAddMailNotification
-(void)postAddMailNotification:(NSString *)access_token name:(NSString *)name email:(NSString *)email;


///postEditMailNotification  FIX
-(void)postEditMailNotification:(NSString *)access_token mail_id:(NSMutableArray<NSNumber *>*)mail_id name:(NSString *)name email:(NSString *)email delete:(int)editOrDelete ;


///postGetDeviceList
-(void)postGetDeviceList:(NSString *)access_token;


///postAddDevice
-(void)postAddDevice:(NSString *)access_token device_type:(int)device_type device_model:(NSString *)device_model error_code:(NSString *)error_code mac_address:(NSString *)mac_address;


///postDeleteDeviceData
-(void)postDeleteDeviceData:(NSString *)access_token mac_address:(NSString *)mac_address;


///postDownloadBPMPDF
-(void)postDownloadBPMPDF:(NSString *)access_token start_date:(NSString *)start_date end_date:(NSString *)end_date sys_threshold:(int)sys_threshold dia_threshold:(int)dia_threshold photo:(UIImage *)photo;


///postDownloadBTPDf
-(void)postDownloadBTPDF:(NSString *)access_token start_date:(NSString *)start_date end_date:(NSString *)end_date threshold:(int)threshold photo:(UIImage *)photo;


///postDownloadWeightPD
-(void)postDownloadWeightPDF:(NSString *)access_token start_date:(NSString *)start_date end_date:(NSString *)end_date bmi_threshold:(int)bmi_threshold photo:(UIImage *)photo;


///postGetMemberBaseData
-(void)postGetMemberBaseData:(NSString *)access_token client_id:(NSString *)client_id client_secret:(NSString *)client_secret;


///postGetMemberData
-(void)postGetMemberData:(NSString *)access_token client_id:(NSString *)client_id client_secret:(NSString *)client_secret;


///postModifyMember
-(void)postModifyMember:(NSString *)access_token client_id:(NSString *)client_id client_secret:(NSString *)client_secret name:(NSString *)name birthday:(NSString *)birthday gender:(int)gender height:(int)height weight:(float)weight unit_type:(int)unit_type sys_unit:(int)sys_unit sys:(int)sys dia:(int)dia goal_weight:(float)goal_weight body_fat:(float)body_fat bmi:(float)bmi sys_activity:(int)sys_activity dia_activity:(int)dia_activity weight_activity:(int)weight_activity body_fat_activity:(int)body_fat_activity bmi_activity:(int)bmi_activity threshold:(int)threshold cuff_size:(int)cuff_size bp_measurement_arm:(int)bp_measurement_arm date_format:(int)date_format conditions:(NSString *)conditions photo:(UIImage *)photo;


///getPushHistoryList
-(void)postGetPushHistoryList:(NSString *)access_token;



//從 url 抓取圖片
-(void)getImgDataFromURL:(NSString *)urlStr;




/**
//特殊解析:token(愈期-失效) , 5205/5206/5207
-(void)postWhenTokenExpired:(NSString *)responseCode;
*/

@property (strong) id <APIPostAndResponseDelegate> delegate;

@end
