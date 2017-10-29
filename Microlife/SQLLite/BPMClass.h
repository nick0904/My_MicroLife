//
//  BPMClass.h
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DataBaseClass.h"

@interface BPMClass : DataBaseClass

@property (nonatomic) int BPM_ID;                   //血壓機ID
@property (nonatomic) int accountID;                //會員ID
@property (nonatomic) int SYS;                      //收縮壓
@property (nonatomic) int DIA;                      //舒張壓
@property (nonatomic) int PUL;                      //脈搏
@property (nonatomic) int PAD;                      //心律不整
@property (nonatomic) int AFIB;                     //心房顫動
@property (nonatomic) int MAM;                      //是否開啟偵測AFIB模式


@property (nonatomic) NSString *date;               //日期
@property (nonatomic) NSString * BPM_PhotoPath;     //筆記照片路徑
@property (nonatomic) NSString * BPM_Note;          //筆記內容
@property (nonatomic) NSString * BPM_RecordingPath; //筆記錄音路徑


+(BPMClass*) sharedInstance;

//抓取全部資料
-(NSMutableArray *)selectAllData;


-(NSMutableArray *)selectBPWithRange:(int)dataRange count:(int)dataCount;
-(NSMutableArray *)selectPULWithRange:(int)dataRange count:(int)dataCount;
-(NSMutableArray *)selectSingleDayPULWithRange:(int)dataRange;
-(NSMutableArray *)selectSingleDayBPWithRange:(int)dataRange;

-(NSMutableArray *)selectDataForList:(int)dataRange count:(int)dataCount;

-(NSDictionary *)selectBPAvgValueWithRange:(int)dataRange count:(int)dataCount;
-(NSDictionary *)selectListBPAvgValueWithRange:(int)dataRange count:(int)dataCount;

-(void)insertData;
- (void)updateData;
-(void)deleteData;

- (NSString *)getLastDate;
@end
