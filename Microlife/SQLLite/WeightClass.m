//
//  WeightClass.m
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "WeightClass.h"

@implementation WeightClass

@synthesize weightID,accountID,weight,BMI,bodyFat,water,skeleton,muscle,BMR,organFat,date,weight_PhotoPath,weight_Note,weight_RecordingPath;

+(WeightClass*) sharedInstance{
    static WeightClass *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        
        sharedInstance = [[WeightClass alloc] initWithOpenDataBase];
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


-(NSMutableArray *)selectAllData {
    
    NSString *Command = [NSString stringWithFormat:@"SELECT * FROM WeightList WHERE accountID = %d ORDER BY date DESC",[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:14];//SELECT:指令：幾筆欄位
    
    return DataArray;
}


-(NSMutableArray *)selectAllDataAtRange:(int)dataRange count:(int)dataCount{
    
    // NSString *SQLStr = @"CREATE TABLE IF NOT EXISTS WeightList( weightID INTEGER NULL PRIMARY KEY AUTOINCREMENT, accountID INTEGER,weight INTEGER, BMI INTEGER, bodyFat INTEGER, water INTEGER, skeleton INTEGER, muscle INTEGER, BMR INTEGER, organFat INTEGER, date TEXT, weight_PhotoPath TEXT,  weight_Note TEXT, weight_RecordingPath TEXT);";
    
    NSMutableArray *resultArray = [NSMutableArray new];
    
    for (int i = dataRange-1; i >= dataRange-dataCount ; i--) {
        
        NSMutableArray* DataArray = [NSMutableArray new];
        
        NSString *Command;
        
        if (dataRange == 12) {
            Command = [NSString stringWithFormat:@"SELECT * FROM WeightList WHERE STRFTIME(\"%%Y-%%m\",\"date\") = STRFTIME(\"%%Y-%%m\",\"now\", \"localtime\",\"-%d month\") AND accountID = %d ORDER BY date DESC",i,[LocalData sharedInstance].accountID];
        }else{
            Command = [NSString stringWithFormat:@"SELECT * FROM WeightList WHERE DATE(date) = STRFTIME(\"%%Y-%%m-%%d\",\"now\", \"localtime\",\"-%d day\") AND accountID = %d ORDER BY date DESC",i,[LocalData sharedInstance].accountID];
        }
        
        DataArray = [self SELECT:Command Num:14];//SELECT:指令：幾筆欄位
    
        NSLog(@"DataArray = %@",DataArray);
    
        
        if ([[DataArray firstObject] count] != 1) {
            //NSLog(@"DataArray = %@",DataArray);
            
            for (int i=0; i<DataArray.count; i++) {
                NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [[DataArray objectAtIndex:i] objectAtIndex:0],@"weightID",
                                          [[DataArray objectAtIndex:i] objectAtIndex:1],@"accountID",
                                          [[DataArray objectAtIndex:i] objectAtIndex:2],@"weight",
                                          
                                          [[DataArray objectAtIndex:i] objectAtIndex:3],@"BMI",
                                          [[DataArray objectAtIndex:i] objectAtIndex:4],@"bodyFat",
                                          [[DataArray objectAtIndex:i] objectAtIndex:5],@"water",
                                          [[DataArray objectAtIndex:i] objectAtIndex:6],@"skeleton",
                                          [[DataArray objectAtIndex:i] objectAtIndex:7],@"muscle",
                                          [[DataArray objectAtIndex:i] objectAtIndex:8],@"BMR",
                                          [[DataArray objectAtIndex:i] objectAtIndex:9],@"organFat",
                                          [[DataArray objectAtIndex:i] objectAtIndex:10],@"date",
                                          [[DataArray objectAtIndex:i] objectAtIndex:11],@"weight_PhotoPath",
                                          [[DataArray objectAtIndex:i] objectAtIndex:12],@"weight_Note",
                                          [[DataArray objectAtIndex:i] objectAtIndex:13],@"weight_RecordingPath",nil];
                
                [resultArray addObject:dataDict];
            }
        }
    }
    
    return resultArray;
}



-(NSMutableArray *)selectData:(NSString *)column range:(int)dataRange count:(int)dataCount{
    
    NSMutableArray* resultArray = [NSMutableArray new];
    
    for (int i = dataRange-2; i >= dataRange-dataCount-1 ; i--) {
        
        NSMutableArray* DataArray = [NSMutableArray new];
        
        NSString *Command;
        
        //WHERE strftime(\"%%Y-%%m\", \"date\") = strftime(\"%%Y-%%m\", \"now\", \"localtime\",\"-%d month\")
        
        NSString *latestTime = @" ";
        
        NSDate *currentDate = [NSDate date];
        
        if (dataCount == 12) {
            Command = [NSString stringWithFormat:@"SELECT %@, STRFTIME(\"%%Y-%%m-%%d\") FROM WeightList WHERE STRFTIME(\"%%Y-%%m\",\"date\") = STRFTIME(\"%%Y-%%m\",\"now\", \"localtime\",\"-%d month\") AND accountID = %d ORDER BY date DESC",column,i,[LocalData sharedInstance].accountID];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comps = [NSDateComponents new];
            comps.month = -i;
            //comps.day   = -1;
            NSDate *pastDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"YYYY-MM-DD";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            latestTime = [dateFormatter stringFromDate:pastDate];
            
            latestTime = [NSString stringWithFormat:@"%@",pastDate];
            latestTime = [latestTime substringToIndex:7];
            
        }else{
           Command = [NSString stringWithFormat:@"SELECT %@, STRFTIME(\"%%Y-%%m-%%d\",\"date\") FROM WeightList WHERE DATE(date) = STRFTIME(\"%%Y-%%m-%%d\",\"now\", \"localtime\",\"-%d day\") AND accountID = %d ORDER BY date DESC",column,i,[LocalData sharedInstance].accountID];
            
            NSDate *pastDate = [currentDate dateByAddingTimeInterval:-24.0f*60.0f*60.0f*i];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"YYYY/MM/dd";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            latestTime = [dateFormatter stringFromDate:pastDate];
        }
        
        DataArray = [self SELECT:Command Num:2];//SELECT:指令：幾筆欄位
        
        float sum = 0;
        
        NSNumber *avgValue = [NSNumber numberWithFloat:0.0];
        
        if ([[DataArray firstObject] count] != 1) {
            
//            if (i < DataArray.count) {
//                
//                latestTime = [NSString stringWithFormat:@"%@",[[DataArray objectAtIndex:i] objectAtIndex:1]];
//                
//                NSLog(@"DataArray = %@",DataArray);
//                NSLog(@"latestTime = %@",latestTime);
//
//            }
            
            for (int j=0; j<DataArray.count; j++) {
                sum += [[[DataArray objectAtIndex:j] firstObject] floatValue];
            }
        }
        
        avgValue = [NSNumber numberWithFloat:sum/DataArray.count];
    
        NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    avgValue,column,
                                    latestTime,@"date",nil];
        
        [resultArray addObject:resultDict];
        
    }
    
    //NSLog(@"%@ Data ==>>>> resultArray = %@",column ,resultArray);
    
    return resultArray;
    
}

-(NSMutableArray *)selectSingleDay:(NSString *)column range:(int)dataRange{
    
    NSMutableArray *resultArray = [NSMutableArray new];
    
    dataRange -= 1;
    
    NSString *Command = [NSString stringWithFormat:@"SELECT %@, STRFTIME(\"%%Y-%%m-%%d\",\"date\") FROM WeightList WHERE strftime(\"%%Y-%%m-%%d\", \"date\") = strftime(\"%%Y-%%m-%%d\", \"now\", \"localtime\", \"-%d day\") AND accountID = %d ORDER BY date DESC",column, dataRange,[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [NSMutableArray new];
    
    DataArray = [self SELECT:Command Num:2];//SELECT:指令：幾筆欄位
    
    NSString *dateStr = @"";
    
    NSDate *currentDate = [NSDate date];
    
    NSDate *pastDate = [currentDate dateByAddingTimeInterval:-24.0f*60.0f*60.0f*dataRange];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateStr = [dateFormatter stringFromDate:pastDate];
    
    for (int i=DataArray.count-1; i>=0; i--) {
        
        NSNumber *weightNum = [NSNumber numberWithFloat:0.0];
        
        if ([[DataArray firstObject] count] != 1) {
            weightNum = [NSNumber numberWithFloat:[[[DataArray objectAtIndex:i] firstObject] floatValue]];
            //dateStr = [NSString stringWithFormat:@"%@",[[DataArray objectAtIndex:i] objectAtIndex:1]];
        }
//        else{
//            break;
//        }
        
        NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    weightNum,column,
                                    dateStr,@"date",nil];
        
        [resultArray addObject:resultDict];
    }
    
    //NSLog(@"currentDay weight resultArray = %@",resultArray);
    
    return resultArray;
    
}

-(NSMutableArray *)selectDataForList:(int)dataRange count:(int)dataCount{
    
    NSMutableArray* resultArray = [NSMutableArray new];
    
    int limitDay;
    
    if (dataCount != -1) {
        limitDay = dataRange-dataCount;
    }else{
        limitDay = dataRange-1;
    }
    dataRange -= 1;
    
    NSMutableArray* DataArray = [NSMutableArray new];
    
    NSString *dateSelectType;
    
    if (dataCount == 12) {
        dateSelectType = @"month";
    }else{
        dateSelectType = @"day";
    }
    
    
    NSString *Command = [NSString stringWithFormat:@"SELECT weight, BMI, bodyFat,water,skeleton,muscle,BMR,organFat,weight_PhotoPath,weight_Note,weight_RecordingPath,weightID,STRFTIME(\"%%Y/%%m/%%d\",\"date\") FROM WeightList WHERE STRFTIME(\"%%Y-%%m-%%d\",\"date\") >= STRFTIME(\"%%Y-%%m-%%d\",\"now\", \"localtime\",\"-%d %@\") AND strftime(\"%%Y-%%m-%%d\", \"date\") <=strftime(\"%%Y-%%m-%%d\", \"now\", \"localtime\", \"-%d %@\") AND accountID = %d ORDER BY date DESC",dataRange,dateSelectType,limitDay,dateSelectType,[LocalData sharedInstance].accountID];
    
//    NSString *Command = [NSString stringWithFormat:@"SELECT weight, BMI, bodyFat,water,skeleton,muscle,BMR,organFat,weight_PhotoPath,weight_Note,weight_RecordingPath,weightID,STRFTIME(\"%%Y/%%m/%%d %%H:%%M\",\"date\") FROM WeightList WHERE STRFTIME(\"%%Y-%%m-%%d\",\"date\") >= STRFTIME(\"%%Y-%%m-%%d\",\"now\",\"-%d day\") AND STRFTIME(\"%%Y-%%m-%%d\",\"date\") <= STRFTIME(\"%%Y-%%m-%%d\",\"now\",\"-%d day\") AND accountID = %d ORDER BY date DESC",dataRange,limitDay,[LocalData sharedInstance].accountID];

    
    DataArray = [self SELECT:Command Num:13];//SELECT:指令：幾筆欄位
    
    NSLog(@"DataArray = %@",DataArray);
    
    if ([[DataArray firstObject] count] != 1) {
        for (int i=0; i<DataArray.count; i++) {
            
            NSString *weightStr = [[DataArray objectAtIndex:i] objectAtIndex:0];
            NSString *BMIStr = [[DataArray objectAtIndex:i] objectAtIndex:1];
            NSString *bodyFatStr = [[DataArray objectAtIndex:i] objectAtIndex:2];
            NSString *waterStr = [[DataArray objectAtIndex:i] objectAtIndex:3];
            NSString *skeletonStr = [[DataArray objectAtIndex:i] objectAtIndex:4];
            NSString *muscleStr = [[DataArray objectAtIndex:i] objectAtIndex:5];
            NSString *BMRStr = [[DataArray objectAtIndex:i] objectAtIndex:6];
            NSString *organFatStr = [[DataArray objectAtIndex:i] objectAtIndex:7];
            NSString *photoPath = [[DataArray objectAtIndex:i] objectAtIndex:8];
            NSString *note = [[DataArray objectAtIndex:i] objectAtIndex:9];
            NSString *recordingPath = [[DataArray objectAtIndex:i] objectAtIndex:10];
            NSString *IDStr = [[DataArray objectAtIndex:i] objectAtIndex:11];
            NSString *listTypeStr = @"1";
            NSString *dateStr = [[DataArray objectAtIndex:i] objectAtIndex:12];
            
            NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      weightStr,@"weight",
                                      BMIStr,@"BMI",
                                      bodyFatStr,@"bodyFat",
                                      waterStr,@"water",
                                      skeletonStr,@"skeleton",
                                      muscleStr,@"muscle",
                                      BMRStr,@"BMR",
                                      organFatStr,@"organFat",
                                      photoPath,@"photoPath",
                                      note,@"note",
                                      recordingPath,@"recordingPath",
                                      IDStr,@"ID",
                                      listTypeStr,@"listType",
                                      dateStr,@"date",nil];
            
            [resultArray addObject:dataDict];
            
        }
    }
    
    //NSLog(@"selectDataForList resultArray = %@",resultArray);
    
    
    return resultArray;
    
}

//圖表資料 泡泡框
-(NSDictionary *)selectWeightAvgValueWithRange:(int)dataRange count:(int)dataCount{
    
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
        Command = [NSString stringWithFormat:@"SELECT weight,BMI,bodyFat FROM WeightList WHERE STRFTIME(\"%%Y-%%m\",\"date\") >= STRFTIME(\"%%Y-%%m\",\"now\", \"localtime\",\"-%d month\") AND STRFTIME(\"%%Y-%%m\",\"date\") <= STRFTIME(\"%%Y-%%m\",\"now\", \"localtime\",\"-%d month\") AND accountID = %d ORDER BY date DESC",dataRange,rangeLimit,[LocalData sharedInstance].accountID];
    }else{
        Command = [NSString stringWithFormat:@"SELECT weight,BMI,bodyFat FROM WeightList WHERE STRFTIME(\"%%Y-%%m-%%d\",\"date\") >= STRFTIME(\"%%Y-%%m-%%d\",\"now\", \"localtime\",\"-%d day\") AND STRFTIME(\"%%Y-%%m-%%d\",\"date\") <= STRFTIME(\"%%Y-%%m-%%d\",\"now\", \"localtime\",\"-%d hour\") AND accountID = %d ORDER BY date DESC",dataRange,rangeLimit,[LocalData sharedInstance].accountID];
    }
    
    DataArray = [self SELECT:Command Num:3];//SELECT:指令：幾筆欄位
    
    float weightSum = 0;
    float BMISum = 0;
    float fatSum = 0;
    
    NSNumber *avgWeight = [NSNumber numberWithFloat:0];
    NSNumber *avgBMI =[NSNumber numberWithFloat:0];
    NSNumber *avgFat =[NSNumber numberWithFloat:0];
    
    if ([[DataArray firstObject] count] != 1) {
        
        for (int i=0; i<DataArray.count; i++) {
            weightSum += [[[DataArray objectAtIndex:i] objectAtIndex:0] floatValue];
            
            BMISum += [[[DataArray objectAtIndex:i] objectAtIndex:1] floatValue];
            fatSum += [[[DataArray objectAtIndex:i] objectAtIndex:2] floatValue];
            
        }
        
        avgWeight = [NSNumber numberWithFloat:weightSum/DataArray.count];
        avgBMI = [NSNumber numberWithFloat:BMISum/DataArray.count];
        avgFat = [NSNumber numberWithInt:fatSum/DataArray.count];
        
    }
    
    NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              avgWeight,@"avgWeight",
                              avgBMI,@"avgBMI",
                              avgFat,@"avgFat",
                              nil];
    
    
    return dataDict;
    
}

- (void)updateData{
    
    NSString *SQLStr = [NSString stringWithFormat:@"UPDATE WeightList SET  weight = \"%f\", BMI = \"%f\" ,bodyFat = \"%f\",water = \"%d\" , skeleton = \"%d\",muscle = \"%d\",BMR = \"%d\",organFat = \"%d\",date = \"%@\",weight_PhotoPath = \"%@\", weight_Note = \"%@\",weight_RecordingPath = \"%@\" WHERE weightID = \"%d\" AND accountID = \"%d\""
                        ,  weight, BMI, bodyFat, water,skeleton,muscle,BMR,organFat,date,weight_PhotoPath,weight_Note,weight_RecordingPath,weightID,[LocalData sharedInstance].accountID];
    
    [self COLUMN_UPDATE:SQLStr];
    
}

-(void)insertData{
    
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO WeightList( accountID, weight, BMI, bodyFat, water, skeleton, muscle, BMR, organFat, date, weight_PhotoPath, weight_Note, weight_RecordingPath) VALUES( \"%d\", \"%f\", \"%f\",\"%f\", \"%d\",\"%d\", \"%d\" ,\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\");" , accountID, weight, BMI, bodyFat, water,skeleton,muscle,BMR,organFat,date,weight_PhotoPath,weight_Note,weight_RecordingPath];
    
    [self COLUMN_INSERT:SQLStr];
}

-(void)deleteData {
    
    NSString *sqStr = [NSString stringWithFormat:@"DELETE FROM WeightList WHERE accountID ='%d';",[LocalData sharedInstance].accountID];
    
    [self COLUMN_DELETE:sqStr];
}


- (NSString *)getLastDate {
    NSString *Command = [NSString stringWithFormat:@"SELECT date FROM WeightList WHERE accountID = %d ORDER BY date DESC",[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:1];//SELECT:指令：幾筆欄位
    NSString *lastDate = [[DataArray firstObject] objectAtIndex:0];
    if (![lastDate isEqualToString:@"Can not find data!"]) {
        lastDate = [lastDate substringToIndex:lastDate.length-3];
        lastDate = [lastDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    return lastDate;
}

@end
