//
//  EventClass.h
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DataBaseClass.h"

@interface EventClass : DataBaseClass

/**
 ----------------------------------------
 規格書參數名稱       |     程式參數命名
 ----------------------------------------
  id               |       eventID
  account_id       |       accountID
  event            |       event
  type             |       type
  event_time       |       eventTime
 
*/
@property (nonatomic) int eventID;          //額溫槍ID
@property (nonatomic) int accountID;        //帳號ID
@property (nonatomic) NSString *eventTime;  //事件時間
@property (nonatomic) NSString *type;       //類別
@property (nonatomic) NSString *event;      //量測事件

+(EventClass*) sharedInstance;

-(NSMutableArray *)selectAllData;
-(void)insertData;
- (void)updateData;
-(void)deletData;

-(void)deleteAllEventData;

@end
