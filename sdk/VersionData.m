//
//  VersionData.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "VersionData.h"

@implementation VersionData
{
    int year;
    int month;
    int day;
    int maxUser;
    int maxMemory;
    BOOL optionIHB;
    BOOL optionAfib;
    BOOL OPtionMAM;
    BOOL optionAmbientT;
    BOOL optionTubeless;
    BOOL optionDeviceID;
    double deviceBatteryVoltage;
    NSString *FWName;
}

/**
 * date of the FW version in BPM
 *
 * @param year
 */
-(void)setYear:(int)vyear {
    year = vyear;
}

/**
 * date of the FW version in BPM
 *
 * @return
 */
-(int)getYear {
    return year;
}

/**
 * date of the FW version in BPM
 *
 * @param month
 */
-(void)setMonth:(int)vmonth {
    month = vmonth;
}

/**
 * date of the FW version in BPM
 *
 * @return
 */
-(int)getMonth {
    return month;
}

/**
 * date of the FW version in BPM
 *
 * @param day
 */
-(void)setDay:(int)vday {
    day = vday;
}

/**
 * date of the FW version in BPM
 *
 * @return
 */
-(int)getDay{
    return day;
}

/**
 * Maximum of user number in BPM
 *
 * @param maxUser
 */
-(void)setMaxUser:(int)vmaxUser{
    maxUser = vmaxUser;
}

/**
 * Maximum of user number in BPM
 *
 * @return
 */
-(int)getMaxUser {
    return maxUser;
}

/**
 * Maximum of memory data can be save for every user.
 *
 * @param maxMemory
 */
-(void)setMaxMemory:(int)vmaxMemory {
    maxMemory = vmaxMemory;
}

/**
 * Maximum of memory data can be save for every user.
 *
 * @return
 */
-(int)getMaxMemory {
    return maxMemory;
}

-(void)setOptionIHB:(BOOL)voptionIHB{
    optionIHB = voptionIHB;
}

-(BOOL)isOptionIHB {
    return optionIHB;
}

-(void)setOptionAfib:(BOOL)voptionAfib{
    optionAfib = voptionAfib;
}

-(BOOL)isOptionAfib {
    return optionAfib;
}

-(void)setOPtionMAM:(BOOL)vOPtionMAM {
    OPtionMAM = vOPtionMAM;
}

-(BOOL)isOPtionMAM {
    return OPtionMAM;
}

-(void)setOptionAmbientT:(BOOL)voptionAmbientT{
    optionAmbientT = voptionAmbientT;
}

-(BOOL)isOptionAmbientT {
    return optionAmbientT;
}

-(void)setOptionTubeless:(BOOL)voptionTubeless {
    optionTubeless = voptionTubeless;
}

-(BOOL)isOptionTubeless {
    return optionTubeless;
}

-(void)setOptionDeviceID:(BOOL)voptionDeviceID {
    optionDeviceID = voptionDeviceID;
}

-(BOOL)isOptionDeviceID {
    return optionDeviceID;
}


/**
 *   Medical device battery voltage information.
 *
 For instance,
 battery voltage = 4.5V, DeviceBatt = 4.5 * 10 = 45 = 0x2d.
 battery voltage = 2.1V, DeviceBatt = 2.1 * 10 = 21 = 0x15.
 *
 * @param deviceBatteryVoltage
 */
-(void)setDeviceBatteryVoltage:(double)vdeviceBatteryVoltage{
    deviceBatteryVoltage = vdeviceBatteryVoltage;
}

/**
 *   Medical device battery voltage information.
 *
 For instance,
 battery voltage = 4.5V, DeviceBatt = 4.5 * 10 = 45 = 0x2d.
 battery voltage = 2.1V, DeviceBatt = 2.1 * 10 = 21 = 0x15.
 *
 * @return
 */
-(double)getDeviceBatteryVoltage{
    return deviceBatteryVoltage;
}

-(void)setFWName:(NSString*)vFWName {
    FWName = vFWName;
}

-(NSString*)getFWName{
    return FWName;
}


-(NSString*)toString{
    
    NSString *msg=[NSString stringWithFormat:@"VersionData:\nyear=%d\nmonth=%d\nday=%d\nmaxUser=%d\nmaxMemory=%d\noptionIHB=%d\noptionAfib=%d\nOPtionMAM=%d\noptionAmbientT=%d\noptionTubeless=%d\noptionDeviceID=%d\ndeviceBatteryVoltage=%f\nFWName=%@\n",year,month,day,maxUser,maxMemory,optionIHB,optionAfib,OPtionMAM,optionAmbientT,optionTubeless,optionDeviceID,deviceBatteryVoltage,FWName];
    
    return msg;
    
}


@end
