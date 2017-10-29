//
//  BTClass.h
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DataBaseClass.h"

@interface BTClass : DataBaseClass

@property (nonatomic) int BT_ID;                    //額溫槍ID
@property (nonatomic) int accountID;                //會員ID
@property (nonatomic) int eventID;                  //事件ID 與EVENTList的ID相對應
@property (nonatomic) NSString *bodyTemp;           //體溫
@property (nonatomic) NSString *roomTmep;           //室溫
@property (nonatomic) NSString *date;               //日期
@property (nonatomic) NSString *BT_PhotoPath;      //筆記照片路徑
@property (nonatomic) NSString *BT_Note;            //筆記內容
@property (nonatomic) NSString *BT_RecordingPath;  //筆記錄音路徑

+(BTClass*) sharedInstance;

-(NSMutableArray *)selectAllData;
-(NSMutableArray *)selectTempWithRange:(int)dataRange count:(int)dataCount;
-(NSMutableArray *)selectSingleHourTempWithRange:(int)dataRange;

-(NSMutableArray *)selectAllDataAtRange:(int)dataRange count:(int)dataCount;

-(NSMutableArray *)selectDataForList:(int)dataRange count:(int)dataCount;

-(NSDictionary *)selectTempAvgValueWithRange:(int)dataRange count:(int)dataCount;

-(void)insertData;
- (void)updateData;
-(void)deleteData;
- (NSString *)getLastDate;
@end
