//
//  CurrentAndMData.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "CurrentAndMData.h"
#import "HexString.h"

@implementation CurrentAndMData

@synthesize systole,dia,hr,year,month,day,hour,minute,MAM,arr;

-(void)importHexString:(NSString*)cDataStr {
    
    HexString *hsCData = [[HexString alloc]initInputString:cDataStr];
    
    systole = [hsCData parseInt:2];
    dia = [hsCData parseInt:2];
    hr = [hsCData parseInt:2];
    
    int monthDay = [hsCData parseInt:2];
    int month_l = (monthDay & 0b11000000)>> 6;
    day = monthDay & 0b00111111;
    
    int monthHour = [hsCData parseInt:2];
    int month_h = (monthHour & 0b11000000) >> 6;
    hour = monthHour & 0b00111111;
    
    month = (month_h << 2) | month_l;
    
    minute = [hsCData parseInt:2];
    int mamYear = [hsCData parseInt:2];
    
    MAM = (mamYear & 0b10000000) >> 7  == 1;
    arr = (mamYear & 0b01000000) >> 6  == 1;
    
    year = (mamYear & 0b00111111);
    
    NSLog(@"importHexString:%@\nyear=%d\nmonth=%d\nday=%d\nhour=%d\nminute=%d\nsystole=%d\ndia=%d\nhr=%d\nMAM=%d\narr=%d\n",cDataStr,year,month,day,hour,minute,systole,dia,hr,MAM,arr);
    //000100010300008E60554D8E0F000000000000000000000000000000
}


-(NSString*)toString {
    
    return [NSString stringWithFormat:@"year=%d\nmonth=%d\nday=%d\nhour=%d\nminute=%d\nsystole=%d\ndia=%d\nhr=%d\nMAM=%d\narr=%d\n",year,month,day,hour,minute,systole,dia,hr,MAM,arr];
    
    
}



@end
