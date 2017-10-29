//
//  MicroLifeCloudClass.h
//  Microlife
//
//  Created by 曾偉亮 on 2017/2/15.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//account:ideabus
//password:1qaz@WSX

#define REAL_URL            @"https://service.microlifecloud.com/"
#define OS                  @"ios"
#define MachineTypePhone    @"phone"
#define MachineTypePad      @"pad"



////========================== 測試用

///帳號-密碼-token
#define TEST_URL    @"http://ec2-35-167-113-254.us-west-2.compute.amazonaws.com/"

#define Client_id        @"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI"
#define Client_secret    @"HnQTBcdCSef4puv2vn3I3RxMms1wh65C"

#define Access_token01   @"hIY8Uwt6bsrVbMLAzcQwpZtGfMWyfRb8WVxRYyxMYnxevGWVDPBK1qQgHGvqhqWCUKYT5sYI1IN2biLiJqHwvaLGrnj8SGW8rR3ab6tcHaxG7c3C1ZrstKva5azcWsvy"
#define Access_token02   @"rszIBKhRY6jZ7gYC9u9GFn9EJeQuYMxEvc78QeSq76HqWwWEpGp45kt85GUPYubAUR3srEQPDZtG9Cfw1M1iSa7uNZp2pZbqJqjCrTb6xIDPHCWg1K1q3R9GScd69sz6"
#define Access_token03   @"UP1GL2UgNn9RFu1TpAmqBszMmer4hIhGt63Cv41itR3KYctq7i5gvTjMbc1TLTr8pevqBXvcvehwFPfMfTdZNevCpZWCFVWsHgh45IjZUuWaLit4JnHCtq1kYGhcWRNE"

#define Client_unique_id @"abcd123456"
#define Email            @"ideabus.nick@gmail.com"



///流水號 (相同會員 流水號不可重覆)
#define BPM_Device_ID       @"13213"
#define Weight_Device_ID    @"556677889"
#define Temp_Device_ID      @"11223344"

 
 
///測試用 帳號-密碼-token


///測試用 圖片
#define Tset_image01    [UIImage imageNamed:@"MicroLifeTest01.png"]
#define Tset_image02    [UIImage imageNamed:@"MicroLifeTest02.png"]

///測試用 錄音檔

 
///=================================== 測試用






///API_KEY
#define API_OAuthToken                  @"oauth/token"
#define API_Sys                         @"api/sys"
#define API_ForgotPW                    @"api/forgot_password"
#define API_AddMemberActionLog          @"api/add_member_action_log"
#define API_GetBpmHistoryData           @"api/get_bpm_history_data"
#define API_AddBpm                      @"api/add_bpm"
#define API_EditBpm                     @"api/edit_bpm"
#define API_GetWeightHistoryData        @"api/get_weight_history_data"
#define API_AddWeightData               @"api/add_weight_data"
#define API_EditWeightData              @"api/edit_weight_data"
#define API_GetBTEventList              @"api/get_bt_event_list"
#define API_AddBTEvent                  @"api/add_bt_event"
#define API_EditBTEvent                 @"api/edit_bt_event"
#define API_GetBTHistoryData            @"api/get_bt_history_data"
#define API_AddBTData                   @"api/add_bt_data"
#define API_EditBTData                  @"api/edit_bt_data"
#define API_AddNoteData                 @"api/add_note_data"
#define API_DeleteRecordData            @"api/delete_record_data"
#define API_GetMailNotification         @"api/get_mail_notification"
#define API_AddMailNotification         @"api/add_mail_notification"
#define API_EditMailNotification        @"api/edit_mail_notification"
#define API_GetDeviceList               @"api/get_device_list"
#define API_AddDevice                   @"api/add_device"
#define API_DeleteDeviceData            @"api/delete_device_data"
#define API_DownloadBPMPDF              @"api/download_bpm_pdf"
#define API_DownloadBTPDF               @"api/download_bt_pdf"
#define API_DownloadWeightPDF           @"api/download_weight_pdf"
#define API_GetMemberBaseData           @"api/get_member_base_data"
#define API_GetMemberData               @"api/get_member_data"
#define API_ModifyMember                @"api/modify_member"
#define API_GetPushHistoryList          @"api/get_push_history_list"


//@"test/post_test"

typedef enum {
    
    CloudAPIEventID_OAuthToken,
    CloudAPIEventID_Sys,
    CloudAPIEventID_ForgotPW,
    CloudAPIEventID_AddMemberActionLog,
    CloudAPIEventID_GetBpmHistoryData,
    CloudAPIEventID_AddBpm,
    CloudAPIEventID_EditBpm,
    CloudAPIEventID_GetWeightHistoryData,
    CloudAPIEventID_AddWeightData,
    CloudAPIEventID_EditWeightData,
    CloudAPIEventID_GetBTEventList,
    CloudAPIEventID_AddBTEvent,
    CloudAPIEventID_EditBTEvent,
    CloudAPIEventID_GetBTHistoryData,
    CloudAPIEventID_AddBTData,
    CloudAPIEventID_EditBTData,
    CloudAPIEventID_AddNoteData,
    CloudAPIEventID_DeleteRecordData,
    CloudAPIEventID_GetMailNotification,
    CloudAPIEventID_AddMailNotification,
    CloudAPIEventID_EditMailNotification,
    CloudAPIEventID_GetDeviceList,
    CloudAPIEventID_AddDevice,
    CloudAPIEventID_DeleteDeviceData,
    CloudAPIEventID_DownloadBPMPDF,
    CloudAPIEventID_DownloadBTPDF,
    CloudAPIEventID_DownloadWeightPDF,
    CloudAPIEventID_GetMemberBaseData,
    CloudAPIEventID_GetMemberData,
    CloudAPIEventID_ModifyMember,
    CloudAPIEventID_GetPushHistoryList
    
    
}CloudAPIEventID;




@protocol MicroLifeCloudDelegate <NSObject>

-(void)networkError;

-(void)MicorLifeCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventID:(int)eventID;

@end




@interface MicroLifeCloudClass : NSObject {
    
    NSString *serverURL;
}

@property (strong,nonatomic) id <MicroLifeCloudDelegate> delegate;

-(id)init;

//非同步
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid;

//非同步相片+文字檔
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath;

//立即同步
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid;

//立即同步相片+文字檔
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath;



//非同步相片
-(void)postDataAsync:(NSMutableDictionary *)postDic APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image;

//非同步相片 + 錄音檔
-(void)postDataAsync:(NSMutableDictionary *)postDic APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withRecording:(NSData *)recording;



@end
