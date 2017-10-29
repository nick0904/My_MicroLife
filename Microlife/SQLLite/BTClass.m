//
//  BTClass.m
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "BTClass.h"

@implementation BTClass

@synthesize BT_ID,accountID,eventID,bodyTemp,roomTmep,date,BT_PhotoPath,BT_Note, BT_RecordingPath;

+(BTClass*) sharedInstance{
    static BTClass *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[BTClass alloc] initWithOpenDataBase];
    });
    
    return sharedInstance;
}

-(id)initWithOpenDataBase{
    
    self = [super initWithOpenDataBase];
    
    if (self) {
        [self setUp];
    }
    return self;
}


-(void)setUp{
    
}

-(NSMutableArray *)selectAllData{
    
    
    //NSString *Command = [NSString stringWithFormat:@"SELECT BT_ID, accountID, eventID, bodyTemp, roomTmep ,date ,BT_PhotoPath, BT_Note, BT_RecordingPath FROM BTList"];
    
    NSString *Command = [NSString stringWithFormat:@"SELECT * FROM BTList WHERE accountID = %d ORDER BY date DESC",[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:9];//SELECT:指令：幾筆欄位
    
    return DataArray;
}

-(NSMutableArray *)selectTempWithRange:(int)dataRange count:(int)dataCount{

    NSMutableArray* resultArray= [NSMutableArray new];

    NSMutableArray* DataArray = [NSMutableArray new];
    
    //roomTmep 資料庫拼錯
    
    int limitHour = dataRange - dataCount-1;
    
//    NSString *Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep,date STRFTIME(\"%%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d %%H\", \"date\") > strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND strftime(\"%%Y-%%m-%%d %%H\", \"date\") <=strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND accountID = %d ORDER BY date DESC",dataRange,limitHour,[LocalData sharedInstance].accountID];
    
    NSString *Command;
    
    for (int i=dataRange-2; i>=limitHour; i--) {
        
        NSDate *currentDate = [NSDate date];
        
        NSDate *pastDate;
        
        NSString *latestTime = @"";
        
        if (dataCount == 14) {
            
            Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep, STRFTIME(\"%%Y-%%m-%%d %%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d\", \"date\") = strftime(\"%%Y-%%m-%%d\", \"now\", \"localtime\", \"-%d day\")  AND accountID = %d AND eventID = %d ORDER BY date DESC",i,[LocalData sharedInstance].accountID,[LocalData sharedInstance].currentEventId];
            
            pastDate = [currentDate dateByAddingTimeInterval:-24.0f*60.0f*60.0f*i];
            
        }
        else{
            
            Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep, STRFTIME(\"%%Y-%%m-%%d %%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d %%H\", \"date\") = strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\")  AND accountID = %d AND eventID = %d ORDER BY date DESC",i,[LocalData sharedInstance].accountID,[LocalData sharedInstance].currentEventId];
            
            pastDate = [currentDate dateByAddingTimeInterval:-60.0f*60.0f*i];
            
        }
        
        NSLog(@"BTList'Command:%@",Command);
        
        DataArray = [self SELECT:Command Num:3];//SELECT:指令：幾筆欄位
                
        //NSLog(@"DataArray = %@",DataArray);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = (i==limitHour)?@"MM/dd HH:59":@"MM/dd HH:00";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        latestTime = [dateFormatter stringFromDate:pastDate];
        
        float sumBodyTemp = 0;
        float sumRoomTemp = 0;
        
        NSNumber *avgBodyTemp = [NSNumber numberWithFloat:0.0];
        NSNumber *avgRoomTemp = [NSNumber numberWithFloat:0.0];
        
            //判斷是有有資料
        if ([[DataArray firstObject] count] != 1) {
                
            for (int i=0; i<DataArray.count; i++) {
                
                sumBodyTemp += [[[DataArray objectAtIndex:i] objectAtIndex:0] floatValue];
                sumRoomTemp += [[[DataArray objectAtIndex:i] objectAtIndex:1] floatValue];
            }
            
            
            avgBodyTemp = [NSNumber numberWithFloat:sumBodyTemp/DataArray.count];
            avgRoomTemp = [NSNumber numberWithFloat:sumRoomTemp/DataArray.count];
            
        }
        
        
        
        NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    avgBodyTemp,@"temp",
                                    avgRoomTemp,@"room",
                                    latestTime,@"date",nil];
        
        [resultArray addObject:resultDict];
        
        
    }
    
    //NSLog(@"Temp data resultArray = %@",resultArray);

    return resultArray;
    
}


-(NSMutableArray *)selectSingleHourTempWithRangeX:(int)dataRange{
    
    NSMutableArray* resultArray= [NSMutableArray new];
    
    //dataRange -= 1;
    
    //NSString *Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep, STRFTIME(\"%%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d %%H\", \"date\") = strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND accountID = %d ORDER BY date DESC", dataRange,[LocalData sharedInstance].accountID];
    
    int limitHour = dataRange-1;
    
    NSMutableArray* DataArray = [NSMutableArray new];
    
    NSString *Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep, STRFTIME(\"%%m/%%d %%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d %%H\", \"date\") > strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND strftime(\"%%Y-%%m-%%d %%H\", \"date\") <=strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND accountID = %d AND eventID = %d ORDER BY date DESC",dataRange,limitHour,[LocalData sharedInstance].accountID, [LocalData sharedInstance].currentEventId];
    
    NSLog(@"selectSingleHourTempWithRange:%@",Command);
    
    DataArray = [self SELECT:Command Num:3];//SELECT:指令：幾筆欄位
    
    //NSLog(@"limitHour = %d, dataRange = %d",limitHour,dataRange);
    
    NSString *dateStr = @"";
//    
//    NSDate *currentDate = [NSDate date];
//    
//    NSDate *pastDate = [currentDate dateByAddingTimeInterval:-60.0f*60.0f*dataRange];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"HH:mm";
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    
//    dateStr = [dateFormatter stringFromDate:pastDate];
//
    NSNumber *bodyTempNum = [NSNumber numberWithFloat:0.0];
    NSNumber *roomTempNum = [NSNumber numberWithFloat:0.0];
    
    
    for (int i=0; i<DataArray.count; i++) {
        
        if ([[DataArray firstObject] count] != 1) {
            bodyTempNum = [NSNumber numberWithFloat:[[[DataArray objectAtIndex:i] firstObject] floatValue]];
            
            roomTempNum = [NSNumber numberWithFloat:[[[DataArray objectAtIndex:i] objectAtIndex:1] floatValue]];
            
            dateStr = [NSString stringWithFormat:@"%@",[[DataArray objectAtIndex:i] objectAtIndex:2]];
            
            dateStr = [dateStr substringWithRange:NSMakeRange(0, 8)];
            
            dateStr = [NSString stringWithFormat:@"%@:00",dateStr];
        }else{
            NSDate *currentDate = [NSDate date];
            
            NSDate *pastDate = [currentDate dateByAddingTimeInterval:-60.0f*60.0f*dataRange];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd HH:mm";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            dateStr = [dateFormatter stringFromDate:pastDate];
//            break;
        }
        
        
        NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    bodyTempNum,@"temp",
                                    roomTempNum,@"room",
                                    dateStr,@"date",nil];
        
        [resultArray addObject:resultDict];
    }

    
    //NSLog(@"current day temp resultArray = %@",resultArray);
    
    return resultArray;
}

-(NSMutableArray *)selectSingleHourTempWithRange:(int)dataRange{
    
    NSMutableArray* resultArray= [NSMutableArray new];
    
    int limitHour = dataRange-1;
    
    NSMutableArray* DataArray = [NSMutableArray new];
    
    NSString *Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep, STRFTIME(\"%%m/%%d %%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d %%H\", \"date\") > strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND strftime(\"%%Y-%%m-%%d %%H\", \"date\") <=strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND accountID = %d AND eventID = %d ORDER BY date DESC",dataRange,limitHour,[LocalData sharedInstance].accountID, [LocalData sharedInstance].currentEventId];
    
    DataArray = [self SELECT:Command Num:3];//SELECT:指令：幾筆欄位
    
    NSString *examination = [DataArray firstObject][0];
    
    NSString *dateStr = @"";
    
    NSNumber *bodyTempNum = [NSNumber numberWithFloat:0.0];
    NSNumber *roomTempNum = [NSNumber numberWithFloat:0.0];
    
    NSDictionary *resultDict = nil;
    
    if ([examination isEqualToString:@"Can not find data!"]) {
        for (int i=0; i<= DataArray.count; i++) {
            if (i == DataArray.count) {
                NSDate *currentDate = [NSDate date];
                
                NSDate *pastDate = [currentDate dateByAddingTimeInterval:-60.0f*60.0f*(dataRange-2)];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd HH:mm";
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                
                dateStr = [dateFormatter stringFromDate:pastDate];
            }
            else{
                NSDate *currentDate = [NSDate date];
                
                NSDate *pastDate = [currentDate dateByAddingTimeInterval:-60.0f*60.0f*(dataRange-1)];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd HH:mm";
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                
                dateStr = [dateFormatter stringFromDate:pastDate];
            }
            
            dateStr = [dateStr substringWithRange:NSMakeRange(0, 8)];
            
            dateStr = [NSString stringWithFormat:@"%@:00",dateStr];
            
            resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        bodyTempNum,@"temp",
                                        roomTempNum,@"room",
                                        dateStr,@"date",nil];
            
            [resultArray addObject:resultDict];
        }
    }else {
        for (int i=0; i<= DataArray.count; i++) {
            
            if (i == DataArray.count) {
                NSDate *currentDate = [NSDate date];
                
                NSDate *pastDate = [currentDate dateByAddingTimeInterval:-60.0f*60.0f*(dataRange-2)];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd HH:mm";
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                
                dateStr = [dateFormatter stringFromDate:pastDate];
                
                dateStr = [dateStr substringWithRange:NSMakeRange(0, 8)];
                
                dateStr = [NSString stringWithFormat:@"%@:00",dateStr];
                
                resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"0",@"temp",
                                            @"0",@"room",
                                            dateStr,@"date",nil];
            }
            else{
                bodyTempNum = [NSNumber numberWithFloat:[[[DataArray objectAtIndex:i] firstObject] floatValue]];
                
                roomTempNum = [NSNumber numberWithFloat:[[[DataArray objectAtIndex:i] objectAtIndex:1] floatValue]];
                
                dateStr = [NSString stringWithFormat:@"%@",[[DataArray objectAtIndex:i] objectAtIndex:2]];
                
                dateStr = [dateStr substringWithRange:NSMakeRange(0, 8)];
                
                dateStr = [NSString stringWithFormat:@"%@:00",dateStr];
                
                resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            bodyTempNum,@"temp",
                                            roomTempNum,@"room",
                                            dateStr,@"date",nil];
            }
            
            [resultArray addObject:resultDict];
        }
        
    }
    
    return resultArray;
}

-(NSMutableArray *)selectDataForList:(int)dataRange count:(int)dataCount{
    
    NSMutableArray* resultArray = [NSMutableArray new];
    
    int limitHour;
    
    if (dataCount != -1) {
        limitHour = dataRange-dataCount;
    }else{
        limitHour = dataRange-1;
    }
    dataRange -= 1;
    
    NSMutableArray* DataArray = [NSMutableArray new];
    
    NSString *Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep,BT_PhotoPath, BT_Note, BT_RecordingPath,BT_ID, STRFTIME(\"%%Y/%%m/%%d %%H:%%M\",\"date\") FROM BTList WHERE strftime(\"%%Y-%%m-%%d %%H\", \"date\") >= strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND strftime(\"%%Y-%%m-%%d %%H\", \"date\") <=strftime(\"%%Y-%%m-%%d %%H\", \"now\", \"localtime\", \"-%d hour\") AND accountID = %d AND eventID = %d ORDER BY date DESC",dataRange,limitHour,[LocalData sharedInstance].accountID, [LocalData sharedInstance].currentEventId];
    
//   NSString *Command = [NSString stringWithFormat:@"SELECT SYS,DIA,AFIB,PAD,MAM FROM BPMList WHERE STRFTIME(\"%%Y-%%m-%%d\",\"date\") >= STRFTIME(\"%%Y-%%m-%%d\",\"now\",\"-%d day\") AND STRFTIME(\"%%Y-%%m-%%d\",\"date\") <= STRFTIME(\"%%Y-%%m-%%d\",\"now\",\"-%d day\") AND accountID = %d ORDER BY date DESC",dataRange,limitHour,[LocalData sharedInstance].accountID];
    
    NSLog(@"selectDataForList's:%@",Command);
    
    DataArray = [self SELECT:Command Num:7];//SELECT:指令：幾筆欄位
    
    //NSLog(@"list temp DataArray = %@",DataArray);
    
    if ([[DataArray firstObject] count] != 1) {
        for (int i=0; i<DataArray.count; i++) {
            
            NSString *bodyTempStr = [[DataArray objectAtIndex:i] objectAtIndex:0];
            NSString *roomTempStr = [[DataArray objectAtIndex:i] objectAtIndex:1];
            NSString *photoPathStr = [[DataArray objectAtIndex:i] objectAtIndex:2];
            NSString *noteStr = [[DataArray objectAtIndex:i] objectAtIndex:3];
            NSString *recordingPathStr = [[DataArray objectAtIndex:i] objectAtIndex:4];
            
            NSString *IDStr = [[DataArray objectAtIndex:i] objectAtIndex:5];
            NSString *dateStr = [[DataArray objectAtIndex:i] objectAtIndex:6];
            NSString *listTypeStr = @"2";
            
            NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      bodyTempStr,@"bodyTemp",
                                      roomTempStr,@"roomTemp",
                                      photoPathStr,@"photoPath",
                                      noteStr,@"note",
                                      recordingPathStr,@"recordingPath",
                                      IDStr,@"ID",
                                      dateStr,@"date",
                                      listTypeStr,@"listType",
                                      nil];
            
            [resultArray addObject:dataDict];
            
        }
    }
    
    //NSLog(@"selectDataForList resultArray = %@",resultArray);
    
    
    return resultArray;
    
}

//圖表資料 泡泡框
-(NSDictionary *)selectTempAvgValueWithRange:(int)dataRange count:(int)dataCount{
    
    NSMutableArray* DataArray = [NSMutableArray new];
    
    NSString *Command;
    
    int rangeLimit = 0;
    
    if (dataCount != -1) {
        rangeLimit = dataRange - dataCount;
    }else{
        rangeLimit = dataRange-1;
    }
    
    dataRange -= 1;
    
    if (dataCount == 12) {
        Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep FROM BTList WHERE STRFTIME(\"%%Y-%%m\",\"date\") >= STRFTIME(\"%%Y-%%m\",\"now\", \"localtime\",\"-%d month\") AND STRFTIME(\"%%Y-%%m\",\"date\") <= STRFTIME(\"%%Y-%%m\",\"now\", \"localtime\",\"-%d month\") AND accountID = %d AND eventID = %d ORDER BY date DESC",dataRange,rangeLimit,[LocalData sharedInstance].accountID, [LocalData sharedInstance].currentEventId];
    }else{
        Command = [NSString stringWithFormat:@"SELECT bodyTemp,roomTmep FROM BTList WHERE STRFTIME(\"%%Y-%%m-%%d %%H\",\"date\") >= STRFTIME(\"%%Y-%%m-%%d %%H\",\"now\", \"localtime\",\"-%d hour\") AND STRFTIME(\"%%Y-%%m-%%d %%H\",\"date\") <= STRFTIME(\"%%Y-%%m-%%d %%H\",\"now\", \"localtime\",\"-%d hour\") AND accountID = %d AND eventID = %d ORDER BY date DESC",dataRange,rangeLimit,[LocalData sharedInstance].accountID, [LocalData sharedInstance].currentEventId];
    }
    
    DataArray = [self SELECT:Command Num:2];//SELECT:指令：幾筆欄位
    
    //NSLog(@"DataArray = %@",DataArray);
    
    float bodyTempSum = 0;
    NSNumber *lastTemp = [NSNumber numberWithFloat:0];
    NSNumber *avgTemp = [NSNumber numberWithFloat:0];
    
    if ([[DataArray firstObject] count] != 1) {
        
        for (int i=0; i<DataArray.count; i++) {
            bodyTempSum += [[[DataArray objectAtIndex:i] objectAtIndex:0] floatValue];
        }
        
        float lastTempVal = [[[DataArray firstObject] objectAtIndex:0] floatValue];
        
        avgTemp = [NSNumber numberWithFloat:bodyTempSum/DataArray.count];
        lastTemp = [NSNumber numberWithFloat:lastTempVal];
        
    }
    
    NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              avgTemp,@"avgTemp",
                              lastTemp,@"lastTemp",nil];
    
    
    return dataDict;
    
}


- (void)updateData{

    NSString *SQLStr = [NSString stringWithFormat:@"UPDATE BTList SET bodyTemp = \"%@\", roomTmep = \"%@\",date = \"%@\",BT_PhotoPath = \"%@\",BT_Note = \"%@\",BT_RecordingPath = \"%@\" WHERE BT_ID = %d AND accountID = %d AND eventID = %d", bodyTemp,roomTmep,date,BT_PhotoPath,BT_Note,BT_RecordingPath ,BT_ID, [LocalData sharedInstance].accountID, eventID];
    
    [self COLUMN_UPDATE:SQLStr];
    
}
 
-(void)insertData{
    
    
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO BTList( accountID, eventID, bodyTemp, roomTmep, date, BT_PhotoPath, BT_Note, BT_RecordingPath) VALUES(  \"%d\",\"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\");", [LocalData sharedInstance].accountID , eventID, bodyTemp, roomTmep, date, BT_PhotoPath, BT_Note, BT_RecordingPath];
    
    [self COLUMN_INSERT:SQLStr];
}

-(void)deleteData {
    
    NSString *sqStr = [NSString stringWithFormat:@"DELETE FROM BTList WHERE accountID ='%d';",[LocalData sharedInstance].accountID];
    
    [self COLUMN_DELETE:sqStr];
}

- (NSString *)getLastDate {
    NSString *Command = [NSString stringWithFormat:@"SELECT date FROM BTList WHERE accountID = %d ORDER BY date DESC",[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:1];//SELECT:指令：幾筆欄位
    NSString *lastDate = [[DataArray firstObject] objectAtIndex:0];
    if (![lastDate isEqualToString:@"Can not find data!"]) {
        lastDate = [lastDate substringToIndex:lastDate.length-3];
        lastDate = [lastDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    return lastDate;
    
}
@end
