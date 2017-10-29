//
//  CurrentAndMData.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentAndMData : NSObject
{
    
}

//縮收壓
@property int systole;
//舒張壓
@property int dia;
//心跳
@property int hr;

//年月日 時分
@property int year;
@property int month;
@property int day;
@property int hour;
@property int minute;

//0=MAM disable, 1=Weight off, 2=Weight on, 3=Light off, 4=Light on
@property BOOL MAM;
//the data detect with PAD 心律不整
@property BOOL arr;


-(void)importHexString:(NSString*)cDataStr;
-(NSString*)toString;

@end
