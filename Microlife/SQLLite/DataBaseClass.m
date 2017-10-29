//
//  DataBaseClass.m
//  DataBase
//
//  Created by Kimi on 12/9/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseClass.h"

@implementation DataBaseClass

- (id)initWithOpenDataBase{
    
    if( self = [super init]) {
        
        BOOL ExistDB = [self OpenOrCreateDB:kDBNameSQLite];
        
        if ( ExistDB == 0 ) {
            //DB不存在

            [self CREATE_ProfileList];  //基本資料
            
            [self CREATE_BPMList];      //創建血壓資料
            
            [self CREATE_WeightList];   //創建體重體脂資料
            
            [self CREATE_EventList];    //創建溫度計資料
            
            [self CREATE_BTList];       //創建藍芽資料
            
        }
        
        [self CREATE_AlertList];    //提示設定
	}
	return self;

}

//= 創建資料表 ========================================================================================================================
-(void)CREATE_ProfileList{
    
    /**
     ------------------------------------
     用戶ID: accountID;
     ------------------------------------
     姓名: name
     ------------------------------------
     性別: userGender; //0 = man 1=women
     ------------------------------------
     生日: birthday;  //預設 1946年01月01日
     ------------------------------------
     身高: userHeight; //預設 175 cm
     ------------------------------------
     體重: userWeight; //預設 75 kg
     ------------------------------------
     臂圍大小: cuff_size 0(預設值)
     ------------------------------------
     左右手: bp_measurement_arm 0(預設值)
     ------------------------------------
     公英制: unit_type;//0 = KG CM   1=lb
     ------------------------------------
     目標收縮壓單位: sys_unit 0(預設值) 0=mmHg   1=kpa;
     ------------------------------------
     目標收縮壓: sys 135(預設值)
     ------------------------------------
     是否開啟目標收縮壓: sys_activity ; 0(預設值), 0=OFF, 1=ON
     ------------------------------------
     目標舒張壓: dia 85(預設值)
     ------------------------------------
     是否開啟目標舒張壓: dia_activity; 0(預設值), 0=OFF, 1=ON
     ------------------------------------
     目標體重: goal_weight 75(預設值)
     ------------------------------------
     是否開啟目標體重: weight_activity; 0(預設值), 0=OFF, 1=ON
     ------------------------------------
     目標BMI: bmi 23(預設值)
     ------------------------------------
     是否開啟目標: BMI bmi_activity 0(預設值), 0=OFF, 1=ON
     ------------------------------------
     目標體脂: body_fat 20(預設值)
     ------------------------------------
     是否開啟目標體脂: body_fat_activity; 0(預設值), 0=OFF, 1=ON
     ------------------------------------
     正常值: threshold 1(預設值), 0=OFF, 1=ON
     ------------------------------------
     疾病: conditions
     ------------------------------------
     日期格式: date_format  0(預設值) 0 = yyyy/mm/dd  1 = mm/dd/yyyy
     ------------------------------------
     病歷資料: 預設值皆為 0 (0:無, 1:使用者有該症狀)
     
     高血壓:isHypertension
     
     心房顫動:isAtrialFibrillation
     
     糖尿病:isDiabetes
     
     心血管疾病:isCardiovascular
     
     慢性腎臟病:isChronicKindey
     
     貧血:isTransientIschemicAttact
     
     血脂異常:isDyslipidemia
     
     打鼾 或 睡眠呼吸暫停:isSnoringOrSleepAponea
     
     使用口服避孕藥:isUseOralContraception
     
     使用抗高血壓:isUseAntiHypertensive
     
     懷孕(正常):isPregenancy_normoal
     
     懷孕(子癇前症 或 妊娠毒血症):isPregenancy_preEclampsia
     
     抽菸習慣:isSmoking
     
     飲用酒精:isAlcoholIntake
     
     ------------------------------------
     */
    
    //profileID INTEGER NULL PRIMARY KEY AUTOINCREMENT,
    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS ProfileList( accountID INTEGER, name TEXT, userGender INTEGER, birthday TEXT, userHeight INTEGER, userWeight INTEGER, cuff_size INTEGER, bp_measurement_arm INTEGER, unit_type INTEGER, sys_unit INTEGER, sys INTEGER, sys_activity INTEGER, dia INTEGER, dia_activity INTEGER, goal_weight INTEGER, weight_activity INTEGER, bmi INTEGER, bmi_activity INTEGER, body_fat INTEGER, body_fat_activity INTEGER, threshold INTEGER, conditions TEXT, date_format INTEGER, isHypertension INTEGER, isAtrialFibrillation INTEGER, isDiabetes INTEGER, isCardiovascular INTEGER, isChronicKindey INTEGER, isTransientIschemicAttact INTEGER, isDyslipidemia INTEGER, isSnoringOrSleepAponea INTEGER, isUseOralContraception INTEGER, isUseAntiHypertensive INTEGER, isPregenancy_normoal INTEGER, isPregenancy_preEclampsia INTEGER, isSmoking INTEGER, isAlcoholIntake INTEGER);";
    
    //建立資料表
    [self CREATE_TABLE:SQLStr];
    
}


-(void)CREATE_BPMList{
    
    //CREATE TABLE IF NOT EXISTS 資料表名稱( 欄位名稱1 數據型態 鍵值, 欄位名稱2 數據型態 鍵值,...)
    /* -數據型態-----------------------------------------------------------------
     NULL:該值是一個NULL值
     INTEGER:該值是一個有正負的整數，由數據的大小決定存儲為1,2,3,4,6或8 bytes
     REAL:該值是一個浮點值，作為一個8 bytes浮點數存儲。
     TEXT:該值是一個文本字符串，使用（UTF-8，UTF-16BE或UTF-16LE）編碼存儲
     BLOB:存儲自定義的數據類型
     ------------------------------------------------------------------ */
    
    //    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS SYSTEM( VerID INTEGER PRIMARY KEY, OPENDAY TEXT, TIMEOUT INT, NOWPAGE INTEGER, NOWID INTEGER, PURCHASE TEXT,ATT1 TEXT,ATT2 TEXT,ATT3 TEXT,ATT4 TEXT,ATT5 TEXT);";
    
    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS BPMList( BPM_ID INTEGER NULL PRIMARY KEY AUTOINCREMENT, accountID INTEGER, userID INTEGER ,SYS INTEGER, DIA INTEGER, PUL INTEGER, PAD INTEGER, AFIB INTEGER, MAM INTEGER,  date TEXT, BPM_PhotoPath TEXT, BPM_Note TEXT, BPM_RecordingPath TEXT);";
    //建立資料表
    [self CREATE_TABLE:SQLStr];
    
}

-(void)CREATE_WeightList{
    
    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS WeightList( weightID INTEGER NULL PRIMARY KEY AUTOINCREMENT, accountID INTEGER,weight INTEGER, BMI INTEGER, bodyFat INTEGER, water INTEGER, skeleton INTEGER, muscle INTEGER, BMR INTEGER, organFat INTEGER, date TEXT, weight_PhotoPath TEXT,  weight_Note TEXT, weight_RecordingPath TEXT);";
    //建立資料表
    [self CREATE_TABLE:SQLStr];
    
}

-(void)CREATE_EventList{
    
    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS EventList( eventID INTEGER NULL PRIMARY KEY AUTOINCREMENT, accountID INTEGER,event TEXT, type TEXT, eventTime TEXT);";
    //建立資料表
    [self CREATE_TABLE:SQLStr];
    
}

-(void)CREATE_BTList{
    
    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS BTList( BT_ID INTEGER PRIMARY KEY AUTOINCREMENT , accountID INTEGER, eventID INTEGER, bodyTemp TEXT, roomTmep TEXT, date TEXT, BT_PhotoPath TEXT, BT_Note TEXT, BT_RecordingPath TEXT);";
    //建立資料表
    [self CREATE_TABLE:SQLStr];
    
}

-(void)CREATE_AlertList{
    
    //CREATE TABLE IF NOT EXISTS 資料表名稱( 欄位名稱1 數據型態 鍵值, 欄位名稱2 數據型態 鍵值,...)
    /* -數據型態-----------------------------------------------------------------
     NULL:該值是一個NULL值
     INTEGER:該值是一個有正負的整數，由數據的大小決定存儲為1,2,3,4,6或8 bytes
     REAL:該值是一個浮點值，作為一個8 bytes浮點數存儲。
     TEXT:該值是一個文本字符串，使用（UTF-8，UTF-16BE或UTF-16LE）編碼存儲
     BLOB:存儲自定義的數據類型
     ------------------------------------------------------------------ */
    
    
    NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS ALERTList(ALERT_ID INTEGER PRIMARY KEY AUTOINCREMENT, accountID INTEGER, ALERT_CONFIG TEXT,FLAG TEXT);";
    
    NSLog(@"Create table ALERTList");
    
    //建立資料表
    [self CREATE_TABLE:SQLStr];
    
}

//= 創建資料表END

//= 寫入資料表END ===================================================================================================================

- (NSString *)ArrayToString:(NSMutableArray *)Array{
    NSString *Str = @"";
    
    for (int i = 0; i < Array.count; i++) 
    {
        if ( i == 0 ) 
            Str = [NSString stringWithFormat:@"%@",[Array objectAtIndex:i]];
        else
            Str = [NSString stringWithFormat:@"%@,%@",Str,[Array objectAtIndex:i]];
    }
    
    return Str;
}

- (BOOL)openDatabase
{
    if(!fmdatabase){
        [self closeDatabase];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *thePath = [paths objectAtIndex:0];
    NSString *filePath = [thePath stringByAppendingPathComponent:kDBNameSQLite];
    
    fmdatabase = [[FMDatabase alloc] initWithPath:filePath];
    
    if ([fmdatabase open])
    {
        NSLog(@"open sqlite db ok.");
        
        //NSString *SQLStr = @"CREATE TABLE ALERTList(ALERT_ID INTEGER PRIMARY KEY AUTOINCREMENT, accountID INTEGER, ALERT_CONFIG TEXT,FLAG TEXT);";
        
        //NSLog(@"create table :%d",[fmdatabase executeUpdate:SQLStr]);
        
        return true;
        
    }
    else{
        
        return false;
    }
    
}

- (void)closeDatabase
{
    if (fmdatabase != NULL) {
        [fmdatabase close];
        NSLog(@"close sqlite db ok.");
    }
}



@end
