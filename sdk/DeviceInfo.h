//
//  DeviceInfo.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

-(id)init;

-(void)setID:(NSString*)vID;

-(NSString*)getID;

-(int)getErrHappendTimes:(int)errIndex;

-(void)setErrHappendTimes:(int)errIndex ErrTimes:(int)errTimes;

-(void)setMeasurementTimes:(int)vmeasurementTimes;

-(int)getMeasurementTimes;

-(NSString*)toString;


@end
