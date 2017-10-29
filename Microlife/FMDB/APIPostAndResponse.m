//
//  APIPostAndResponse.m
//  MicroLifeAPITest
//
//  Created by 曾偉亮 on 2017/2/17.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "APIPostAndResponse.h"



@implementation APIPostAndResponse {
    
    MicroLifeCloudClass *cloudClass;
    
    SFSafariViewController *webView;
}


-(id)initCloud {
    
    self = [super init];
    
    if (self) {
        
        cloudClass = [[MicroLifeCloudClass alloc] init];
        cloudClass.delegate = self;
    }
    
    return self;
}


#pragma mark - MicroLifeCloud Delegate
-(void)MicorLifeCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventID:(int)eventID {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSError *jsonError;
        NSDictionary *responseData;
        
        if (data == nil) {
            NSLog(@"API Response Error:%@",error.description);
        } else {
            responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
            NSLog(@"API Response Data:%@",responseData);
        }
       
        switch (eventID) {
                
            case CloudAPIEventID_OAuthToken:
                [self.delegate processOAuthToken:responseData Error:jsonError];
                break;
            case CloudAPIEventID_Sys:
                [self.delegate processSys:responseData Error:jsonError];
                break;
            case CloudAPIEventID_ForgotPW:
                [self.delegate processForgetPW:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddMemberActionLog:
                [self.delegate processAddMemberActionLog:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetBpmHistoryData:
                [self.delegate processgetBpmHistoryData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddBpm:
                [self.delegate processAddBPM:responseData Error:jsonError];
                break;
            case CloudAPIEventID_EditBpm:
                [self.delegate processEditBPM:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetWeightHistoryData:
                [self.delegate processGetWeightHistoryData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddWeightData:
                [self.delegate processAddWeightData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_EditWeightData:
                [self.delegate processEditWeightData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetBTEventList:
                [self.delegate processGetBTEventList:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddBTEvent:
                [self.delegate processAddBTEvent:responseData Error:(NSError *)jsonError];
                break;
            case CloudAPIEventID_EditBTEvent:
                [self.delegate processeEditBTEvent:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetBTHistoryData:
                [self.delegate processeGetBTHistoryData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddBTData:
                [self.delegate processeAddBTData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_EditBTData:
                [self.delegate processeEditBTData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddNoteData:
                [self.delegate processeAddNoteData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_DeleteRecordData:
                [self.delegate processeDeleteRecordData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetMailNotification:
                [self.delegate processeGetMailNotificationList:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddMailNotification:
                [self.delegate processeAddMailNotification:responseData Error:jsonError];
                break;
            case CloudAPIEventID_EditMailNotification:
                [self.delegate processeEditMailNotification:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetDeviceList:
                [self.delegate processeGetDeviceList:responseData Error:jsonError];
                break;
            case CloudAPIEventID_AddDevice:
                [self.delegate processeAddDevice:responseData Error:jsonError];
                break;
            case CloudAPIEventID_DeleteDeviceData:
                [self.delegate processeDeleteDeviceData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_DownloadBPMPDF:
                [self.delegate processDownloadBPMPDF:responseData Error:jsonError];
                break;
            case CloudAPIEventID_DownloadBTPDF:
                [self.delegate processDownloadBTPDF:responseData Error:jsonError];
                break;
            case CloudAPIEventID_DownloadWeightPDF:
                [self.delegate processDownloadWeightPDF:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetMemberBaseData:
                [self.delegate processGetMemberBaseData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetMemberData:
                [self.delegate processGetMemberData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_ModifyMember:
                [self.delegate processModifyMemberData:responseData Error:jsonError];
                break;
            case CloudAPIEventID_GetPushHistoryList:
                [self.delegate processGetPushHistoryList:responseData Error:jsonError];
            default:
                break;
        }
        
        
    });
}


#pragma mark - Post API
///postOAuthToken
-(void)postOAuthToken:(GrantType)grant_type code:(NSString *)code refreshToken:(NSString *)refresh_token clientID:(NSString *)client_id clientSecret:(NSString *)client_secret redirectURI:(NSString *)redirect_uri {
    
    NSString *grant_type_str;
    
    if (grant_type == authorization_code) {
        
        grant_type_str = @"authorization_code";
    }
    else {
        
        grant_type_str = @"refresh_token";
    }
    
    NSMutableDictionary *postOAuthDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      grant_type_str,@"grant_type",
                                      code,@"code",
                                      refresh_token,@"refresh_token",
                                      client_id,@"client_id",
                                      client_secret,@"client_secret",
                                      redirect_uri,@"redirect_uri",nil];
    
    [cloudClass postDataSync:postOAuthDic APIName:API_OAuthToken EventId:CloudAPIEventID_OAuthToken];
    //[cloudClass postDataAsync:postOAuthDic APIName:API_OAuthToken EventId:CloudAPIEventID_OAuthToken];
}



///PostSys
-(void)postSys:(NSString *)token client_unique_id:(NSString *)client_unique_id os:(NSString *)os machine_type:(NSString *)machine_type push_unique_id:(NSString *)push_unique_id model:(NSString *)model company:(NSString *)company gps:(NSString *)gps {
    
    NSMutableDictionary *postSysDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       token,@"access_token",
                                       client_unique_id,@"client_unique_id",
                                       os,@"os",
                                       machine_type,@"machine_type",
                                       push_unique_id,@"push_unique_id",
                                       model,@"model",
                                       company,@"company",
                                       gps,@"gps",nil];
    
    [cloudClass postDataAsync:postSysDic APIName:API_Sys EventId:CloudAPIEventID_Sys];

}


///postForgetPassword
-(void)postForgetPassword:(NSString *)account client_id:(NSString *)client_id client_secret:(NSString *)client_secret {
    
    NSMutableDictionary *postForgetpwDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         account,@"account",
                                         client_id,@"client_id",
                                         client_secret,@"client_secret",nil];

     [cloudClass postDataAsync:postForgetpwDic APIName:API_ForgotPW EventId:CloudAPIEventID_ForgotPW];
}


///postAddMemberActionLog
-(void)postAddMemberActionLog:(NSString *)access_token device_type:(int)device_type log_action:(int)log_action date:(NSString *)date {
    
    NSNumber *device_type_int = [NSNumber numberWithInt:device_type];
    NSNumber *log_action_int = [NSNumber numberWithInt:log_action];
    
    NSMutableDictionary *postAddMemberActionLogDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                   access_token,@"access_token",
                                                   device_type_int,@"device_type",
                                                   log_action_int,@"log_action",
                                                   date,@"date",nil];
    
    [cloudClass postDataAsync:postAddMemberActionLogDic APIName:API_AddMemberActionLog EventId:CloudAPIEventID_AddMemberActionLog];
    
}


///postGetBPMHistoryData
-(void)postGetBPMHistoryData:(NSString *)access_token {
    
    NSMutableDictionary *postGetBpmHistoryDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token", nil];
    
    [cloudClass postDataAsync:postGetBpmHistoryDataDic APIName:API_GetBpmHistoryData EventId:CloudAPIEventID_GetBpmHistoryData];

}


///postAddBPM
-(void)postAddBPM:(NSString *)access_token user_id:(NSString *)user_id sys:(int)sys dia:(int)dia pul:(int)pul bpm_id:(NSString *)bpm_id afib:(int)afib pad:(int)pad man:(int)man date:(NSString *)date mac_address:(NSString *)mac_address {
    
    NSNumber *sysInt = [NSNumber numberWithInt:sys];
    NSNumber *diaInt = [NSNumber numberWithInt:dia];
    NSNumber *pulInt = [NSNumber numberWithInt:pul];
    NSNumber *afibInt = [NSNumber numberWithInt:afib];
    NSNumber *padInt = [NSNumber numberWithInt:pad];
    NSNumber *manInt = [NSNumber numberWithInt:man];
    
    NSMutableDictionary *postaddBPMDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              access_token,@"access_token",
                                              user_id,@"user_id",
                                              sysInt,@"sys",
                                              diaInt,@"dia",
                                              pulInt,@"pul",
                                              bpm_id,@"bpm_id",
                                              afibInt,@"afib",
                                              padInt,@"pad",
                                              manInt,@"man",
                                              date,@"date",
                                              mac_address,@"mac_address",nil];
    
    [cloudClass postDataAsync:postaddBPMDataDic APIName:API_AddBpm EventId:CloudAPIEventID_AddBpm];
}



///postEditBPM
-(void)postEditBPM:(NSString *)access_token bpm_id:(NSString *)bpm_id sys:(int)sys dia:(int)dia pul:(int)pul date:(NSString *)date {
    
    NSNumber *sys_int = [NSNumber numberWithInt:sys];
    NSNumber *dia_int = [NSNumber numberWithInt:dia];
    NSNumber *pul_int = [NSNumber numberWithInt:pul];
    
    
    NSMutableDictionary *postEditBPMDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            access_token,@"access_token",
                                            bpm_id,@"bpm_id",
                                            sys_int,@"sys",
                                            dia_int,@"dia",
                                            pul_int,@"pul",
                                            date,@"date",nil];
    
    [cloudClass postDataAsync:postEditBPMDataDic APIName:API_EditBpm EventId:CloudAPIEventID_EditBpm];
}


///postGetWeightHistoryData
-(void)postGetWeightHistoryData:(NSString *)access_token {
    
    NSMutableDictionary *postGetWeightHistoryDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token" ,nil];
    
    [cloudClass postDataAsync:postGetWeightHistoryDic APIName:API_GetWeightHistoryData EventId:CloudAPIEventID_GetWeightHistoryData];
}



///postAddWeightData
-(void)postAddWeightData:(NSString *)access_token weight_id:(NSString *)weight_id weight:(float)weight bmi:(float)bmi body_fat:(float)body_fat water:(int)water skeleton:(float)skeleton muscle:(int)muscle bmr:(int)bmr organ_fat:(float)organ_fat date:(NSString *)date mac_address:(NSString *)mac_address {
    
    NSNumber *weight_float = [NSNumber numberWithFloat:weight];
    NSNumber *BMI_float = [NSNumber numberWithFloat:bmi];
    NSNumber *body_fat_float = [NSNumber numberWithFloat:body_fat];
    NSNumber *water_int = [NSNumber numberWithInt:water];
    NSNumber *skeleton_float = [NSNumber numberWithFloat:skeleton];
    NSNumber *muscle_int = [NSNumber numberWithInt:muscle];
    NSNumber *bmr_int = [NSNumber numberWithInt:bmr];
    NSNumber *organ_fat_float = [NSNumber numberWithFloat:organ_fat];
    
    
    NSMutableDictionary *postAddWeightDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              access_token,@"access_token",
                                              weight_float,@"weight",
                                              weight_id,@"weight_id",
                                              BMI_float,@"bmi",
                                              body_fat_float,@"body_fat",
                                              water_int,@"water",
                                              skeleton_float,@"skeleton",
                                              muscle_int,@"muscle",
                                              bmr_int,@"bmr",
                                              organ_fat_float,@"organ_fat",
                                              date,@"date",
                                              mac_address,@"mac_address",nil];
    
    [cloudClass postDataAsync:postAddWeightDataDic APIName:API_AddWeightData EventId:CloudAPIEventID_AddWeightData];
    
}



///postEditWeightData
-(void)postEditWeightData:(NSString *)access_token weight_id:(NSString *)weight_id weight:(float)weight bmi:(float)bmi body_fat:(float)body_fat date:(NSString *)date {
    
    NSNumber *weight_float = [NSNumber numberWithFloat:weight];
    NSNumber *bmi_float = [NSNumber numberWithFloat:bmi];
    NSNumber *body_fat_float = [NSNumber numberWithFloat:body_fat];

    
    NSMutableDictionary *postEditWeightDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               access_token,@"access_token" ,
                                               weight_id,@"weight_id",
                                               weight_float,@"weight",
                                               bmi_float,@"bmi",
                                               body_fat_float,@"body_fat",
                                               date,@"date",nil];
    
    [cloudClass postDataAsync:postEditWeightDataDic APIName:API_EditWeightData EventId:CloudAPIEventID_EditWeightData];

}



///postGetBTEventList
-(void)postGetBTEventList:(NSString *)access_token {
    
    NSMutableDictionary *postGetBTEventListDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token", nil];
    
    [cloudClass postDataAsync:postGetBTEventListDic APIName:API_GetBTEventList EventId:CloudAPIEventID_GetBTEventList];

}



///postAddBTEvent
-(void)postAddBTEvent:(NSString *)access_token event_code:(int)event_code event:(NSString *)event type:(NSString *)type event_time:(NSString *)event_time {
    
    NSNumber *event_code_int = [NSNumber numberWithInt:event_code];
    
    NSMutableDictionary *postAddBTEventDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           access_token,@"access_token",
                                           event_code_int,@"event_code",
                                           event,@"event",
                                           type,@"type",
                                           event_time,@"event_time",nil];
    
    
    [cloudClass postDataAsync:postAddBTEventDic APIName:API_AddBTEvent EventId:CloudAPIEventID_AddBTEvent];
}


///postEditBTEvent
-(void)postEditBTEvent:(NSString *)access_token event_code:(int)event_cod event:(NSString *)event type:(NSString *)type event_time:(NSString *)event_time delete:(int)editOrDelete {
    
    /**
     1:Delete ; 0,2,3...除1以外都是Edit
     2:刪除時，event_time不用檢驗
    */
    
    NSNumber *event_cod_int = [NSNumber numberWithInt:event_cod];
    
    NSMutableDictionary *postEditBTEventDic = [[NSMutableDictionary alloc] init];
    
    if (editOrDelete == 1) {
        ///Delete
        
        NSDictionary *deleteBTEvent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       access_token,@"access_token",
                                       event_cod_int,@"event_code",
                                       event,@"event",
                                       type,@"type",
                                       editOrDelete,@"delete",nil];
        
        [postEditBTEventDic setDictionary:deleteBTEvent];
        
    }
    else {
        ///Edit
        
        NSDictionary *editBTEvent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     access_token,@"access_token",
                                     event_cod_int,@"event_code",
                                     event,@"event",
                                     type,@"type",
                                     event_time,@"event_time",
                                     editOrDelete,@"delete",nil];
        
        [postEditBTEventDic setDictionary:editBTEvent];
        
    }
    
    [cloudClass postDataAsync:postEditBTEventDic APIName:API_EditBTEvent EventId:CloudAPIEventID_EditBTEvent];
    
}


///postGetBTHistoryData
-(void)postGetBTHistoryData:(NSString *)access_token event_code:(int)event_code {
    
    NSNumber *event_cod_int = [NSNumber numberWithInt:event_code];
    
    NSMutableDictionary *postGetBTHistoryDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 access_token,@"access_token",
                                                 event_cod_int,@"event_code",nil];
    
    [cloudClass postDataAsync:postGetBTHistoryDataDic APIName:API_GetBTHistoryData EventId:CloudAPIEventID_GetBTHistoryData];
    
}



///postAddBTData
-(void)postAddBTData:(NSString *)access_token event_code:(int)event_code bt_id:(NSString *)bt_id body_temp:(float)body_temp room_temp:(float)room_temp date:(NSString *)date mac_address:(NSString *)mac_address {
    
    NSNumber *event_code_int = [NSNumber numberWithInt:event_code];
    NSNumber *body_temp_float = [NSNumber numberWithFloat:body_temp];
    NSNumber *room_temp_float = [NSNumber numberWithFloat:room_temp];
    
    
    NSMutableDictionary *postAddBTDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          access_token,@"access_token",
                                          event_code_int,@"event_code",
                                          bt_id,@"bt_id",
                                          body_temp_float,@"body_temp",
                                          room_temp_float,@"room_temp",
                                          date,@"date",
                                          mac_address,@"mac_address",nil];
    
    [cloudClass postDataAsync:postAddBTDataDic APIName:API_AddBTData EventId:CloudAPIEventID_AddBTData];

}


///postEditBTData
-(void)postEditBTData:(NSString *)access_token event_code:(int)event_code bt_id:(NSString *)bt_id body_temp:(float)body_temp room_temp:(float)room_temp date:(NSString *)date {
    
    NSNumber *event_cod_int = [NSNumber numberWithInt:event_code];
    NSNumber *body_temp_float = [NSNumber numberWithFloat:body_temp];
    NSNumber *room_temp_float = [NSNumber numberWithFloat:room_temp];
    
    NSMutableDictionary *postEditBTDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           access_token,@"access_token",
                                           event_cod_int,@"event_code",
                                           bt_id,@"bt_id",
                                           body_temp_float,@"body_temp",
                                           room_temp_float,@"room_temp",
                                           date,@"date",nil];
    
    [cloudClass postDataAsync:postEditBTDataDic APIName:API_EditBTData EventId:CloudAPIEventID_EditBTData];

}


///postAddNoteData
-(void)postAddNoteData:(NSString *)access_token type_id:(NSString *)type_id note_type:(int)note_type note:(NSString *)note photo:(UIImage *)photo recording:(NSData *)recording recording_time:(NSString *)recording_time {
    
    ///note_type ==> 1:血壓計 - 2:體重計 - 3:額溫槍
    
    NSNumber *note_typeInt = [NSNumber numberWithInt:note_type];
    
    NSMutableDictionary *postAddNoteDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            access_token,@"access_token",
                                            type_id,@"type_id",
                                            note_typeInt,@"note_type",
                                            note,@"note",
                                            photo,@"photo",
                                            recording,@"recording",
                                            recording_time,@"recording_time",nil];    
    
    //[cloudClass postDataAsync:postAddNoteDataDic APIName:API_AddNoteData EventId:CloudAPIEventID_AddNoteData];
    
    //UIImage *imageData = [UIImage imageWithContentsOfFile:@"/Users/Zengwei-liang/Desktop/MicroLifeAPITest/MicroLifeAPITest/MicroLifeTest01.png"];

    
//    [cloudClass postDataSync:postAddNoteDataDic APIName:API_AddNoteData EventId:CloudAPIEventID_AddNoteData withImage:photo withFile:@"path"];

    [cloudClass postDataAsync:postAddNoteDataDic APIName:API_AddNoteData EventId:CloudAPIEventID_AddNoteData withImage:photo withRecording:recording];
}


///postDeleteRecordData
-(void)postDeleteRecordData:(NSString *)access_token type_id:(NSString *)type_id note_type:(int)note_type {
    
    NSNumber *note_type_int = [NSNumber numberWithInt:note_type];

    NSMutableDictionary *postDeleteRecordDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 access_token,@"access_token",
                                                 note_type_int,@"note_type",
                                                 type_id,@"type_id",nil];
    
    [cloudClass postDataAsync:postDeleteRecordDataDic APIName:API_DeleteRecordData EventId:CloudAPIEventID_DeleteRecordData];

}


///postGetMailNotificationList
-(void)postGetMailNotificationList:(NSString *)access_token {
    
    NSMutableDictionary *postGetMailNotificationListDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token", nil];
    
    [cloudClass postDataAsync:postGetMailNotificationListDic APIName:API_GetMailNotification EventId:CloudAPIEventID_GetMailNotification];
}


///postAddMailNotification
-(void)postAddMailNotification:(NSString *)access_token name:(NSString *)name email:(NSString *)email {
    
    NSMutableDictionary *postAddMailNotificationDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    access_token,@"access_token",
                                                    name,@"name",
                                                    email,@"email",nil];
    
    
    [cloudClass postDataAsync:postAddMailNotificationDic APIName:API_AddMailNotification EventId:CloudAPIEventID_AddMailNotification];

}



///postEditMailNotification
-(void)postEditMailNotification:(NSString *)access_token mail_id:(NSMutableArray<NSNumber *> *)mail_id name:(NSString *)name email:(NSString *)email delete:(int)editOrDelete {
    
    ///mail_id：更新資料，一次只能一個; 唯有刪除才能多筆([1,2,3])
    
    ///欲編輯或刪除的資料 字串格式: 2,5,6,7
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < mail_id.count; i++) {
        
        [mutableString appendFormat:@"%d,",[mail_id[i] intValue]];
    }
    
    NSString *mail_idStr = (NSString *)[mutableString substringToIndex:mutableString.length - 1];
    
    NSLog(@"mail_idStr:%@",mail_idStr);
    
    NSMutableDictionary *postEditMailNotificationDic = [[NSMutableDictionary alloc] init];
    
    NSNumber *editOrDelete_num = [NSNumber numberWithInt:editOrDelete];
    
    
    if (editOrDelete == 1) {
        ///Delete
        
        NSDictionary *deleteDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   access_token,@"access_token",
                                   mail_idStr,@"mail_id",
                                   name,@"name",
                                   email,@"email",
                                   editOrDelete_num,@"delete",nil];
        
        [postEditMailNotificationDic setDictionary:deleteDic];
        
    }
    else {
        ///Edit
        
        NSDictionary *editDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 access_token,@"access_token",
                                 mail_idStr,@"mail_id",
                                 name,@"name",
                                 email,@"email",
                                 editOrDelete_num,@"delete",nil];
        
        
        [postEditMailNotificationDic setDictionary:editDic];
    }
    
    
    NSLog(@"postEditMailNotificationDic: %@",postEditMailNotificationDic);
    
    [cloudClass postDataAsync:postEditMailNotificationDic APIName:API_EditMailNotification EventId:CloudAPIEventID_EditMailNotification];

    
}



///postGetDeviceList
-(void)postGetDeviceList:(NSString *)access_token {
    
    NSMutableDictionary *postGetDeviceListDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token" ,nil];
    
    [cloudClass postDataAsync:postGetDeviceListDic APIName:API_GetDeviceList EventId:CloudAPIEventID_GetDeviceList];
}


///postAddDevice
-(void)postAddDevice:(NSString *)access_token device_type:(int)device_type device_model:(NSString *)device_model error_code:(NSString *)error_code mac_address:(NSString *)mac_address {
 
    NSNumber *device_type_num = [NSNumber numberWithInt:device_type];
    
    NSMutableDictionary *addDeviceDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         access_token,@"access_token",
                                         device_type_num,@"device_type",
                                         device_model,@"device_model",
                                         error_code,@"error_code",
                                         mac_address,@"mac_address",nil];
    
    [cloudClass postDataAsync:addDeviceDic APIName:API_AddDevice EventId:CloudAPIEventID_AddDevice];
    
}


///postDeleteDeviceData
-(void)postDeleteDeviceData:(NSString *)access_token mac_address:(NSString *)mac_address {
    
    NSMutableDictionary *deleteDeviceDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             access_token,@"access_token",
                                             mac_address,@"mac_address",nil];
    
    [cloudClass postDataAsync:deleteDeviceDataDic APIName:API_DeleteDeviceData EventId:CloudAPIEventID_DeleteDeviceData];

}


///postDownloadBPMPDF
-(void)postDownloadBPMPDF:(NSString *)access_token start_date:(NSString *)start_date end_date:(NSString *)end_date sys_threshold:(int)sys_threshold dia_threshold:(int)dia_threshold photo:(UIImage *)photo {
    
    NSNumber *sys_threshold_int = [NSNumber numberWithInt:sys_threshold];
    NSNumber *dia_threshold_int = [NSNumber numberWithInt:dia_threshold];
    
    NSMutableDictionary *downloadBPMPDFDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              access_token,@"access_token",
                                              start_date,@"start_date",
                                              end_date,@"end_date",
                                              sys_threshold_int,@"sys_threshold",
                                              dia_threshold_int,@"dia_threshold",
                                              photo,@"photo",nil];

     [cloudClass postDataAsync:downloadBPMPDFDic APIName:API_DownloadBPMPDF EventId:CloudAPIEventID_DownloadBPMPDF withImage:photo];
    
}


///postDownloadBTPDf
-(void)postDownloadBTPDF:(NSString *)access_token start_date:(NSString *)start_date end_date:(NSString *)end_date threshold:(int)threshold photo:(UIImage *)photo {
    
    NSNumber *threshold_int = [NSNumber numberWithInt:threshold];
    
    NSMutableDictionary *downloadBTPDF = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          access_token,@"access_token",
                                          start_date,@"start_date",
                                          end_date,@"end_date",
                                          threshold_int,@"threshold",
                                          photo,@"photo",nil];
    
    [cloudClass postDataAsync:downloadBTPDF APIName:API_DownloadBTPDF EventId:CloudAPIEventID_DownloadBTPDF withImage:photo];

}


///postDownloadWeightPD
-(void)postDownloadWeightPDF:(NSString *)access_token start_date:(NSString *)start_date end_date:(NSString *)end_date bmi_threshold:(int)bmi_threshold photo:(UIImage *)photo {
    
    NSNumber *bmi_threshold_int = [NSNumber numberWithInt:bmi_threshold];
    
    
    NSMutableDictionary *downloadWeightPDF = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              access_token,@"access_token",
                                              start_date,@"start_date",
                                              end_date,@"end_date",
                                              bmi_threshold_int,@"bmi_threshold",
                                              photo,@"photo",nil];
    
    [cloudClass postDataAsync:downloadWeightPDF APIName:API_DownloadWeightPDF EventId:CloudAPIEventID_DownloadWeightPDF withImage:photo];
}

///postGetMemberBaseData
-(void)postGetMemberBaseData:(NSString *)access_token client_id:(NSString *)client_id client_secret:(NSString *)client_secret {
    
    NSMutableDictionary *getMemberBaseDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 access_token,@"access_token",
                                                 client_id,@"client_id",
                                                 client_secret,@"client_secret",nil];
    
    [cloudClass postDataAsync:getMemberBaseDataDic APIName:API_GetMemberBaseData EventId:CloudAPIEventID_GetMemberBaseData];
    
}


///postGetMemberData
-(void)postGetMemberData:(NSString *)access_token client_id:(NSString *)client_id client_secret:(NSString *)client_secret {
    
    
    NSMutableDictionary *getMemberDataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 access_token,@"access_token",
                                                 client_id,@"client_id",
                                                 client_secret,@"client_secret",nil];
    
    [cloudClass postDataAsync:getMemberDataDic APIName:API_GetMemberData EventId:CloudAPIEventID_GetMemberData];
    

}



-(void)postModifyMember:(NSString *)access_token client_id:(NSString *)client_id client_secret:(NSString *)client_secret name:(NSString *)name birthday:(NSString *)birthday gender:(int)gender height:(int)height weight:(float)weight unit_type:(int)unit_type sys_unit:(int)sys_unit sys:(int)sys dia:(int)dia goal_weight:(float)goal_weight body_fat:(float)body_fat bmi:(float)bmi sys_activity:(int)sys_activity dia_activity:(int)dia_activity weight_activity:(int)weight_activity body_fat_activity:(int)body_fat_activity bmi_activity:(int)bmi_activity threshold:(int)threshold cuff_size:(int)cuff_size bp_measurement_arm:(int)bp_measurement_arm date_format:(int)date_format conditions:(NSString *)conditions photo:(UIImage *)photo {
    
    /**
     conditions: NSString,if choose 2 & 5 & 11 ==> @"2,5,11"
    */
    
    NSNumber *gender_num = [NSNumber numberWithInt:gender];
    
    NSNumber *height_num = [NSNumber numberWithInt:height];
    
    NSNumber *weight_num = [NSNumber numberWithFloat:weight];
    
    NSNumber *unit_type_num = [NSNumber numberWithInt:unit_type];
    
    NSNumber *sys_unit_num = [NSNumber numberWithInt:sys_unit];
    
    NSNumber *sys_num = [NSNumber numberWithInt:sys];
    
    NSNumber *dia_num = [NSNumber numberWithInt:dia];
    
    NSNumber *goal_weight_num = [NSNumber numberWithFloat:goal_weight];
    
    NSNumber *body_fat_num = [NSNumber numberWithFloat:body_fat];
    
    NSNumber *bmi_num = [NSNumber numberWithFloat:bmi];
    
    NSNumber *sys_activity_num = [NSNumber numberWithInt:sys_activity];
    
    NSNumber *dia_activity_num = [NSNumber numberWithInt:dia_activity];
    
    NSNumber *weight_activity_num = [NSNumber numberWithInt:weight_activity];
    
    NSNumber *body_fat_activity_num = [NSNumber numberWithInt:body_fat_activity];
    
    NSNumber *bmi_activity_num = [NSNumber numberWithInt:bmi_activity];
    
    NSNumber *threshold_num = [NSNumber numberWithInt:threshold];
    
    NSNumber *cuff_size_num = [NSNumber numberWithInt:cuff_size];
    
    NSNumber *bp_measurement_arm_num = [NSNumber numberWithInt:bp_measurement_arm];
    
    NSNumber *date_format_num = [NSNumber numberWithInt:date_format];
    
    
    NSMutableDictionary *modifyMemberDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            access_token,@"access_token",
                                            client_id,@"client_id",
                                            client_secret,@"client_secret",
                                            name,@"name",
                                            birthday,@"birthday",
                                            gender_num,@"gender",
                                            height_num,@"height",
                                            weight_num,@"weight",
                                            unit_type_num,@"unit_type",
                                            sys_unit_num,@"sys_unit",
                                            sys_num,@"sys",
                                            dia_num,@"dia",
                                            goal_weight_num,@"goal_weight",
                                            body_fat_num,@"body_fat",
                                            bmi_num,@"bmi",
                                            sys_activity_num,@"sys_activity",
                                            dia_activity_num,@"dia_activity",
                                            weight_activity_num,@"weight_activity",
                                            body_fat_activity_num,@"body_fat_activity",
                                            bmi_activity_num,@"bmi_activity",
                                            threshold_num,@"threshold",
                                            cuff_size_num,@"cuff_size",
                                            bp_measurement_arm_num,@"bp_measurement_arm",
                                            date_format_num,@"date_format",
                                            conditions,@"conditions",
                                            photo,@"photo",nil];
    
    
    [cloudClass postDataAsync:modifyMemberDic APIName:API_ModifyMember EventId:CloudAPIEventID_ModifyMember withImage:photo];
    
}




-(void)postGetPushHistoryList:(NSString *)access_token {
    
    NSMutableDictionary *postGetPushHistoryListDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token", nil];
    
    [cloudClass postDataAsync:postGetPushHistoryListDic APIName:API_GetPushHistoryList EventId:CloudAPIEventID_GetPushHistoryList];
}




//GET Image
-(void)getImgDataFromURL:(NSString *)urlStr {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            NSLog(@"img Error:%@",error);
            
            UIImage *img = [UIImage imageNamed:@"personal"];
            
            NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
            
            [self.delegate processGetImage:imageData];
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate processGetImage:data];
        });
        
    }];
    
    [dataTask resume];
}




/**
//特殊解析:token(愈期-失效) , 5205/5206/5207
-(void)postWhenTokenExpired:(NSString *)responseCode currentVC:(UIViewController *)currentVC {
    
    if ([responseCode isEqualToString:@"5205"] || [responseCode isEqualToString:@"5206"]) {
        //5205:authorization_code過期,重新回到 webView 登入頁
        //5206:refresh_token過期(正常狀況是3年未登入,refresh_token過期),到 webView 登入頁,取 token

        webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:WEBVIEW_URL] entersReaderIfAvailable:YES];
        
        [currentVC presentViewController:webView animated:YES completion:nil];
        
    }
    else if ([responseCode isEqualToString:@"5207"]) {
        //access_token過期,拿 refresh_token去換 token
        
        NSString *refresh_token_str = [NSString stringWithContentsOfFile:OAuth_Refreash_TOKEN encoding:NSUTF8StringEncoding error:nil];
        
        [self postOAuthToken:refresh_token code:@"" refreshToken:refresh_token_str clientID:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" clientSecret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C" redirectURI:@"com.CustomURLAPP.demo"];
        
    }
    
}
*/
@end
