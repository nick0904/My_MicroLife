//
//  EBodyMeasureData.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "EBodyMeasureData.h"
#import "HexString.h"

@implementation EBodyMeasureData
{
     int unit;
     double weight;
     int year;
     int month;
     int day;
     int hour;
     int minute;
     int second;
     int althleteLevel;//
     int gender;
     int age;
     int height;

     double fat;
     double water;//水份
     double muscle;//肌肉
     double bone;
     int visceraFat;//內臟脂肪
     int kcal;//熱量
    
}

-(void)importHexString:(NSString*)data{
    
    HexString *hs = [[HexString alloc]initInputString:data];
    
    int unitWeight_h = [hs parseInt:2];
    
    unit = (unitWeight_h & 0xc0) >>6;//unitWeight_h&0xa0 >>6;
    
    int weight_h = unitWeight_h & 0x3F;
    
    int weight_l = [hs parseInt:2];
    
    weight =( weight_h<<8 | weight_l ) /10.0;//

    year = [hs parseInt:2];//空值 0x00
    
    int monthDayL = [hs parseInt:2];//空值 0x00
    
    //        this.month = monthDayL& 0xf0 >> 4;
    //        int dayL = monthDayL & 0x0f;
    
    int dayHHour = [hs parseInt:2];//空值 0x00
    
    //        int dayH = dayHHour & 0xe0 >> 5;
    //        this.hour = dayHHour & 0x05;
    
    
    minute = [hs parseInt:2];//空值 0x00
    second = [hs parseInt:2];//空值 0x00
    
    //Year Month Day HH min sec
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    year=[calendar component:NSCalendarUnitYear fromDate:date];
    month=[calendar component:NSCalendarUnitMonth fromDate:date];
    day=[calendar component:NSCalendarUnitDay fromDate:date];
    hour=[calendar component:NSCalendarUnitHour fromDate:date];
    minute=[calendar component:NSCalendarUnitMinute fromDate:date];
    second=[calendar component:NSCalendarUnitSecond fromDate:date];
    
    
    
    
    int valthleteLevel = [hs parseInt:2];
    althleteLevel = valthleteLevel & 0x30 >> 4;
    
    int genderAge = [hs parseInt:2];
    
    gender = genderAge & 0x80 >> 7;
    age = genderAge & 0x7f ;
    
    height = [hs parseInt:2];
    
    int  fat_l =  [hs parseInt:2];
    
    int fatHWaterH =  [hs parseInt:2];
    int fatH = (fatHWaterH & 0xf0) >>4;
    fat =( fatH<<8 | fat_l ) /10.0;
    
    
    int waterH = fatHWaterH & 0x0f;
    int waterL =  [hs parseInt:2];
    water = (waterH<<8 | waterL)/10.0;
    
    muscle = ([hs parseInt:4])/10.0;
    
    bone = ([hs parseInt:2]) /10.0;
    visceraFat =  [hs parseInt:2];
    kcal =  [hs parseInt:4];
    
    
}

/**
 * 單位  1=KG，2=LB，3=ST(英石)
 *
 * @return
 */
-(int)getUnit{
    return unit;
}

/**
 * 體重
 *
 * @return
 */
-(double)getWeight{
    return weight;
}

/**
 * 時間：年
 *
 * @return
 */
-(int)getYear{
    return year;
}

/**
 * 時間：月
 *
 * @return
 */
-(int)getMonth{
    return month;
}

/**
 * 時間：日
 *
 * @return
 */
-(int)getDay{
    return day;
}

/**
 * 時間：時
 *
 * @return
 */
-(int)getHour{
    return hour;
}

/**
 * 時間：分
 *
 * @return
 */
-(int)getMinute{
    return minute;
}

/**
 * 時間：秒
 *
 * @return
 */
-(int)getSecond{
    return second;
}

/**
 * 運動員類型  0=普通，1=業餘運動員，2=運動員
 *
 * @return
 */
-(int)getAlthleteLevel{
    return althleteLevel;
}

/**
 * 性別
 *
 * @return
 */
-(int)getGender{
    return gender;
}

/**
 * 年齡
 *
 * @return
 */
-(int)getAge{
    return age;
}

/**
 * 身高
 *
 * @return
 */
-(int)getHeight{
    return height;
}

/**
 * 脂肪
 *
 * @return
 */
-(double)getFat{
    return fat;
}

/**
 * 水份
 *
 * @return
 */
-(double)getWater{
    return water;
}

/**
 * 肌肉
 *
 * @return
 */
-(double)getMuscle{
    return muscle;
}

/**
 * 骨量
 *
 * @return
 */
-(double)getBone{
    return bone;
}


/**
 * 内脏脂肪等级
 *
 * @return
 */
-(int)getVisceraFat{
    return visceraFat;
}

/**
 * 热量
 *
 * @return
 */
-(int)getKcal{
    return kcal;
}

/**
 * BMI
 *
 * @return
 */
-(double)getBMI{
    return weight/((height/100.0)*(height/100.0));
}


-(NSString*)toString{
    
    NSString *msg=[NSString stringWithFormat:@"EBodyMeasureData:\nunit=%d\nweight=%f\nyear=%d\nmonth=%d\nday=%d\nhour=%d\nminute=%d\nsecond=%d\nalthleteLevel=%d\ngender=%d\nage=%d\nheight=%d\nfat=%f\nwater=%f\nmuscle=%f\nbone=%f\nvisceraFat=%d\nkcal=%d\nBMI=%f\n",unit,weight,year,month,day,hour,minute,second,althleteLevel,gender,age,height,fat,water,muscle,bone,visceraFat,kcal,[self getBMI]];
    
    return msg;
    
    /*
    return "EBodyMeasureData{" +
    "unit=" + unit +
    ", weight=" + weight +
    ", year=" + year +
    ", month=" + month +
    ", hour=" + hour +
    ", minute=" + minute +
    ", second=" + second +
    ", althleteLevel=" + althleteLevel +
    ", gender=" + gender +
    ", age=" + age +
    ", height=" + height +
    ", fat=" + fat +
    ", water=" + water +
    ", muscle=" + muscle +
    ", bone=" + bone +
    ", visceraFat=" + visceraFat +
    ", kcal=" + kcal +
    ", BMI=" + getBMI() +
    '}';
     
     */
}

@end
