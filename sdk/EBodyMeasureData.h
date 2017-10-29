//
//  EBodyMeasureData.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBodyMeasureData : NSObject

-(void)importHexString:(NSString*)data;

-(int)getUnit;

-(double)getWeight;

-(int)getYear;

-(int)getMonth;

-(int)getDay;

-(int)getHour;

-(int)getMinute;

-(int)getSecond;

-(int)getAlthleteLevel;

-(int)getGender;

-(int)getAge;

-(int)getHeight;

-(double)getFat;

-(double)getWater;

-(double)getMuscle;

-(double)getBone;

-(int)getVisceraFat;

-(int)getKcal;

-(double)getBMI;


-(NSString*)toString;

@end
