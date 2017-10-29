//
//  ThermoMeasureData.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/8.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "ThermoMeasureData.h"
#import "Function.h"
#import "HexString.h"

@implementation ThermoMeasureData


-(float)getAmbientTemperature{
    return ambientTemperature;
}

-(float)getMeasureTemperature
{
    return measureTemperature;
}

-(int)getMode
{
    return mode;
}

-(int)getYear
{
    return year;
}

-(int)getMonth
{
    return month;
}

-(int)getDay
{
    return day;
}

-(int)getHour
{
    return hour;
}

-(int)getMinute
{
    return minute;
}

-(int)getSec
{
    return sec;
}


-(int)getFlagErr
{
    return flagErr;
}


-(int)getFlagFever
{
    return flagFever;
}

-(int)getErrorCode
{
    return errorCode;
}


//匯入取得資料 轉換 實際值
-(void)importDataString:(NSString *)data
{
    if(data==NULL || data.length<16)
    {
        [Function printLog:[NSString stringWithFormat:@"importDataString error:%@",data]];
        return;
    }
    
    HexString *hexString=[[HexString alloc]initInputString:data];
    
    int ambiTemp=[hexString parseInt:4];
    int mode_measure = [hexString parseInt:4];
    int monthDay = [hexString parseInt:2];
    int monthHour = [hexString parseInt:2];
    int min = [hexString parseInt:2];
    int feverYear = [hexString parseInt:2];
    
    
    flagErr = (feverYear & 0x80) >> 7;
    flagFever = (feverYear & 0x40) >> 6;
    
    if (flagErr == 1 && flagFever == 0) {
        errorCode = feverYear;
        
    } else {
        year = feverYear & 0x3F;
        
        ambientTemperature = ambiTemp/100.0;
        
        mode = (mode_measure & 0x8000) >> 15;
        
        measureTemperature = (mode_measure & 0x7FFF)/100.0;
        
        
        int month_temp = (monthDay & 0xC0) >> 4;
        month = ((monthHour & 0xC0) >> 6) | month_temp;


        day = monthDay & 0x3F;
        hour = monthHour & 0x3F;
        minute = min;
    }
    
    
    
}

-(NSString*)toString
{
    NSString *testString=[NSString stringWithFormat:@"ambientTemperature=%f\nmeasureTemperature=%f\nmode=%d\nyear=%d\nmonth=%d\nday=%d\nhour=%d\nminute=%d\nflagErr=%d\nflagFever=%d\nerrorCode=%d",ambientTemperature,measureTemperature,mode,year,month,day,hour,minute,flagErr,flagFever,errorCode];
    
    
    return testString;
}



@end
