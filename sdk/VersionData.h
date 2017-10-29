//
//  VersionData.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionData : NSObject

/**
 * date of the FW version in BPM
 *
 * @param year
 */
-(void)setYear:(int)vyear;

/**
 * date of the FW version in BPM
 *
 * @return
 */
-(int)getYear;

/**
 * date of the FW version in BPM
 *
 * @param month
 */
-(void)setMonth:(int)vmonth;

/**
 * date of the FW version in BPM
 *
 * @return
 */
-(int)getMonth;

/**
 * date of the FW version in BPM
 *
 * @param day
 */
-(void)setDay:(int)vday;

/**
 * date of the FW version in BPM
 *
 * @return
 */
-(int)getDay;

/**
 * Maximum of user number in BPM
 *
 * @param maxUser
 */
-(void)setMaxUser:(int)vmaxUser;

/**
 * Maximum of user number in BPM
 *
 * @return
 */
-(int)getMaxUser;

/**
 * Maximum of memory data can be save for every user.
 *
 * @param maxMemory
 */
-(void)setMaxMemory:(int)vmaxMemory;

/**
 * Maximum of memory data can be save for every user.
 *
 * @return
 */
-(int)getMaxMemory;

-(void)setOptionIHB:(BOOL)voptionIHB;

-(BOOL)isOptionIHB;

-(void)setOptionAfib:(BOOL)voptionAfib;

-(BOOL)isOptionAfib;

-(void)setOPtionMAM:(BOOL)vOPtionMAM;

-(BOOL)isOPtionMAM;

-(void)setOptionAmbientT:(BOOL)voptionAmbientT;

-(BOOL)isOptionAmbientT;

-(void)setOptionTubeless:(BOOL)voptionTubeless;

-(BOOL)isOptionTubeless;

-(void)setOptionDeviceID:(BOOL)voptionDeviceID;

-(BOOL)isOptionDeviceID;


/**
 *   Medical device battery voltage information.
 *
 For instance,
 battery voltage = 4.5V, DeviceBatt = 4.5 * 10 = 45 = 0x2d.
 battery voltage = 2.1V, DeviceBatt = 2.1 * 10 = 21 = 0x15.
 *
 * @param deviceBatteryVoltage
 */
-(void)setDeviceBatteryVoltage:(double)vdeviceBatteryVoltage;

/**
 *   Medical device battery voltage information.
 *
 For instance,
 battery voltage = 4.5V, DeviceBatt = 4.5 * 10 = 45 = 0x2d.
 battery voltage = 2.1V, DeviceBatt = 2.1 * 10 = 21 = 0x15.
 *
 * @return
 */
-(double)getDeviceBatteryVoltage;

-(void)setFWName:(NSString*)vFWName;

-(NSString*)getFWName;


-(NSString*)toString;


@end
