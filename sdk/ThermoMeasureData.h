//
//  ThermoMeasureData.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/8.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThermoMeasureData : NSObject
{
    float ambientTemperature;
    float measureTemperature;
    
    int mode;

    
    int year;
    int month;
    int day;
    
    int hour;
    int minute;
    int sec;
    
    int flagErr;
    int flagFever;
    int errorCode;
    
}

//室溫
-(float)getAmbientTemperature;

//量測溫度
-(float)getMeasureTemperature;

//模式 0:身體 1:物質
-(int)getMode;

//量測時間：年
-(int)getYear;

//量測時間：月
-(int)getMonth;

//量測時間：日
-(int)getDay;

//量測時間：小時：
-(int)getHour;

//量側時間：分
-(int)getMinute;

//量側時間：秒
-(int)getSec;

-(int)getFlagErr;
-(int)getFlagFever;
-(int)getErrorCode;


//匯入取得資料 轉換 實際值
-(void)importDataString:(NSString *)data;

-(NSString*)toString;

@end
